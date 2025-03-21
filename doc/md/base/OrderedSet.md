# OrderedSet

Conjunto ordenado estable implementado como un árbol red-black (RBTree).

Un árbol red-black es un árbol de búsqueda binario equilibrado ordenado por los
elementos.

La estructura de datos del árbol colorea internamente cada uno de sus nodos como
rojo o negro, y utiliza esta información para equilibrar el árbol durante las
operaciones de modificación.

Rendimiento:

- Tiempo de ejecución: `O(log(n))` costo en el peor de los casos por inserción,
  eliminación y recuperación operación.
- Espacio: `O(n)` para almacenar todo el árbol. `n` denota el número de
  elementos (es decir, nodos) almacenados en el árbol.

Créditos:

El núcleo de esta implementación se deriva de:

- Ken Friis Larsen's
  [RedBlackMap.sml](https://github.com/kfl/mosml/blob/master/src/mosmllib/Redblackmap.sml),
  que a su vez se basa en:
- Stefan Kahrs, "Red-black trees with types", Journal of Functional Programming,
  11(4): 425-432 (2001),
  [versión 1 en el apéndice web](http://www.cs.ukc.ac.uk/people/staff/smk/redblack/rb.html).

## Tipo `Set`

```motoko no-repl
type Set<T> = { size : Nat; root : Tree<T> }
```

Colección ordenada de elementos únicos del tipo genérico `T`. Si el tipo `T` es
estable, entonces `Set<T>` también es estable. Para garantizar esa propiedad, el
`Set<T>` no tiene ningún método, en su lugar se recopilan en la clase tipo
functor `Operations` (ver ejemplo allí).

## Clase `Operations<T>`

```motoko no-repl
class Operations<T>(compare : (T, T) -> O.Order)
```

Clase que captura el tipo de elemento `T` junto con su función de ordenación
`compare` y proporciona todas las operaciones para trabajar con un conjunto de
tipo `Set<T>`.

Se debe crear un objeto de instancia una vez como un campo del canister para
asegurar que el mismo función de ordenación se utiliza para cada operación.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";

actor {
  let natSet = Set.Make<Nat>(Nat.compare); // : Operations<Nat>
  stable var usedIds : Set.Set<Nat> = natSet.empty();

  public func createId(id : Nat) : async () {
    usedIds := natSet.put(usedIds, id);
  };

  public func idIsUsed(id: Nat) : async Bool {
     natSet.contains(usedIds, id)
  }
}
```

### Función `fromIter`

```motoko no-repl
func fromIter(i : I.Iter<T>) : Set<T>
```

Devuelve un nuevo conjunto, que contiene todas las entradas dadas por el
iterador `i`. Si hay múltiples entradas idénticas, solo se toma una.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show(Iter.toArray(natSet.vals(set))));
// [0, 1, 2]
```

Tiempo de ejecución: `O(n * log(n))`. Espacio: `O(n)` memoria retenida más
basura, ver la nota a continuación. donde `n` denota el número de elementos
almacenados en el conjunto y asumiendo que la función `compare` implementa una
comparación `O(1)`.

Nota: Crea `O(n * log(n))` objetos temporales que se recogerán como basura.

### Función `put`

```motoko no-repl
func put(s : Set<T>, value : T) : Set<T>
```

Inserta el valor `value` en el conjunto `s`. No tiene efecto si `value` ya está
presente en el conjunto. Devuelve un conjunto modificado.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
var set = natSet.empty();

set := natSet.put(set, 0);
set := natSet.put(set, 2);
set := natSet.put(set, 1);

Debug.print(debug_show(Iter.toArray(natSet.vals(set))));
// [0, 1, 2]
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(log(n))`. donde `n` denota el
número de elementos almacenados en el conjunto y asumiendo que la función
`compare` implementa una comparación `O(1)`.

Nota: El conjunto devuelto comparte con el `s` la mayoría de los nodos del
árbol. Recolectar basura uno de los conjuntos (por ejemplo, después de una
asignación `m := natSet.delete(m, k)`) causa la recolección de `O(log(n))`
nodos.

### Función `delete`

```motoko no-repl
func delete(s : Set<T>, value : T) : Set<T>
```

Elimina el valor `value` del conjunto `s`. No tiene efecto si `value` no está
presente en el conjunto. Devuelve el conjunto modificado.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show(Iter.toArray(natSet.vals(natSet.delete(set, 1)))));
Debug.print(debug_show(Iter.toArray(natSet.vals(natSet.delete(set, 42)))));
// [0, 2]
// [0, 1, 2]
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(log(n))`. donde `n` denota el
número de elementos almacenados en el conjunto y asumiendo que la función
`compare` implementa una comparación `O(1)`.

Nota: El conjunto devuelto comparte con el `s` la mayoría de los nodos del
árbol. Recolectar basura uno de los conjuntos (por ejemplo, después de una
asignación `m := natSet.delete(m, k)`) causa la recolección de `O(log(n))`
nodos.

### Función `contains`

```motoko no-repl
func contains(s : Set<T>, value : T) : Bool
```

Prueba si el conjunto 's' contiene un elemento dado.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show natSet.contains(set, 1)); // => true
Debug.print(debug_show natSet.contains(set, 42)); // => false
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(1)` memoria retenida más basura,
ver la nota a continuación. donde `n` denota el número de elementos almacenados
en el conjunto y asumiendo que la función `compare` implementa una comparación
`O(1)`.

### Función `max`

```motoko no-repl
func max(s : Set<T>) : ?T
```

Obtiene un elemento maximal del conjunto `s` si no está vacío, de lo contrario
devuelve `null`

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let s1 = natSet.fromIter(Iter.fromArray([0, 2, 1]));
let s2 = natSet.empty();

Debug.print(debug_show(natSet.max(s1))); // => ?2
Debug.print(debug_show(natSet.max(s2))); // => null
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(1)`. donde `n` denota el número de
elementos en el conjunto

### Función `min`

```motoko no-repl
func min(s : Set<T>) : ?T
```

Obtiene un elemento mínimo del conjunto `s` si no está vacío, de lo contrario
devuelve `null`

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let s1 = natSet.fromIter(Iter.fromArray([0, 2, 1]));
let s2 = natSet.empty();

Debug.print(debug_show(natSet.min(s1))); // => ?0
Debug.print(debug_show(natSet.min(s2))); // => null
```

Tiempo de ejecución: `O(log(n))`. Espacio: `O(1)`. donde `n` denota el número de
elementos en el conjunto

### Función `union`

```motoko no-repl
func union(s1 : Set<T>, s2 : Set<T>) : Set<T>
```

Operación de
[unión de conjuntos](<https://en.wikipedia.org/wiki/Union_(set_theory)>).

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set1 = natSet.fromIter(Iter.fromArray([0, 1, 2]));
let set2 = natSet.fromIter(Iter.fromArray([2, 3, 4]));

Debug.print(debug_show Iter.toArray(natSet.vals(natSet.union(set1, set2))));
// [0, 1, 2, 3, 4]
```

Tiempo de ejecución: `O(m * log(n))`. Espacio: `O(m)`, memoria retenida más
basura, ver la nota a continuación. donde `m` y `n` denotan el número de
elementos en los conjuntos, y `m <= n`.

Nota: Crea `O(m * log(n))` objetos temporales que se recogerán como basura.

### Función `intersect`

```motoko no-repl
func intersect(s1 : Set<T>, s2 : Set<T>) : Set<T>
```

Operación de
[intersección de conjuntos](<https://en.wikipedia.org/wiki/Intersection_(set_theory)>).

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set1 = natSet.fromIter(Iter.fromArray([0, 1, 2]));
let set2 = natSet.fromIter(Iter.fromArray([1, 2, 3]));

Debug.print(debug_show Iter.toArray(natSet.vals(natSet.intersect(set1, set2))));
// [1, 2]
```

Tiempo de ejecución: `O(m * log(n))`. Espacio: `O(m)`, memoria retenida más
basura, ver la nota a continuación. donde `m` y `n` denotan el número de
elementos en los conjuntos, y `m <= n`.

Nota: Crea `O(m)` objetos temporales que se recogerán como basura.

### Función `diff`

```motoko no-repl
func diff(s1 : Set<T>, s2 : Set<T>) : Set<T>
```

[Diferencia de conjuntos](<https://en.wikipedia.org/wiki/Difference_(set_theory)>).

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set1 = natSet.fromIter(Iter.fromArray([0, 1, 2]));
let set2 = natSet.fromIter(Iter.fromArray([1, 2, 3]));

Debug.print(debug_show Iter.toArray(natSet.vals(natSet.diff(set1, set2))));
// [0]
```

Tiempo de ejecución: `O(m * log(n))`. Espacio: `O(m)`, memoria retenida más
basura, ver la nota a continuación. donde `m` y `n` denotan el número de
elementos en los conjuntos, y `m <= n`.

Nota: Crea `O(m * log(n))` objetos temporales que se recogerán como basura.

### Función `map`

```motoko no-repl
func map<T1>(s : Set<T1>, f : T1 -> T) : Set<T>
```

Crea un nuevo `Set` aplicando `f` a cada entrada en el conjunto `s`. Cada
elemento `x` en el conjunto antiguo se transforma en una nueva entrada `x2`,
donde el nuevo valor `x2` se crea aplicando `f` a `x`. El conjunto resultante
puede ser más pequeño que el conjunto original debido a elementos duplicados.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 1, 2, 3]));

func f(x : Nat) : Nat = if (x < 2) { x } else { 0 };

let resSet = natSet.map(set, f);

Debug.print(debug_show(Iter.toArray(natSet.vals(resSet))));
// [0, 1]
```

Costo de mapear todos los elementos: Tiempo de ejecución: `O(n * log(n))`.
Espacio: `O(n)` memoria retenida donde `n` denota el número de elementos
almacenados en el conjunto.

Nota: Crea `O(n * log(n))` objetos temporales que se recogerán como basura.

### Función `mapFilter`

```motoko no-repl
func mapFilter<T1>(s : Set<T1>, f : T1 -> ?T) : Set<T>
```

Crea un nuevo conjunto aplicando `f` a cada elemento en el conjunto `s`. Para
cada elemento `x` en el conjunto original, si `f` evalúa a `null`, el elemento
se descarta. De lo contrario, la entrada se transforma en una nueva entrada
`x2`, donde el nuevo valor `x2` es el resultado de aplicar `f` a `x`.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 1, 2, 3]));

func f(x : Nat) : ?Nat {
  if(x == 0) {null}
  else { ?( x * 2 )}
};

let newRbSet = natSet.mapFilter(set, f);

Debug.print(debug_show(Iter.toArray(natSet.vals(newRbSet))));
// [2, 4, 6]
```

Tiempo de ejecución: `O(n * log(n))`. Espacio: `O(n)` memoria retenida más
basura, ver la nota a continuación, donde `n` denota el número de elementos
almacenados en el conjunto y asumiendo que la función `compare` implementa una
comparación `O(1)`.

Nota: Crea `O(n * log(n))` objetos temporales que se recogerán como basura.

### Función `isSubset`

```motoko no-repl
func isSubset(s1 : Set<T>, s2 : Set<T>) : Bool
```

Comprueba si `set1` es un subconjunto de `set2`.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set1 = natSet.fromIter(Iter.fromArray([1, 2]));
let set2 = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show natSet.isSubset(set1, set2)); // => true
```

Tiempo de ejecución: `O(m * log(n))`. Espacio: `O(1)` memoria retenida más
basura, ver la nota a continuación, donde `m` y `n` denotan el número de
elementos almacenados en los conjuntos set1 y set2, respectivamente, y asumiendo
que la función `compare` implementa una comparación `O(1)`.

### Función `equals`

```motoko no-repl
func equals(s1 : Set<T>, s2 : Set<T>) : Bool
```

Comprueba si dos conjuntos son iguales.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set1 = natSet.fromIter(Iter.fromArray([0, 2, 1]));
let set2 = natSet.fromIter(Iter.fromArray([1, 2]));

Debug.print(debug_show natSet.equals(set1, set1)); // => true
Debug.print(debug_show natSet.equals(set1, set2)); // => false
```

Tiempo de ejecución: `O(m * log(n))`. Espacio: `O(1)` memoria retenida más
basura, ver la nota a continuación, donde `m` y `n` denotan el número de
elementos almacenados en los conjuntos set1 y set2, respectivamente, y asumiendo
que la función `compare` implementa una comparación `O(1)`.

### Función `vals`

```motoko no-repl
func vals(s : Set<T>) : I.Iter<T>
```

Devuelve un Iterador (`Iter`) sobre los elementos del conjunto. El iterador
proporciona un método `next()`, que devuelve los elementos en orden ascendente,
o `null` cuando no hay más elementos para iterar.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show(Iter.toArray(natSet.vals(set))));
// [0, 1, 2]
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: `O(log(n))` memoria retenida más basura, ver la nota a continuación,
donde `n` denota el número de elementos almacenados en el conjunto.

Nota: La iteración completa del conjunto crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `valsRev`

```motoko no-repl
func valsRev(s : Set<T>) : I.Iter<T>
```

Igual que `vals()`, pero itera sobre los elementos del conjunto `s` en orden
descendente.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show(Iter.toArray(natSet.valsRev(set))));
// [2, 1, 0]
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: `O(log(n))` memoria retenida más basura, ver la nota a continuación,
donde `n` denota el número de elementos almacenados en el conjunto.

Nota: La iteración completa del conjunto crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `empty`

```motoko no-repl
func empty() : Set<T>
```

Crea un nuevo conjunto vacío.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.empty();

Debug.print(debug_show(natSet.size(set))); // => 0
```

Costo de creación de un conjunto vacío: Tiempo de ejecución: `O(1)`. Espacio:
`O(1)`

### Función `size`

```motoko no-repl
func size(s : Set<T>) : Nat
```

Devuelve el número de elementos en el conjunto.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show(natSet.size(set))); // => 3
```

Tiempo de ejecución: `O(1)`. Espacio: `O(1)`.

### Función `foldLeft`

```motoko no-repl
func foldLeft<Accum>(set : Set<T>, base : Accum, combine : (Accum, T) -> Accum) : Accum
```

Combina los elementos en `set` en un solo valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de izquierda a derecha.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

func folder(accum : Nat, val : Nat) : Nat = val + accum;

Debug.print(debug_show(natSet.foldLeft(set, 0, folder)));
// 3
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: depende de la función `combine` más basura, ver la nota a continuación,
donde `n` denota el número de elementos almacenados en el conjunto.

Nota: La iteración completa del conjunto crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `foldRight`

```motoko no-repl
func foldRight<Accum>(set : Set<T>, base : Accum, combine : (T, Accum) -> Accum) : Accum
```

Combina los elementos en `set` en un solo valor comenzando con `base` y
combinando progresivamente los elementos en `base` con `combine`. La iteración
se realiza de derecha a izquierda.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

func folder(val : Nat, accum : Nat) : Nat = val + accum;

Debug.print(debug_show(natSet.foldRight(set, 0, folder)));
// 3
```

Costo de iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio: depende de la función `combine` más basura, ver la nota a continuación,
donde `n` denota el número de elementos almacenados en el conjunto.

Nota: La iteración completa del conjunto crea `O(n)` objetos temporales que se
recogerán como basura.

### Función `isEmpty`

```motoko no-repl
func isEmpty(s : Set<T>) : Bool
```

Comprueba si el conjunto `s` dado está vacío.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.empty();

Debug.print(debug_show(natSet.isEmpty(set))); // => true
```

Tiempo de ejecución: `O(1)`. Espacio: `O(1)`.

### Función `all`

```motoko no-repl
func all(s : Set<T>, pred : T -> Bool) : Bool
```

Comprueba si todos los valores en el conjunto `s` satisfacen un predicado `pred`
dado.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show(natSet.all(set, func (v) = (v < 10))));
// true
Debug.print(debug_show(natSet.all(set, func (v) = (v < 2))));
// false
```

Tiempo de ejecución: `O(n)`. Espacio: `O(1)`. donde `n` denota el número de
elementos almacenados en el conjunto.

### Función `some`

```motoko no-repl
func some(s : Set<T>, pred : (T) -> Bool) : Bool
```

Comprueba si existe un elemento en el conjunto `s` que cumple el predicado
`pred` dado.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let natSet = Set.Make<Nat>(Nat.compare);
let set = natSet.fromIter(Iter.fromArray([0, 2, 1]));

Debug.print(debug_show(natSet.some(set, func (v) = (v >= 3))));
// false
Debug.print(debug_show(natSet.some(set, func (v) = (v >= 0))));
// true
```

Tiempo de ejecución: `O(n)`. Espacio: `O(1)`. donde `n` denota el número de
elementos almacenados en el conjunto.

### Función `validate`

```motoko no-repl
func validate(s : Set<T>) : ()
```

Función auxiliar de prueba que verifica la invariante interna del conjunto `s`.
Lanza un error (para obtener una traza de la pila) si se violan las invariantes.

## Valor `Make`

```motoko no-repl
let Make : <T>(compare : (T, T) -> O.Order) -> Operations<T>
```

Crear un objeto `OrderedSet.Operations` que capture el tipo de elemento `T` y la
función `compare`. Es un alias para el constructor `Operations`.

Ejemplo:

```motoko
import Set "mo:base/OrderedSet";
import Nat "mo:base/Nat";

actor {
  let natSet = Set.Make<Nat>(Nat.compare);
  stable var set : Set.Set<Nat> = natSet.empty();
};
```
