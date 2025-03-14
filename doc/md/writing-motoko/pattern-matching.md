---
sidebar_position: 19
---

# Coincidencia de patrones (Pattern matching)

La coincidencia de patrones es una característica del lenguaje que facilita
tanto la prueba como la descomposición de datos estructurados en sus partes
constituyentes. Mientras que la mayoría de los lenguajes de programación
proporcionan formas familiares de construir datos estructurados, la coincidencia
de patrones te permite desarmar datos estructurados y llevar sus fragmentos al
alcance vinculándolos a los nombres que especifiques. Sintácticamente, los
patrones se asemejan a la construcción de datos estructurados, pero generalmente
aparecen en posiciones de entrada, como en los argumentos de funciones, después
de la palabra clave `case` en expresiones `switch`, y después de declaraciones
`let` o `var`.

## Tipos de patrones

La siguiente tabla resume las diferentes formas de coincidencia de patrones.

| Tipo de patrón            | Ejemplo(s)                         | Contexto        | ¿Puede fallar?                       | Observaciones                                                                                 |
| ------------------------- | ---------------------------------- | --------------- | ------------------------------------ | --------------------------------------------------------------------------------------------- |
| Literal                   | `null`, `42`, `()`, `"Hi"`         | En todas partes | Cuando el tipo tiene más de un valor |                                                                                               |
| Nombre                    | `age`, `x`                         | En todas partes | No                                   | Introduce identificadores en un nuevo alcance                                                 |
| Comodín                   | `_`                                | En todas partes | No                                   |                                                                                               |
| Tipado                    | `age : Nat`                        | En todas partes | Condicional                          |                                                                                               |
| Opción                    | `?0`, `?val`                       | En todas partes | Sí                                   | Ver también [bloques de opciones](#option-blocks-for-streamlined-processing-of-optional-data) |
| Tupla                     | `( componente0, componente1, …​ )` | En todas partes | Condicional                          | Debe tener al menos dos componentes                                                           |
| Objeto                    | `{ campoA; campoB; …​ }`           | En todas partes | Condicional                          | Se permite mencionar un subconjunto de campos                                                 |
| Campo                     | `age`, `count = 0`                 | Objeto          | Condicional                          | `age` es una forma abreviada de `age = age`                                                   |
| Variante                  | `#celsius deg`, `#sunday`          | En todas partes | Sí                                   | `#sunday` es la forma abreviada de `#sunday ()`                                               |
| Alternativa (patrón `or`) | `0 or 1`                           | En todas partes | Depende                              | Ninguna alternativa puede vincular un identificador                                           |

## Uso de la coincidencia de patrones

Considera la siguiente llamada de función:

```motoko no-repl
let name : Text = fullName({ first = "Jane"; mid = "M"; last = "Doe" });
```

Este código construye un registro con tres campos y lo pasa a la función
`fullName`. El resultado de la llamada se nombra y se trae al alcance al
vincularlo con el identificador `name`. El último paso, llamado coincidencia de
patrones, y `name : Text` es una de las formas más simples de un patrón. Por
ejemplo, en la siguiente implementación del receptor:

```motoko
func fullName({ first : Text; mid : Text; last : Text }) : Text {
  first # " " # mid # " " # last
};
```

El input es un objeto anónimo que se desestructura en sus tres campos
[`Text`](../base/Text.md), cuyos valores se asignan a los identificadores
`first`, `mid` y `last`. Se pueden utilizar libremente en el bloque que forma el
cuerpo de la función. Arriba hemos recurrido al juego de palabras de nombres,
una forma de aliasing para patrones de campos de objetos, utilizando el nombre
de un campo para nombrar también su contenido. Una forma más general de patrones
de campos permite que el contenido se nombre por separado del campo, como en
`…​; mid = m : Text; …​`. Aquí `mid` determina qué campo se va a emparejar, y
`m` nombra el contenido de ese campo dentro del alcance del patrón.

## Patrones literales

También puedes usar la coincidencia de patrones para declarar patrones
literales, que se ven igual que las constantes literales. Los patrones literales
son especialmente útiles en las expresiones `switch` porque pueden hacer que la
coincidencia de patrones actual falle y, por lo tanto, comience a coincidir con
el siguiente patrón. Por ejemplo:

```motoko
switch ("Adrienne", #female) {
  case (name, #female) { name # " is a girl!" };
  case (name, #male) { name # " is a boy!" };
  case (name, _) { name # ", is a human!" };
}
```

Este programa coincidirá con la primera cláusula `case` porque la vinculación al
identificador `name` no puede fallar y la variante literal abreviada `#female`
se compara como igual. Luego, se evalúa como `"¡Adrienne es una niña!"`. La
última cláusula muestra el patrón comodín `_`. No puede fallar, pero no
vinculará ningún identificador.

## Patrones `or`

El último tipo de patrón es el patrón `or`. Como su nombre lo indica, estos son
dos o más patrones separados por la palabra clave `or`. Cada uno de los
subpatrones debe vincularse al mismo conjunto de identificadores y se compara de
izquierda a derecha. Un patrón `or` falla cuando su subpatrón más a la derecha
falla.

## Más sobre patrones

Dado que la coincidencia de patrones tiene una historia rica y mecánicas
interesantes, algunos comentarios adicionales están justificados.

### Terminología

La expresión cuyo valor se está comparando se llama frecuentemente el
**scrutinee**. Los patrones que aparecen después de la palabra clave `case` son
las **alternativas**. Cuando cada valor posible del scrutinee coincide con al
menos una alternativa, se dice que el scrutinee está **cubierto**. Las
alternativas se prueban en orden. En caso de patrones superpuestos, se
selecciona el primero. Una alternativa se considera muerta o redundante si para
cada valor que coincide, ya existe una alternativa anterior que también coincide
con ese valor.

### Booleanos

El tipo de dato [`Bool`](../base/Bool.md) puede considerarse como dos
alternativas disjuntas (`true` y `false`), y la construcción `if` integrada en
Motoko eliminará los datos y los convertirá en flujo de control. Las expresiones
`if` son una forma de coincidencia de patrones que abrevia la expresión general
`switch` para el caso especial de scrutinees booleanos.

### Patrones de variantes

Los tipos de variantes de Motoko son una forma de unión disjunta, a veces
también llamada tipo suma. Un valor de tipo variante siempre tiene exactamente
un discriminador y una carga útil que puede variar según el discriminador. Al
comparar un patrón de variante con un valor de variante, los discriminadores
deben ser iguales para seleccionar la alternativa, y si lo son, la carga útil se
expone para una mayor coincidencia.

### Tipos enumerados

Otros lenguajes de programación suelen usar una palabra clave `enum` para
definir enumeraciones discretas. Estas son versiones limitadas de los tipos de
variantes más generales de Motoko, ya que las alternativas de una enumeración no
pueden llevar ninguna carga útil. Correspondientemente, en esos lenguajes, las
declaraciones similares a `switch` utilizadas para analizar valores de
enumeración carecen del poder completo de la coincidencia de patrones. Motoko
proporciona la sintaxis abreviada, como en `type Weekday = { #mon; #tue; …​ }`,
para definir enumeraciones básicas para las que no se requieren cargas útiles.

### Manejo de errores

El manejo de errores puede considerarse un caso de uso para la coincidencia de
patrones. Cuando una función devuelve un valor que tiene una alternativa para el
éxito y otra para el fracaso, la coincidencia de patrones puede usarse para
distinguir entre los dos, como se discute en [manejo de errores](errors.md).

### Patrones irrefutables

Un patrón es refutable si la coincidencia de algún valor del tipo esperado con
él puede fallar. Los patrones literales y de variantes son generalmente
refutables, ya que requieren un valor igual o una etiqueta de variante, y estos
podrían no coincidir.

Un patrón que no puede fallar al coincidir con cada valor es irrefutable.
Ejemplos de patrones irrefutables son el patrón comodín `_`, los patrones de
identificador `x` y los patrones de tupla o registro construidos a partir de
subpatrones irrefutables.

### Tipos singleton

Algunos tipos contienen solo un valor. Llamamos a estos tipos singleton.
Ejemplos de estos son el tipo unitario, también conocido como tupla vacía, o
tuplas de tipos singleton. Las variantes con una sola etiqueta y sin carga útil
o con una carga útil de tipo singleton también son tipos singleton. La
coincidencia de patrones en tipos singleton es particularmente sencilla, ya que
solo tiene un posible resultado de una coincidencia exitosa.

### Verificación de exhaustividad (cobertura)

En tiempo de ejecución, una expresión `switch` puede terminar examinando un
valor al que ninguno de sus patrones alternativos se aplica, generando una
trampa no deseada. Para detectar la posibilidad de tales fallos en tiempo de
ejecución, el compilador de Motoko verifica la exhaustividad de la coincidencia
de patrones rastreando la forma cubierta del scrutinee. El compilador emite una
advertencia para cualquier scrutinee no cubierto. Motoko incluso construye un
ejemplo útil de un scrutinee que no coincide. Un subproducto útil de la
verificación de exhaustividad es que identifica y advierte al desarrollador
sobre alternativas muertas o redundantes que nunca pueden coincidir.

## Patrones refutables y manejo de datos no coincidentes

La construcción `let`-`else` en Motoko está diseñada para desarrolladores que
desean trabajar con un patrón específico de datos mientras manejan todos los
datos no coincidentes en una ruta de flujo de control diferente. A diferencia
del `let` de desestructuración estándar, que genera una trampa (y desencadena
una advertencia en tiempo de compilación) cuando los datos no coinciden con el
patrón esperado, `let`-`else` proporciona una forma de manejar coincidencias
refutadas. Esta construcción permite a los programadores manejar errores de
coincidencia de manera elegante, como salir de la función actual o registrar un
mensaje antes de generar una trampa.

`let`-`else` puede verse como una versión más compacta de una declaración
`switch` de dos casos. Tiene la ventaja adicional de no requerir sangría para el
código que lo sigue, lo que puede mejorar la legibilidad. Esta característica
permite a los desarrolladores escribir estructuras similares a `if`-`else` sin
sangría en su código.

Aquí hay un ejemplo que demuestra cómo usar `let`-`else` para evitar un `switch`
menos legible y que aumenta la sangría:

```motoko
func getName(optionalName : ?Text) : Text {
  let ?name = optionalName else return "Unknown";
  name
}
```

En un constructo `let-else`, la expresión o bloque que sigue a la palabra clave
`else` debe tener el tipo `None`. Esto indica que su ejecución no puede ingresar
al código que sigue a la declaración `let`, sino que debe cambiar el flujo de
control, generalmente mediante una salida temprana, un salto a una etiqueta
externa o un error (trap).

## Bloques de options (opciones) para un procesamiento simplificado de datos opcionales

Motoko ofrece un método preferido para manejar datos opcionales (de tipo `?T`) a
través de la coincidencia de patrones, lo que ayuda a evitar los notorios
problemas de excepciones de `null` comunes en otros lenguajes de programación.
Sin embargo, el uso de múltiples declaraciones `switch` en varias options puede
volverse engorroso y resultar en un código profundamente anidado y difícil de
leer. Para abordar esto, Motoko introduce una característica llamada _bloques de
options_, escritos como `do ? { ... }`. Estos bloques permiten desenvolver de
manera segura valores opcionales utilizando un operador postfijo `!`. Cada uso
de `!` dentro del bloque es equivalente a una declaración `switch` sobre una
opción, pero con un beneficio adicional: si `!` se aplica a un valor `null`, el
bloque completo abandona inmediatamente la ejecución y devuelve `null`. Este
comportamiento de cortocircuito simplifica el manejo de múltiples valores
opcionales de una manera más concisa y legible.

Para ver un ejemplo, consulta
[bloques de options y rupturas de null](./control-flow#bloques-de-opciones-y-rupturas-con-null).

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
