# Iter

Iteradores

## Tipo `Iter`

```motoko no-repl
type Iter<T> = { next : () -> ?T }
```

Un iterador que produce valores de tipo `T`. Llamar a `next` devuelve `null`
cuando la iteración ha finalizado.

Los iteradores son inherentemente estatales. Llamar a `next` "consume" un valor
del iterador que no se puede devolver, así que tenlo en cuenta al compartir
iteradores entre consumidores.

Un iterador `i` se puede recorrer utilizando

```
for (x in i) {
  …hacer algo con x…
}
```

## Clase `range`

```motoko no-repl
class range(x : Nat, y : Int)
```

Crea un iterador que produce todos los `Nat` desde `x` hasta `y`, incluyendo
ambos límites.

```motoko
import Iter "mo:base/Iter";
let iter = Iter.range(1, 3);
assert(?1 == iter.next());
assert(?2 == iter.next());
assert(?3 == iter.next());
assert(null == iter.next());
```

### Función `next`

```motoko no-repl
func next() : ?Nat
```

## Clase `revRange`

```motoko no-repl
class revRange(x : Int, y : Int)
```

Similar a `range` pero produce los valores en orden inverso.

### Función `next`

```motoko no-repl
func next() : ?Int
```

## Función `iterate`

```motoko no-repl
func iterate<A>(xs : Iter<A>, f : (A, Nat) -> ())
```

Llama a una función `f` en cada valor producido por un iterador y descarta los
resultados. Si deseas mantener estos resultados, utiliza `map` en su lugar.

```motoko
import Iter "mo:base/Iter";
var sum = 0;
Iter.iterate<Nat>(Iter.range(1, 3), func(x, _index) {
  sum += x;
});
assert(6 == sum)
```

## Función `size`

```motoko no-repl
func size<A>(xs : Iter<A>) : Nat
```

Consume un iterador y cuenta cuántos elementos se produjeron (descartándolos en
el proceso).

## Función `map`

```motoko no-repl
func map<A, B>(xs : Iter<A>, f : A -> B) : Iter<B>
```

Toma una función y un iterador y devuelve un nuevo iterador que aplica
perezosamente la función a cada elemento producido por el iterador de argumento.

```motoko
import Iter "mo:base/Iter";
let iter = Iter.range(1, 3);
let mappedIter = Iter.map(iter, func (x : Nat) : Nat { x * 2 });
assert(?2 == mappedIter.next());
assert(?4 == mappedIter.next());
assert(?6 == mappedIter.next());
assert(null == mappedIter.next());
```

## Función `filter`

```motoko no-repl
func filter<A>(xs : Iter<A>, f : A -> Bool) : Iter<A>
```

Toma una función y un iterador y devuelve un nuevo iterador que produce
elementos del iterador original solo si el predicado es verdadero.

```motoko
import Iter "mo:base/Iter";
let iter = Iter.range(1, 3);
let mappedIter = Iter.filter(iter, func (x : Nat) : Bool { x % 2 == 1 });
assert(?1 == mappedIter.next());
assert(?3 == mappedIter.next());
assert(null == mappedIter.next());
```

## Función `make`

```motoko no-repl
func make<A>(x : A) : Iter<A>
```

Crea un iterador que produce una secuencia infinita de `x`.

```motoko
import Iter "mo:base/Iter";
let iter = Iter.make(10);
assert(?10 == iter.next());
assert(?10 == iter.next());
assert(?10 == iter.next());
// ...
```

## Función `concat`

```motoko no-repl
func concat<A>(a : Iter<A>, b : Iter<A>) : Iter<A>
```

Toma dos iteradores y devuelve un nuevo iterador que produce elementos de los
iteradores originales secuencialmente.

```motoko
import Iter "mo:base/Iter";
let iter1 = Iter.range(1, 2);
let iter2 = Iter.range(5, 6);
let concatenatedIter = Iter.concat(iter1, iter2);
assert(?1 == concatenatedIter.next());
assert(?2 == concatenatedIter.next());
assert(?5 == concatenatedIter.next());
assert(?6 == concatenatedIter.next());
assert(null == concatenatedIter.next());
```

## Función `fromArray`

```motoko no-repl
func fromArray<A>(xs : [A]) : Iter<A>
```

Crea un iterador que produce los elementos de un Array en orden ascendente de
índice.

```motoko
import Iter "mo:base/Iter";
let iter = Iter.fromArray([1, 2, 3]);
assert(?1 == iter.next());
assert(?2 == iter.next());
assert(?3 == iter.next());
assert(null == iter.next());
```

## Función `fromArrayMut`

```motoko no-repl
func fromArrayMut<A>(xs : [var A]) : Iter<A>
```

Similar a `fromArray` pero para Arrays con elementos mutables. Captura los
elementos del Array en el momento en que se crea el iterador, por lo que las
modificaciones posteriores no se reflejarán en el iterador.

## Valor `fromList`

```motoko no-repl
let fromList
```

Similar a `fromArray` pero para Listas.

## Función `toArray`

```motoko no-repl
func toArray<A>(xs : Iter<A>) : [A]
```

Consume un iterador y recopila sus elementos producidos en un Array.

```motoko
import Iter "mo:base/Iter";
let iter = Iter.range(1, 3);
assert([1, 2, 3] == Iter.toArray(iter));
```

## Función `toArrayMut`

```motoko no-repl
func toArrayMut<A>(xs : Iter<A>) : [var A]
```

Similar a `toArray` pero para Arrays con elementos mutables.

## Función `toList`

```motoko no-repl
func toList<A>(xs : Iter<A>) : List.List<A>
```

Similar a `toArray` pero para Listas.

## Función `sort`

```motoko no-repl
func sort<A>(xs : Iter<A>, compare : (A, A) -> Order.Order) : Iter<A>
```

Iterador ordenado. Iterará sobre _todos_ los elementos para ordenarlos,
necesariamente.
