# Trie

Hash maps clave-valor funcionales.

Este módulo proporciona un map hash aplicativo (funcional) llamado trie.
Notablemente, cada operación produce un nuevo trie en lugar de actualizar
destructivamente un trie existente.

Aquellas personas que buscan un map hash más familiar (imperativo, orientado a
objetos) deberían considerar `TrieMap` o `HashMap` en su lugar.

Las operaciones básicas de `Trie` consisten en:

- `put` - inserta una clave-valor en el trie, produciendo una nueva versión.
- `get` - obtiene el valor de una clave en el trie, o `null` si no existe.
- `remove` - elimina el valor de una clave en el trie.
- `iter` - visita cada clave-valor en el trie.

Las operaciones `put`, `get` y `remove` trabajan con registros `Key`, que
agrupan el hash de la clave con su valor de clave no hash.

LIMITACIONES: Esta estructura de datos permite como máximo MAX_LEAF_SIZE=8
colisiones de hash: los intentos de insertar más de MAX_LEAF_SIZE claves (ya sea
directamente a través de `put` o indirectamente a través de otras operaciones)
con el mismo valor de hash generarán un error.

CRÉDITOS: Basado en la Sección 6 de
["Incremental computation via function caching", Pugh & Teitelbaum](https://dl.acm.org/citation.cfm?id=75305).

Ejemplo:

```motoko
import Trie "mo:base/Trie";
import Text "mo:base/Text";

// we do this to have shorter type names and thus
// better readibility
type Trie<K, V> = Trie.Trie<K, V>;
type Key<K> = Trie.Key<K>;

// we have to provide `put`, `get` and `remove` with
// a record of type `Key<K> = { hash : Hash.Hash; key : K }`;
// thus we define the following function that takes a value of type `K`
// (in this case `Text`) and returns a `Key<K>` record.
func key(t: Text) : Key<Text> { { hash = Text.hash t; key = t } };

// we start off by creating an empty `Trie`
let t0 : Trie<Text, Nat> = Trie.empty();

// `put` requires 4 arguments:
// - the trie we want to insert the value into,
// - the key of the value we want to insert (note that we use the `key` function defined above),
// - a function that checks for equality of keys, and
// - the value we want to insert.
//
// When inserting a value, `put` returns a tuple of type `(Trie<K, V>, ?V)`.
// to get the new trie that contains the value,  we use the `0` projection
// and assign it to `t1` and `t2` respectively.
let t1 : Trie<Text, Nat> = Trie.put(t0, key "hello", Text.equal, 42).0;
let t2 : Trie<Text, Nat> = Trie.put(t1, key "world", Text.equal, 24).0;

// If for a given key there already was a value in the trie, `put` returns
// that previous value as the second element of the tuple.
// in our case we have already inserted the value 42 for the key "hello", so
// `put` returns 42 as the second element of the tuple.
let (t3, n) : (Trie<Text, Nat>, ?Nat) = Trie.put(
  t2,
  key "hello",
  Text.equal,
  0,
);
assert (n == ?42);

// `get` requires 3 arguments:
// - the trie we want to get the value from
// - the key of the value we want to get (note that we use the `key` function defined above)
// - a function that checks for equality of keys
//
// If the given key is nonexistent in the trie, `get` returns `null`.
var value = Trie.get(t3, key "hello", Text.equal); // Returns `?42`
assert(value == ?0);
value := Trie.get(t3, key "universe", Text.equal); // Returns `null`
assert(value == null);

// `remove` requires 3 arguments:
// - the trie we want to remove the value from,
// - the key of the value we want to remove (note that we use the `key` function defined above), and
// - a function that checks for equality of keys.
//
// In the case of keys of type `Text`, we can use `Text.equal`
// to check for equality of keys. Function `remove` returns a tuple of type `(Trie<K, V>, ?V)`.
// where the second element of the tuple is the value that was removed, or `null` if
// there was no value for the given key.
let removedValue : ?Nat = Trie.remove(
  t3,
  key "hello",
  Text.equal,
).1;
assert (removedValue == ?0);

// To iterate over the Trie, we use the `iter` function that takes a trie
// of type `Trie<K,V>` and returns an iterator of type `Iter<(K,V)>`:
var sum : Nat = 0;
for (kv in Trie.iter(t3)) {
  sum += kv.1;
};
assert(sum == 24);
```

## Tipo `Trie`

```motoko no-repl
type Trie<K, V> = {#empty; #leaf : Leaf<K, V>; #branch : Branch<K, V>}
```

Hash tries binarios: vacío, un nodo hoja o un nodo de rama

## Tipo `Leaf`

```motoko no-repl
type Leaf<K, V> = { size : Nat; keyvals : AssocList<Key<K>, V> }
```

Los nodos hoja del trie consisten en pares clave-valor en forma de lista.

## Tipo `Branch`

```motoko no-repl
type Branch<K, V> = { size : Nat; left : Trie<K, V>; right : Trie<K, V> }
```

Los nodos de rama del trie discriminan en una posición de bit de los hashes de
las claves. Esta posición de bit no se almacena en la rama, sino que se
determina a partir del contexto de la rama.

## Tipo `AssocList`

```motoko no-repl
type AssocList<K, V> = AssocList.AssocList<K, V>
```

## Tipo `Key`

```motoko no-repl
type Key<K> = { hash : Hash.Hash; key : K }
```

Una `Key` para el trie tiene un valor de hash asociado

- `hash` permite verificaciones de desigualdad rápidas y permite colisiones,
  mientras que
- `key` permite verificaciones precisas de igualdad, pero solo se utiliza en
  valores con hashes iguales.

## Función `equalKey`

```motoko no-repl
func equalKey<K>(keq : (K, K) -> Bool) : ((Key<K>, Key<K>) -> Bool)
```

Función de igualdad para dos `Key<K>`, en términos de igualdad de `K`.

## Función `isValid`

```motoko no-repl
func isValid<K, V>(t : Trie<K, V>, _enforceNormal : Bool) : Bool
```

@deprecated `isValid` es un predicado interno y se eliminará en el futuro.

## Tipo `Trie2D`

```motoko no-repl
type Trie2D<K1, K2, V> = Trie<K1, Trie<K2, V>>
```

Un trie 2D mapea claves de la dimensión 1 a otra capa de tries, cada uno con
claves en la dimensión 2.

## Tipo `Trie3D`

```motoko no-repl
type Trie3D<K1, K2, K3, V> = Trie<K1, Trie2D<K2, K3, V>>
```

Un trie 3D mapea claves de la dimensión 1 a otra composición de tries 2D, cada
uno con claves en la dimensión 2 y dimensión 3.

## Función `empty`

```motoko no-repl
func empty<K, V>() : Trie<K, V>
```

Un trie vacío. Este suele ser el punto de partida para construir un trie.

Ejemplo:

```motoko name=initialize
import { print } "mo:base/Debug";
import Trie "mo:base/Trie";
import Text "mo:base/Text";

// we do this to have shorter type names and thus
// better readibility
type Trie<K, V> = Trie.Trie<K, V>;
type Key<K> = Trie.Key<K>;

// We have to provide `put`, `get` and `remove` with
// a function of return type `Key<K> = { hash : Hash.Hash; key : K }`
func key(t: Text) : Key<Text> { { hash = Text.hash t; key = t } };
// We start off by creating an empty `Trie`
var trie : Trie<Text, Nat> = Trie.empty();
```

## Función `size`

```motoko no-repl
func size<K, V>(t : Trie<K, V>) : Nat
```

Obtiene el tamaño en tiempo O(1).

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
var size = Trie.size(trie); // Devuelve 0, ya que `trie` está vacío
assert(size == 0);
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
size := Trie.size(trie); // Devuelve 1, ya que acabamos de agregar una nueva entrada
assert(size == 1);
```

## Función `branch`

```motoko no-repl
func branch<K, V>(l : Trie<K, V>, r : Trie<K, V>) : Trie<K, V>
```

Construye un nodo de rama, calculando el tamaño almacenado allí.

## Función `leaf`

```motoko no-repl
func leaf<K, V>(kvs : AssocList<Key<K>, V>, bitpos : Nat) : Trie<K, V>
```

Construye un nodo hoja, calculando el tamaño almacenado allí.

Esta función auxiliar aplica automáticamente el MAX_LEAF_SIZE construyendo ramas
según sea necesario; para hacerlo, también necesita la posición de bit del nodo
hoja.

## Función `fromList`

```motoko no-repl
func fromList<K, V>(kvc : ?Nat, kvs : AssocList<Key<K>, V>, bitpos : Nat) : Trie<K, V>
```

Transforma una lista en un trie, dividiendo la lista de entrada en listas
pequeñas (hojas), si es necesario.

## Función `clone`

```motoko no-repl
func clone<K, V>(t : Trie<K, V>) : Trie<K, V>
```

Clona el trie de manera eficiente, a través del uso compartido.

La representación puramente funcional permite una copia _O(1)_, a través del uso
compartido persistente.

## Función `replace`

```motoko no-repl
func replace<K, V>(t : Trie<K, V>, k : Key<K>, k_eq : (K, K) -> Bool, v : ?V) : (Trie<K, V>, ?V)
```

Reemplaza la opción de valor de la clave dada con el valor dado, devolviendo el
trie modificado. También devuelve el valor reemplazado si la clave existía y
`null` en caso contrario. Compara las claves usando la función proporcionada
`k_eq`.

Nota: Reemplazar el valor de una clave por `null` elimina la clave y también
reduce el tamaño del trie.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "test", Text.equal, 1).0;
trie := Trie.replace(trie, key "test", Text.equal, 42).0;
assert (Trie.get(trie, key "hello", Text.equal) == ?42);
```

## Función `put`

```motoko no-repl
func put<K, V>(t : Trie<K, V>, k : Key<K>, k_eq : (K, K) -> Bool, v : V) : (Trie<K, V>, ?V)
```

Inserta el valor de la clave dada en el trie; devuelve el nuevo trie y el valor
anterior asociado con la clave, si existe.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
let previousValue = Trie.put(trie, key "hello", Text.equal, 33).1; // Returns ?42
assert(previousValue == ?42);
```

## Función `get`

```motoko no-repl
func get<K, V>(t : Trie<K, V>, k : Key<K>, k_eq : (K, K) -> Bool) : ?V
```

Obtiene el valor de la clave dada en el trie, o devuelve `null` si no existe.

Para obtener una descripción más detallada de cómo usar un Trie, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
var value = Trie.get(trie, key "hello", Text.equal); // Returns `?42`
assert(value == ?42);
value := Trie.get(trie, key "world", Text.equal); // Returns `null`
assert(value == null);
```

## Función `find`

```motoko no-repl
func find<K, V>(t : Trie<K, V>, k : Key<K>, k_eq : (K, K) -> Bool) : ?V
```

Encuentra el valor de la clave dada en el trie, o devuelve `null` si no existe.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
var value = Trie.find(trie, key "hello", Text.equal); // Returns `?42`
assert(value == ?42);
value := Trie.find(trie, key "world", Text.equal); // Returns `null`
assert(value == null);
```

## Función `merge`

```motoko no-repl
func merge<K, V>(tl : Trie<K, V>, tr : Trie<K, V>, k_eq : (K, K) -> Bool) : Trie<K, V>
```

Combina tries, prefiriendo el trie izquierdo en caso de colisiones en claves
comunes.

nota: la operación `disj` generaliza esta operación `merge` de varias maneras, y
no pierde información (en general); esta operación es un caso más simple y
especial de la misma.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 42).0;
// trie2 is a copy of trie
var trie2 = Trie.clone(trie);
// trie2 has a different value for "hello"
trie2 := Trie.put(trie2, key "hello", Text.equal, 33).0;
// mergedTrie has the value 42 for "hello", as the left trie is preferred
// in the case of a collision
var mergedTrie = Trie.merge(trie, trie2, Text.equal);
var value = Trie.get(mergedTrie, key "hello", Text.equal);
assert(value == ?42);
```

## Función `mergeDisjoint`

```motoko no-repl
func mergeDisjoint<K, V>(tl : Trie<K, V>, tr : Trie<K, V>, k_eq : (K, K) -> Bool) : Trie<K, V>
```

<a name="mergedisjoint"></a>

Combina tries como `merge`, pero genera un error si hay colisiones en claves
comunes entre las entradas izquierda y derecha.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 42).0;
// trie2 is a copy of trie
var trie2 = Trie.clone(trie);
// trie2 has a different value for "hello"
trie2 := Trie.put(trie2, key "hello", Text.equal, 33).0;
// `mergeDisjoint` signals a dynamic errror
// in the case of a collision
var mergedTrie = Trie.mergeDisjoint(trie, trie2, Text.equal);
```

## Función `diff`

```motoko no-repl
func diff<K, V, W>(tl : Trie<K, V>, tr : Trie<K, W>, k_eq : (K, K) -> Bool) : Trie<K, V>
```

Diferencia de tries. La salida consiste en pares del trie izquierdo cuyas claves
no están presentes en el trie derecho; los valores del trie derecho no son
relevantes.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 42).0;
// trie2 is a copy of trie
var trie2 = Trie.clone(trie);
// trie2 now has an additional key
trie2 := Trie.put(trie2, key "ciao", Text.equal, 33).0;
// `diff` returns a trie with the key "ciao",
// as this key is not present in `trie`
// (note that we pass `trie2` as the left trie)
Trie.diff(trie2, trie, Text.equal);
```

## Función `disj`

```motoko no-repl
func disj<K, V, W, X>(tl : Trie<K, V>, tr : Trie<K, W>, k_eq : (K, K) -> Bool, vbin : (?V, ?W) -> X) : Trie<K, X>
```

Unión de maps.

Esta operación generaliza la noción de "unión de conjuntos" a maps finitos.

Produce una "imagen disjunta" de los dos tries, donde los valores de las claves
coincidentes se combinan con el operador binario dado.

Para los pares clave-valor no coincidentes, el operador aún se aplica para crear
el valor en la imagen. Para acomodar estas diversas situaciones, el operador
acepta valores opcionales, pero nunca se aplica a (null, null).

Implementa la idea de una unión externa en bases de datos
["outer join"](https://stackoverflow.com/questions/38549/what-is-the-difference-between-inner-join-and-outer-join).

## Función `join`

```motoko no-repl
func join<K, V, W, X>(tl : Trie<K, V>, tr : Trie<K, W>, k_eq : (K, K) -> Bool, vbin : (V, W) -> X) : Trie<K, X>
```

Unión de maps.

Implementa la idea de una unión interna en bases de datos
["inner join"](https://stackoverflow.com/questions/38549/what-is-the-difference-between-inner-join-and-outer-join).

Esta operación generaliza la noción de "intersección de conjuntos" a maps
finitos. Los valores de las claves coincidentes se combinan con el operador
binario dado y los pares clave-valor no coincidentes no están presentes en la
salida.

## Función `foldUp`

```motoko no-repl
func foldUp<K, V, X>(t : Trie<K, V>, bin : (X, X) -> X, leaf : (K, V) -> X, empty : X) : X
```

Esta operación proporciona un recursor para la estructura interna de los tries.
Muchas operaciones comunes son instancias de esta función, ya sea como clientes
o como versiones especializadas a mano (por ejemplo, ver , map, mapFilter, some
y all a continuación).

## Función `prod`

```motoko no-repl
func prod<K1, V1, K2, V2, K3, V3>(tl : Trie<K1, V1>, tr : Trie<K2, V2>, op : (K1, V1, K2, V2) -> ?(Key<K3>, V3), k3_eq : (K3, K3) -> Bool) : Trie<K3, V3>
```

Producto de maps.

Producto cartesiano condicional, donde la operación dada `op` crea elementos de
salida condicionalmente en el trie resultante.

La estructura clave de los tries de entrada no es relevante para esta operación:
se consideran todos los pares, independientemente de si las claves coinciden o
no. Además, el trie resultante puede usar claves que no están relacionadas con
estas claves de entrada.

## Función `iter`

```motoko no-repl
func iter<K, V>(t : Trie<K, V>) : I.Iter<(K, V)>
```

Devuelve un iterador de tipo `Iter` sobre las entradas clave-valor del trie.

Cada iterador obtiene una "vista persistente" del mapeo, independiente de las
actualizaciones concurrentes al map iterado.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulte la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
// create an Iterator over key-value pairs of trie
let iter = Trie.iter(trie);
// add another key-value pair to `trie`.
// because we created our iterator before
// this update, it will not contain this new key-value pair
trie := Trie.put(trie, key "ciao", Text.equal, 3).0;
var sum : Nat = 0;
for ((k,v) in iter) {
  sum += v;
};
assert(sum == 74);
```

## Módulo `Build`

```motoko no-repl
module Build
```

Representa la construcción de tries como datos.

Este módulo proporciona variantes optimizadas de tries normales para consultas
de unión más eficientes.

La idea central es que, para los resultados de consultas de unión (no
materializados), no necesitamos construir realmente ningún trie resultante de
los datos, sino que solo necesitamos una colección de lo que estaría en ese
trie. Dado que los resultados de las consultas pueden ser grandes (cuadráticos
en el tamaño de la base de datos), evitar la construcción de este trie
proporciona un ahorro considerable.

Para obtener este ahorro, utilizamos un ADT para las operaciones que
_construirían_ este trie, si se evaluaran. Esta estructura especializa una
cuerda: un árbol equilibrado que representa una secuencia. Solo está tan
equilibrado como los tries a partir de los cuales generamos estos AST de
construcción. No tienen propiedades de equilibrio intrínsecas propias.

### Tipo `Build`

```motoko no-repl
type Build<K, V> = {#skip; #put : (K, ?Hash.Hash, V); #seq : { size : Nat; left : Build<K, V>; right : Build<K, V> }}
```

La construcción de un trie, como un AST para un DSL simple.

### Función `size`

```motoko no-repl
func size<K, V>(tb : Build<K, V>) : Nat
```

Tamaño de la construcción, medido en operaciones `#put`

### Función `seq`

```motoko no-repl
func seq<K, V>(l : Build<K, V>, r : Build<K, V>) : Build<K, V>
```

Secuencia de construcción de dos subconstrucciones

### Función `prod`

```motoko no-repl
func prod<K1, V1, K2, V2, K3, V3>(tl : Trie<K1, V1>, tr : Trie<K2, V2>, op : (K1, V1, K2, V2) -> ?(K3, V3), _k3_eq : (K3, K3) -> Bool) : Build<K3, V3>
```

Similar a [`prod`](#prod), excepto que no realiza realmente las llamadas `put`,
solo las registra como una estructura de datos (árbol binario) isomorfa a la
recursión de esta función (que está equilibrada, en promedio).

### Función `nth`

```motoko no-repl
func nth<K, V>(tb : Build<K, V>, i : Nat) : ?(K, ?Hash.Hash, V)
```

Proyecta el par clave-valor enésimo de la construcción del trie.

Esta posición solo es significativa cuando la construcción contiene múltiples
usos de una o más claves; de lo contrario, no lo es.

### Función `projectInner`

```motoko no-repl
func projectInner<K1, K2, V>(t : Trie<K1, Build<K2, V>>) : Build<K2, V>
```

Similar a [`mergeDisjoint`](#mergedisjoint), excepto que evita el trabajo de
fusionar realmente cualquier trie; en su lugar, solo registra el trabajo para
más tarde (si alguna vez).

### Función `toArray`

```motoko no-repl
func toArray<K, V, W>(tb : Build<K, V>, f : (K, V) -> W) : [W]
```

Reúne la colección de pares clave-valor en un array de un tipo (posiblemente
distinto).

## Función `fold`

```motoko no-repl
func fold<K, V, X>(t : Trie<K, V>, f : (K, V, X) -> X, x : X) : X
```

Fold sobre los pares clave-valor del trie, utilizando un acumulador. Los pares
clave-valor no tienen un orden confiable o significativo.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulte la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
trie := Trie.put(trie, key "ciao", Text.equal, 3).0;
// create an accumulator, in our case the sum of all values
func calculateSum(k : Text, v : Nat, acc : Nat) : Nat = acc + v;
// Fold over the trie using the accumulator.
// Note that 0 is the initial value of the accumulator.
let sum = Trie.fold(trie, calculateSum, 0);
assert(sum == 77);
```

## Función `some`

```motoko no-repl
func some<K, V>(t : Trie<K, V>, f : (K, V) -> Bool) : Bool
```

Comprueba si un par clave-valor dado está presente o no.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulte la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
trie := Trie.put(trie, key "ciao", Text.equal, 3).0;
// `some` takes a function that returns a Boolean indicating whether
// the key-value pair is present or not
var isPresent = Trie.some(
  trie,
  func(k : Text, v : Nat) : Bool = k == "bye" and v == 32,
);
assert(isPresent == true);
isPresent := Trie.some(
  trie,
  func(k : Text, v : Nat) : Bool = k == "hello" and v == 32,
);
assert(isPresent == false);
```

## Función `all`

```motoko no-repl
func all<K, V>(t : Trie<K, V>, f : (K, V) -> Bool) : Bool
```

Comprueba si todos los pares clave-valor tienen una propiedad dada.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulte la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
trie := Trie.put(trie, key "ciao", Text.equal, 10).0;
// `all` takes a function that returns a boolean indicating whether
// the key-value pairs all have a given property, in our case that
// all values are greater than 9
var hasProperty = Trie.all(
  trie,
  func(k : Text, v : Nat) : Bool = v > 9,
);
assert(hasProperty == true);
// now we check if all values are greater than 100
hasProperty := Trie.all(
  trie,
  func(k : Text, v : Nat) : Bool = v > 100,
);
assert(hasProperty == false);
```

## Función `nth`

```motoko no-repl
func nth<K, V>(t : Trie<K, V>, i : Nat) : ?(Key<K>, V)
```

Proyecta el par clave-valor enésimo del trie.

Nota: Esta posición no es significativa; solo está aquí para que podamos
inyectar tries en arrays usando funciones como `Array.tabulate`.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulte la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
import Array "mo:base/Array";
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
trie := Trie.put(trie, key "ciao", Text.equal, 10).0;
// `tabulate` takes a size parameter, so we check the size of
// the trie first
let size = Trie.size(trie);
// Now we can create an array of the same size passing `nth` as
// the generator used to fill the array.
// Note that `toArray` is a convenience function that does the
// same thing without you having to check whether the tuple is
// `null` or not, which we're not doing in this example
let array = Array.tabulate<?(Key<Text>, Nat)>(
  size,
  func n = Trie.nth(trie, n)
);
```

## Función `toArray`

```motoko no-repl
func toArray<K, V, W>(t : Trie<K, V>, f : (K, V) -> W) : [W]
```

Reúne la colección de pares clave-valor en un array de un tipo (posiblemente
distinto).

Para obtener una descripción más detallada de cómo usar un `Trie`, consulte la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
trie := Trie.put(trie, key "ciao", Text.equal, 10).0;
// `toArray` takes a function that takes a key-value tuple
// and returns a value of the type you want to use to fill
// the array.
// In our case we just return the value
let array = Trie.toArray<Text, Nat, Nat>(
  trie,
  func (k, v) = v
);
```

## Función `isEmpty`

```motoko no-repl
func isEmpty<K, V>(t : Trie<K, V>) : Bool
```

Comprueba la "vaciedad profunda": subárboles que tienen estructura de
ramificación, pero no hojas. Estos pueden resultar de operaciones de filtrado
ingenuas; el filtro utiliza esta función para evitar crear tales subárboles.

## Función `filter`

```motoko no-repl
func filter<K, V>(t : Trie<K, V>, f : (K, V) -> Bool) : Trie<K, V>
```

Filtra los pares clave-valor según un predicado dado.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulte la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
trie := Trie.put(trie, key "ciao", Text.equal, 10).0;
// `filter` takes a function that takes a key-value tuple
// and returns true if the key-value pair should be included.
// In our case those are pairs with a value greater than 20
let filteredTrie = Trie.filter<Text, Nat>(
  trie,
  func (k, v) = v > 20
);
assert (Trie.all<Text, Nat>(filteredTrie, func(k, v) = v > 20) == true);
```

## Función `mapFilter`

```motoko no-repl
func mapFilter<K, V, W>(t : Trie<K, V>, f : (K, V) -> ?W) : Trie<K, W>
```

Mapea y filtra los pares clave-valor según un predicado dado.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
trie := Trie.put(trie, key "ciao", Text.equal, 10).0;
// `mapFilter` takes a function that takes a key-value tuple
// and returns a possibly-distinct value if the key-value pair should be included.
// In our case, we filter for values greater than 20 and map them to their square.
let filteredTrie = Trie.mapFilter<Text, Nat, Nat>(
  trie,
  func (k, v) = if (v > 20) return ?(v**2) else return null
);
assert (Trie.all<Text, Nat>(filteredTrie, func(k, v) = v > 60) == true);
```

## Función `equalStructure`

```motoko no-repl
func equalStructure<K, V>(tl : Trie<K, V>, tr : Trie<K, V>, keq : (K, K) -> Bool, veq : (V, V) -> Bool) : Bool
```

Comprueba la igualdad, pero de manera ingenua, basada en la estructura. No
intenta eliminar "basura" en el árbol; por ejemplo, un enfoque "más inteligente"
igualaría `#bin {left = #empty; right = #empty}` con `#empty`. No observamos esa
igualdad aquí.

## Función `replaceThen`

```motoko no-repl
func replaceThen<K, V, X>(t : Trie<K, V>, k : Key<K>, k_eq : (K, K) -> Bool, v2 : V, success : (Trie<K, V>, V) -> X, fail : () -> X) : X
```

Reemplaza el valor de la clave dada en el trie y solo si tiene éxito, realiza la
continuación de éxito, de lo contrario, devuelve el valor de falla.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
trie := Trie.put(trie, key "ciao", Text.equal, 10).0;
// `replaceThen` takes the same arguments as `replace` but also a success continuation
// and a failure connection that are called in the respective scenarios.
// if the replace fails, that is the key is not present in the trie, the failure continuation is called.
// if the replace succeeds, that is the key is present in the trie, the success continuation is called.
// in this example we are simply returning the Text values `success` and `fail` respectively.
var continuation = Trie.replaceThen<Text, Nat, Text>(
  trie,
  key "hello",
  Text.equal,
  12,
  func (t, v) = "success",
  func () = "fail"
);
assert (continuation == "success");
continuation := Trie.replaceThen<Text, Nat, Text>(
  trie,
  key "shalom",
  Text.equal,
  12,
  func (t, v) = "success",
  func () = "fail"
);
assert (continuation == "fail");
```

## Función `putFresh`

```motoko no-repl
func putFresh<K, V>(t : Trie<K, V>, k : Key<K>, k_eq : (K, K) -> Bool, v : V) : Trie<K, V>
```

Coloca el valor de la clave dada en el trie; devuelve el nuevo trie; asegura que
no haya un valor previo asociado con la clave.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
// note that compared to `put`, `putFresh` does not return a tuple
trie := Trie.putFresh(trie, key "hello", Text.equal, 42);
trie := Trie.putFresh(trie, key "bye", Text.equal, 32);
// this will fail as "hello" is already present in the trie
trie := Trie.putFresh(trie, key "hello", Text.equal, 10);
```

## Función `put2D`

```motoko no-repl
func put2D<K1, K2, V>(t : Trie2D<K1, K2, V>, k1 : Key<K1>, k1_eq : (K1, K1) -> Bool, k2 : Key<K2>, k2_eq : (K2, K2) -> Bool, v : V) : Trie2D<K1, K2, V>
```

Coloca el valor de la clave dada en el trie 2D; devuelve el nuevo trie 2D.

## Función `put3D`

```motoko no-repl
func put3D<K1, K2, K3, V>(t : Trie3D<K1, K2, K3, V>, k1 : Key<K1>, k1_eq : (K1, K1) -> Bool, k2 : Key<K2>, k2_eq : (K2, K2) -> Bool, k3 : Key<K3>, k3_eq : (K3, K3) -> Bool, v : V) : Trie3D<K1, K2, K3, V>
```

Coloca el valor de la clave dada en el trie; devuelve el nuevo trie;

## Función `remove`

```motoko no-repl
func remove<K, V>(t : Trie<K, V>, k : Key<K>, k_eq : (K, K) -> Bool) : (Trie<K, V>, ?V)
```

Elimina la entrada de la clave dada del trie, devolviendo el trie reducido.
También devuelve el valor eliminado si la clave existía y `null` en caso
contrario. Compara claves usando la función proporcionada `k_eq`.

Nota: La eliminación de una clave existente reduce el trie.

Para obtener una descripción más detallada de cómo usar un `Trie`, consulta la
[Descripción general del usuario](#overview).

Ejemplo:

```motoko include=initialize
trie := Trie.put(trie, key "hello", Text.equal, 42).0;
trie := Trie.put(trie, key "bye", Text.equal, 32).0;
// remove the entry associated with "hello"
trie := Trie.remove(trie, key "hello", Text.equal).0;
assert (Trie.get(trie, key "hello", Text.equal) == null);
```

## Función `removeThen`

```motoko no-repl
func removeThen<K, V, X>(t : Trie<K, V>, k : Key<K>, k_eq : (K, K) -> Bool, success : (Trie<K, V>, V) -> X, fail : () -> X) : X
```

Elimina el valor de la clave dada en el trie y solo si tiene éxito, realiza la
continuación de éxito, de lo contrario, devuelve el valor de falla

## Función `remove2D`

```motoko no-repl
func remove2D<K1, K2, V>(t : Trie2D<K1, K2, V>, k1 : Key<K1>, k1_eq : (K1, K1) -> Bool, k2 : Key<K2>, k2_eq : (K2, K2) -> Bool) : (Trie2D<K1, K2, V>, ?V)
```

elimina el valor de la pareja clave-clave dada en el trie 2D; devuelve el nuevo
trie y el valor anterior, si lo hay.

## Función `remove3D`

```motoko no-repl
func remove3D<K1, K2, K3, V>(t : Trie3D<K1, K2, K3, V>, k1 : Key<K1>, k1_eq : (K1, K1) -> Bool, k2 : Key<K2>, k2_eq : (K2, K2) -> Bool, k3 : Key<K3>, k3_eq : (K3, K3) -> Bool) : (Trie3D<K1, K2, K3, V>, ?V)
```

Elimina el valor de la pareja clave-clave dada en el trie 3D; devuelve el nuevo
trie y el valor anterior, si lo hay.

## Función `mergeDisjoint2D`

```motoko no-repl
func mergeDisjoint2D<K1, K2, V>(t : Trie2D<K1, K2, V>, _k1_eq : (K1, K1) -> Bool, k2_eq : (K2, K2) -> Bool) : Trie<K2, V>
```

Similar a [`mergeDisjoint`](#mergedisjoint), excepto que en lugar de fusionar un
par, fusiona la colección de subárboles de dimensión 2 de un trie 2D.
