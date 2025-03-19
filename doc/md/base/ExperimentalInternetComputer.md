# ExperimentalInternetComputer

Interfaz de bajo nivel para el Internet Computer.

**ADVERTENCIA:** Esta API de bajo nivel es **experimental** y es probable que
cambie o incluso desaparezca.

## Valor `call`

```motoko no-repl
let call : (canister : Principal, name : Text, data : Blob) -> async (reply : Blob)
```

Llama a la función de actualización o consulta del `canister`, `name`, con el
contenido binario de `data` como argumento de IC. Devuelve la respuesta a la
llamada, una respuesta o rechazo de IC, como un futuro de Motoko:

- Los datos del mensaje de una respuesta de IC determinan el contenido binario
  de `reply`.
- El código de error y los datos de mensaje de texto de un rechazo de IC
  determinan el valor `Error` del futuro.

Nota: `call` es una función asíncrona y solo se puede aplicar en un contexto
asíncrono.

Ejemplo:

```motoko no-repl
import IC "mo:base/ExperimentalInternetComputer";
import Principal "mo:base/Principal";

let ledger = Principal.fromText("ryjl3-tyaaa-aaaaa-aaaba-cai");
let method = "decimals";
let input = ();
type OutputType = { decimals : Nat32 };

let rawReply = await IC.call(ledger, method, to_candid(input)); // Candid serializado
let output : ?OutputType = from_candid(rawReply); // { decimals = 8 }
```

[Aprende más sobre la serialización de Candid](https://internetcomputer.org/docs/current/motoko/main/reference/language-manual#candid-serialization)

## Valor `isReplicated`
``` motoko no-repl
let isReplicated : () -> Bool
```

`isReplicated` es true para los mensajes de actualización (update) y de consulta (query) que pasaron por consenso.

## Function `countInstructions`
``` motoko no-repl
func countInstructions(comp : () -> ()) : Nat64
```

Dada una computación, `comp`, cuenta el número de instrucciones reales y (para
llamadas del sistema de IC) instrucciones notacionales de WebAssembly realizadas
durante la ejecución de `comp()`.

Más precisamente, devuelve la diferencia entre el estado del contador de
instrucciones de IC (_contador de rendimiento_ `0`) antes y después de ejecutar
`comp()` (consultar
[Performance Counter](https://internetcomputer.org/docs/current/references/ic-interface-spec#system-api-performance-counter)).

NB: `countInstructions(comp)` no tendrá en cuenta los costos de recolección de
basura diferida incurridos por `comp()`.

Ejemplo:

```motoko no-repl
import IC "mo:base/ExperimentalInternetComputer";

let count = IC.countInstructions(func() {
  // ...
});
```

## Valor `performanceCounter`

```motoko no-repl
let performanceCounter : (counter : Nat32) -> (value : Nat64)
```

Devuelve el valor actual del _contador de rendimiento_ de IC `counter`.

- El contador `0` es el _contador de instrucciones de ejecución actual_, que
  cuenta solo las instrucciones desde el inicio del mensaje de IC actual. Este
  contador se restablece al valor `0` en la entrada de la función compartida y
  en cada `await`. Por lo tanto, solo es adecuado para medir el costo de código
  síncrono.

- El contador `1` es el _contador de instrucciones de contexto de llamada_ para
  la llamada actual de la función compartida. Para mensajes replicados en
  ejecución, esto excluye el costo de llamadas anidadas de IC (incluso al
  canister actual). Para mensajes no replicados, como consultas compuestas,
  incluye el costo de llamadas anidadas. El valor actual de este contador se
  conserva a través de `awaits` (a diferencia del contador `0`).

- La función (actualmente) genera una excepción si `counter` >= 2.

Consultar
[Performance Counter](https://internetcomputer.org/docs/current/references/ic-interface-spec#system-api-performance-counter)
para más detalles.

Ejemplo:

```motoko no-repl
import IC "mo:base/ExperimentalInternetComputer";

let c1 = IC.performanceCounter(1);
work();
let diff : Nat64 = IC.performanceCounter(1) - c1;
```

## Función `replyDeadline`

```motoko no-repl
func replyDeadline() : ?Nat
```

Devuelve el tiempo (en nanosegundos desde el inicio de la época) en el que el
mensaje de actualización debe responder al mensaje de mejor esfuerzo para que
pueda ser recibido por el canister solicitante. Las consultas y los mensajes de
actualización no de mejor esfuerzo devuelven cero.
