# Buffer

# Buffer

La clase `Buffer<X>` proporciona una lista mutable de elementos de tipo `X`. La
clase envuelve y redimensiona un array subyacente que contiene los elementos, y
por lo tanto es comparable a ArrayLists o Vectores en otros lenguajes.

Cuando sea necesario, el estado actual de un objeto buffer se puede convertir en
un array de tamaño fijo de sus elementos. Esto se recomienda, por ejemplo, al
almacenar un buffer en una variable estable.

A lo largo de esta documentación, aparecen dos términos que pueden confundirse:
`size` y `capacity`. `size` es la longitud de la lista que representa el buffer.
`capacity` es la longitud del array subyacente que respalda esta lista.
`capacity` >= `size` es una invariante para esta clase.

Al igual que los arrays, los elementos en el buffer están ordenados por índices
del 0 a `size`-1.

ADVERTENCIA: Ciertas operaciones tienen un tiempo amortizado O(1), como `add`,
pero se ejecutan en el peor caso en tiempo O(n). Estos tiempos de ejecución en
el peor caso pueden superar el límite de ciclos por mensaje si el tamaño del
buffer es lo suficientemente grande. Haga crecer estas estructuras con
discreción. Todas las operaciones amortizadas a continuación también indican el
tiempo de ejecución en el peor caso.

Constructor: El argumento `initCapacity` determina la capacidad inicial del
array. El array subyacente crece en un factor de 1.5 cuando se excede su
capacidad actual. Además, cuando el tamaño del buffer se reduce a menos de 1/4
de la capacidad, el array subyacente se reduce en un factor de 2.

Ejemplo:

```motoko name=initialize
import Buffer "mo:base/Buffer";

let buffer = Buffer.Buffer<Nat>(3); // Creates a new Buffer
```

Tiempo de ejecución: O(initCapacity)

Espacio: O(initCapacity)

## Clase `Buffer<X>`

```motoko no-repl
class Buffer<X>(initCapacity : Nat)
```

### Función `size`

```motoko no-repl
func size() : Nat
```

Devuelve el número actual de elementos en el buffer.

Ejemplo:

```motoko include=initialize
buffer.size() // => 0
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `add`

```motoko no-repl
func add(element : X)
```

Agrega un solo elemento al final del buffer, duplicando el tamaño del array si
se excede la capacidad.

Ejemplo:

```motoko include=initialize

buffer.add(0); // add 0 to buffer
buffer.add(1);
buffer.add(2);
buffer.add(3); // causes underlying array to increase in capacity
Buffer.toArray(buffer) // => [0, 1, 2, 3]
```

Tiempo de ejecución amortizado: O(1), Peor Caso Tiempo de ejecución: O(size)

Espacio amortizado: O(1), Peor Caso Espacio: O(size)

### Función `get`

```motoko no-repl
func get(index : Nat) : X
```

Devuelve el elemento en el índice `index`. Traps si `index >= size`. La
indexación comienza en cero.

Ejemplo:

```motoko include=initialize

buffer.add(10);
buffer.add(11);
buffer.get(0); // => 10
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `getOpt`

```motoko no-repl
func getOpt(index : Nat) : ?X
```

Devuelve el elemento en el índice `index` como una opción. Devuelve `null`
cuando `index >= size`. La indexación comienza en cero.

Ejemplo:

```motoko include=initialize

buffer.add(10);
buffer.add(11);
let x = buffer.getOpt(0); // => ?10
let y = buffer.getOpt(2); // => null
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `put`

```motoko no-repl
func put(index : Nat, element : X)
```

Sobrescribe el elemento actual en `index` con `element`. Traps si `index` >=
tamaño. La indexación comienza en cero.

Ejemplo:

```motoko include=initialize

buffer.add(10);
buffer.put(0, 20); // overwrites 10 at index 0 with 20
Buffer.toArray(buffer) // => [20]
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `removeLast`

```motoko no-repl
func removeLast() : ?X
```

Remueve y devuelve el último elemento en el buffer o `null` si el buffer está
vacío.

Ejemplo:

```motoko include=initialize

buffer.add(10);
buffer.add(11);
buffer.removeLast(); // => ?11
```

Tiempo de ejecución amortizado: O(1), Peor Caso Tiempo de ejecución: O(size)

Espacio amortizado: O(1), Peor Caso Espacio: O(size)

### Función `remove`

```motoko no-repl
func remove(index : Nat) : X
```

Remueve y devuelve el elemento en `index` del buffer. Todos los elementos con
índice > `index` se desplazan una posición a la izquierda. Esto puede causar una
reducción del tamaño del array.

Traps si index >= size.

ADVERTENCIA: La eliminación repetida de elementos utilizando este método es
ineficiente y puede ser una señal de que debes considerar una estructura de
datos diferente para tu caso de uso.

Ejemplo:

```motoko include=initialize

buffer.add(10);
buffer.add(11);
buffer.add(12);
let x = buffer.remove(1); // evaluates to 11. 11 no longer in list.
Buffer.toArray(buffer) // => [10, 12]
```

Tiempo de ejecución: O(size)

Espacio amortizado: O(1), Peor Caso Espacio: O(size)

### Función `clear`

```motoko no-repl
func clear()
```

Reinicia el buffer. La capacidad se establece en 8.

Ejemplo:

```motoko include=initialize

buffer.add(10);
buffer.add(11);
buffer.add(12);
buffer.clear(); // buffer is now empty
Buffer.toArray(buffer) // => []
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `filterEntries`

```motoko no-repl
func filterEntries(predicate : (Nat, X) -> Bool)
```

Remueve todos los elementos del buffer para los cuales el predicado devuelve
falso. El predicado recibe tanto el índice del elemento como el elemento en sí.
Esto puede causar una reducción del tamaño del array.

Ejemplo:

```motoko include=initialize

buffer.add(10);
buffer.add(11);
buffer.add(12);
buffer.filterEntries(func(_, x) = x % 2 == 0); // only keep even elements
Buffer.toArray(buffer) // => [10, 12]
```

Tiempo de ejecución: O(size)

Espacio amortizado: O(1), Peor Caso Espacio: O(size)

### Función `capacity`

```motoko no-repl
func capacity() : Nat
```

Devuelve la capacidad del buffer (la longitud del array subyacente).

Ejemplo:

```motoko include=initialize

let buffer = Buffer.Buffer<Nat>(2); // underlying array has capacity 2
buffer.add(10);
let c1 = buffer.capacity(); // => 2
buffer.add(11);
buffer.add(12); // causes capacity to increase by factor of 1.5
let c2 = buffer.capacity(); // => 3
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `reserve`

```motoko no-repl
func reserve(capacity : Nat)
```

Cambia la capacidad a `capacity`. Traps si `capacity` < `size`.

```motoko include=initialize

buffer.reserve(4);
buffer.add(10);
buffer.add(11);
buffer.capacity(); // => 4
```

Tiempo de ejecución: O(capacity)

Espacio: O(capacity)

### Función `append`

```motoko no-repl
func append(buffer2 : Buffer<X>)
```

Agrega todos los elementos en el buffer `b` a este buffer.

```motoko include=initialize
let buffer1 = Buffer.Buffer<Nat>(2);
let buffer2 = Buffer.Buffer<Nat>(2);
buffer1.add(10);
buffer1.add(11);
buffer2.add(12);
buffer2.add(13);
buffer1.append(buffer2); // adds elements from buffer2 to buffer1
Buffer.toArray(buffer1) // => [10, 11, 12, 13]
```

Tiempo de ejecución amortizado: O(size2), Peor Caso Tiempo de ejecución:
O(size1 + size2)

Espacio amortizado: O(1), Peor Caso Espacio: O(size1 + size2)

### Función `insert`

```motoko no-repl
func insert(index : Nat, element : X)
```

Inserta `element` en `index`, desplaza todos los elementos a la derecha de
`index` en un índice. Traps si `index` es mayor que el tamaño.

```motoko include=initialize
let buffer1 = Buffer.Buffer<Nat>(2);
let buffer2 = Buffer.Buffer<Nat>(2);
buffer.add(10);
buffer.add(11);
buffer.insert(1, 9);
Buffer.toArray(buffer) // => [10, 9, 11]
```

Tiempo de ejecución: O(size)

Espacio amortizado: O(1), Peor Caso Espacio: O(size)

### Función `insertBuffer`

```motoko no-repl
func insertBuffer(index : Nat, buffer2 : Buffer<X>)
```

Inserta `buffer2` en `index`, desplaza todos los elementos a la derecha de
`index` en un índice. Traps si `index` es mayor que el tamaño.

```motoko include=initialize
let buffer1 = Buffer.Buffer<Nat>(2);
let buffer2 = Buffer.Buffer<Nat>(2);
buffer1.add(10);
buffer1.add(11);
buffer2.add(12);
buffer2.add(13);
buffer1.insertBuffer(1, buffer2);
Buffer.toArray(buffer1) // => [10, 12, 13, 11]
```

Tiempo de ejecución: O(size)

Espacio amortizado: O(1), Peor Caso Espacio: O(size1 + size2)

### Función `sort`

```motoko no-repl
func sort(compare : (X, X) -> Order.Order)
```

Ordena los elementos en el buffer según `compare`. La ordenación es
determinista, estable y en su lugar.

```motoko include=initialize

import Nat "mo:base/Nat";

buffer.add(11);
buffer.add(12);
buffer.add(10);
buffer.sort(Nat.compare);
Buffer.toArray(buffer) // => [10, 11, 12]
```

Tiempo de ejecución: O(size \* log(size))

Espacio: O(size)

### Función `vals`

```motoko no-repl
func vals() : { next : () -> ?X }
```

Devuelve un Iterador (`Iter`) sobre los elementos de este buffer. El Iterador
proporciona un único método `next()`, que devuelve los elementos en orden, o
`null` cuando no hay más elementos para iterar.

```motoko include=initialize

buffer.add(10);
buffer.add(11);
buffer.add(12);

var sum = 0;
for (element in buffer.vals()) {
  sum += element;
};
sum // => 33
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `clone`

```motoko no-repl
func clone() : Buffer<X>
```

@deprecated Use static library function instead.

### Función `toArray`

```motoko no-repl
func toArray() : [X]
```

@deprecated Use static library function instead.

### Función `toVarArray`

```motoko no-repl
func toVarArray() : [var X]
```

@deprecated Use static library function instead.

## Function `isEmpty`

```motoko no-repl
func isEmpty<X>(buffer : Buffer<X>) : Bool
```

Returna true si y solo si el buffer está vacío.

Ejemplo:

```motoko include=initialize
buffer.add(2);
buffer.add(0);
buffer.add(3);
Buffer.isEmpty(buffer); // => false
```

```motoko include=initialize
Buffer.isEmpty(buffer); // => true
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Function `contains`

```motoko no-repl
func contains<X>(buffer : Buffer<X>, element : X, equal : (X, X) -> Bool) : Bool
```

Devuelve true si y solo si `buffer` contiene `element` con respecto a la
igualdad definida por `equal`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(2);
buffer.add(0);
buffer.add(3);
Buffer.contains<Nat>(buffer, 2, Nat.equal); // => true
```

Tiempo de ejecución: O(size)

Espacio: O(1) \*El tiempo de ejecución y el espacio asumen que `equal` se
ejecuta en tiempo y espacio O(1).

## Function `clone`

```motoko no-repl
func clone<X>(buffer : Buffer<X>) : Buffer<X>
```

Devuelve una copia de `buffer`, con la misma capacidad.

Ejemplo:

```motoko include=initialize

buffer.add(1);

let clone = Buffer.clone(buffer);
Buffer.toArray(clone); // => [1]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Function `max`

```motoko no-repl
func max<X>(buffer : Buffer<X>, compare : (X, X) -> Order) : ?X
```

Encuentra el elemento más grande en `buffer` definido por `compare`. Devuelve
`null` si `buffer` está vacío.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);

Buffer.max(buffer, Nat.compare); // => ?2
```

Tiempo de ejecución: O(size)

Espacio: O(1) \*Tiempo de ejecución y espacio asume que `compare` se ejecuta en
tiempo y espacio O(1).

## Function `min`

```motoko no-repl
func min<X>(buffer : Buffer<X>, compare : (X, X) -> Order) : ?X
```

Encuentra el elemento más pequeño en `buffer` definido por `compare`. Devuelve
`null` si `buffer` está vacío.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);

Buffer.min(buffer, Nat.compare); // => ?1
```

Tiempo de ejecución: O(size)

Espacio: O(1) \*Tiempo de ejecución y espacio asume que `compare` se ejecuta en
tiempo y espacio O(1).

## Function `equal`

```motoko no-repl
func equal<X>(buffer1 : Buffer<X>, buffer2 : Buffer<X>, equal : (X, X) -> Bool) : Bool
```

Define la igualdad para dos buffers, utilizando `equal` para comparar
recursivamente los elementos en los buffers. Devuelve true si y solo si los dos
buffers tienen el mismo tamaño y `equal` evalúa a true para cada par de
elementos en los dos buffers con el mismo índice.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

let buffer1 = Buffer.Buffer<Nat>(2);
buffer1.add(1);
buffer1.add(2);

let buffer2 = Buffer.Buffer<Nat>(5);
buffer2.add(1);
buffer2.add(2);

Buffer.equal(buffer1, buffer2, Nat.equal); // => true
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `compare`

```motoko no-repl
func compare<X>(buffer1 : Buffer<X>, buffer2 : Buffer<X>, compare : (X, X) -> Order.Order) : Order.Order
```

Define la comparación para dos buffers, utilizando `compare` para comparar
recursivamente los elementos en los buffers. La comparación se define de forma
lexicográfica.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

let buffer1 = Buffer.Buffer<Nat>(2);
buffer1.add(1);
buffer1.add(2);

let buffer2 = Buffer.Buffer<Nat>(3);
buffer2.add(3);
buffer2.add(4);

Buffer.compare<Nat>(buffer1, buffer2, Nat.compare); // => #less
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `compare` se ejecuta en tiempo
y espacio O(1).

## Function `toText`

```motoko no-repl
func toText<X>(buffer : Buffer<X>, toText : X -> Text) : Text
```

Creates a textual representation of `buffer`, using `toText` to recursively
convert the elements into Text.

Example:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

Buffer.toText(buffer, Nat.toText); // => "[1, 2, 3, 4]"
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*Tiempo de ejecución and space assumes that `toText` runs in O(1) time and
space.

## Function `hash`

```motoko no-repl
func hash<X>(buffer : Buffer<X>, hash : X -> Nat32) : Nat32
```

Hashes `buffer` using `hash` to hash the underlying elements. The deterministic
hash function is a function of the elements in the Buffer, as well as their
ordering.

Example:

```motoko include=initialize
import Hash "mo:base/Hash";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(1000);

Buffer.hash<Nat>(buffer, Hash.hash); // => 2_872_640_342
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*Tiempo de ejecución and space assumes that `hash` runs in O(1) time and space.

## Function `indexOf`

```motoko no-repl
func indexOf<X>(element : X, buffer : Buffer<X>, equal : (X, X) -> Bool) : ?Nat
```

Finds the first index of `element` in `buffer` using equality of elements
defined by `equal`. Returns `null` if `element` is not found.

Example:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

Buffer.indexOf<Nat>(3, buffer, Nat.equal); // => ?2
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `lastIndexOf`

```motoko no-repl
func lastIndexOf<X>(element : X, buffer : Buffer<X>, equal : (X, X) -> Bool) : ?Nat
```

Finds the last index of `element` in `buffer` using equality of elements defined
by `equal`. Returns `null` if `element` is not found.

Example:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);
buffer.add(2);
buffer.add(2);

Buffer.lastIndexOf<Nat>(2, buffer, Nat.equal); // => ?5
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `indexOfBuffer`

```motoko no-repl
func indexOfBuffer<X>(subBuffer : Buffer<X>, buffer : Buffer<X>, equal : (X, X) -> Bool) : ?Nat
```

Searches for `subBuffer` in `buffer`, and returns the starting index if it is
found.

Example:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);
buffer.add(5);
buffer.add(6);

let sub = Buffer.Buffer<Nat>(2);
sub.add(4);
sub.add(5);
sub.add(6);

Buffer.indexOfBuffer<Nat>(sub, buffer, Nat.equal); // => ?3
```

Tiempo de ejecución: O(size of buffer + size of subBuffer)

Espacio: O(size of subBuffer)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `binarySearch`

```motoko no-repl
func binarySearch<X>(element : X, buffer : Buffer<X>, compare : (X, X) -> Order.Order) : ?Nat
```

Similar to indexOf, but runs in logarithmic time. Assumes that `buffer` is
sorted. Behavior is undefined if `buffer` is not sorted. Uses `compare` to
perform the search. Returns an index of `element` if it is found.

Example:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(4);
buffer.add(5);
buffer.add(6);

Buffer.binarySearch<Nat>(5, buffer, Nat.compare); // => ?2
```

Tiempo de ejecución: O(log(size))

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `compare` se ejecuta en tiempo
y espacio O(1).

## Function `subBuffer`

```motoko no-repl
func subBuffer<X>(buffer : Buffer<X>, start : Nat, length : Nat) : Buffer<X>
```

Devuelve el sub-buffer de `buffer` que comienza en el índice `start` y tiene una
longitud de `length`. Genera un error si `start` está fuera de los límites o si
`start + length` es mayor que el tamaño de `buffer`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);
buffer.add(5);
buffer.add(6);

let sub = Buffer.subBuffer(buffer, 3, 2);
Buffer.toText(sub, Nat.toText); // => [4, 5]
```

Tiempo de ejecución: O(length)

Espacio: O(length)

## Function `isSubBufferOf`

```motoko no-repl
func isSubBufferOf<X>(subBuffer : Buffer<X>, buffer : Buffer<X>, equal : (X, X) -> Bool) : Bool
```

Verifica si `subBuffer` es un sub-buffer de `buffer`. Utiliza `equal` para
comparar los elementos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);
buffer.add(5);
buffer.add(6);

let sub = Buffer.Buffer<Nat>(2);
sub.add(2);
sub.add(3);
Buffer.isSubBufferOf(sub, buffer, Nat.equal); // => true
```

Tiempo de ejecución: O(size of subBuffer + size of buffer)

Espacio: O(size of subBuffer)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `isStrictSubBufferOf`

```motoko no-repl
func isStrictSubBufferOf<X>(subBuffer : Buffer<X>, buffer : Buffer<X>, equal : (X, X) -> Bool) : Bool
```

Verifica si `subBuffer` es un sub-buffer estricto de `buffer`, es decir,
`subBuffer` debe estar estrictamente contenido dentro de los primeros y últimos
índices de `buffer`. Utiliza `equal` para comparar los elementos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

let sub = Buffer.Buffer<Nat>(2);
sub.add(2);
sub.add(3);
Buffer.isStrictSubBufferOf(sub, buffer, Nat.equal); // => true
```

Tiempo de ejecución: O(size of subBuffer + size of buffer)

Espacio: O(size of subBuffer)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `prefix`

```motoko no-repl
func prefix<X>(buffer : Buffer<X>, length : Nat) : Buffer<X>
```

Devuelve el prefijo de `buffer` de longitud `length`. Genera un error si
`length` es mayor que el tamaño de `buffer`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

let pre = Buffer.prefix(buffer, 3); // => [1, 2, 3]
Buffer.toText(pre, Nat.toText);
```

Tiempo de ejecución: O(length)

Espacio: O(length)

## Function `isPrefixOf`

```motoko no-repl
func isPrefixOf<X>(prefix : Buffer<X>, buffer : Buffer<X>, equal : (X, X) -> Bool) : Bool
```

Verifica si `prefix` es un prefijo de `buffer`. Utiliza `equal` para comparar
los elementos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

let pre = Buffer.Buffer<Nat>(2);
pre.add(1);
pre.add(2);
Buffer.isPrefixOf(pre, buffer, Nat.equal); // => true
```

Tiempo de ejecución: O(size of prefix)

Espacio: O(size of prefix)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `isStrictPrefixOf`

```motoko no-repl
func isStrictPrefixOf<X>(prefix : Buffer<X>, buffer : Buffer<X>, equal : (X, X) -> Bool) : Bool
```

Verifica si `prefix` es un prefijo estricto de `buffer`. Utiliza `equal` para
comparar los elementos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

let pre = Buffer.Buffer<Nat>(3);
pre.add(1);
pre.add(2);
pre.add(3);
Buffer.isStrictPrefixOf(pre, buffer, Nat.equal); // => true
```

Tiempo de ejecución: O(size of prefix)

Espacio: O(size of prefix)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `suffix`

```motoko no-repl
func suffix<X>(buffer : Buffer<X>, length : Nat) : Buffer<X>
```

Devuelve el sufijo de `buffer` de longitud `length`. Genera un error si `length`
es mayor que el tamaño de `buffer`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

let suf = Buffer.suffix(buffer, 3); // => [2, 3, 4]
Buffer.toText(suf, Nat.toText);
```

Tiempo de ejecución: O(length)

Espacio: O(length)

## Function `isSuffixOf`

```motoko no-repl
func isSuffixOf<X>(suffix : Buffer<X>, buffer : Buffer<X>, equal : (X, X) -> Bool) : Bool
```

Verifica si `suffix` es un sufijo de `buffer`. Utiliza `equal` para comparar los
elementos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

let suf = Buffer.Buffer<Nat>(3);
suf.add(2);
suf.add(3);
suf.add(4);
Buffer.isSuffixOf(suf, buffer, Nat.equal); // => true
```

Tiempo de ejecución: O(length of suffix)

Espacio: O(length of suffix)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `isStrictSuffixOf`

```motoko no-repl
func isStrictSuffixOf<X>(suffix : Buffer<X>, buffer : Buffer<X>, equal : (X, X) -> Bool) : Bool
```

Verifica si `suffix` es un sufijo estricto de `buffer`. Utiliza `equal` para
comparar los elementos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);

let suf = Buffer.Buffer<Nat>(3);
suf.add(2);
suf.add(3);
suf.add(4);
Buffer.isStrictSuffixOf(suf, buffer, Nat.equal); // => true
```

Tiempo de ejecución: O(length of suffix)

Espacio: O(length of suffix)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `forAll`

```motoko no-repl
func forAll<X>(buffer : Buffer<X>, predicate : X -> Bool) : Bool
```

Devuelve true si todos los elementos en `buffer` satisfacen `predicate`.

Ejemplo:

```motoko include=initialize

buffer.add(2);
buffer.add(3);
buffer.add(4);

Buffer.forAll<Nat>(buffer, func x { x > 1 }); // => true
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `predicate` se ejecuta en
tiempo y espacio O(1).

## Function `forSome`

```motoko no-repl
func forSome<X>(buffer : Buffer<X>, predicate : X -> Bool) : Bool
```

Devuelve true si algún elemento en `buffer` satisface `predicate`.

Ejemplo:

```motoko include=initialize

buffer.add(2);
buffer.add(3);
buffer.add(4);

Buffer.forSome<Nat>(buffer, func x { x > 3 }); // => true
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `predicate` se ejecuta en
tiempo y espacio O(1).

## Function `forNone`

```motoko no-repl
func forNone<X>(buffer : Buffer<X>, predicate : X -> Bool) : Bool
```

Devuelve true si ningún elemento en `buffer` satisface `predicate`.

Ejemplo:

```motoko include=initialize

buffer.add(2);
buffer.add(3);
buffer.add(4);

Buffer.forNone<Nat>(buffer, func x { x == 0 }); // => true
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `predicate` se ejecuta en
tiempo y espacio O(1).

## Function `toArray`

```motoko no-repl
func toArray<X>(buffer : Buffer<X>) : [X]
```

Crea un array que contiene los elementos de `buffer`.

Ejemplo:

```motoko include=initialize

buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.toArray<Nat>(buffer); // => [1, 2, 3]

```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Function `toVarArray`

```motoko no-repl
func toVarArray<X>(buffer : Buffer<X>) : [var X]
```

Crea un array mutable que contiene los elementos de `buffer`.

Ejemplo:

```motoko include=initialize

buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.toVarArray<Nat>(buffer); // => [1, 2, 3]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Function `fromArray`

```motoko no-repl
func fromArray<X>(array : [X]) : Buffer<X>
```

Crea un buffer que contiene los elementos de `array`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

let array = [2, 3];

let buf = Buffer.fromArray<Nat>(array); // => [2, 3]
Buffer.toText(buf, Nat.toText);
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Function `fromVarArray`

```motoko no-repl
func fromVarArray<X>(array : [var X]) : Buffer<X>
```

Crea un buffer que contiene los elementos de `array`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

let array = [var 1, 2, 3];

let buf = Buffer.fromVarArray<Nat>(array); // => [1, 2, 3]
Buffer.toText(buf, Nat.toText);
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Function `fromIter`

```motoko no-repl
func fromIter<X>(iter : { next : () -> ?X }) : Buffer<X>
```

Crea un buffer que contiene los elementos de `iter`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

let array = [1, 1, 1];
let iter = array.vals();

let buf = Buffer.fromIter<Nat>(iter); // => [1, 1, 1]
Buffer.toText(buf, Nat.toText);
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Function `trimToSize`

```motoko no-repl
func trimToSize<X>(buffer : Buffer<X>)
```

Reubica el array subyacente de `buffer` de modo que la capacidad == tamaño.

Ejemplo:

```motoko include=initialize

let buffer = Buffer.Buffer<Nat>(10);
buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.trimToSize<Nat>(buffer);
buffer.capacity(); // => 3
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Function `map`

```motoko no-repl
func map<X, Y>(buffer : Buffer<X>, f : X -> Y) : Buffer<Y>
```

Crea un nuevo buffer aplicando `f` a cada elemento en `buffer`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

let newBuf = Buffer.map<Nat, Nat>(buffer, func (x) { x + 1 });
Buffer.toText(newBuf, Nat.toText); // => [2, 3, 4]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Function `iterate`

```motoko no-repl
func iterate<X>(buffer : Buffer<X>, f : X -> ())
```

Aplica `f` a cada elemento en `buffer`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.iterate<Nat>(buffer, func (x) {
  Debug.print(Nat.toText(x)); // prints each element in buffer
});
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Function `mapEntries`

```motoko no-repl
func mapEntries<X, Y>(buffer : Buffer<X>, f : (Nat, X) -> Y) : Buffer<Y>
```

Aplica `f` a cada elemento en `buffer` y su índice.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

let newBuf = Buffer.mapEntries<Nat, Nat>(buffer, func (x, i) { x + i + 1 });
Buffer.toText(newBuf, Nat.toText); // => [2, 4, 6]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Function `mapFilter`

```motoko no-repl
func mapFilter<X, Y>(buffer : Buffer<X>, f : X -> ?Y) : Buffer<Y>
```

Crea un nuevo buffer aplicando `f` a cada elemento en `buffer` y manteniendo
todos los elementos no nulos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

let newBuf = Buffer.mapFilter<Nat, Nat>(buffer, func (x) {
  if (x > 1) {
    ?(x * 2);
  } else {
    null;
  }
});
Buffer.toText(newBuf, Nat.toText); // => [4, 6]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Function `mapResult`

```motoko no-repl
func mapResult<X, Y, E>(buffer : Buffer<X>, f : X -> Result.Result<Y, E>) : Result.Result<Buffer<Y>, E>
```

Crea un nuevo buffer aplicando `f` a cada elemento en `buffer`. Si alguna
invocación de `f` produce un `#err`, devuelve un `#err`. De lo contrario,
devuelve un `#ok` que contiene el nuevo buffer.

Ejemplo:

```motoko include=initialize
import Result "mo:base/Result";

buffer.add(1);
buffer.add(2);
buffer.add(3);

let result = Buffer.mapResult<Nat, Nat, Text>(buffer, func (k) {
  if (k > 0) {
    #ok(k);
  } else {
    #err("One or more elements are zero.");
  }
});

Result.mapOk<Buffer.Buffer<Nat>, [Nat], Text>(result, func buffer = Buffer.toArray(buffer)) // => #ok([1, 2, 3])
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Function `chain`

```motoko no-repl
func chain<X, Y>(buffer : Buffer<X>, k : X -> Buffer<Y>) : Buffer<Y>
```

Crea un nuevo buffer aplicando `k` a cada elemento en `buffer` y concatenando
los buffers resultantes en orden. Esta operación es similar a lo que en otros
lenguajes funcionales se conoce como bind monádico.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

let chain = Buffer.chain<Nat, Nat>(buffer, func (x) {
  let b = Buffer.Buffer<Nat>(2);
  b.add(x);
  b.add(x * 2);
  return b;
});
Buffer.toText(chain, Nat.toText); // => [1, 2, 2, 4, 3, 6]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*Tiempo de ejecución and space assumes that `k` runs in O(1) time and space.

## Function `foldLeft`

```motoko no-repl
func foldLeft<A, X>(buffer : Buffer<X>, base : A, combine : (A, X) -> A) : A
```

Colapsa los elementos en `buffer` en un único valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de izquierda a derecha.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.foldLeft<Text, Nat>(buffer, "", func (acc, x) { acc # Nat.toText(x)}); // => "123"
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*Tiempo de ejecución and space assumes that `combine` runs in O(1) time and
space.

## Function `foldRight`

```motoko no-repl
func foldRight<X, A>(buffer : Buffer<X>, base : A, combine : (X, A) -> A) : A
```

Colapsa los elementos en `buffer` en un único valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de derecha a izquierda.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.foldRight<Nat, Text>(buffer, "", func (x, acc) { Nat.toText(x) # acc }); // => "123"
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*Tiempo de ejecución and space assumes that `combine` runs in O(1) time and
space.

## Function `first`

```motoko no-repl
func first<X>(buffer : Buffer<X>) : X
```

Devuelve el primer elemento de `buffer`. Traps si `buffer` está vacío.

Ejemplo:

```motoko include=initialize

buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.first(buffer); // => 1
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Function `last`

```motoko no-repl
func last<X>(buffer : Buffer<X>) : X
```

Devuelve el último elemento de `buffer`. Traps si `buffer` está vacío.

Ejemplo:

```motoko include=initialize

buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.last(buffer); // => 3
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Function `make`

```motoko no-repl
func make<X>(element : X) : Buffer<X>
```

Devuelve un nuevo buffer con capacidad y tamaño 1, que contiene `element`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

let buffer = Buffer.make<Nat>(1);
Buffer.toText(buffer, Nat.toText); // => [1]
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Function `reverse`

```motoko no-repl
func reverse<X>(buffer : Buffer<X>)
```

Invierte el orden de los elementos en `buffer`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.reverse(buffer);
Buffer.toText(buffer, Nat.toText); // => [3, 2, 1]
```

Tiempo de ejecución: O(size)

Espacio: O(1)

## Function `merge`

```motoko no-repl
func merge<X>(buffer1 : Buffer<X>, buffer2 : Buffer<X>, compare : (X, X) -> Order) : Buffer<X>
```

Une dos buffers ordenados en un solo buffer ordenado, utilizando `compare` para
definir el orden. El orden final es estable. El comportamiento no está definido
si `buffer1` o `buffer2` no están ordenados.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

let buffer1 = Buffer.Buffer<Nat>(2);
buffer1.add(1);
buffer1.add(2);
buffer1.add(4);

let buffer2 = Buffer.Buffer<Nat>(2);
buffer2.add(2);
buffer2.add(4);
buffer2.add(6);

let merged = Buffer.merge<Nat>(buffer1, buffer2, Nat.compare);
Buffer.toText(merged, Nat.toText); // => [1, 2, 2, 4, 4, 6]
```

Tiempo de ejecución: O(size1 + size2)

Espacio: O(size1 + size2)

\*El tiempo de ejecución y el espacio asumen que `compare` se ejecuta en tiempo
y espacio O(1).

## Function `removeDuplicates`

```motoko no-repl
func removeDuplicates<X>(buffer : Buffer<X>, compare : (X, X) -> Order)
```

Elimina todos los elementos duplicados en `buffer` según lo definido por
`compare`. La eliminación es estable con respecto al orden original de los
elementos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(1);
buffer.add(2);
buffer.add(3);

Buffer.removeDuplicates<Nat>(buffer, Nat.compare);
Buffer.toText(buffer, Nat.toText); // => [1, 2, 3]
```

Tiempo de ejecución: O(size \* log(size))

Espacio: O(size)

## Function `partition`

```motoko no-repl
func partition<X>(buffer : Buffer<X>, predicate : X -> Bool) : (Buffer<X>, Buffer<X>)
```

Divide `buffer` en un par de buffers donde todos los elementos en el buffer
izquierdo satisfacen `predicate` y todos los elementos en el buffer derecho no
lo hacen.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);
buffer.add(5);
buffer.add(6);

let partitions = Buffer.partition<Nat>(buffer, func (x) { x % 2 == 0 });
(Buffer.toArray(partitions.0), Buffer.toArray(partitions.1)) // => ([2, 4, 6], [1, 3, 5])
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `predicate` se ejecuta en
tiempo y espacio O(1).

## Function `split`

```motoko no-repl
func split<X>(buffer : Buffer<X>, index : Nat) : (Buffer<X>, Buffer<X>)
```

Divide el buffer en dos buffers en `index`, donde el buffer izquierdo contiene
todos los elementos con índices menores que `index`, y el buffer derecho
contiene todos los elementos con índices mayores o iguales a `index`. Traps si
`index` está fuera de los límites.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);
buffer.add(5);
buffer.add(6);

let split = Buffer.split<Nat>(buffer, 3);
(Buffer.toArray(split.0), Buffer.toArray(split.1)) // => ([1, 2, 3], [4, 5, 6])
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `compare` se ejecuta en tiempo
y espacio O(1).

## Function `chunk`

```motoko no-repl
func chunk<X>(buffer : Buffer<X>, size : Nat) : Buffer<Buffer<X>>
```

Divide `buffer` en buffers de tamaño `size`. El último fragmento puede tener
menos de `size` elementos si el número de elementos no es divisible por el
tamaño del fragmento.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);
buffer.add(4);
buffer.add(5);
buffer.add(6);

let chunks = Buffer.chunk<Nat>(buffer, 3);
Buffer.toText<Buffer.Buffer<Nat>>(chunks, func buf = Buffer.toText(buf, Nat.toText)); // => [[1, 2, 3], [4, 5, 6]]
```

Tiempo de ejecución: O(number of elements in buffer)

Espacio: O(number of elements in buffer)

## Function `groupBy`

```motoko no-repl
func groupBy<X>(buffer : Buffer<X>, equal : (X, X) -> Bool) : Buffer<Buffer<X>>
```

Agrupa elementos iguales y adyacentes en la lista en sublistas.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(2);
buffer.add(4);
buffer.add(5);
buffer.add(5);

let grouped = Buffer.groupBy<Nat>(buffer, func (x, y) { x == y });
Buffer.toText<Buffer.Buffer<Nat>>(grouped, func buf = Buffer.toText(buf, Nat.toText)); // => [[1], [2, 2], [4], [5, 5]]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `equal` se ejecuta en tiempo y
espacio O(1).

## Function `flatten`

```motoko no-repl
func flatten<X>(buffer : Buffer<Buffer<X>>) : Buffer<X>
```

Aplana el buffer de buffers en un solo buffer.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

let buffer = Buffer.Buffer<Buffer.Buffer<Nat>>(1);

let inner1 = Buffer.Buffer<Nat>(2);
inner1.add(1);
inner1.add(2);

let inner2 = Buffer.Buffer<Nat>(2);
inner2.add(3);
inner2.add(4);

buffer.add(inner1);
buffer.add(inner2);
// buffer = [[1, 2], [3, 4]]

let flat = Buffer.flatten<Nat>(buffer);
Buffer.toText<Nat>(flat, Nat.toText); // => [1, 2, 3, 4]
```

Tiempo de ejecución: O(number of elements in buffer)

Espacio: O(number of elements in buffer)

## Function `zip`

```motoko no-repl
func zip<X, Y>(buffer1 : Buffer<X>, buffer2 : Buffer<Y>) : Buffer<(X, Y)>
```

Combina los dos buffers en un solo buffer de pares, emparejando los elementos
con el mismo índice. Si un buffer es más largo que el otro, los elementos
restantes del buffer más largo no se incluyen.

Ejemplo:

```motoko include=initialize

let buffer1 = Buffer.Buffer<Nat>(2);
buffer1.add(1);
buffer1.add(2);
buffer1.add(3);

let buffer2 = Buffer.Buffer<Nat>(2);
buffer2.add(4);
buffer2.add(5);

let zipped = Buffer.zip(buffer1, buffer2);
Buffer.toArray(zipped); // => [(1, 4), (2, 5)]
```

Tiempo de ejecución: O(min(size1, size2))

Espacio: O(min(size1, size2))

## Function `zipWith`

```motoko no-repl
func zipWith<X, Y, Z>(buffer1 : Buffer<X>, buffer2 : Buffer<Y>, zip : (X, Y) -> Z) : Buffer<Z>
```

Combina los dos buffers en un solo buffer, emparejando los elementos con el
mismo índice y combinándolos utilizando `zip`. Si un buffer es más largo que el
otro, los elementos restantes del buffer más largo no se incluyen.

Ejemplo:

```motoko include=initialize

let buffer1 = Buffer.Buffer<Nat>(2);
buffer1.add(1);
buffer1.add(2);
buffer1.add(3);

let buffer2 = Buffer.Buffer<Nat>(2);
buffer2.add(4);
buffer2.add(5);
buffer2.add(6);

let zipped = Buffer.zipWith<Nat, Nat, Nat>(buffer1, buffer2, func (x, y) { x + y });
Buffer.toArray(zipped) // => [5, 7, 9]
```

Tiempo de ejecución: O(min(size1, size2))

Espacio: O(min(size1, size2))

\*El tiempo de ejecución y el espacio asumen que `zip` se ejecuta en tiempo y
espacio O(1).

## Function `takeWhile`

```motoko no-repl
func takeWhile<X>(buffer : Buffer<X>, predicate : X -> Bool) : Buffer<X>
```

Crea un nuevo buffer tomando elementos en orden de `buffer` hasta que
`predicate` devuelva false.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

let newBuf = Buffer.takeWhile<Nat>(buffer, func (x) { x < 3 });
Buffer.toText(newBuf, Nat.toText); // => [1, 2]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `predicate` se ejecuta en
tiempo y espacio O(1).

## Function `dropWhile`

```motoko no-repl
func dropWhile<X>(buffer : Buffer<X>, predicate : X -> Bool) : Buffer<X>
```

Crea un nuevo buffer excluyendo elementos en orden de `buffer` hasta que el
predicado devuelva falso.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

buffer.add(1);
buffer.add(2);
buffer.add(3);

let newBuf = Buffer.dropWhile<Nat>(buffer, func x { x < 3 }); // => [3]
Buffer.toText(newBuf, Nat.toText);
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `predicate` se ejecuta en
tiempo y espacio O(1).
