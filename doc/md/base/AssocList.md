# AssocList

Map implementado como una lista enlazada de pares clave-valor ("Asociaciones").

NOTA: Esta implementación de map se utiliza principalmente como cubetas
(buckets) subyacentes para otras estructuras de map. Por lo tanto, en la mayoría
de los casos, es más fácil usar otras implementaciones de maps.

## Type `AssocList`

```motoko no-repl
type AssocList<K, V> = List.List<(K, V)>
```

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import AssocList "mo:base/AssocList";
import List "mo:base/List";
import Nat "mo:base/Nat";

type AssocList<K, V> = AssocList.AssocList<K, V>;
```

Inicializa un map vacío usando una lista vacía.

```motoko name=initialize include=import
var map : AssocList<Nat, Nat> = List.nil(); // Empty list as an empty map
map := null; // Alternative: null as empty list.
map
```

## Función `find`

```motoko no-repl
func find<K, V>(map : AssocList<K, V>, key : K, equal : (K, K) -> Bool) : ?V
```

Busca el valor asociado con la clave `key`, o `null` si no existe tal clave.
Compara las claves usando la función `equal` proporcionada.

Ejemplo:

```motoko include=import,initialize
// Create map = [(0, 10), (1, 11), (2, 12)]
map := AssocList.replace(map, 0, Nat.equal, ?10).0;
map := AssocList.replace(map, 1, Nat.equal, ?11).0;
map := AssocList.replace(map, 2, Nat.equal, ?12).0;

// Find value associated with key 1
AssocList.find(map, 1, Nat.equal)
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Función `replace`

```motoko no-repl
func replace<K, V>(map : AssocList<K, V>, key : K, equal : (K, K) -> Bool, value : ?V) : (AssocList<K, V>, ?V)
```

Maps `key` to `value` in `map`, and overwrites the old entry if the key was
already present. Returns the old value in an option if it existed and `null`
otherwise, as well as the new map. Compares keys using the provided function
`equal`.

Example:

```motoko include=import,initialize
// Add three entries to the map
// map = [(0, 10), (1, 11), (2, 12)]
map := AssocList.replace(map, 0, Nat.equal, ?10).0;
map := AssocList.replace(map, 1, Nat.equal, ?11).0;
map := AssocList.replace(map, 2, Nat.equal, ?12).0;
// Override second entry
map := AssocList.replace(map, 1, Nat.equal, ?21).0;

List.toArray(map)
```

Tiempo de ejecución: O(size)

Espacio: O(size) \*Tiempo de ejecución y espacio asume que `equal` se ejecuta en
tiempo y espacio O(1).

## Función `diff`

```motoko no-repl
func diff<K, V, W>(map1 : AssocList<K, V>, map2 : AssocList<K, W>, equal : (K, K) -> Bool) : AssocList<K, V>
```

Produce un nuevo map que contiene todas las entradas de `map1` cuyas claves no
están contenidas en `map2`. Las entradas "extra" en `map2` son ignoradas.
Compara las claves usando la función proporcionada `equal`.

Ejemplo:

```motoko include=import,initialize
// Create map1 = [(0, 10), (1, 11), (2, 12)]
var map1 : AssocList<Nat, Nat> = null;
map1 := AssocList.replace(map1, 0, Nat.equal, ?10).0;
map1 := AssocList.replace(map1, 1, Nat.equal, ?11).0;
map1 := AssocList.replace(map1, 2, Nat.equal, ?12).0;

// Create map2 = [(2, 12), (3, 13)]
var map2 : AssocList<Nat, Nat> = null;
map2 := AssocList.replace(map2, 2, Nat.equal, ?12).0;
map2 := AssocList.replace(map2, 3, Nat.equal, ?13).0;

// Take the difference
let newMap = AssocList.diff(map1, map2, Nat.equal);
List.toArray(newMap)
```

Tiempo de ejecución: O(size1 \* size2)

Espacio: O(1)

\*Tiempo de ejecución y espacio asume que `equal` se ejecuta en tiempo y espacio
O(1).

## Función `mapAppend`

```motoko no-repl
func mapAppend<K, V, W, X>(map1 : AssocList<K, V>, map2 : AssocList<K, W>, f : (?V, ?W) -> X) : AssocList<K, X>
```

@deprecated

## Función `disjDisjoint`

```motoko no-repl
func disjDisjoint<K, V, W, X>(map1 : AssocList<K, V>, map2 : AssocList<K, W>, f : (?V, ?W) -> X) : AssocList<K, X>
```

Produce un nuevo map mapeando las entradas en `map1` y `map2` usando `f` y
concatenando los resultados. Asume que no hay colisiones entre las claves en
`map1` y `map2`.

Ejemplo:

```motoko include=import,initialize
import { trap } "mo:base/Debug";

// Create map1 = [(0, 10), (1, 11), (2, 12)]
var map1 : AssocList<Nat, Nat> = null;
map1 := AssocList.replace(map1, 0, Nat.equal, ?10).0;
map1 := AssocList.replace(map1, 1, Nat.equal, ?11).0;
map1 := AssocList.replace(map1, 2, Nat.equal, ?12).0;

// Create map2 = [(4, "14"), (3, "13")]
var map2 : AssocList<Nat, Text> = null;
map2 := AssocList.replace(map2, 4, Nat.equal, ?"14").0;
map2 := AssocList.replace(map2, 3, Nat.equal, ?"13").0;

// Map and append the two AssocLists
let newMap =
  AssocList.disjDisjoint<Nat, Nat, Text, Text>(
    map1,
    map2,
    func((v1, v2) : (?Nat, ?Text)) {
      switch(v1, v2) {
        case(?v1, null) {
          debug_show(v1) // convert values from map1 to Text
        };
        case(null, ?v2) {
          v2 // keep values from map2 as Text
        };
        case _ {
          trap "These cases will never happen in mapAppend"
        }
      }
    }
  );

List.toArray(newMap)
```

Tiempo de ejecución: O(size1 + size2)

Espacio: O(1) \*Tiempo de ejecución y espacio asume que `f` se ejecuta en tiempo
y espacio O(1).

## Función `disj`

```motoko no-repl
func disj<K, V, W, X>(map1 : AssocList<K, V>, map2 : AssocList<K, W>, equal : (K, K) -> Bool, combine : (?V, ?W) -> X) : AssocList<K, X>
```

Crea un nuevo map fusionando las entradas de `map1` y `map2`, y mapeándolas
usando `combine`. `combine` también se utiliza para combinar los valores de las
claves que colisionan. Las claves se comparan utilizando la función `equal`
proporcionada.

NOTA: `combine` nunca se aplicará a `(null, null)`.

Ejemplo:

```motoko include=import,initialize
import { trap } "mo:base/Debug";

// Create map1 = [(0, 10), (1, 11), (2, 12)]
var map1 : AssocList<Nat, Nat> = null;
map1 := AssocList.replace(map1, 0, Nat.equal, ?10).0;
map1 := AssocList.replace(map1, 1, Nat.equal, ?11).0;
map1 := AssocList.replace(map1, 2, Nat.equal, ?12).0;

// Create map2 = [(2, 12), (3, 13)]
var map2 : AssocList<Nat, Nat> = null;
map2 := AssocList.replace(map2, 2, Nat.equal, ?12).0;
map2 := AssocList.replace(map2, 3, Nat.equal, ?13).0;

// Merge the two maps using `combine`
let newMap =
  AssocList.disj<Nat, Nat, Nat, Nat>(
    map1,
    map2,
    Nat.equal,
    func((v1, v2) : (?Nat, ?Nat)) : Nat {
      switch(v1, v2) {
        case(?v1, ?v2) {
          v1 + v2 // combine values of colliding keys by adding them
        };
        case(?v1, null) {
          v1 // when a key doesn't collide, keep the original value
        };
        case(null, ?v2) {
          v2
        };
        case _ {
          trap "This case will never happen in disj"
        }
      }
    }
  );

List.toArray(newMap)
```

Tiempo de ejecución: O(size1 \* size2)

Espacio: O(size1 + size2) \*Tiempo de ejecución y espacio asume que `equal` y
`combine` se ejecutan en tiempo y espacio O(1).

## Función `join`

```motoko no-repl
func join<K, V, W, X>(map1 : AssocList<K, V>, map2 : AssocList<K, W>, equal : (K, K) -> Bool, combine : (V, W) -> X) : AssocList<K, X>
```

Toma la intersección de `map1` y `map2`, manteniendo solo las claves que
colisionan y combinando los valores utilizando la función `combine`. Las claves
se comparan utilizando la función `equal`.

Ejemplo:

```motoko include=import,initialize
// Create map1 = [(0, 10), (1, 11), (2, 12)]
var map1 : AssocList<Nat, Nat> = null;
map1 := AssocList.replace(map1, 0, Nat.equal, ?10).0;
map1 := AssocList.replace(map1, 1, Nat.equal, ?11).0;
map1 := AssocList.replace(map1, 2, Nat.equal, ?12).0;

// Create map2 = [(2, 12), (3, 13)]
var map2 : AssocList<Nat, Nat> = null;
map2 := AssocList.replace(map2, 2, Nat.equal, ?12).0;
map2 := AssocList.replace(map2, 3, Nat.equal, ?13).0;

// Take the intersection of the two maps, combining values by adding them
let newMap = AssocList.join<Nat, Nat, Nat, Nat>(map1, map2, Nat.equal, Nat.add);

List.toArray(newMap)
```

Tiempo de ejecución: O(size1 \* size2)

Espacio: O(size1 + size2)

\*El tiempo de ejecución y el espacio asumen que `equal` y `combine` se ejecutan
en tiempo y espacio O(1).

## Función `fold`

```motoko no-repl
func fold<K, V, X>(map : AssocList<K, V>, base : X, combine : (K, V, X) -> X) : X
```

Colapsa los elementos en `map` en un único valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de izquierda a derecha.

Ejemplo:

```motoko include=import,initialize
// Create map = [(0, 10), (1, 11), (2, 12)]
var map : AssocList<Nat, Nat> = null;
map := AssocList.replace(map, 0, Nat.equal, ?10).0;
map := AssocList.replace(map, 1, Nat.equal, ?11).0;
map := AssocList.replace(map, 2, Nat.equal, ?12).0;

// (0 * 10) + (1 * 11) + (2 * 12)
AssocList.fold<Nat, Nat, Nat>(map, 0, func(k, v, sumSoFar) = (k * v) + sumSoFar)
```

Tiempo de ejecución: O(size)

Espacio: O(size) \*El tiempo de ejecución y el espacio asumen que `combine` se
ejecuta en tiempo y espacio O(1).
