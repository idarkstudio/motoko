---
sidebar_position: 9
---

# Manejo de errores

Existen tres formas principales de representar y manejar valores de errores en
Motoko:

- Valores de opción con un valor `null` no informativo que indica algún error.

- Variantes de `Result` con un `#err value` descriptivo que proporciona más
  información sobre el error.

- Valores de [`Error`](../base/Error.md) que, en un contexto asíncrono, se
  pueden lanzar y capturar de manera similar a las excepciones y contienen un
  código numérico y un mensaje.

## Ejemplo

Considera construir una API para una aplicación de lista de tareas que desea
exponer una función que permita a los usuarios marcar una de sus tareas como
"Hecha". Este ejemplo simple aceptará un objeto `TodoId` y devolverá un
[`Int`](../base/Int.md) que representa cuántos segundos ha estado abierta la
tarea. Este ejemplo asume que se está ejecutando en un actor, que devuelve un
valor asíncrono:

```motoko no-repl
func markDone(id : TodoId) : async Int
```

El ejemplo completo de la aplicación se puede encontrar a continuación:

```motoko no-repl file=../examples/todo-error.mo#L1-L6

```

```motoko no-repl file=../examples/todo-error.mo#L10-L37

```

En este ejemplo, existen condiciones bajo las cuales marcar una tarea como
"Hecha" falla:

- El `id` podría hacer referencia a una tarea que no existe.

- La tarea podría estar marcada como hecha.

Veamos las diferentes formas de comunicar estos errores en Motoko y mejorar
gradualmente la API de ejemplo.

## Option/result

Usar `Option` o `Result` es la forma preferida de señalar errores en Motoko.
Funcionan tanto en contextos síncronos como asíncronos y hacen que tus APIs sean
más seguras al alentar a los clientes a considerar los casos de error, así como
los casos de éxito. Las excepciones solo deben usarse para señalar estados de
error inesperados.

### Reportando errores con tipos `Option`

Una función que desea devolver un valor de tipo `A` o señalar un error puede
devolver un valor de tipo opción `?A` y usar el valor `null` para designar el
error. En el ejemplo anterior, esto significa que la función `markDone` devuelve
un `async ?Seconds`:

Definición:

```motoko no-repl file=../examples/todo-error.mo#L49-L58

```

Llamado:

```motoko no-repl file=../examples/todo-error.mo#L117-L126

```

La principal desventaja de este enfoque es que mezcla todos los posibles errores
con un único valor `null` no informativo. El lugar desde donde se llama podría
estar interesado en saber por qué falló al marcar un `Todo` como hecho, pero esa
información se pierde en ese momento, lo que significa que solo podemos decirle
al usuario que "Algo salió mal".

Devolver valores de opción para señalar errores solo debe usarse si hay una
única razón posible para el fallo y esa razón se puede determinar fácilmente en
el lugar desde donde se llama. Un ejemplo de un caso de uso adecuado para esto
es cuando falla una búsqueda en un HashMap.

### Reportando errores con tipos `Result`

Mientras que las opciones son un tipo incorporado, el `Result` se define como un
tipo variante de la siguiente manera:

```motoko no-repl
type Result<Ok, Err> = { #ok : Ok; #err : Err }
```

Debido al segundo parámetro de tipo, `Err`, el tipo `Result` te permite
seleccionar el tipo utilizado para describir errores. Define un tipo `TodoError`
que la función `markDone` utilizará para señalar errores:

```motoko no-repl file=../examples/todo-error.mo#L60-L60

```

La definición original ahora se ha revisado como:

Definición:

```motoko no-repl file=../examples/todo-error.mo#L62-L76

```

Llamado:

```motoko no-repl file=../examples/todo-error.mo#L128-L141

```

### Coincidencia de patrones (Pattern matching)

La primera y más común forma de trabajar con `Option` y `Result` es utilizar la
coincidencia de patrones. Si tienes un valor de tipo `?Text`, puedes usar la
palabra clave `switch` para acceder al contenido potencial de
[`Text`](../base/Text.md):

```motoko no-repl file=../examples/error-examples.mo#L3-L10

```

Motoko no te permite acceder al valor opcional sin considerar también el caso de
que esté ausente.

En el caso de un `Result`, también puedes utilizar la coincidencia de patrones
con la diferencia de que obtienes un valor informativo, no solo `null`, en el
caso de `#err`:

```motoko no-repl file=../examples/error-examples.mo#L12-L19

```

### Funciones de orden superior

El emparejamiento de patrones puede volverse tedioso y verboso, especialmente
cuando se trata de múltiples valores opcionales. La biblioteca
[base](https://github.com/dfinity/motoko-base) expone una colección de funciones
de orden superior de los módulos `Option` y `Result` para mejorar la ergonomía
del manejo de errores.

A veces querrás moverte entre `Option` y `Result`. Una búsqueda en un Hashmap
devuelve `null` en caso de fallo, pero tal vez el llamador tenga más contexto y
pueda convertir ese fallo de búsqueda en un `Result` significativo. Otras veces
no necesitas la información adicional que proporciona un `Result` y simplemente
quieres convertir todos los casos `#err` en `null`. Para estas situaciones,
[base](https://github.com/dfinity/motoko-base) proporciona las funciones
`fromOption` y `toOption` en el módulo `Result`.

## Errores asíncronos

La última forma de manejar errores en Motoko es utilizar el manejo asíncrono de
[`Error`](../base/Error.md), una forma restringida del manejo de excepciones
familiar en otros lenguajes. Los valores de error de Motoko solo pueden lanzarse
y capturarse en contextos asíncronos, típicamente el cuerpo de una función
`shared` o una expresión `async`. Las funciones no `shared` no pueden emplear el
manejo estructurado de errores. Esto significa que puedes salir de una función
`shared` lanzando (`throw`) un valor de [`Error`](../base/Error.md) y `try`
(intentar) algún código que llame a una función `shared` en otro actor. En este
flujo de trabajo, puedes `catch` (capturar) el fallo como un resultado de tipo
[`Error`](../base/Error.md), pero no puedes usar estas construcciones de manejo
de errores fuera de un contexto asíncrono.

Los errores asíncronos de [`Error`](../base/Error.md) generalmente solo deben
usarse para señalar fallos inesperados de los que no puedes recuperarte y que no
esperas que muchos consumidores de tu API manejen. Si un fallo debe ser manejado
por tu llamante, debes hacerlo explícito en tu firma devolviendo un `Result` en
su lugar. Para completar, aquí está el ejemplo de `markDone` con excepciones:

Definición:

```motoko no-repl file=../examples/todo-error.mo#L78-L92

```

Llamado:

```motoko no-repl file=../examples/todo-error.mo#L143-L150

```

## Usando try/finally

Una cláusula `finally` se puede utilizar dentro de una expresión de manejo de
errores `try/catch` que facilita la limpieza de expresiones de control de flujo,
la liberación de recursos o la reversión de cambios de estado temporales. La
cláusula `finally` es opcional y, cuando se utiliza, la cláusula `catch` puede
omitirse. Cualquier error no capturado del bloque `try` se propagará después de
que se haya ejecutado el bloque `finally`.

:::info

`try/finally` es compatible con `moc` `v0.12.0` y versiones más recientes, y
`dfx` `v0.24.0` y versiones más recientes.

:::

`try/finally` debe ser utilizado dentro de una expresión asíncrona o en el
cuerpo de una función compartida. Antes de usar `try/finally`, por favor revisa
las
[mejores prácticas de seguridad](https://internetcomputer.org/docs/current/developer-docs/security/security-best-practices/inter-canister-calls#recommendation)
para utilizar esta sintaxis.

```motoko no-repl file=../examples/try-finally.mo

```

Dentro del bloque `try`, incluye código que pueda lanzar un error. En el bloque
`finally`, incluye código que se debe ejecutar tanto si se lanzó un error como
si no. El código dentro del bloque `finally` no debe atrapar y debe finalizar
rápidamente. Si un bloque `finally` llegara a atrapar, podría impedir una futura
actualización del canister.

Aprende más sobre
[`try/finally`](https://internetcomputer.org/docs/current/motoko/main/reference/language-manual#try).

### Cómo no manejar errores

Una forma generalmente deficiente de informar errores es a través del uso de un
valor centinela. Por ejemplo, para tu función `markDone`, podrías decidir usar
el valor `-1` para indicar que algo falló. Luego, el lugar desde donde se llama
debe verificar el valor de retorno contra este valor especial y reportar el
error. Es fácil no verificar esa condición de error y continuar trabajando con
ese valor en el código. Esto puede llevar a una detección de errores retrasada o
incluso a la falta de detección de errores, y se desaconseja enérgicamente.

Definición:

```motoko no-repl file=../examples/todo-error.mo#L38-L47

```

Llamado:

```motoko no-repl file=../examples/todo-error.mo#L108-L115

```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
