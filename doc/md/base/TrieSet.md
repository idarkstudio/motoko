# TrieSet

Conjunto funcional

Los conjuntos son mapas parciales del tipo de elemento al tipo de unidad, es
decir, el mapa parcial representa el conjunto con su dominio.

LIMITACIONES: Esta estructura de datos permite como máximo MAX_LEAF_SIZE=8
colisiones de hash: los intentos de insertar más de MAX_LEAF_SIZE elementos (ya
sea directamente a través de `put` o indirectamente a través de otras
operaciones) con el mismo valor de hash generarán un error. Esta limitación se
hereda de la estructura de datos subyacente `Trie`.

## Tipo `Hash`

```motoko no-repl
type Hash = Hash.Hash
```

## Tipo `Set`

```motoko no-repl
type Set<T> = Trie.Trie<T, ()>
```

## Función `empty`

```motoko no-repl
func empty<T>() : Set<T>
```

Conjunto vacío.

## Función `put`

```motoko no-repl
func put<T>(s : Set<T>, x : T, xh : Hash, eq : (T, T) -> Bool) : Set<T>
```

Inserta un elemento en el conjunto.

## Función `delete`

```motoko no-repl
func delete<T>(s : Set<T>, x : T, xh : Hash, eq : (T, T) -> Bool) : Set<T>
```

Elimina un elemento del conjunto.

## Función `equal`

```motoko no-repl
func equal<T>(s1 : Set<T>, s2 : Set<T>, eq : (T, T) -> Bool) : Bool
```

Comprueba si dos conjuntos son iguales.

## Función `size`

```motoko no-repl
func size<T>(s : Set<T>) : Nat
```

El número de elementos del conjunto, la cardinalidad del conjunto.

## Función `isEmpty`

```motoko no-repl
func isEmpty<T>(s : Set<T>) : Bool
```

Comprueba si `s` es el conjunto vacío.

## Función `isSubset`

```motoko no-repl
func isSubset<T>(s1 : Set<T>, s2 : Set<T>, eq : (T, T) -> Bool) : Bool
```

Comprueba si `s1` es un subconjunto de `s2`.

## Función `mem`

```motoko no-repl
func mem<T>(s : Set<T>, x : T, xh : Hash, eq : (T, T) -> Bool) : Bool
```

@deprecated: usa `TrieSet.contains()`

Comprueba si un conjunto contiene un elemento dado.

## Función `contains`

```motoko no-repl
func contains<T>(s : Set<T>, x : T, xh : Hash, eq : (T, T) -> Bool) : Bool
```

Comprueba si un conjunto contiene un elemento dado.

## Función `union`

```motoko no-repl
func union<T>(s1 : Set<T>, s2 : Set<T>, eq : (T, T) -> Bool) : Set<T>
```

[Unión de conjuntos](<https://en.wikipedia.org/wiki/Union_(set_theory)>).

## Función `diff`

```motoko no-repl
func diff<T>(s1 : Set<T>, s2 : Set<T>, eq : (T, T) -> Bool) : Set<T>
```

[Diferencia de conjuntos](<https://en.wikipedia.org/wiki/Difference_(set_theory)>).

## Función `intersect`

```motoko no-repl
func intersect<T>(s1 : Set<T>, s2 : Set<T>, eq : (T, T) -> Bool) : Set<T>
```

[Intersección de conjuntos](<https://en.wikipedia.org/wiki/Intersection_(set_theory)>).

## Función `fromArray`

```motoko no-repl
func fromArray<T>(arr : [T], elemHash : T -> Hash, eq : (T, T) -> Bool) : Set<T>
```

## Función `toArray`

```motoko no-repl
func toArray<T>(s : Set<T>) : [T]
```
