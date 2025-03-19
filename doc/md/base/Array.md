# Array

Proporciona funciones de utilidad extendidas para Arrays.

Ten en cuenta la diferencia entre arrays mutables y no mutables a continuación.

ADVERTENCIA: Si estás buscando una lista que pueda crecer y disminuir de tamaño,
se recomienda que uses la clase Buffer o la clase List para esos propósitos. Los
arrays deben crearse con un tamaño fijo.

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Array "mo:base/Array";
```

## Función `init`

```motoko no-repl
func init<X>(size : Nat, initValue : X) : [var X]
```

Crea un array mutable con `size` copias del valor inicial.

```motoko include=import
let array = Array.init<Nat>(4, 2);
```

Tiempo de ejecución: O(size) Espacio: O(size)

## Función `tabulate`

```motoko no-repl
func tabulate<X>(size : Nat, generator : Nat -> X) : [X]
```

Crea un array inmutable de tamaño `size`. Cada elemento en el índice i se crea
aplicando `generator` a i.

```motoko include=import
let array : [Nat] = Array.tabulate<Nat>(4, func i = i * 2);
```

Tiempo de ejecución: O(size) Espacio: O(size)

\*Tiempo de ejecución y espacio asume que `generator` se ejecuta en O(1) de
tiempo y espacio.

## Función `tabulateVar`

```motoko no-repl
func tabulateVar<X>(size : Nat, generator : Nat -> X) : [var X]
```

Crea un array mutable de tamaño `size`. Cada elemento en el índice i se crea
aplicando `generator` a i.

```motoko include=import
let array : [var Nat] = Array.tabulateVar<Nat>(4, func i = i * 2);
array[2] := 0;
array
```

Tiempo de ejecución: O(size) Espacio: O(size)

\*Tiempo de ejecución y espacio asume que `generator` se ejecuta en O(1) de
tiempo y espacio.

## Función `freeze`

```motoko no-repl
func freeze<X>(varArray : [var X]) : [X]
```

Transforma un array mutable en un array inmutable.

```motoko include=import

let varArray = [var 0, 1, 2];
varArray[2] := 3;
let array = Array.freeze<Nat>(varArray);
```

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `thaw`

```motoko no-repl
func thaw<A>(array : [A]) : [var A]
```

Transforma un array inmutable en un array mutable.

```motoko include=import

let array = [0, 1, 2];
let varArray = Array.thaw<Nat>(array);
varArray[2] := 3;
varArray
```

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `equal`

```motoko no-repl
func equal<X>(array1 : [X], array2 : [X], equal : (X, X) -> Bool) : Bool
```

Prueba si dos arrays contienen valores iguales (es decir, representan la misma
lista de elementos). Utiliza `equal` para comparar los elementos en los arrays.

```motoko include=import
// Use the equal function from the Nat module to compare Nats
import {equal} "mo:base/Nat";

let array1 = [0, 1, 2, 3];
let array2 = [0, 1, 2, 3];
Array.equal(array1, array2, equal)
```

Tiempo de ejecución: O(size1 + size2)

Espacio: O(1)

\*Tiempo de ejecución y espacio asume que `equal` se ejecuta en O(1) de tiempo y
espacio.

## Función `find`

```motoko no-repl
func find<X>(array : [X], predicate : X -> Bool) : ?X
```

Devuelve el primer valor en `array` para el cual `predicate` devuelve verdadero.
Si ningún elemento satisface el predicado, devuelve null.

```motoko include=import
let array = [1, 9, 4, 8];
Array.find<Nat>(array, func x = x > 8)
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*Tiempo de ejecución y espacio asume que `predicate` se ejecuta en tiempo y
espacio O(1).

## Función `append`

```motoko no-repl
func append<X>(array1 : [X], array2 : [X]) : [X]
```

Crea un nuevo array agregando los valores de `array1` y `array2`. Ten en cuenta
que `Array.append` copia sus argumentos y tiene una complejidad lineal; cuando
se utiliza en un bucle, considera usar un `Buffer` y `Buffer.append` en su
lugar.

```motoko include=import
let array1 = [1, 2, 3];
let array2 = [4, 5, 6];
Array.append<Nat>(array1, array2)
```

Tiempo de ejecución: O(size1 + size2)

Espacio: O(size1 + size2)

## Función `sort`

```motoko no-repl
func sort<X>(array : [X], compare : (X, X) -> Order.Order) : [X]
```

Ordena los elementos en el array según `compare`. La ordenación es determinista
y estable.

```motoko include=import
import Nat "mo:base/Nat";

let array = [4, 2, 6];
Array.sort(array, Nat.compare)
```

Tiempo de ejecución: O(size \* log(size))

Espacio: O(size) \*El tiempo de ejecución y el espacio asumen que `compare` se
ejecuta en tiempo y espacio O(1).

## Función `sortInPlace`

```motoko no-repl
func sortInPlace<X>(array : [var X], compare : (X, X) -> Order.Order)
```

Ordena los elementos en el array, **en su lugar**, según `compare`. La
ordenación es determinista, estable y en su lugar.

```motoko include=import

import {compare} "mo:base/Nat";

let array = [var 4, 2, 6];
Array.sortInPlace(array, compare);
array
```

Tiempo de ejecución: O(size \* log(size))

Espacio: O(size) \*El tiempo de ejecución y el espacio asumen que `compare` se
ejecuta en tiempo y espacio O(1).

## Función `reverse`

```motoko no-repl
func reverse<X>(array : [X]) : [X]
```

Crea un nuevo array invirtiendo el orden de los elementos en `array`.

```motoko include=import

let array = [10, 11, 12];

Array.reverse(array)
```

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `map`

```motoko no-repl
func map<X, Y>(array : [X], f : X -> Y) : [Y]
```

Crea un nuevo array aplicando `f` a cada elemento en `array`. `f` "mapea" cada
elemento al que se aplica de tipo `X` a un elemento de tipo `Y`. Mantiene el
orden original de los elementos.

```motoko include=import

let array = [0, 1, 2, 3];
Array.map<Nat, Nat>(array, func x = x * 3)
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Función `filter`

```motoko no-repl
func filter<X>(array : [X], predicate : X -> Bool) : [X]
```

Crea un nuevo array aplicando `predicate` a cada elemento en `array`,
manteniendo los elementos para los cuales `predicate` devuelve verdadero.

```motoko include=import
let array = [4, 2, 6, 1, 5];
let evenElements = Array.filter<Nat>(array, func x = x % 2 == 0);
```

Tiempo de ejecución: O(size)

Espacio: O(size) \*El tiempo de ejecución y el espacio asume que `predicate` se
ejecuta en tiempo y espacio O(1).

## Función `mapEntries`

```motoko no-repl
func mapEntries<X, Y>(array : [X], f : (X, Nat) -> Y) : [Y]
```

Crea un nuevo array aplicando `f` a cada elemento en `array` y su índice.
Mantiene el orden original de los elementos.

```motoko include=import

let array = [10, 10, 10, 10];
Array.mapEntries<Nat, Nat>(array, func (x, i) = i * x)
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*Tiempo de ejecución y espacio asume que `f` se ejecuta en tiempo y espacio
O(1).

## Función `mapFilter`

```motoko no-repl
func mapFilter<X, Y>(array : [X], f : X -> ?Y) : [Y]
```

Crea un nuevo array aplicando `f` a cada elemento en `array` y manteniendo todos
los elementos no nulos. Se mantiene el orden.

```motoko include=import
import {toText} "mo:base/Nat";

let array = [4, 2, 0, 1];
let newArray =
  Array.mapFilter<Nat, Text>( // mapping from Nat to Text values
    array,
    func x = if (x == 0) { null } else { ?toText(100 / x) } // can't divide by 0, so return null
  );
```

Tiempo de ejecución: O(size)

Espacio: O(size) \*El tiempo de ejecución y el espacio asume que `f` se ejecuta
en tiempo y espacio O(1).

## Función `mapResult`

```motoko no-repl
func mapResult<X, Y, E>(array : [X], f : X -> Result.Result<Y, E>) : Result.Result<[Y], E>
```

Crea un nuevo array aplicando `f` a cada elemento en `array`. Si alguna
invocación de `f` produce un `#err`, devuelve un `#err`. De lo contrario,
devuelve un `#ok` que contiene el nuevo array.

```motoko include=import
let array = [4, 3, 2, 1, 0];
// divide 100 by every element in the array
Array.mapResult<Nat, Nat, Text>(array, func x {
  if (x > 0) {
    #ok(100 / x)
  } else {
    #err "Cannot divide by zero"
  }
})
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*Tiempo de ejecución y espacio asume que `f` se ejecuta en tiempo y espacio
O(1).

## Función `chain`

```motoko no-repl
func chain<X, Y>(array : [X], k : X -> [Y]) : [Y]
```

Crea un nuevo array aplicando `k` a cada elemento en `array` y concatenando los
arrays resultantes en orden. Esta operación es similar a lo que en otros
lenguajes funcionales se conoce como enlace monádico.

```motoko include=import
import Nat "mo:base/Nat";

let array = [1, 2, 3, 4];
Array.chain<Nat, Int>(array, func x = [x, -x])

```

Tiempo de ejecución: O(size)

Espacio: O(size) \*El tiempo de ejecución y el espacio asume que `k` se ejecuta
en tiempo y espacio O(1).

## Función `foldLeft`

```motoko no-repl
func foldLeft<X, A>(array : [X], base : A, combine : (A, X) -> A) : A
```

Combina los elementos en `array` en un solo valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de izquierda a derecha.

```motoko include=import
import {add} "mo:base/Nat";

let array = [4, 2, 0, 1];
let sum =
  Array.foldLeft<Nat, Nat>(
    array,
    0, // start the sum at 0
    func(sumSoFar, x) = sumSoFar + x // this entire function can be replaced with `add`!
  );
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*Tiempo de ejecución y espacio asume que `combine` se ejecuta en tiempo y
espacio O(1).

## Función `foldRight`

```motoko no-repl
func foldRight<X, A>(array : [X], base : A, combine : (X, A) -> A) : A
```

Combina los elementos en `array` en un solo valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de derecha a izquierda.

```motoko include=import
import {toText} "mo:base/Nat";

let array = [1, 9, 4, 8];
let bookTitle = Array.foldRight<Nat, Text>(array, "", func(x, acc) = toText(x) # acc);
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `combine` se ejecuta en tiempo
y espacio O(1).

## Función `flatten`

```motoko no-repl
func flatten<X>(arrays : [[X]]) : [X]
```

Aplana el array de arrays en un solo array. Conserva el orden original de los
elementos.

```motoko include=import

let arrays = [[0, 1, 2], [2, 3], [], [4]];
Array.flatten<Nat>(arrays)
```

Tiempo de ejecución: O(numero de elementos en array)

Espacio: O(numero de elementos en array)

## Función `make`

```motoko no-repl
func make<X>(element : X) : [X]
```

Crea un array que contiene un solo valor.

```motoko include=import
Array.make(2)
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `vals`

```motoko no-repl
func vals<X>(array : [X]) : I.Iter<X>
```

Devuelve un iterador (`Iter`) sobre los elementos de `array`. El iterador
proporciona un único método `next()`, que devuelve los elementos en orden, o
`null` cuando no hay más elementos para iterar.

NOTA: También puedes usar `array.vals()` en lugar de esta función. Ver ejemplo a
continuación.

```motoko include=import

let array = [10, 11, 12];

var sum = 0;
for (element in array.vals()) {
  sum += element;
};
sum
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `keys`

```motoko no-repl
func keys<X>(array : [X]) : I.Iter<Nat>
```

Devuelve un iterador (`Iter`) sobre los índices de `array`. El iterador
proporciona un único método `next()`, que devuelve los índices en orden, o
`null` cuando no hay más índices para iterar.

NOTA: También puedes usar `array.keys()` en lugar de esta función. Ver ejemplo a
continuación.

```motoko include=import

let array = [10, 11, 12];

var sum = 0;
for (element in array.keys()) {
  sum += element;
};
sum
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `size`

```motoko no-repl
func size<X>(array : [X]) : Nat
```

Devuelve el tamaño de `array`.

NOTA: También puedes usar `array.size()` en lugar de esta función. Ver ejemplo a
continuación.

```motoko include=import

let array = [10, 11, 12];
let size = Array.size(array);
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `subArray`

```motoko no-repl
func subArray<X>(array : [X], start : Nat, length : Nat) : [X]
```

Devuelve un nuevo subarreglo a partir del arreglo dado, proporcionando el índice
de inicio y la longitud de elementos en el subarreglo.

Limitaciones: Genera un error si el índice de inicio + la longitud es mayor que
el tamaño del arreglo.

```motoko include=import

let array = [1,2,3,4,5];
let subArray = Array.subArray<Nat>(array, 2, 3);
```

Tiempo de ejecución: O(length); Espacio: O(length);

## Función `indexOf`

```motoko no-repl
func indexOf<X>(element : X, array : [X], equal : (X, X) -> Bool) : ?Nat
```

Retorna el índice del primer `element` en el `array`.

```motoko include=import
import Char "mo:base/Char";
let array = ['c', 'o', 'f', 'f', 'e', 'e'];
assert Array.indexOf<Char>('c', array, Char.equal) == ?0;
assert Array.indexOf<Char>('f', array, Char.equal) == ?2;
assert Array.indexOf<Char>('g', array, Char.equal) == null;
```

Tiempo de ejecución: O(array.size()); Espacio: O(1);

## Función `nextIndexOf`

```motoko no-repl
func nextIndexOf<X>(element : X, array : [X], fromInclusive : Nat, equal : (X, X) -> Bool) : ?Nat
```

Retorna el índice de la próxima ocurrencia de `element` en el `array` comenzando
desde el índice `from` (inclusive).

```motoko include=import
import Char "mo:base/Char";
let array = ['c', 'o', 'f', 'f', 'e', 'e'];
assert Array.nextIndexOf<Char>('c', array, 0, Char.equal) == ?0;
assert Array.nextIndexOf<Char>('f', array, 0, Char.equal) == ?2;
assert Array.nextIndexOf<Char>('f', array, 2, Char.equal) == ?2;
assert Array.nextIndexOf<Char>('f', array, 3, Char.equal) == ?3;
assert Array.nextIndexOf<Char>('f', array, 4, Char.equal) == null;
```

Tiempo de ejecución: O(array.size()); Espacio: O(1);

## Función `lastIndexOf`

```motoko no-repl
func lastIndexOf<X>(element : X, array : [X], equal : (X, X) -> Bool) : ?Nat
```

Devuelve el índice del último `element` en el `array`.

```motoko include=import
import Char "mo:base/Char";
let array = ['c', 'o', 'f', 'f', 'e', 'e'];
assert Array.lastIndexOf<Char>('c', array, Char.equal) == ?0;
assert Array.lastIndexOf<Char>('f', array, Char.equal) == ?3;
assert Array.lastIndexOf<Char>('e', array, Char.equal) == ?5;
assert Array.lastIndexOf<Char>('g', array, Char.equal) == null;
```

Tiempo de ejecución: O(array.size()); Espacio: O(1);

## Función `prevIndexOf`

```motoko no-repl
func prevIndexOf<T>(element : T, array : [T], fromExclusive : Nat, equal : (T, T) -> Bool) : ?Nat
```

Devuelve el índice de la ocurrencia anterior de `element` en el `array`
comenzando desde el índice `from` (exclusivo).

```motoko include=import
import Char "mo:base/Char";
let array = ['c', 'o', 'f', 'f', 'e', 'e'];
assert Array.prevIndexOf<Char>('c', array, array.size(), Char.equal) == ?0;
assert Array.prevIndexOf<Char>('e', array, array.size(), Char.equal) == ?5;
assert Array.prevIndexOf<Char>('e', array, 5, Char.equal) == ?4;
assert Array.prevIndexOf<Char>('e', array, 4, Char.equal) == null;
```

Tiempo de ejecución: O(array.size()); Espacio: O(1);

## Función `slice`

```motoko no-repl
func slice<X>(array : [X], fromInclusive : Nat, toExclusive : Nat) : I.Iter<X>
```

Retorna un iterador sobre una porción del arreglo dado.

```motoko include=import
let array = [1, 2, 3, 4, 5];
let s = Array.slice<Nat>(array, 3, array.size());
assert s.next() == ?4;
assert s.next() == ?5;
assert s.next() == null;

let s = Array.slice<Nat>(array, 0, 0);
assert s.next() == null;
```

Tiempo de ejecución: O(1) Espacio: O(1)

## Función `take`

```motoko no-repl
func take<T>(array : [T], length : Int) : [T]
```

Devuelve un nuevo subarreglo de la longitud dada desde el principio o el final
del arreglo dado.

Devuelve el arreglo completo si la longitud es mayor que el tamaño del arreglo.

```motoko include=import
let array = [1, 2, 3, 4, 5];
assert Array.take(array, 2) == [1, 2];
assert Array.take(array, -2) == [4, 5];
assert Array.take(array, 10) == [1, 2, 3, 4, 5];
assert Array.take(array, -99) == [1, 2, 3, 4, 5];
```

Tiempo de ejecución: O(length); Espacio: O(length);
