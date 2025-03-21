# OrderedMap

Map clave-valor (key-value) estable implementado como un árbol red-black
(RBTree) con nodos que almacenan pares clave-valor.

Un árbol red-black es un árbol de búsqueda binario equilibrado ordenado por las
claves.

La estructura de datos del árbol colorea internamente cada uno de sus nodos de
rojo o negro, y utiliza esta información para equilibrar el árbol durante las
operaciones de modificación.

Rendimiento:

- Tiempo de ejecución: `O(log(n))` costo peor caso por inserción, eliminación y
  recuperación operación.
- Espacio: `O(n)` para almacenar todo el árbol. `n` denota el número de pares
  clave-valor entradas (es decir, nodos) almacenados en el árbol.

Nota:

- Las operaciones del map, como la recuperación, inserción y eliminación, crean
  `O(log(n))` objetos temporales que se convierten en basura.

Créditos:

El núcleo de esta implementación se deriva de:

- Ken Friis Larsen's
  [RedBlackMap.sml](https://github.com/kfl/mosml/blob/master/src/mosmllib/Redblackmap.sml),
  que a su vez se basa en:
- Stefan Kahrs, "Red-black trees with types", Journal of Functional Programming,
  11(4): 425-432 (2001),
  [versión 1 en el apéndice web](http://www.cs.ukc.ac.uk/people/staff/smk/redblack/rb.html).

## Tipo `Map`

```motoko no-repl
type Map<K, V> = { size : Nat; root : Tree<K, V> }
```

Colección de entradas clave-valor, ordenadas por las claves y clave única. Las
claves tienen el tipo genérico `K` y los valores el tipo genérico `V`. Si `K` y
`V` son tipos estables, entonces `Map<K, V>` también es estable. Para asegurar
esa propiedad, el `Map<K, V>` no tiene ningún método, en su lugar se recopilan
en la clase tipo functor `Operations` (ver ejemplo allí).

## Clase `Operations<K>`

```motoko no-repl
class Operations<K>(compare : (K, K) -> O.Order)
```

Clase que captura el tipo de clave `K` junto con su función de ordenación
`compare` y proporciona todas las operaciones para trabajar con un map de tipo
`Map<K, _>`.

Se debe crear un objeto de instancia una vez como un campo del contenedor para
asegurar que el se utiliza la misma función de ordenación para cada operación.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";

actor {
  let natMap = Map.Make<Nat>(Nat.compare); // : Operations<Nat>
  stable var keyStorage : Map.Map<Nat, Text> = natMap.empty<Text>();

  public func addKey(id : Nat, key : Text) : async () {
    keyStorage := natMap.put(keyStorage, id, key);
  }
}
```

### Función `fromIter`

```motoko no-repl
func fromIter<V>(i : I.Iter<(K, V)>) : Map<K, V>
```

Devuelve un nuevo map que contiene todas las entradas dadas por el iterador `i`.
Si hay múltiples entradas con la misma clave, se toma la última.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let m = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(Iter.toArray(natMap.entries(m))));

// [(0, "Zero"), (1, "One"), (2, "Two")]
```

Tiempo de ejecución: `O(n * log(n))`. Espacio: `O(n)` memoria retenida más
basura, ver la nota a continuación. donde `n` denota el número de pares
clave-valor entradas almacenadas en el map y asumiendo que la función `compare`
implementa una comparación `O(1)`.

Nota: Crea `O(n * log(n))` objetos temporales que se recogerán como basura.

### Función `put`

```motoko no-repl
func put<V>(m : Map<K, V>, key : K, value : V) : Map<K, V>
```

Inserta el valor `value` con la clave `key` en el map `m`. Sobrescribe cualquier
entrada existente con la clave `key`. Devuelve un map modificado.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
var map = natMap.empty<Text>();

map := natMap.put(map, 0, "Zero");
map := natMap.put(map, 2, "Two");
map := natMap.put(map, 1, "One");

Debug.print(debug_show(Iter.toArray(natMap.entries(map))));

// [(0, "Zero"), (1, "One"), (2, "Two")]
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(log(n))`. donde `n` denota el
número de pares clave-valor almacenados en el map y asumiendo que la función
`compare` implementa una comparación `O(1)`.

Nota: El map devuelto comparte con el `m` la mayoría de los nodos del árbol.
Recolectar basura uno de los maps (por ejemplo, después de una asignación
`m := natMap.put(m, k)`) causa recolectar `O(log(n))` nodos.

### Función `replace`

```motoko no-repl
func replace<V>(m : Map<K, V>, key : K, value : V) : (Map<K, V>, ?V)
```

Inserta el valor `value` con la clave `key` en el map `m`. Devuelve el map
modificado y el valor anterior asociado con la clave `key` o `null` si no existe
dicho valor.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map0 = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

let (map1, old1) = natMap.replace(map0, 0, "Nil");

Debug.print(debug_show(Iter.toArray(natMap.entries(map1))));
Debug.print(debug_show(old1));
// [(0, "Nil"), (1, "One"), (2, "Two")]
// ?"Zero"

let (map2, old2) = natMap.replace(map0, 3, "Three");

Debug.print(debug_show(Iter.toArray(natMap.entries(map2))));
Debug.print(debug_show(old2));
// [(0, "Zero"), (1, "One"), (2, "Two"), (3, "Three")]
// null
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(log(n))` memoria retenida más
basura, ver la nota a continuación. donde `n` denota el número de pares
clave-valor almacenados en el map y asumiendo que la función `compare`
implementa una comparación `O(1)`.

Nota: El map devuelto comparte con el `m` la mayoría de los nodos del árbol.
Recolectar basura uno de los maps (por ejemplo, después de una asignación
`m := natMap.replace(m, k).0`) causa recolectar `O(log(n))` nodos.

### Función `mapFilter`

```motoko no-repl
func mapFilter<V1, V2>(m : Map<K, V1>, f : (K, V1) -> ?V2) : Map<K, V2>
```

Crea un nuevo map aplicando `f` a cada entrada en el map `m`. Para cada entrada
`(k, v)` en el map antiguo, si `f` se evalúa a `null`, se descarta la entrada.
De lo contrario, la entrada se transforma en una nueva entrada `(k, v2)`, donde
el nuevo valor `v2` es el resultado de aplicar `f` a `(k, v)`.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

func f(key : Nat, val : Text) : ?Text {
  if(key == 0) {null}
  else { ?("Twenty " # val)}
};

let newMap = natMap.mapFilter(map, f);

Debug.print(debug_show(Iter.toArray(natMap.entries(newMap))));

// [(1, "Twenty One"), (2, "Twenty Two")]
```

Tiempo de ejecución: `O(n * log(n))`. Espacio: `O(n)` memoria retenida más
basura, ver la nota a continuación. donde `n` denota el número de pares
clave-valor almacenados en el map y asumiendo que la función `compare`
implementa una comparación `O(1)`.

Nota: Crea `O(n * log(n))` objetos temporales que se recogerán como basura.

### Función `get`

```motoko no-repl
func get<V>(m : Map<K, V>, key : K) : ?V
```

Obtiene el valor asociado con la clave `key` en el map dado `m` si está presente
y `null` de lo contrario.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(natMap.get(map, 1)));
Debug.print(debug_show(natMap.get(map, 42)));

// ?"One"
// null
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(1)`. donde `n` denota el número de
pares clave-valor entradas almacenadas en el map y asumiendo que la función
`compare` implementa una comparación `O(1)`.

### Función `contains`

```motoko no-repl
func contains<V>(m : Map<K, V>, key : K) : Bool
```

Comprueba si el map `m` contiene alguna asociación para la clave dada `key`.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));


Debug.print(debug_show natMap.contains(map, 1)); // => true
Debug.print(debug_show natMap.contains(map, 42)); // => false
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(1)`. donde `n` denota el número de
pares clave-valor almacenados en el map y asumiendo que la función `compare`
implementa una comparación `O(1)`.

### Función `maxEntry`

```motoko no-repl
func maxEntry<V>(m : Map<K, V>) : ?(K, V)
```

Recupera un par clave-valor del map `m` con la clave máxima. Si el map está
vacío, devuelve `null`.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(natMap.maxEntry(map))); // => ?(2, "Two")
Debug.print(debug_show(natMap.maxEntry(natMap.empty()))); // => null
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(1)`, donde `n` denota el número de
pares clave-valor almacenados en el map.

### Función `minEntry`

```motoko no-repl
func minEntry<V>(m : Map<K, V>) : ?(K, V)
```

Recupera un par clave-valor del map `m` con la clave mínima. Si el map está
vacío, devuelve `null`.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(natMap.minEntry(map))); // => ?(0, "Zero")
Debug.print(debug_show(natMap.minEntry(natMap.empty()))); // => null
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(1)`, donde `n` denota el número de
pares clave-valor almacenados en el map.

### Función `delete`

```motoko no-repl
func delete<V>(m : Map<K, V>, key : K) : Map<K, V>
```

Elimina la entrada con la clave `key` del map `m`. No tiene efecto si la clave
no está presente en el map. Devuelve el map modificado.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(Iter.toArray(natMap.entries(natMap.delete(map, 1)))));
Debug.print(debug_show(Iter.toArray(natMap.entries(natMap.delete(map, 42)))));

// [(0, "Zero"), (2, "Two")]
// [(0, "Zero"), (1, "One"), (2, "Two")]
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(log(n))`, donde `n` denota el
número de pares clave-valor almacenados en el map y asumiendo que la función
`compare` implementa una comparación `O(1)`.

Nota: El map devuelto comparte con `m` la mayoría de los nodos del árbol.
Recolectar basura en uno de los maps (por ejemplo, después de una asignación
`m := natMap.delete(m, k).0`) provoca la recolección de `O(log(n))` nodos.

### Función `remove`

```motoko no-repl
func remove<V>(m : Map<K, V>, key : K) : (Map<K, V>, ?V)
```

Elimina la entrada con la clave `key`. Devuelve el map modificado y el valor
anterior asociado con la clave `key` o `null` si no existe dicho valor.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map0 = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

let (map1, old1) = natMap.remove(map0, 0);

Debug.print(debug_show(Iter.toArray(natMap.entries(map1))));
Debug.print(debug_show(old1));
// [(1, "One"), (2, "Two")]
// ?"Zero"

let (map2, old2) = natMap.remove(map0, 42);

Debug.print(debug_show(Iter.toArray(natMap.entries(map2))));
Debug.print(debug_show(old2));
// [(0, "Zero"), (1, "One"), (2, "Two")]
// null
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(log(n))`, donde `n` denota el
número de pares clave-valor almacenados en el map y asumiendo que la función
`compare` implementa una comparación `O(1)`.

Nota: El map devuelto comparte con `m` la mayoría de los nodos del árbol.
Recolectar basura en uno de los maps (por ejemplo, después de una asignación
`m := natMap.remove(m, k)`) provoca la recolección de `O(log(n))` nodos.

### Función `empty`

```motoko no-repl
func empty<V>() : Map<K, V>
```

Crea un nuevo map vacío.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);

let map = natMap.empty<Text>();

Debug.print(debug_show(natMap.size(map)));

// 0
```

Costo de creación de un map vacío Tiempo de ejecución: `O(1)`. Espacio: `O(1)`

### Función `entries`

```motoko no-repl
func entries<V>(m : Map<K, V>) : I.Iter<(K, V)>
```

Devuelve un iterador (`Iter`) sobre los pares clave-valor en el map. El iterador
proporciona un único método `next()`, que devuelve los pares en orden ascendente
por claves, o `null` cuando no hay más pares para iterar.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(Iter.toArray(natMap.entries(map))));
// [(0, "Zero"), (1, "One"), (2, "Two")]
var sum = 0;
for ((k, _) in natMap.entries(map)) { sum += k; };
Debug.print(debug_show(sum)); // => 3
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: `O(log(n))` memoria retenida más basura, ver la nota a continuación.
donde `n` denota el número de pares clave-valor almacenados en el map.

Nota: La iteración completa del map crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `entriesRev`

```motoko no-repl
func entriesRev<V>(m : Map<K, V>) : I.Iter<(K, V)>
```

Igual que `entries` pero itera en orden descendente.

### Función `keys`

```motoko no-repl
func keys<V>(m : Map<K, V>) : I.Iter<K>
```

Devuelve un iterador (`Iter`) sobre las claves del map. El iterador proporciona
un único método `next()`, que devuelve las claves en orden ascendente, o `null`
cuando no hay más claves para iterar.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(Iter.toArray(natMap.keys(map))));

// [0, 1, 2]
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: `O(log(n))` memoria retenida más basura, ver la nota a continuación.
donde `n` denota el número de pares clave-valor almacenados en el map.

Nota: La iteración completa del map crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `vals`

```motoko no-repl
func vals<V>(m : Map<K, V>) : I.Iter<V>
```

Devuelve un iterador (`Iter`) sobre los valores del map. El iterador proporciona
un único método `next()`, que devuelve los valores en orden ascendente de las
claves asociadas, o `null` cuando no hay más valores para iterar.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(Iter.toArray(natMap.vals(map))));

// ["Zero", "One", "Two"]
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: `O(log(n))` memoria retenida más basura, ver la nota a continuación.
donde `n` denota el número de pares clave-valor almacenados en el map.

Nota: La iteración completa del map crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `map`

```motoko no-repl
func map<V1, V2>(m : Map<K, V1>, f : (K, V1) -> V2) : Map<K, V2>
```

Crea un nuevo map aplicando `f` a cada entrada en el map `m`. Cada entrada
`(k, v)` en el map antiguo se transforma en una nueva entrada `(k, v2)`, donde
el nuevo valor `v2` se crea aplicando `f` a `(k, v)`.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

func f(key : Nat, _val : Text) : Nat = key * 2;

let resMap = natMap.map(map, f);

Debug.print(debug_show(Iter.toArray(natMap.entries(resMap))));
// [(0, 0), (1, 2), (2, 4)]
```

Costo de mapeo de todos los elementos: Tiempo de ejecución: `O(n)`. Espacio:
`O(n)` memoria retenida donde `n` denota el número de pares clave-valor
almacenados en el map.

### Función `size`

```motoko no-repl
func size<V>(m : Map<K, V>) : Nat
```

Determina el tamaño del map como el número de pares clave-valor.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

Debug.print(debug_show(natMap.size(map)));
// 3
```

Tiempo de ejecución: `O(n)`. Espacio: `O(1)`.

### Función `foldLeft`

```motoko no-repl
func foldLeft<Value, Accum>(map : Map<K, Value>, base : Accum, combine : (Accum, K, Value) -> Accum) : Accum
```

Combina los elementos del `map` en un único valor comenzando con `base` y
combinando progresivamente claves y valores en `base` con `combine`. La
iteración se realiza de izquierda a derecha.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

func folder(accum : (Nat, Text), key : Nat, val : Text) : ((Nat, Text))
  = (key + accum.0, accum.1 # val);

Debug.print(debug_show(natMap.foldLeft(map, (0, ""), folder)));

// (3, "ZeroOneTwo")
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: depende de la función `combine` más basura, ver la nota a continuación.
donde `n` denota el número de pares clave-valor almacenados en el map.

Nota: La iteración completa del map crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `foldRight`

```motoko no-repl
func foldRight<Value, Accum>(map : Map<K, Value>, base : Accum, combine : (K, Value, Accum) -> Accum) : Accum
```

Combina los elementos del `map` en un único valor comenzando con `base` y
combinando progresivamente claves y valores en `base` con `combine`. La
iteración se realiza de derecha a izquierda.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "Zero"), (2, "Two"), (1, "One")]));

func folder(key : Nat, val : Text, accum : (Nat, Text)) : ((Nat, Text))
  = (key + accum.0, accum.1 # val);

Debug.print(debug_show(natMap.foldRight(map, (0, ""), folder)));

// (3, "TwoOneZero")
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: depende de la función `combine` más basura, ver la nota a continuación.
donde `n` denota el número de pares clave-valor almacenados en el map.

Nota: La iteración completa del map crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `all`

```motoko no-repl
func all<V>(m : Map<K, V>, pred : (K, V) -> Bool) : Bool
```

Comprueba si todos los pares clave-valor satisfacen un predicado dado `pred`.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "0"), (2, "2"), (1, "1")]));

Debug.print(debug_show(natMap.all<Text>(map, func (k, v) = (v == debug_show(k)))));
// true
Debug.print(debug_show(natMap.all<Text>(map, func (k, v) = (k < 2))));
// false
```

Tiempo de ejecución: `O(n)`. Espacio: `O(1)`, donde `n` denota el número de
pares clave-valor almacenados en el map.

### Función `some`

```motoko no-repl
func some<V>(m : Map<K, V>, pred : (K, V) -> Bool) : Bool
```

Comprueba si existe un par clave-valor que cumple un predicado dado `pred`.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natMap = Map.Make<Nat>(Nat.compare);
let map = natMap.fromIter<Text>(Iter.fromArray([(0, "0"), (2, "2"), (1, "1")]));

Debug.print(debug_show(natMap.some<Text>(map, func (k, v) = (k >= 3))));
// false
Debug.print(debug_show(natMap.some<Text>(map, func (k, v) = (k >= 0))));
// true
```

Tiempo de ejecución: `O(n)`. Espacio: `O(1)`, donde `n` denota el número de
pares clave-valor almacenados en el map.

### Función `validate`

```motoko no-repl
func validate<V>(m : Map<K, V>) : ()
```

Ayudante de depuración que verifica las invariantes internas del map `m` dado.
Lanza un error (con una traza de pila) si se violan las invariantes.

## Valor `Make`

```motoko no-repl
let Make : <K>(compare : (K, K) -> O.Order) -> Operations<K>
```

Crea un objeto `OrderedMap.Operations` que captura el tipo de clave `K` y la
función `compare`. Es un alias para el constructor `Operations`.

Ejemplo:

```motoko
import Map "mo:base/OrderedMap";
import Nat "mo:base/Nat";

actor {
  let natMap = Map.Make<Nat>(Nat.compare);
  stable var map : Map.Map<Nat, Text> = natMap.empty<Text>();
};
```
