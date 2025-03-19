# Deque

Queue de doble extremo (deque) de un tipo genérico `T`.

La interfaz de los deques es puramente funcional, no imperativa, y los deques
son valores inmutables. En particular, las operaciones de deque como push y pop
no actualizan su deque de entrada, sino que devuelven el valor del deque
modificado, junto con cualquier otro dato. El deque de entrada se mantiene sin
cambios.

Ejemplos de casos de uso: Cola (Queue) (FIFO) utilizando `pushBack()` y
`popFront()`. Pila (Stack) (LIFO) utilizando `pushFront()` y `popFront()`.

Un deque se implementa internamente como dos listas, una lista de acceso a la
cabeza y una lista de acceso a la cola (invertida), que se equilibran
dinámicamente mediante divisiones.

Construcción: Crea un nuevo deque con la función `empty<T>()`.

Nota sobre los costos de las funciones push y pop:

- Tiempo de ejecución: costos amortizados de `O(1)`, costo de peor caso de
  `O(n)` por llamada única.
- Espacio: costos amortizados de `O(1)`, costo de peor caso de `O(n)` por
  llamada única.

`n` denota el número de elementos almacenados en el deque.

## Tipo `Deque`

```motoko no-repl
type Deque<T> = (List<T>, List<T>)
```

Tipo de datos de cola de doble extremo (deque).

## Función `empty`

```motoko no-repl
func empty<T>() : Deque<T>
```

Crea un deque vacío nuevo.

Ejemplo:

```motoko
import Deque "mo:base/Deque";

Deque.empty<Nat>()
```

Tiempo de ejecución: `O(1)`.

Espacio: `O(1)`.

## Función `isEmpty`

```motoko no-repl
func isEmpty<T>(deque : Deque<T>) : Bool
```

Determina si un deque está vacío. Devuelve true si `deque` está vacío, de lo
contrario, false.

Ejemplo:

```motoko
import Deque "mo:base/Deque";

let deque = Deque.empty<Nat>();
Deque.isEmpty(deque) // => true
```

Tiempo de ejecución: `O(1)`.

Espacio: `O(1)`.

## Función `pushFront`

```motoko no-repl
func pushFront<T>(deque : Deque<T>, element : T) : Deque<T>
```

Inserta un nuevo elemento en el extremo frontal de un deque. Devuelve el nuevo
deque con `element` en el frente seguido de los elementos de `deque`.

Esto puede implicar el reequilibrio dinámico de las dos listas utilizadas
internamente.

Ejemplo:

```motoko
import Deque "mo:base/Deque";

Deque.pushFront(Deque.pushFront(Deque.empty<Nat>(), 2), 1) // deque con elementos [1, 2]
```

Tiempo de ejecución: peor caso de `O(n)`, amortizado a `O(1)`.

Espacio: peor caso de `O(n)`, amortizado a `O(1)`.

`n` denota el número de elementos almacenados en el deque.

## Función `peekFront`

```motoko no-repl
func peekFront<T>(deque : Deque<T>) : ?T
```

Inspecciona el elemento opcional en el extremo frontal de un deque. Devuelve
`null` si `deque` está vacío. De lo contrario, el elemento frontal de `deque`.

Ejemplo:

```motoko
import Deque "mo:base/Deque";

let deque = Deque.pushFront(Deque.pushFront(Deque.empty<Nat>(), 2), 1);
Deque.peekFront(deque) // => ?1
```

Tiempo de ejecución: `O(1)`.

Espacio: `O(1)`.

## Función `popFront`

```motoko no-repl
func popFront<T>(deque : Deque<T>) : ?(T, Deque<T>)
```

Elimina el elemento en el extremo frontal de un deque. Devuelve `null` si
`deque` está vacío. De lo contrario, devuelve un par del primer elemento y un
nuevo deque que contiene todos los elementos restantes de `deque`.

Esto puede implicar el reequilibrio dinámico de las dos listas utilizadas
internamente.

Ejemplo:

```motoko
import Deque "mo:base/Deque";
import Debug "mo:base/Debug";
let initial = Deque.pushFront(Deque.pushFront(Deque.empty<Nat>(), 2), 1);
// deque inicial con elementos [1, 2]
let reduced = Deque.popFront(initial);
switch reduced {
  case null {
    Debug.trap "Queue vacío imposible"
  };
  case (?result) {
    let removedElement = result.0; // 1
    let reducedDeque = result.1; // deque con elemento [2].
  }
}
```

Tiempo de ejecución: peor caso de `O(n)`, amortizado a `O(1)`.

Espacio: peor caso de `O(n)`, amortizado a `O(1)`.

`n` denota el número de elementos almacenados en el deque.

## Función `pushBack`

```motoko no-repl
func pushBack<T>(deque : Deque<T>, element : T) : Deque<T>
```

Inserta un nuevo elemento en el extremo posterior de un deque. Devuelve el nuevo
deque con todos los elementos de `deque`, seguido de `element` en la parte
posterior.

Esto puede implicar el reequilibrio dinámico de las dos listas utilizadas
internamente.

Ejemplo:

```motoko
import Deque "mo:base/Deque";

Deque.pushBack(Deque.pushBack(Deque.empty<Nat>(), 1), 2) // deque con elementos [1, 2]
```

Tiempo de ejecución: peor caso de `O(n)`, amortizado a `O(1)`.

Espacio: peor caso de `O(n)`, amortizado a `O(1)`.

`n` denota el número de elementos almacenados en el deque.

## Función `peekBack`

```motoko no-repl
func peekBack<T>(deque : Deque<T>) : ?T
```

Inspecciona el elemento opcional en el extremo posterior de un deque. Devuelve
`null` si `deque` está vacío. De lo contrario, el elemento posterior de `deque`.

Ejemplo:

```motoko
import Deque "mo:base/Deque";

let deque = Deque.pushBack(Deque.pushBack(Deque.empty<Nat>(), 1), 2);
Deque.peekBack(deque) // => ?2
```

Tiempo de ejecución: `O(1)`.

Espacio: `O(1)`.

## Función `popBack`

```motoko no-repl
func popBack<T>(deque : Deque<T>) : ?(Deque<T>, T)
```

Elimina el elemento en el extremo posterior de un deque. Devuelve `null` si
`deque` está vacío. De lo contrario, devuelve un par de un nuevo deque que
contiene los elementos restantes de `deque` y, como segundo elemento del par, el
elemento posterior eliminado.

Esto puede implicar el reequilibrio dinámico de las dos listas utilizadas
internamente.

Ejemplo:

```motoko
import Deque "mo:base/Deque";
import Debug "mo:base/Debug";

let initial = Deque.pushBack(Deque.pushBack(Deque.empty<Nat>(), 1), 2);
// deque inicial con elementos [1, 2]
let reduced = Deque.popBack(initial);
switch reduced {
  case null {
    Debug.trap "Queue vacío imposible"
  };
  case (?result) {
    let reducedDeque = result.0; // deque con elemento [1].
    let removedElement = result.1; // 2
  }
}
```

Tiempo de ejecución: peor caso de `O(n)`, amortizado a `O(1)`.

Espacio: peor caso de `O(n)`, amortizado a `O(1)`.

`n` denota el número de elementos almacenados en el deque.
