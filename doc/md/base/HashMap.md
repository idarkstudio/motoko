# HashMap

La clase `HashMap<K, V>` proporciona un hashmap de claves de tipo `K` a valores
de tipo `V`. La clase está parametrizada por las funciones de igualdad y hash de
la clave, y una capacidad inicial. Sin embargo, la asignación subyacente ocurre
solo cuando se inserta la primera entrada de clave-valor.

Internamente, el mapa se representa como un array de `AssocList` (buckets). La
política de crecimiento del array subyacente es muy simple, por ahora: duplicar
la capacidad actual cuando el tamaño esperado de la lista de buckets crece más
allá de una cierta constante.

ADVERTENCIA: Ciertas operaciones son de tiempo amortizado O(1), como `put`, pero
se ejecutan en el peor caso en tiempo O(size). Estos tiempos de ejecución en el
peor caso pueden exceder el límite de ciclos por mensaje si el tamaño del mapa
es lo suficientemente grande. Además, este análisis de tiempo de ejecución asume
que las funciones de hash mapean uniformemente las claves sobre el espacio de
hash. Haga crecer estas estructuras con discreción y con buenas funciones de
hash. Todas las operaciones amortizadas a continuación también enumeran el
tiempo de ejecución en el peor caso.

Para mapas sin amortización, consulte `TrieMap`.

Nota sobre el constructor: El argumento `initCapacity` determina el número
inicial de buckets en el array subyacente. Además, el análisis de tiempo de
ejecución y espacio en esta documentación asume que las funciones de igualdad y
hash para las claves utilizadas para construir el mapa se ejecutan en tiempo y
espacio O(1).

Ejemplo:

```motoko name=initialize
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";

let map = HashMap.HashMap<Text, Nat>(5, Text.equal, Text.hash);
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Clase `HashMap<K, V>`

```motoko no-repl
class HashMap<K, V>(initCapacity : Nat, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash)
```

## Función `size`

```motoko no-repl
func size() : Nat
```

Devuelve el número actual de entradas de clave-valor en el mapa.

Ejemplo:

```motoko include=initialize
map.size() // => 0
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `get`

```motoko no-repl
func get(key : K) : (value : ?V)
```

Devuelve el valor asociado con la clave `key` si está presente y `null` en caso

Ejemplo:

```motoko include=initialize
map.put("key", 3);
map.get("key") // => ?3
```

Tiempo de ejecución esperado: O(1), Tiempo de ejecución en el peor de los casos:
O(size)

Espacio: O(1)

## Función `put`

```motoko no-repl
func put(key : K, value : V)
```

Inserta el valor `value` con la clave `key`. Sobrescribe cualquier entrada
existente con la clave `key`.

Ejemplo:

```motoko include=initialize
map.put("key", 3);
map.get("key") // => ?3
```

Tiempo de ejecución amortizado esperado: O(1), Tiempo de ejecución en el peor de
los casos: O(size)

Espacio amortizado esperado: O(1), Espacio en el peor de los casos: O(size)

Nota: Si esta es la primera entrada en este mapa, esta operación causará la
asignación inicial del array subyacente.

## Función `replace`

```motoko no-repl
func replace(key : K, value : V) : (oldValue : ?V)
```

Inserta el valor `value` con la clave `key`. Devuelve el valor anterior asociado
con la clave `key` o `null` si no existe tal valor.

Ejemplo:

```motoko include=initialize
map.put("key", 3);
ignore map.replace("key", 2); // => ?3
map.get("key") // => ?2
```

Tiempo de ejecución amortizado esperado: O(1), Tiempo de ejecución en el peor de
los casos: O(size)

Espacio amortizado esperado: O(1), Espacio en el peor de los casos: O(size)

Nota: Si esta es la primera entrada en este mapa, esta operación causará la
asignación inicial del array subyacente.

## Función `delete`

```motoko no-repl
func delete(key : K)
```

Elimina la entrada con la clave `key`. No tiene efecto si `key` no está presente
en el mapa.

Ejemplo:

```motoko include=initialize
map.put("key", 3);
map.delete("key");
map.get("key"); // => null
```

Tiempo de ejecución esperado: O(1), Tiempo de ejecución en el peor de los casos:
O(size)

Espacio esperado: O(1), Espacio en el peor de los casos: O(size)

## Función `remove`

```motoko no-repl
func remove(key : K) : (oldValue : ?V)
```

Elimina la entrada con la clave `key`. Devuelve el valor anterior asociado con
la clave `key` o `null` si no existe tal valor.

Ejemplo:

```motoko include=initialize
map.put("key", 3);
map.remove("key"); // => ?3
```

Tiempo de ejecución esperado: O(1), Tiempo de ejecución en el peor de los casos:
O(size)

Espacio esperado: O(1), Espacio en el peor de los casos: O(size)

## Función `keys`

```motoko no-repl
func keys() : Iter.Iter<K>
```

Devuelve un iterador (`Iter`) sobre las claves del mapa. El iterador proporciona
un único método `next()`, que devuelve las claves en un orden no específico, o
`null` cuando no hay más claves para iterar.

Ejemplo:

```motoko include=initialize

map.put("key1", 1);
map.put("key2", 2);
map.put("key3", 3);

var keys = "";
for (key in map.keys()) {
  keys := key # " " # keys
};
keys // => "key3 key2 key1 "
```

Costo de la iteración sobre todas las keys:

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `vals`

```motoko no-repl
func vals() : Iter.Iter<V>
```

Devuelve un iterador (`Iter`) sobre los valores del mapa. El iterador
proporciona un único método `next()`, que devuelve los valores en un orden no
específico, o `null` cuando no hay más valores para iterar.

Ejemplo:

```motoko include=initialize

map.put("key1", 1);
map.put("key2", 2);
map.put("key3", 3);

var sum = 0;
for (value in map.vals()) {
  sum += value;
};
sum // => 6
```

Costo de la iteración sobre todos los values:

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `entries`

```motoko no-repl
func entries() : Iter.Iter<(K, V)>
```

Devuelve un iterador (`Iter`) sobre los pares clave-valor en el mapa. El
iterador proporciona un único método `next()`, que devuelve los pares en un
orden no específico, o `null` cuando no hay más pares para iterar.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

map.put("key1", 1);
map.put("key2", 2);
map.put("key3", 3);

var pairs = "";
for ((key, value) in map.entries()) {
  pairs := "(" # key # ", " # Nat.toText(value) # ") " # pairs
};
pairs // => "(key3, 3) (key2, 2) (key1, 1)"
```

Costo de la iteración sobre todos los pares:

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `clone`

```motoko no-repl
func clone<K, V>(map : HashMap<K, V>, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash) : HashMap<K, V>
```

Devuelve una copia de `map`, inicializando la copia con las funciones de
igualdad y hash proporcionadas.

Ejemplo:

```motoko include=initialize
map.put("key1", 1);
map.put("key2", 2);
map.put("key3", 3);

let map2 = HashMap.clone(map, Text.equal, Text.hash);
map2.get("key1") // => ?1
```

Tiempo de ejecución esperado: O(size), Tiempo de ejecución en el peor de los
casos: O(size \* size)

Espacio esperado: O(size), Espacio en el peor de los casos: O(size)

## Función `fromIter`

```motoko no-repl
func fromIter<K, V>(iter : Iter.Iter<(K, V)>, initCapacity : Nat, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash) : HashMap<K, V>
```

Devuelve un nuevo mapa, que contiene todas las entradas proporcionadas por el
iterador `iter`. El nuevo mapa se inicializa con la capacidad inicial, funciones
de igualdad y hash proporcionadas.

Ejemplo:

```motoko include=initialize
let entries = [("key3", 3), ("key2", 2), ("key1", 1)];
let iter = entries.vals();

let map2 = HashMap.fromIter<Text, Nat>(iter, entries.size(), Text.equal, Text.hash);
map2.get("key1") // => ?1
```

Tiempo de ejecución esperado: O(size), Tiempo de ejecución en el peor de los
casos: O(size \* size)

Espacio esperado: O(size), Espacio en el peor de los casos: O(size)

## Función `map`

```motoko no-repl
func map<K, V1, V2>(hashMap : HashMap<K, V1>, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash, f : (K, V1) -> V2) : HashMap<K, V2>
```

Crea un nuevo mapa aplicando `f` a cada entrada en `hashMap`. Cada entrada
`(k, v)` en el mapa antiguo se transforma en una nueva entrada `(k, v2)`, donde
el nuevo valor `v2` se crea aplicando `f` a `(k, v)`.

```motoko include=initialize
map.put("key1", 1);
map.put("key2", 2);
map.put("key3", 3);

let map2 = HashMap.map<Text, Nat, Nat>(map, Text.equal, Text.hash, func (k, v) = v * 2);
map2.get("key2") // => ?4
```

Tiempo de ejecución esperado: O(size), Tiempo de ejecución en el peor de los
casos: O(size \* size)

Espacio esperado: O(size), Espacio en el peor de los casos: O(size)

\*Tiempo de ejecución y espacio asume que `f` se ejecuta en tiempo y espacio
O(1).

## Función `mapFilter`

```motoko no-repl
func mapFilter<K, V1, V2>(hashMap : HashMap<K, V1>, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash, f : (K, V1) -> ?V2) : HashMap<K, V2>
```

Crea un nuevo mapa aplicando `f` a cada entrada en `hashMap`. Para cada entrada
`(k, v)` en el mapa antiguo, si `f` evalúa a `null`, la entrada se descarta. De
lo contrario, la entrada se transforma en una nueva entrada `(k, v2)`, donde el
nuevo valor `v2` es el resultado de aplicar `f` a `(k, v)`.

```motoko include=initialize
map.put("key1", 1);
map.put("key2", 2);
map.put("key3", 3);

let map2 =
  HashMap.mapFilter<Text, Nat, Nat>(
    map,
    Text.equal,
    Text.hash,
    func (k, v) = if (v == 2) { null } else { ?(v * 2)}
);
map2.get("key3") // => ?6
```

Tiempo de ejecución esperado: O(size), Tiempo de ejecución en el peor de los
casos: O(size \* size)

Espacio esperado: O(size), Espacio en el peor de los casos: O(size)

\*Tiempo de ejecución y espacio asume que `f` se ejecuta en tiempo y espacio
O(1).
