# Time

Tiempo del sistema

## Tipo `Time`

```motoko no-repl
type Time = Int
```

El tiempo del sistema se representa en nanosegundos desde 1970-01-01.

## Valor `now`

```motoko no-repl
let now : () -> Time
```

Tiempo actual del sistema dado en nanosegundos desde 1970-01-01. El sistema
garantiza que:

- el tiempo, tal como es observado por el contrato inteligente del canister,
  aumenta de forma monótona, incluso a través de actualizaciones del canister.
- dentro de una invocación de un punto de entrada, el tiempo es constante.

Los tiempos del sistema de diferentes canisters no están relacionados, y las
llamadas de un canister a otro pueden parecer viajar "hacia atrás en el tiempo".

Nota: Aunque una implementación probablemente intentará mantener el tiempo del
sistema cercano al tiempo real, esto no está garantizado formalmente.
