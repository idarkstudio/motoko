---
sidebar_position: 14
---

# Inspección de mensajes

En ICP, un canister puede inspeccionar selectivamente y luego elegir aceptar o
rechazar mensajes de entrada enviados a través de la interfaz HTTP.

> Un canister puede inspeccionar los mensajes de entrada antes de ejecutarlos.
> Cuando el IC recibe una llamada de actualización de un usuario, el IC
> utilizará el método del canister `canister_inspect_message` para determinar si
> el mensaje debe ser aceptado. Si el canister está vacío (es decir, no tiene un
> módulo Wasm), entonces el mensaje de entrada será rechazado. Si el canister no
> está vacío y no implementa `canister_inspect_message`, entonces el mensaje de
> entrada será aceptado.
>
> En `canister_inspect_message`, el canister puede aceptar el mensaje invocando
> `ic0.accept_message : () → ()`. Esta función genera una trampa si se invoca
> dos veces. Si el canister genera una trampa en `canister_inspect_message` o no
> llama a `ic0.accept_message`, entonces se deniega el acceso.
>
> El método `canister_inspect_message` no se invoca para llamadas de consulta
> HTTP, llamadas entre canisters o llamadas al canister de gestión.
>
> —
> [Especificación de la interfaz de IC](https://internetcomputer.org/docs/current/references/ic-interface-spec/#system-api-inspect-message)

La inspección de mensajes mitiga algunos ataques de denegación de servicio
diseñados para agotar los ciclos de los canisters mediante llamadas gratuitas no
solicitadas.

## Inspección de mensajes en Motoko

En Motoko, los actores pueden optar por inspeccionar y aceptar o rechazar
mensajes de entrada declarando una función `system` particular llamada
`inspect`. Dado un registro de atributos del mensaje, esta función produce un
[`Bool`](../base/Bool.md) que indica si aceptar o rechazar el mensaje
devolviendo `true` o `false`.

La función es invocada por el sistema en cada mensaje de entrada. Similar a una
consulta, cualquier efecto secundario de una invocación se descarta y es
transitorio. Una llamada que genera una trampa debido a algún fallo tiene el
mismo resultado que devolver un rechazo de mensaje con `false`.

A diferencia de otras funciones del sistema que tienen un tipo de argumento
fijo, el tipo de argumento de `inspect` depende de la interfaz del actor que la
contiene. En particular, el argumento formal de `inspect` es un registro de
campos con los siguientes tipos:

- `caller : Principal`: El principal del llamante del mensaje.

- `arg : Blob`: El contenido binario crudo del argumento del mensaje.

- `msg : <variant>`: Una variante de funciones de decodificación, donde
  `<variant> == {…​; #<id>: () → T; …​}` contiene una variante por cada función
  compartida, `<id>`, del actor. La etiqueta de la variante identifica la
  función a la que se va a llamar. El argumento de la variante es una función
  que devuelve el argumento decodificado de la llamada como un valor de tipo
  `T`.

El uso de una variante, etiquetada con `#<id>`, permite que el tipo de retorno,
`T`, de la función de decodificación varíe con el tipo de argumento, también
`T`, de la función compartida `<id>`.

El argumento de la variante es una función para evitar el costo de la
decodificación del mensaje.

Al explotar el subtipado, el argumento formal puede omitir campos del registro
que no requiere, o ignorar selectivamente los argumentos de funciones
compartidas particulares. Por ejemplo, para simplemente despachar en el nombre
de una función sin inspeccionar su argumento real.

:::note

Una función `shared query` puede llamarse utilizando una llamada de
actualización HTTP regular para obtener una respuesta certificada. Es por eso
que el tipo de variante también incluye funciones `shared query`.

Una función `shared composite query` no puede llamarse como una llamada de
actualización. Solo puede llamarse con la llamada de consulta HTTP más rápida,
pero no certificada.

Es por eso que el tipo de variante `inspect` incluye funciones `shared query`,
pero no funciones `shared composite query`.

:::

:::danger

Un actor que no declare el campo del sistema `inspect` simplemente aceptará
todos los mensajes de entrada.

:::

:::danger

La función del sistema `inspect` **no** debe usarse para un control de acceso
definitivo. Esto se debe a que `inspect` es ejecutada por una sola réplica, sin
pasar por un consenso completo. Su resultado podría ser falsificado por un nodo
límite malicioso. Además, `inspect` no se invoca para llamadas entre canisters.
Los controles de acceso confiables solo pueden realizarse dentro de las
funciones `shared` protegidas por `inspect`. Consulta las
[mejores prácticas de seguridad en el desarrollo de canisters](https://internetcomputer.org/docs/building-apps/security/iam/#do-not-rely-on-ingress-message-inspection)
para obtener más información.

:::

## Ejemplo

Un ejemplo simple de inspección de métodos es un actor de contador que
inspecciona algunos de sus mensajes en detalle y otros de manera superficial:

```motoko file=../examples/InspectFull.mo

```

Debido a la subtipificación, todas las siguientes variaciones en orden de
especificidad creciente de argumentos son definiciones legales de `inspect`.

Denegación total de todos los mensajes de ingreso, ignorando más información:

```motoko no-repl file=../examples/InspectNone.mo#L10-L10

```

Declinando llamadas anónimas:

```motoko no-repl file=../examples/InspectCaller.mo#L12-L14

```

Declinando mensajes grandes, basado en el tamaño en bytes sin procesar de `arg`
antes de cualquier decodificación de un blob binario Candid a un valor Motoko:

```motoko no-repl file=../examples/InspectArg.mo#L10-L13

```

Declinando mensajes solo por nombre, ignorando los argumentos del mensaje. Ten
en cuenta el uso del tipo `Any` como variantes de argumentos del mensaje:

```motoko no-repl file=../examples/InspectName.mo#L10-L23

```

Una combinación de los tres anteriores, especificando los tipos de argumentos de
algunas variantes mientras se ignoran otros con el tipo `Any` y utilizando el
emparejamiento de patrones para fusionar casos idénticos:

```motoko no-repl file=../examples/InspectMixed.mo#L12-L30

```

## Consejos para escribir `inspect`

Implementar `inspect` después de haber implementado todas las funciones
compartidas de un actor puede ser tedioso. Deberás declarar una variante con el
tipo correcto para cada función compartida. Un truco sencillo es implementar
primero la función de forma incorrecta con un argumento `()`, compilar el código
y luego utilizar el mensaje de error del compilador para obtener el tipo de
argumento requerido.

Por ejemplo, en el actor del apartado anterior, al declarar incorrectamente
`inspect`, el compilador informará el tipo esperado que se muestra a
continuación, el cual puedes copiar y pegar en tu código:

```motoko no-repl file=../examples/InspectTrick.mo#L11-L13

```

```motoko no-repl
Inspect.mo:12.4-14.5: type error [M0127], system function inspect is declared with type
  () -> Bool
instead of expected type
  {
    arg : Blob;
    caller : Principal;
    msg :
      {
        #inc : () -> ();
        #read : () -> ();
        #reset : () -> ();
        #set : () -> Nat
      }
  } -> Bool
```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
