# Heap

La clase `Heap<X>` proporciona una cola de prioridad de elementos de tipo `X`.

La clase envuelve una implementación puramente funcional basada en un heap
izquierdo.

Nota sobre el constructor: El constructor recibe una función de comparación
`compare` que define el orden entre elementos de tipo `X`. La mayoría de los
tipos primitivos tienen una versión predeterminada de esta función de
comparación definida en sus módulos (por ejemplo, `Nat.compare`). El análisis de
tiempo de ejecución en esta documentación asume que la función `compare` se
ejecuta en tiempo y espacio `O(1)`.

Ejemplo:

```motoko name=initialize
import Heap "mo:base/Heap";
import Text "mo:base/Text";

let heap = Heap.Heap<Text>(Text.compare);
```

Tiempo de ejecución: `O(1)`

Espacio: `O(1)`

## Tipo `Tree`

```motoko no-repl
type Tree<X> = ?(Int, X, Tree<X>, Tree<X>)
```

## Clase `Heap<X>`

```motoko no-repl
class Heap<X>(compare : (X, X) -> O.Order)
```

### Función `put`

```motoko no-repl
func put(x : X)
```

Inserta un elemento en el heap.

Ejemplo:

```motoko include=initialize

heap.put("manzana");
heap.peekMin() // => ?"manzana"
```

Tiempo de ejecución: `O(log(n))`

Espacio: `O(log(n))`

### Función `peekMin`

```motoko no-repl
func peekMin() : ?X
```

Devuelve el elemento mínimo en el heap, o `null` si el heap está vacío.

Ejemplo:

```motoko include=initialize

heap.put("manzana");
heap.put("plátano");
heap.put("melón");
heap.peekMin() // => ?"manzana"
```

Tiempo de ejecución: `O(1)`

Espacio: `O(1)`

### Función `deleteMin`

```motoko no-repl
func deleteMin()
```

Elimina el elemento mínimo en el heap, si existe.

Ejemplo:

```motoko include=initialize

heap.put("manzana");
heap.put("plátano");
heap.put("melón");
heap.deleteMin();
heap.peekMin(); // => ?"plátano"
```

Tiempo de ejecución: `O(log(n))`

Espacio: `O(log(n))`

### Función `removeMin`

```motoko no-repl
func removeMin() : (minElement : ?X)
```

Elimina y devuelve el elemento mínimo en el heap, si existe.

Ejemplo:

```motoko include=initialize

heap.put("manzana");
heap.put("plátano");
heap.put("melón");
heap.removeMin(); // => ?"manzana"
```

Tiempo de ejecución: `O(log(n))`

Espacio: `O(log(n))`

### Función `share`

```motoko no-repl
func share() : Tree<X>
```

Devuelve una instantánea de la representación interna del árbol funcional como
datos compartibles. La representación del árbol devuelto no se ve afectada por
cambios posteriores en la instancia de `Heap`.

Ejemplo:

```motoko include=initialize

heap.put("plátano");
heap.share();
```

Útil para almacenar el heap como una variable estable, imprimirlo de forma
legible y compartirlo en llamadas de función asíncronas, es decir, pasándolo en
argumentos asíncronos o resultados asíncronos.

Tiempo de ejecución: `O(1)`

Espacio: `O(1)`

### Función `unsafeUnshare`

```motoko no-repl
func unsafeUnshare(tree : Tree<X>)
```

Vuelve a envolver una instantánea de un heap (obtenida mediante `share()`) en
una instancia de `Heap`. La instancia de envoltura debe inicializarse con la
misma función de `compare` que creó la instantánea.

Ejemplo:

```motoko include=initialize

heap.put("manzana");
heap.put("plátano");
let snapshot = heap.share();
let heapCopy = Heap.Heap<Text>(Text.compare);
heapCopy.unsafeUnshare(snapshot);
heapCopy.peekMin() // => ?"manzana"
```

Útil para cargar un heap almacenado desde una variable estable o acceder a una
instantánea de heap pasada desde una llamada de función asíncrona.

Tiempo de ejecución: `O(1)`.

Espacio: `O(1)`.

## Función `fromIter`

```motoko no-repl
func fromIter<X>(iter : I.Iter<X>, compare : (X, X) -> O.Order) : Heap<X>
```

Devuelve un nuevo `Heap`, que contiene todas las entradas dadas por el iterador
`iter`. El nuevo heap se inicializa con la función de `compare` proporcionada.

Ejemplo:

```motoko include=initialize
let entries = ["plátano", "manzana", "melón"];
let iter = entries.vals();

let newHeap = Heap.fromIter<Text>(iter, Text.compare);
newHeap.peekMin() // => ?"manzana"
```

Tiempo de ejecución: `O(size)`

Espacio: `O(size)`
