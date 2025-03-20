# Hash

Valores de hash

## Tipo `Hash`

```motoko no-repl
type Hash = Nat32
```

Los valores de hash representan una cadena de _bits de hash_, empaquetados en un
`Nat32`.

## Valor `length`

```motoko no-repl
let length : Nat
```

La longitud del hash, siempre 31.

## Función `bit`

```motoko no-repl
func bit(h : Hash, pos : Nat) : Bool
```

Proyecta un bit dado del vector de bits.

## Función `equal`

```motoko no-repl
func equal(ha : Hash, hb : Hash) : Bool
```

Comprueba si dos hashes son iguales.

## Función `hash`

```motoko no-repl
func hash(n : Nat) : Hash
```

Calcula un hash a partir de los 32 bits menos significativos de `n`, ignorando
otros bits. @deprecated Para valores grandes de `Nat`, considera usar una
función de hash personalizada que tenga en cuenta todos los bits del argumento.

## Función `debugPrintBits`

```motoko no-repl
func debugPrintBits(bits : Hash)
```

@deprecated Esta función se eliminará en el futuro.

## Función `debugPrintBitsRev`

```motoko no-repl
func debugPrintBitsRev(bits : Hash)
```

@deprecated Esta función se eliminará en el futuro.

## Función `hashNat8`

```motoko no-repl
func hashNat8(key : [Hash]) : Hash
```

Uno a la vez de Jenkins:

https://en.wikipedia.org/wiki/Jenkins_hash_function#one_at_a_time

El tipo de entrada debería ser `[Nat8]`. Nota: Asegúrate de descomponer cada
`Nat8` de un `Nat32` en su propio `Nat32`, y de desplazarlo a los 8 bits
inferiores. @deprecated Esta función puede eliminarse o modificarse en el
futuro.
