# TrieMap

La clase `TrieMap<K, V>` proporciona un map de claves de tipo `K` a valores de
tipo `V`. La clase envuelve y manipula un trie de hash subyacente, que se
encuentra en el módulo `Trie`. El trie es un árbol binario en el que la posición
de los elementos en el árbol se determina utilizando el hash de los elementos.

LIMITACIONES: Esta estructura de datos permite como máximo MAX_LEAF_SIZE=8
colisiones de hash: los intentos de insertar más de MAX_LEAF_SIZE claves (ya sea
directamente a través de `put` o indirectamente a través de otras operaciones)
con el mismo valor de hash generarán un error. Esta limitación se hereda de la
estructura de datos `Trie` subyacente.

Nota: La clase `TrieMap` expone la misma interfaz que `HashMap`.

Creación de un map: La función de igualdad se utiliza para comparar las claves y
la función de hash se utiliza para hashear las claves. Consulta el ejemplo a
continuación.

```motoko name=initialize
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";

let map = TrieMap.TrieMap<Nat, Nat>(Nat.equal, Hash.hash)
```

## Clase `TrieMap<K, V>`

```motoko no-repl
class TrieMap<K, V>(isEq : (K, K) -> Bool, hashOf : K -> Hash.Hash)
```

### Función `size`

```motoko no-repl
func size() : Nat
```

Devuelve el número de entradas en el map.

Ejemplo:

```motoko include=initialize
map.size()
```

Tiempo de ejecución: O(1) Espacio: O(1)

### Función `put`

```motoko no-repl
func put(key : K, value : V)
```

Mapea la `key` al `value` y sobrescribe la entrada anterior si la clave ya
estaba presente.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.put(2, 12);
Iter.toArray(map.entries())
```

Tiempo de ejecución: O(log(size)) Espacio: O(log(size))

\*El tiempo de ejecución y el espacio asumen que el trie está razonablemente
equilibrado y que el map está utilizando una función de igualdad y hash de
tiempo y espacio constante.

### Función `replace`

```motoko no-repl
func replace(key : K, value : V) : ?V
```

Mapea la `key` al `value`. Sobrescribe y devuelve la entrada anterior como una
opción si la clave ya estaba presente, y `null` en caso contrario.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.replace(0, 20)
```

Tiempo de ejecución: O(log(size)) Espacio: O(log(size))

\*El tiempo de ejecución y el espacio asumen que el trie está razonablemente
equilibrado y que el map está utilizando una función de igualdad y hash de
tiempo y espacio constante.

### Función `get`

```motoko no-repl
func get(key : K) : ?V
```

Obtiene el valor asociado con la clave `key` en una opción, o `null` si no
existe.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.get(0)
```

Tiempo de ejecución: O(log(size)) Espacio: O(log(size))

\*El tiempo de ejecución y el espacio asumen que el trie está razonablemente
equilibrado y que el map está utilizando una función de igualdad y hash de
tiempo y espacio constante.

### Función `delete`

```motoko no-repl
func delete(key : K)
```

Elimina la entrada asociada con la clave `key`, si existe. Si la clave está
ausente, no tiene efecto.

Nota: La eliminación de una clave existente reduce el tamaño del trie map.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.delete(0);
map.get(0)
```

Tiempo de ejecución: O(log(size)) Espacio: O(log(size))

\*El tiempo de ejecución y el espacio asumen que el trie está razonablemente
equilibrado y que el map está utilizando una función de igualdad y hash de
tiempo y espacio constante.

### Función `remove`

```motoko no-repl
func remove(key : K) : ?V
```

Elimina la entrada asociada con la clave `key`. Devuelve el valor eliminado como
una opción si existe, y `null` en caso contrario.

Nota: La eliminación de una clave existente reduce el tamaño del trie map.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.remove(0)
```

Tiempo de ejecución: O(log(size)) Espacio: O(log(size))

\*El tiempo de ejecución y el espacio asumen que el trie está razonablemente
equilibrado y que el map está utilizando una función de igualdad y hash de
tiempo y espacio constante.

### Función `keys`

```motoko no-repl
func keys() : I.Iter<K>
```

Devuelve un iterador sobre las claves del map.

Cada iterador obtiene una "vista instantánea" de la asignación y no se ve
afectado por las actualizaciones concurrentes en el map iterado.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.put(1, 11);
map.put(2, 12);

// find the sum of all the keys
var sum = 0;
for (key in map.keys()) {
  sum += key;
};
// 0 + 1 + 2
sum
```

Tiempo de ejecución: O(1) Espacio: O(1)

\*El tiempo de ejecución y el espacio anteriores son para la construcción del
iterador. La iteración en sí misma requiere tiempo lineal y espacio logarítmico
para ejecutarse.

### Función `vals`

```motoko no-repl
func vals() : I.Iter<V>
```

Devuelve un iterador sobre los valores en el map.

Cada iterador obtiene una "vista instantánea" de la asignación y no se ve
afectado por las actualizaciones concurrentes en el map iterado.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.put(1, 11);
map.put(2, 12);

// find the sum of all the values
var sum = 0;
for (key in map.vals()) {
  sum += key;
};
// 10 + 11 + 12
sum
```

Tiempo de ejecución: O(1) Espacio: O(1)

\*El tiempo de ejecución y el espacio anteriores son para la construcción del
iterador. La iteración en sí misma requiere tiempo lineal y espacio logarítmico
para ejecutarse.

### Función `entries`

```motoko no-repl
func entries() : I.Iter<(K, V)>
```

Devuelve un iterador sobre las entradas (pares clave-valor) en el map.

Cada iterador obtiene una "vista instantánea" de la asignación y no se ve
afectado por las actualizaciones concurrentes en el map iterado.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.put(1, 11);
map.put(2, 12);

// find the sum of all the products of key-value pairs
var sum = 0;
for ((key, value) in map.entries()) {
  sum += key * value;
};
// (0 * 10) + (1 * 11) + (2 * 12)
sum
```

Tiempo de ejecución: O(1) Espacio: O(1)

\*El tiempo de ejecución y el espacio anteriores son para la construcción del
iterador. La iteración en sí misma requiere tiempo lineal y espacio logarítmico
para ejecutarse.

## Función `clone`

```motoko no-repl
func clone<K, V>(map : TrieMap<K, V>, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash) : TrieMap<K, V>
```

Produce una copia de `map`, utilizando `keyEq` para comparar las claves y
`keyHash` para hashear las claves.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.put(1, 11);
map.put(2, 12);
// Clone using the same equality and hash functions used to initialize `map`
let mapCopy = TrieMap.clone(map, Nat.equal, Hash.hash);
Iter.toArray(mapCopy.entries())
```

Tiempo de ejecución: O(size \* log(size)) Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que el trie subyacente de `map`
está razonablemente equilibrado y que `keyEq` y `keyHash` se ejecutan en tiempo
y espacio O(1).

## Función `fromEntries`

```motoko no-repl
func fromEntries<K, V>(entries : I.Iter<(K, V)>, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash) : TrieMap<K, V>
```

Crea un nuevo map a partir de las entradas en `entries`, utilizando `keyEq` para
comparar las claves y `keyHash` para hashear las claves.

Ejemplo:

```motoko include=initialize
let entries = [(0, 10), (1, 11), (2, 12)];
let newMap = TrieMap.fromEntries<Nat, Nat>(entries.vals(), Nat.equal, Hash.hash);
newMap.get(2)
```

Tiempo de ejecución: O(size \* log(size)) Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `entries` devuelve elementos en
tiempo O(1), y que `keyEq` y `keyHash` se ejecutan en tiempo y espacio O(1).

## Función `map`

```motoko no-repl
func map<K, V1, V2>(map : TrieMap<K, V1>, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash, f : (K, V1) -> V2) : TrieMap<K, V2>
```

Transforma (mapea) los valores en `map` utilizando la función `f`, manteniendo
las claves. Utiliza `keyEq` para comparar las claves y `keyHash` para hashear
las claves.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.put(1, 11);
map.put(2, 12);
// double all the values in map
let newMap = TrieMap.map<Nat, Nat, Nat>(map, Nat.equal, Hash.hash, func(key, value) = value * 2);
Iter.toArray(newMap.entries())
```

Tiempo de ejecución: O(size \* log(size)) Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f`, `keyEq` y `keyHash` se
ejecutan en tiempo y espacio O(1).

## Función `mapFilter`

```motoko no-repl
func mapFilter<K, V1, V2>(map : TrieMap<K, V1>, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash, f : (K, V1) -> ?V2) : TrieMap<K, V2>
```

Transforma (mapea) los valores en `map` utilizando la función `f`, descartando
las entradas para las cuales `f` evalúa a `null`. Utiliza `keyEq` para comparar
las claves y `keyHash` para hashear las claves.

Ejemplo:

```motoko include=initialize
map.put(0, 10);
map.put(1, 11);
map.put(2, 12);
// double all the values in map, only keeping entries that have an even key
let newMap =
  TrieMap.mapFilter<Nat, Nat, Nat>(
    map,
    Nat.equal,
    Hash.hash,
    func(key, value) = if (key % 2 == 0) { ?(value * 2) } else { null }
  );
Iter.toArray(newMap.entries())
```

Tiempo de ejecución: O(size \* log(size)) Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f`, `keyEq` y `keyHash` se
ejecutan en tiempo y espacio O(1).
