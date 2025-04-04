# Random

Un módulo para obtener aleatoriedad en Internet Computer (IC).

Este módulo proporciona los fundamentos para que las abstracciones de usuario se
basen en ellos.

Lidiar con la aleatoriedad en una plataforma informática determinista, como IC,
es complicado. El usuario de este módulo debe seguir algunas reglas básicas para
obtener (y mantener) los beneficios de la aleatoriedad criptográfica:

- la entropía criptográfica (fuente de aleatoriedad) solo se puede obtener de
  forma asíncrona en fragmentos discretos de 256 bits (bloques de 32 bytes
  `Blob`)
- todas las apuestas deben cerrarse _antes_ de solicitar la entropía para
  decidirlas
- esto implica que la misma entropía (es decir, `Blob`) - o la entropía
  excedente no utilizada todavía - no se puede utilizar para una nueva ronda de
  apuestas sin perder las garantías criptográficas.

Concretamente, la siguiente clase `Finite`, así como los métodos `*From`, corren
el riesgo de llevar el estado de rondas anteriores. Se proporcionan por razones
de rendimiento (y conveniencia), y se necesita tener cuidado especial al
usarlos. Se aplican advertencias similares para generadores de números
aleatorios (pseudo) definidos por el usuario.

Uso:

```motoko no-repl
import Random "mo:base/Random";
```

## Function `blob`

```motoko no-repl
func blob() : async Blob
```

Obtiene un `blob` completo (32 bytes) de entropía fresca.

Ejemplo:

```motoko no-repl
let random = Random.Finite(await Random.blob());
```

## Clase `Finite`

```motoko no-repl
class Finite(entropy : Blob)
```

A partir de un suministro finito de entropía, `Finite` proporciona métodos para
obtener valores aleatorios. Cuando se agota la entropía, se devuelve `null`. De
lo contrario, la distribución de los resultados se indica para cada método. La
uniformidad de los resultados solo se garantiza cuando la entropía suministrada
se obtiene originalmente mediante la llamada a `blob()`, y nunca se reutiliza.

Ejemplo:

```motoko no-repl
import Random "mo:base/Random";

let random = Random.Finite(await Random.blob());

let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
let seedRandom = Random.Finite(seed);
```

### Función `byte`

```motoko no-repl
func byte() : ?Nat8
```

Distribuye uniformemente los resultados en el rango numérico [0 .. 255]. Consume
1 byte de entropía.

Ejemplo:

```motoko no-repl
let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
let random = Random.Finite(seed);
random.byte() // => ?20
```

### Función `coin`

```motoko no-repl
func coin() : ?Bool
```

Simula una tirada de moneda. Ambos resultados tienen la misma probabilidad.
Consume 1 bit de entropía (amortizado).

Ejemplo:

```motoko no-repl
let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
let random = Random.Finite(seed);
random.coin() // => ?false
```

### Función `range`

```motoko no-repl
func range(p : Nat8) : ?Nat
```

Distribuye uniformemente los resultados en el rango numérico [0 .. 2^p - 1].
Consume ⌈p/8⌉ bytes de entropía.

Ejemplo:

```motoko no-repl
let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
let random = Random.Finite(seed);
random.range(32) // => ?348746249
```

### Función `binomial`

```motoko no-repl
func binomial(n : Nat8) : ?Nat8
```

Cuenta el número de caras en `n` lanzamientos justos de moneda. Consume ⌈n/8⌉
bytes de entropía.

Ejemplo:

```motoko no-repl
let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
let random = Random.Finite(seed);
random.binomial(5) // => ?1
```

## Función `byteFrom`

```motoko no-repl
func byteFrom(seed : Blob) : Nat8
```

Distribuye los resultados en el rango numérico [0 .. 255]. El `blob` de semilla
debe contener al menos un byte.

Ejemplo:

```motoko no-repl
let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
Random.byteFrom(seed) // => 20
```

## Función `coinFrom`

```motoko no-repl
func coinFrom(seed : Blob) : Bool
```

Simula una tirada de moneda. El `blob` de semilla debe contener al menos un
byte.

Ejemplo:

```motoko no-repl
let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
Random.coinFrom(seed) // => false
```

## Función `rangeFrom`

```motoko no-repl
func rangeFrom(p : Nat8, seed : Blob) : Nat
```

Distribuye los resultados en el rango numérico [0 .. 2^p - 1]. El `blob` de
semilla debe contener al menos ((p+7) / 8) bytes.

Ejemplo:

```motoko no-repl
let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
Random.rangeFrom(32, seed) // => 348746249
```

## Función `binomialFrom`

```motoko no-repl
func binomialFrom(n : Nat8, seed : Blob) : Nat8
```

Cuenta el número de caras en `n` lanzamientos de moneda. El `blob` de semilla
debe contener al menos ((n+7) / 8) bytes.

Ejemplo:

```motoko no-repl
let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
Random.binomialFrom(5, seed) // => 1
```
