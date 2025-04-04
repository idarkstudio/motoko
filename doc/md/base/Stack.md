# Stack

La clase `Stack<X>` proporciona un stack (pila) LIFO mínima de elementos de tipo
`X`.

Consulte la biblioteca `Deque` para obtener un comportamiento mixto LIFO/FIFO.

Ejemplo:

```motoko name=initialize
import Stack "mo:base/Stack";

let stack = Stack.Stack<Nat>(); // crea un stack
```

Tiempo de ejecución: O(1)

Espacio: O(1)

## Clase `Stack<T>`

```motoko no-repl
class Stack<T>()
```

### Función `push`

```motoko no-repl
func push(x : T)
```

Añade un elemento en la parte superior de el stack.

Ejemplo:

```motoko include=initialize
stack.push(1);
stack.push(2);
stack.push(3);
stack.peek(); // examina el elemento más superior
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `isEmpty`

```motoko no-repl
func isEmpty() : Bool
```

Devuelve verdadero cuando el stack está vacío y falso en caso contrario.

Ejemplo:

```motoko include=initialize
stack.isEmpty();
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `peek`

```motoko no-repl
func peek() : ?T
```

Devuelve (sin eliminar) el elemento superior, o devuelve null si el stack está
vacío.

Ejemplo:

```motoko include=initialize
stack.push(1);
stack.push(2);
stack.push(3);
stack.peek();
```

Tiempo de ejecución: O(1)

Espacio: O(1)

### Función `pop`

```motoko no-repl
func pop() : ?T
```

Elimina y devuelve el elemento superior, o devuelve null si el stack está vacío.

Ejemplo:

```motoko include=initialize
stack.push(1);
ignore stack.pop();
stack.isEmpty();
```

Tiempo de ejecución: O(1)

Espacio: O(1)
