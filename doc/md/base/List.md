# List

Listas puramente funcionales y enlazadas de forma simple. Una lista de tipo
`List<T>` es o bien `null` o un par opcional de un valor de tipo `T` y una cola,
que a su vez es de tipo `List<T>`.

Para usar esta biblioteca, impórtela de la siguiente manera:

```motoko name=initialize
import List "mo:base/List";
```

## Tipo `List`

```motoko no-repl
type List<T> = ?(T, List<T>)
```

## Función `nil`

```motoko no-repl
func nil<T>() : List<T>
```

Crea una lista vacía.

Ejemplo:

```motoko include=initialize
List.nil<Nat>() // => null
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `isNil`

```motoko no-repl
func isNil<T>(l : List<T>) : Bool
```

Comprueba si una lista está vacía y devuelve `true` si la lista está vacía.

Ejemplo:

```motoko include=initialize
List.isNil<Nat>(null) // => true
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `push`

```motoko no-repl
func push<T>(x : T, l : List<T>) : List<T>
```

Agrega `x` al principio de `list` y devuelve la nueva lista.

Ejemplo:

```motoko include=initialize
List.push<Nat>(0, null) // => ?(0, null);
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `last`

```motoko no-repl
func last<T>(l : List<T>) : ?T
```

Devuelve el último elemento de la lista, si está presente.

Ejemplo:

```motoko include=initialize
List.last<Nat>(?(0, ?(1, null))) // => ?1
```

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `pop`

```motoko no-repl
func pop<T>(l : List<T>) : (?T, List<T>)
```

Elimina el primer elemento de la lista, devolviendo el elemento opcional y la
cola de la lista en un par. Devuelve `(null, null)` si la lista está vacía.

Ejemplo:

```motoko include=initialize
List.pop<Nat>(?(0, ?(1, null))) // => (?0, ?(1, null))
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `size`

```motoko no-repl
func size<T>(l : List<T>) : Nat
```

Devuelve la longitud de la lista.

Ejemplo:

```motoko include=initialize
List.size<Nat>(?(0, ?(1, null))) // => 2
```

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `get`

```motoko no-repl
func get<T>(l : List<T>, n : Nat) : ?T
```

Accede a cualquier elemento de una lista, basado en cero.

NOTA: Indexar en una lista es una operación lineal y generalmente indica que una
lista puede no ser la mejor estructura de datos para usar.

Ejemplo:

```motoko include=initialize
List.get<Nat>(?(0, ?(1, null)), 1) // => ?1
```

Tiempo de ejecución: O(size)

Espacio: O(1)

## Función `reverse`

```motoko no-repl
func reverse<T>(l : List<T>) : List<T>
```

Invierte la lista.

Ejemplo:

```motoko include=initialize
List.reverse<Nat>(?(0, ?(1, ?(2, null)))) // => ?(2, ?(1, ?(0, null)))
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Función `iterate`

```motoko no-repl
func iterate<T>(l : List<T>, f : T -> ())
```

Llama a la función dada para su efecto secundario, con cada elemento de la lista
por turno.

Ejemplo:

```motoko include=initialize
var sum = 0;
List.iterate<Nat>(?(0, ?(1, ?(2, null))), func n { sum += n });
sum // => 3
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Función `map`

```motoko no-repl
func map<T, U>(l : List<T>, f : T -> U) : List<U>
```

Llama a la función dada `f` en cada elemento de la lista y recopila los
resultados en una nueva lista.

Ejemplo:

```motoko include=initialize
import Nat = "mo:base/Nat"
List.map<Nat, Text>(?(0, ?(1, ?(2, null))), Nat.toText) // => ?("0", ?("1", ?("2", null))
```

Tiempo de ejecución: O(size)

Espacio: O(size) \*El tiempo de ejecución y el espacio asumen que `f` se ejecuta
en tiempo y espacio O(1).

## Función `filter`

```motoko no-repl
func filter<T>(l : List<T>, f : T -> Bool) : List<T>
```

Crea una nueva lista con solo aquellos elementos de la lista original para los
cuales la función dada (a menudo llamada el _predicado_) devuelve verdadero.

Ejemplo:

```motoko include=initialize
List.filter<Nat>(?(0, ?(1, ?(2, null))), func n { n != 1 }) // => ?(0, ?(2, null))
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Función `partition`

```motoko no-repl
func partition<T>(l : List<T>, f : T -> Bool) : (List<T>, List<T>)
```

Crea dos nuevas listas a partir de los resultados de una función dada (`f`). La
primera lista solo incluye los elementos para los cuales la función dada `f`
devuelve verdadero y la segunda lista solo incluye los elementos para los cuales
la función devuelve falso.

Ejemplo:

```motoko include=initialize
List.partition<Nat>(?(0, ?(1, ?(2, null))), func n { n != 1 }) // => (?(0, ?(2, null)), ?(1, null))
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Función `mapFilter`

```motoko no-repl
func mapFilter<T, U>(l : List<T>, f : T -> ?U) : List<U>
```

Llama a la función dada en cada elemento de la lista y recopila los resultados
no nulos en una nueva lista.

Ejemplo:

```motoko include=initialize
List.mapFilter<Nat, Nat>(
  ?(1, ?(2, ?(3, null))),
  func n {
    if (n > 1) {
      ?(n * 2);
    } else {
      null
    }
  }
) // => ?(4, ?(6, null))
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Función `mapResult`

```motoko no-repl
func mapResult<T, R, E>(xs : List<T>, f : T -> Result.Result<R, E>) : Result.Result<List<R>, E>
```

Mapea una función que devuelve un resultado `Result` sobre una lista y devuelve
el primer error o una lista de valores exitosos.

Ejemplo:

```motoko include=initialize
List.mapResult<Nat, Nat, Text>(
  ?(1, ?(2, ?(3, null))),
  func n {
    if (n > 0) {
      #ok(n * 2);
    } else {
      #err("Some element is zero")
    }
  }
); // => #ok ?(2, ?(4, ?(6, null))
```

Tiempo de ejecución: O(size)

Espacio: O(size)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Función `append`

```motoko no-repl
func append<T>(l : List<T>, m : List<T>) : List<T>
```

Agrega los elementos de una lista a otra lista.

Ejemplo:

```motoko include=initialize
List.append<Nat>(
  ?(0, ?(1, ?(2, null))),
  ?(3, ?(4, ?(5, null)))
) // => ?(0, ?(1, ?(2, ?(3, ?(4, ?(5, null))))))
```

Tiempo de ejecución: O(size(l))

Espacio: O(size(l))

## Función `flatten`

```motoko no-repl
func flatten<T>(l : List<List<T>>) : List<T>
```

Aplana, o concatena, una lista de listas como una lista.

Ejemplo:

```motoko include=initialize
List.flatten<Nat>(
  ?(?(0, ?(1, ?(2, null))),
    ?(?(3, ?(4, ?(5, null))),
      null))
); // => ?(0, ?(1, ?(2, ?(3, ?(4, ?(5, null))))))
```

Tiempo de ejecución: O(size\*tamaño)

Espacio: O(size\*tamaño)

## Función `take`

```motoko no-repl
func take<T>(l : List<T>, n : Nat) : List<T>
```

Devuelve los primeros `n` elementos de la lista dada. Si la lista dada tiene
menos de `n` elementos, esta función devuelve una copia de la lista de entrada
completa.

Ejemplo:

```motoko include=initialize
List.take<Nat>(
  ?(0, ?(1, ?(2, null))),
  2
); // => ?(0, ?(1, null))
```

Tiempo de ejecución: O(n)

Espacio: O(n)

## Función `drop`

```motoko no-repl
func drop<T>(l : List<T>, n : Nat) : List<T>
```

Elimina los primeros `n` elementos de la lista dada.

Ejemplo:

```motoko include=initialize
List.drop<Nat>(
  ?(0, ?(1, ?(2, null))),
  2
); // => ?(2, null)
```

Tiempo de ejecución: O(n)

Espacio: O(1)

## Función `foldLeft`

```motoko no-repl
func foldLeft<T, S>(list : List<T>, base : S, combine : (S, T) -> S) : S
```

Combina los elementos en `list` en un solo valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de izquierda a derecha.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

List.foldLeft<Nat, Text>(
  ?(1, ?(2, ?(3, null))),
  "",
  func (acc, x) { acc # Nat.toText(x)}
) // => "123"
```

Tiempo de ejecución: O(size(list))

Espacio: O(1) en el heap, O(1) en el stack

\*El tiempo de ejecución y el espacio asumen que `combine` se ejecuta en tiempo
y espacio O(1).

## Función `foldRight`

```motoko no-repl
func foldRight<T, S>(list : List<T>, base : S, combine : (T, S) -> S) : S
```

Combina los elementos en `buffer` en un solo valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de derecha a izquierda.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

List.foldRight<Nat, Text>(
  ?(1, ?(2, ?(3, null))),
  "",
  func (x, acc) { Nat.toText(x) # acc}
) // => "123"
```

Tiempo de ejecución: O(size(list))

Espacio: O(1) en el heap, O(size(list)) en el stack

\*El tiempo de ejecución y el espacio asumen que `combine` se ejecuta en tiempo
y espacio O(1).

## Función `find`

```motoko no-repl
func find<T>(l : List<T>, f : T -> Bool) : ?T
```

Devuelve el primer elemento para el cual el predicado dado `f` es verdadero, si
existe dicho elemento.

Ejemplo:

```motoko include=initialize

List.find<Nat>(
  ?(1, ?(2, ?(3, null))),
  func n { n > 1 }
); // => ?2
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Función `some`

```motoko no-repl
func some<T>(l : List<T>, f : T -> Bool) : Bool
```

Devuelve `true` si existe un elemento de la lista para el cual el predicado dado
`f` es verdadero.

Ejemplo:

```motoko include=initialize

List.some<Nat>(
  ?(1, ?(2, ?(3, null))),
  func n { n > 1 }
) // => true
```

Tiempo de ejecución: O(size(lista))

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Función `all`

```motoko no-repl
func all<T>(l : List<T>, f : T -> Bool) : Bool
```

Devuelve `true` si el predicado dado `f` es verdadero para todos los elementos
de la lista.

Ejemplo:

```motoko include=initialize

List.all<Nat>(
  ?(1, ?(2, ?(3, null))),
  func n { n > 1 }
); // => false
```

Tiempo de ejecución: O(size)

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que `f` se ejecuta en tiempo y
espacio O(1).

## Función `merge`

```motoko no-repl
func merge<T>(l1 : List<T>, l2 : List<T>, lessThanOrEqual : (T, T) -> Bool) : List<T>
```

Combina dos listas ordenadas en una sola lista ordenada. Esta función requiere
que ambas listas estén ordenadas según la relación dada `lessThanOrEqual`.

Ejemplo:

```motoko include=initialize

List.merge<Nat>(
  ?(1, ?(2, ?(4, null))),
  ?(2, ?(4, ?(6, null))),
  func (n1, n2) { n1 <= n2 }
); // => ?(1, ?(2, ?(2, ?(4, ?(4, ?(6, null))))))),
```

Tiempo de ejecución: O(size(l1) + tamaño(l2))

Espacio: O(size(l1) + tamaño(l2))

\*El tiempo de ejecución y el espacio asumen que `lessThanOrEqual` se ejecuta en
tiempo y espacio O(1).

## Función `compare`

```motoko no-repl
func compare<T>(l1 : List<T>, l2 : List<T>, compare : (T, T) -> Order.Order) : Order.Order
```

Compara dos listas utilizando un orden lexicográfico especificado por la función
de argumento `compare`.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

List.compare<Nat>(
  ?(1, ?(2, null)),
  ?(3, ?(4, null)),
  Nat.compare
) // => #less
```

Tiempo de ejecución: O(size(l1))

Espacio: O(1)

\*El tiempo de ejecución y el espacio asumen que el argumento `compare` se
ejecuta en tiempo y espacio O(1).

## Función `equal`

```motoko no-repl
func equal<T>(l1 : List<T>, l2 : List<T>, equal : (T, T) -> Bool) : Bool
```

Compara dos listas para determinar si son iguales utilizando la función de
argumento `equal` para determinar la igualdad de sus elementos.

Ejemplo:

```motoko include=initialize
import Nat "mo:base/Nat";

List.equal<Nat>(
  ?(1, ?(2, null)),
  ?(3, ?(4, null)),
  Nat.equal
); // => false
```

Tiempo de ejecución: O(size(l1))

Espacio: O(1)

\*Tiempo de ejecución y espacio asumen que el argumento `equal` se ejecuta en
tiempo y espacio O(1).

## Función `tabulate`

```motoko no-repl
func tabulate<T>(n : Nat, f : Nat -> T) : List<T>
```

Genera una lista basada en una longitud y una función que mapea desde un índice
de lista a un elemento de lista.

Ejemplo:

```motoko include=initialize
List.tabulate<Nat>(
  3,
  func n { n * 2 }
) // => ?(0, ?(2, (?4, null)))
```

Tiempo de ejecución: O(n)

Espacio: O(n)

\*Tiempo de ejecución y espacio asumen que `f` se ejecuta en tiempo y espacio
O(1).

## Función `make`

```motoko no-repl
func make<T>(x : T) : List<T>
```

Crea una lista con exactamente un elemento.

Ejemplo:

```motoko include=initialize
List.make<Nat>(
  0
) // => ?(0, null)
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Función `replicate`

```motoko no-repl
func replicate<T>(n : Nat, x : T) : List<T>
```

Crea una lista de la longitud dada con el mismo valor en cada posición.

Ejemplo:

```motoko include=initialize
List.replicate<Nat>(
  3,
  0
) // => ?(0, ?(0, ?(0, null)))
```

Tiempo de ejecución: O(n)

Espacio: O(n)

## Función `zip`

```motoko no-repl
func zip<T, U>(xs : List<T>, ys : List<U>) : List<(T, U)>
```

Crea una lista de pares a partir de un par de listas.

Si las listas dadas tienen longitudes diferentes, entonces la lista creada
tendrá una longitud igual a la longitud de la lista más pequeña.

Ejemplo:

```motoko include=initialize
List.zip<Nat, Text>(
  ?(0, ?(1, ?(2, null))),
  ?("0", ?("1", null)),
) // => ?((0, "0"), ?((1, "1"), null))
```

Tiempo de ejecución: O(min(size(xs), size(ys)))

Espacio: O(min(size(xs), size(ys)))

## Función `zipWith`

```motoko no-repl
func zipWith<T, U, V>(xs : List<T>, ys : List<U>, f : (T, U) -> V) : List<V>
```

Crea una lista en la que los elementos se crean aplicando la función `f` a cada
par `(x, y)` de elementos que ocurren en la misma posición en la lista `xs` y la
lista `ys`.

Si las listas dadas tienen longitudes diferentes, entonces la lista creada
tendrá una longitud igual a la longitud de la lista más pequeña.

Ejemplo:

```motoko include=initialize
import Nat = "mo:base/Nat";
import Char = "mo:base/Char";

List.zipWith<Nat, Char, Text>(
  ?(0, ?(1, ?(2, null))),
  ?('a', ?('b', null)),
  func (n, c) { Nat.toText(n) # Char.toText(c) }
) // => ?("0a", ?("1b", null))
```

Tiempo de ejecución: O(min(size(xs), size(ys)))

Espacio: O(min(size(xs), size(ys)))

\*Tiempo de ejecución y espacio asumen que `f` se ejecuta en tiempo y espacio
O(1).

## Función `split`

```motoko no-repl
func split<T>(n : Nat, xs : List<T>) : (List<T>, List<T>)
```

Divide la lista dada en el índice dado basado en cero.

Ejemplo:

```motoko include=initialize
List.split<Nat>(
  2,
  ?(0, ?(1, ?(2, null)))
) // => (?(0, ?(1, null)), ?(2, null))
```

Tiempo de ejecución: O(n)

Espacio: O(n)

## Función `chunks`

```motoko no-repl
func chunks<T>(n : Nat, xs : List<T>) : List<List<T>>
```

Divide la lista dada en fragmentos de longitud `n`. El último fragmento será más
corto si la longitud de la lista dada no se divide de manera uniforme por `n`.

Ejemplo:

```motoko include=initialize
List.chunks<Nat>(
  2,
  ?(0, ?(1, ?(2, ?(3, ?(4, null)))))
)
/* => ?(?(0, ?(1, null)),
        ?(?(2, ?(3, null)),
          ?(?(4, null),
            null)))
*/
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Función `fromArray`

```motoko no-repl
func fromArray<T>(xs : [T]) : List<T>
```

Convierte un array en una lista.

Ejemplo:

```motoko include=initialize
List.fromArray<Nat>([ 0, 1, 2, 3, 4])
// =>  ?(0, ?(1, ?(2, ?(3, ?(4, null)))))
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Función `fromVarArray`

```motoko no-repl
func fromVarArray<T>(xs : [var T]) : List<T>
```

Convierte un array mutable en una lista.

Ejemplo:

```motoko include=initialize
List.fromVarArray<Nat>([var 0, 1, 2, 3, 4])
// =>  ?(0, ?(1, ?(2, ?(3, ?(4, null)))))
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Función `toArray`

```motoko no-repl
func toArray<T>(xs : List<T>) : [T]
```

Crea un array a partir de una lista. Ejemplo:

```motoko include=initialize
List.toArray<Nat>(?(0, ?(1, ?(2, ?(3, ?(4, null))))))
// => [0, 1, 2, 3, 4]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Función `toVarArray`

```motoko no-repl
func toVarArray<T>(xs : List<T>) : [var T]
```

Crea un array mutable a partir de una lista. Ejemplo:

```motoko include=initialize
List.toVarArray<Nat>(?(0, ?(1, ?(2, ?(3, ?(4, null))))))
// => [var 0, 1, 2, 3, 4]
```

Tiempo de ejecución: O(size)

Espacio: O(size)

## Función `toIter`

```motoko no-repl
func toIter<T>(xs : List<T>) : Iter.Iter<T>
```

Crea un iterador a partir de una lista. Ejemplo:

```motoko include=initialize
var sum = 0;
for (n in List.toIter<Nat>(?(0, ?(1, ?(2, ?(3, ?(4, null))))))) {
  sum += n;
};
sum
// => 10
```

Tiempo de ejecución: O(1)

Espacio: O(1)
