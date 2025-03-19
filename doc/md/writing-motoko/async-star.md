---
sidebar_position: 28
---

# Abstracción de código asíncrono

Las funciones son un mecanismo de abstracción que te permite nombrar una
computación y reutilizar esa computación en diferentes ubicaciones dentro de tu
código simplemente invocando el nombre de esa función. Cuando la función toma
parámetros, puedes personalizar la computación para diferentes sitios de llamada
proporcionando diferentes argumentos.

Los programadores a menudo mejoran su código refactorizando patrones comunes de
código en una única función reutilizable.

En Motoko, es posible que desees refactorizar código que involucra operaciones
asíncronas, como enviar mensajes o esperar futuros. El sistema de tipos de
Motoko te impide usar una función ordinaria para esto, ya que las funciones
ordinarias no tienen permiso para enviar mensajes ni esperar. Sin embargo,
puedes definir una función asíncrona local que contenga el código asíncrono y
luego reemplazar todas las ocurrencias del patrón con una llamada a esa función.
Dado que estas llamadas devuelven futuros, cada llamada debe estar envuelta en
un `await` para extraer el resultado de su futuro.

Aunque esto puede funcionar, tiene algunos inconvenientes y riesgos:

- Cada llamada a la función implica enviar un mensaje adicional al propio actor.

- Cada llamada debe ser esperada (`await`), lo que aumenta significativamente el
  costo del código que abstrae.

- Cada `await` implica suspender la ejecución del que espera hasta que una
  respuesta esté disponible, permitiendo más intercalaciones y, por lo tanto,
  más interferencia con la ejecución de otros mensajes concurrentes.

Considera el siguiente código que realiza un registro de logs en un canister
remoto.

```motoko
persistent actor class (Logger : actor { log : Text -> async () }) {

  var logging = true;

  func doStuff() : async () {
    // do stuff
    if (logging) { await Logger.log("stuff") };
    // do more stuff
    if (logging) { await Logger.log("more stuff") };
  }
}
```

Para evitar la repetición de la lógica de registro, sería ideal refactorizar
este código para usar una función auxiliar `maybeLog`. La función `maybeLog`
necesita ser asíncrona porque comunicarse con el canister `Logger` implica
enviar un mensaje.

```motoko
persistent actor class (Logger : actor { log : Text -> async () }) {

  var logging = true;

  func maybeLog(msg : Text) : async () {
    if (logging) { await Logger.log(msg) };
  };

  func doStuff() : async () {
    // do stuff
    await maybeLog("stuff");
    // do more stuff
    await maybeLog("more stuff");
  }
}
```

Aunque este código se comprueba y ejecuta correctamente, el código para
`doStuff()` ahora es mucho menos eficiente que el original, ya que cada llamada
a la función `maybeLog` implica un `await` adicional que suspende la ejecución
de `doStuff()`, incluso cuando la bandera `logging` es `false`. La semántica de
este código también es ligeramente diferente, ya que el valor de la variable
`logging` podría, en principio, cambiar entre la llamada a `maybeLog` y la
ejecución de su cuerpo, dependiendo del resto del código del actor.

Una refactorización más segura pasa el estado actual de la variable `logging`
con cada llamada:

```motoko
persistent actor class (Logger : actor { log : Text -> async () }) {

  var logging = true;

  func maybeLog(log : Bool, msg : Text) : async () {
    if (log) { await Logger.log(msg) };
  };

  func doStuff() : async () {
    // do stuff
    await maybeLog(logging, "stuff");
    // do more stuff
    await maybeLog(logging, "more stuff");
  }
}
```

## Tipos de computación

Para evitar la sobrecarga y los peligros de los `await` adicionales, Motoko
ofrece tipos de computación, `async* T`, que, al igual que los tipos de futuro,
`async T`, pueden abstraer tareas asíncronas.

Al igual que una expresión `async` se utiliza para crear un futuro (programando
la ejecución de su cuerpo), una expresión `async*` se utiliza para crear una
computación (retrasando la ejecución de su cuerpo). De manera similar a cómo se
usa `await` para consumir el resultado de un futuro, `await*` se utiliza para
producir el resultado de una computación (exigiendo otra ejecución de su
cuerpo).

Desde una perspectiva de tipificación, los futuros y las computaciones son muy
similares. Donde difieren es en su comportamiento dinámico: un futuro es un
objeto con estado que contiene el resultado de una tarea asíncrona programada,
mientras que una computación es simplemente un valor inerte que describe una
tarea.

A diferencia de `await` en un futuro, `await*` en una computación no suspende al
que espera, simplemente ejecuta la computación de inmediato, como una llamada a
una función ordinaria. Esto significa que esperar (`await*`) un valor `async*`
solo suspende su ejecución (para completarse de manera asíncrona) si el cuerpo
de `async*` realiza un `await` propiamente dicho. El `*` en estas expresiones
está destinado a indicar que la computación puede involucrar 0 o más expresiones
`await` ordinarias y, por lo tanto, puede entrelazarse con la ejecución de otros
mensajes.

Para crear un valor `async*`, puedes usar una expresión `async*`, pero más
típicamente, declararás una función local que devuelve un tipo `async*`.

Para calcular el resultado de una computación `async*`, simplemente usas un
`await*`.

Aquí se muestra cómo podemos refactorizar nuestra clase original para que sea
más clara, eficiente y tenga el mismo significado, utilizando computaciones en
lugar de futuros:

```motoko
persistent actor class (Logger : actor { log : Text -> async () }) {

  var logging = true;

  func maybeLog(msg : Text) : async* () {
    if (logging) { await Logger.log(msg) };
  };

  func doStuff() : async () {
    // do stuff
    await* maybeLog("stuff");
    // do more stuff
    await* maybeLog("more stuff");
  }
}
```

Una diferencia notable entre las expresiones `async` y `async*` es que las
primeras son ansiosas (eager), mientras que las segundas no lo son. Esto
significa que llamar a la versión `async` de `maybeLog` programará ansiosamente
la ejecución de su cuerpo, incluso si el resultado `async` (un futuro) de la
llamada nunca se espera (`await`). Esperar el mismo futuro otra vez siempre
producirá el resultado original: el mensaje se ejecuta solo una vez.

Por otro lado, llamar a la versión `async*` de `maybeLog` no hará nada a menos
que el resultado se espere (`await*`), y esperar (`await*`) la misma computación
varias veces repetirá la computación cada vez.

Para otro ejemplo, supongamos que definimos una función `clap` con el efecto
secundario de imprimir "clap".

```motoko no-repl
import Debug "mo:base/Debug"
func clap() { Debug.print("clap") }
```

Ahora, utilizando futuros, este código aplaudirá una vez:

```motoko no-repl
let future = async { clap() };
```

Este sigue siendo el caso, sin importar cuántas veces esperes `future`. Por
ejemplo:

```motoko no-repl
let future = async { clap() };
await future;
await future;
```

Usando computaciones, por otro lado, la siguiente definición no tiene efecto por
sí misma:

```motoko no-repl
let computation = async* { clap() };
```

Pero, el siguiente ejemplo aplaudirá dos veces:

```motoko no-repl
let computation = async* { clap() };
await* computation;
await* computation;
```

:::danger

Debes usar `async*`/`await*` con cuidado. Un `await` ordinario es un punto de
confirmación (commit) en Motoko: todos los cambios de estado se confirmarán en
el `await` antes de la suspensión. Un `await*`, por otro lado, no es un punto de
confirmación (ya que su cuerpo puede no esperar en absoluto, o confirmarse en
algún punto indefinido). Esto significa que los errores (traps) dentro de la
computación esperada pueden revertir el estado del actor al último punto de
confirmación _antes_ del `await*`, no al estado en el `await*` en sí.

:::

Consulta el manual del lenguaje para más detalles sobre el
[tipo `async*`](../reference/language-manual#async-type-1), la
[expresión `async*`](../reference/language-manual#async-1) y la
[expresión `await*`](../reference/language-manual#await-1).

## Paquetes de Mops para computaciones

- [`star`](https://mops.one/star): Se utiliza para manejar comportamientos
  asíncronos y errores (traps) usando funciones `async*`.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
