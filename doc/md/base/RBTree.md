# RBTree

Mapa clave-valor implementado como un árbol red-black (RBTree) con nodos que
almacenan pares clave-valor.

Un árbol red-black es un árbol de búsqueda binario equilibrado ordenado por las
claves.

La estructura de datos del árbol colorea internamente cada uno de sus nodos de
rojo o negro, y utiliza esta información para equilibrar el árbol durante las
operaciones de modificación.

Creación: Instancie la clase `RBTree<K, V>` que proporciona un mapa de claves de
tipo `K` a valores de tipo `V`.

Ejemplo:

```motoko
import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

let tree = RBTree.RBTree<Nat, Text>(Nat.compare); // Crea un nuevo árbol red-black que mapea Nat a Text
tree.put(1, "uno");
tree.put(2, "dos");
tree.put(3, "tres");
for (entry in tree.entries()) {
  Debug.print("Key del elemento=" # debug_show(entry.0) # " value=\"" # entry.1 #"\"");
}
```

Rendimiento:

- Tiempo de ejecución: `O(log(n))` costo en el peor de los casos por inserción,
  eliminación y operación de recuperación.
- Espacio en el heap: `O(n)` para almacenar todo el árbol.
- Espacio en el stack: `O(log(n))` para almacenar todo el árbol. `n` denota el
  número de entradas clave-valor (es decir, nodos) almacenados en el árbol.

Nota:

- La inserción, reemplazo y eliminación del árbol producen objetos basura
  `O(log(n))`.

Créditos:

El núcleo de esta implementación se deriva de:

- [RedBlackMap.sml](https://github.com/kfl/mosml/blob/master/src/mosmllib/Redblackmap.sml)
  de Ken Friis Larsen, que a su vez se basa en:
- Stefan Kahrs, "Red-black trees with types", Journal of Functional Programming,
  11(4): 425-432 (2001),
  [versión 1 en el apéndice web](http://www.cs.ukc.ac.uk/people/staff/smk/redblack/rb.html).

## Tipo `Color`

```motoko no-repl
type Color = {#R; #B}
```

Color del nodo: ya sea rojo (`#R`) o negro (`#B`).

## Tipo `Tree`

```motoko no-repl
type Tree<K, V> = {#node : (Color, Tree<K, V>, (K, ?V), Tree<K, V>); #leaf}
```

Árbol red-black de nodos con entradas clave-valor, ordenado por las claves. Las
claves tienen el tipo genérico `K` y los valores el tipo genérico `V`. Las hojas
se consideran implícitamente negras.

## Clase `RBTree<K, V>`

```motoko no-repl
class RBTree<K, V>(compare : (K, K) -> O.Order)
```

Un mapa de claves de tipo `K` a valores de tipo `V` implementado como un árbol
red-black. Las entradas de pares clave-valor están ordenadas por la función
`compare` aplicada a las claves.

La clase permite el uso imperativo en estilo orientado a objetos. Sin embargo,
internamente, la clase utiliza una implementación funcional.

La función `compare` debe implementar un orden total consistente entre todos los
valores posibles de `K` y, para mayor eficiencia, solo implica costos de tiempo
de ejecución `O(1)` sin asignación de espacio.

Ejemplo:

```motoko name=initialize
import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";

let tree = RBTree.RBTree<Nat, Text>(Nat.compare); // Crea un mapa de `Nat` a `Text` usando el orden `Nat.compare`
```

Costos de la instanciación (solo árbol vacío): Tiempo de ejecución: `O(1)`.
Espacio en el heap: `O(1)`. Espacio en el stack: `O(1)`.

### Función `share`

```motoko no-repl
func share() : Tree<K, V>
```

Devuelve una instantánea de la representación funcional interna del árbol como
datos compartibles. La representación del árbol devuelto no se ve afectada por
cambios posteriores de la instancia de `RBTree`.

Ejemplo:

```motoko include=initialize

tree.put(1, "uno");
let treeSnapshot = tree.share();
tree.put(2, "segundo");
RBTree.size(treeSnapshot) // => 1 (Solo la primera inserción forma parte de la instantánea.)
```

Útil para almacenar el estado de un objeto de árbol como una variable estable,
determinar su tamaño, imprimirlo de forma legible y compartirlo entre llamadas
de funciones asíncronas, es decir, pasándolo en argumentos asíncronos o
resultados asíncronos.

Tiempo de ejecución: `O(1)`. Espacio en el heap: `O(1)`. Espacio en el stack:
`O(1)`.

### Función `unshare`

```motoko no-repl
func unshare(t : Tree<K, V>) : ()
```

Restablece el estado actual del objeto de árbol a partir de una representación
de árbol funcional.

Ejemplo:

```motoko include=initialize
import Iter "mo:base/Iter";

tree.put(1, "uno");
let snapshot = tree.share(); // guarda el estado actual del objeto de árbol en una instantánea
tree.put(2, "dos");
tree.unshare(snapshot); // restaura el objeto de árbol desde la instantánea
Iter.toArray(tree.entries()) // => [(1, "uno")]
```

Útil para restaurar el estado de un objeto de árbol a partir de datos estables,
guardados, por ejemplo, en una variable estable.

Tiempo de ejecución: `O(1)`. Espacio en el heap: `O(1)`. Espacio en el stack:
`O(1)`.

### Función `get`

```motoko no-repl
func get(key : K) : ?V
```

Recupera el valor asociado con una clave dada, si está presente. Devuelve `null`
si la clave está ausente. La clave se busca según la función `compare` definida
en la instancia de la clase.

Ejemplo:

```motoko include=initialize

tree.put(1, "uno");
tree.put(2, "dos");

tree.get(1) // => ?"uno"
```

Tiempo de ejecución: `O(log(n))`. Espacio en el heap: `O(1)`. Espacio en el
stack: `O(log(n))`. donde `n` denota el número de entradas clave-valor
almacenadas en el árbol y asumiendo que la función `compare` implementa una
comparación `O(1)`.

### Función `replace`

```motoko no-repl
func replace(key : K, value : V) : ?V
```

Reemplaza el valor asociado con una clave dada, si la clave está presente. De lo
contrario, si la clave aún no existe, inserta la entrada clave-valor.

Devuelve el valor anterior de la clave, si la clave ya existía. De lo contrario,
`null` si la clave aún no existía antes.

Ejemplo:

```motoko include=initialize
import Iter "mo:base/Iter";

tree.put(1, "uno antiguo");
tree.put(2, "dos");

ignore tree.replace(1, "uno nuevo");
Iter.toArray(tree.entries()) // => [(1, "uno nuevo"), (2, "dos")]
```

Tiempo de ejecución: `O(log(n))`. Espacio en el heap: `O(1)` memoria retenida
más basura, consulte la nota a continuación. Espacio en el stack: `O(log(n))`.
donde `n` denota el número de entradas clave-valor almacenadas en el árbol y
asumiendo que la función `compare` implementa una comparación `O(1)`.

Nota: Crea objetos basura `O(log(n))`.

### Función `put`

```motoko no-repl
func put(key : K, value : V)
```

Inserta una entrada clave-valor en el árbol. Si la clave ya existe, sobrescribe
el valor asociado.

Ejemplo:

```motoko include=initialize
import Iter "mo:base/Iter";

tree.put(1, "uno");
tree.put(2, "dos");
tree.put(3, "tres");
Iter.toArray(tree.entries()) // ahora contiene tres entradas
```

Tiempo de ejecución: `O(log(n))`. Espacio en el heap: `O(1)` memoria retenida
más basura, consulte la nota a continuación. Espacio en el stack: `O(log(n))`.
donde `n` denota el número de entradas clave-valor almacenadas en el árbol y
asumiendo que la función `compare` implementa una comparación `O(1)`.

Nota: Crea objetos basura `O(log(n))`.

### Función `delete`

```motoko no-repl
func delete(key : K)
```

Elimina la entrada asociada con una clave dada, si la clave existe. Sin efecto
si la clave está ausente. Igual que `remove(key)` excepto que no tiene un valor
de retorno.

Ejemplo:

```motoko include=initialize
import Iter "mo:base/Iter";

tree.put(1, "uno");
tree.put(2, "dos");

tree.delete(1);
Iter.toArray(tree.entries()) // => [(2, "dos")].
```

Tiempo de ejecución: `O(log(n))`. Espacio en el heap: `O(1)` memoria retenida
más basura, consulte la nota a continuación. Espacio en el stack: `O(log(n))`.
donde `n` denota el número de entradas clave-valor almacenadas en el árbol y
asumiendo que la función `compare` implementa una comparación `O(1)`.

Nota: Crea objetos temporales `O(log(n))` que se recogerán como basura.

### Función `remove`

```motoko no-repl
func remove(key : K) : ?V
```

Elimina la entrada asociada con una clave dada, si la clave existe, y devuelve
el valor asociado. Devuelve `null` sin ningún otro efecto si la clave está
ausente.

Ejemplo:

```motoko include=initialize
import Iter "mo:base/Iter";

tree.put(1, "uno");
tree.put(2, "dos");

ignore tree.remove(1);
Iter.toArray(tree.entries()) // => [(2, "dos")].
```

Tiempo de ejecución: `O(log(n))`. Espacio en el heap: `O(1)` memoria retenida
más basura, consulte la nota a continuación. Espacio en el stack: `O(log(n))`.
donde `n` denota el número de entradas clave-valor almacenadas en el árbol y
asumiendo que la función `compare` implementa una comparación `O(1)`.

Nota: Crea objetos basura `O(log(n))`.

### Función `entries`

```motoko no-repl
func entries() : I.Iter<(K, V)>
```

Un iterador para las entradas clave-valor del mapa, en orden ascendente de las
claves. El iterador toma una vista instantánea del árbol y no se ve afectado por
modificaciones concurrentes.

Ejemplo:

```motoko include=initialize
import Debug "mo:base/Debug";

tree.put(1, "uno");
tree.put(2, "dos");
tree.put(3, "dos");

for (entry in tree.entries()) {
  Debug.print("Clave del elemento=" # debug_show(entry.0) # " valor=\"" # entry.1 #"\"");
}

// Clave del elemento=1 valor="uno"
// Clave del elemento=2 valor="dos"
// Clave del elemento=3 valor="tres"
```

Costo de la iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio en el heap: `O(log(n))` memoria retenida más basura, consulte la nota a
continuación. Espacio en el stack: `O(log(n))`. donde `n` denota el número de
entradas clave-valor almacenadas en el árbol.

Nota: La iteración completa del árbol crea objetos temporales `O(n)` que se
recogerán como basura.

### Función `entriesRev`

```motoko no-repl
func entriesRev() : I.Iter<(K, V)>
```

Un iterador para las entradas clave-valor del mapa, en orden descendente de las
claves. El iterador toma una vista instantánea del árbol y no se ve afectado por
modificaciones concurrentes.

Ejemplo:

```motoko include=initialize
import Debug "mo:base/Debug";

let tree = RBTree.RBTree<Nat, Text>(Nat.compare);
tree.put(1, "uno");
tree.put(2, "dos");
tree.put(3, "dos");

for (entry in tree.entriesRev()) {
  Debug.print("Clave del elemento=" # debug_show(entry.0) # " valor=\"" # entry.1 #"\"");
}

// Clave del elemento=3 valor="tres"
// Clave del elemento=2 valor="dos"
// Clave del elemento=1 valor="uno"
```

Costo de la iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio en el heap: `O(log(n))` memoria retenida más basura, consulte la nota a
continuación. Espacio en el stack: `O(log(n))`. donde `n` denota el número de
entradas clave-valor almacenadas en el árbol.

Nota: La iteración completa del árbol crea objetos temporales `O(n)` que se
recogerán como basura.

## Función `iter`

```motoko no-repl
func iter<X, Y>(tree : Tree<X, Y>, direction : {#fwd; #bwd}) : I.Iter<(X, Y)>
```

Obtiene un iterador para las entradas del `tree`, en orden ascendente (`#fwd`) o
descendente (`#bwd`) según lo especificado por `direction`. El iterador toma una
vista instantánea del árbol y no se ve afectado por modificaciones concurrentes.

Ejemplo:

```motoko
import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

let tree = RBTree.RBTree<Nat, Text>(Nat.compare);
tree.put(1, "uno");
tree.put(2, "dos");
tree.put(3, "dos");

for (entry in RBTree.iter(tree.share(), #bwd)) { // iteración hacia atrás
  Debug.print("Clave del elemento=" # debug_show(entry.0) # " valor=\"" # entry.1 #"\"");
}

// Clave del elemento=3 valor="tres"
// Clave del elemento=2 valor="dos"
// Clave del elemento=1 valor="uno"
```

Costo de la iteración sobre todos los elementos: Tiempo de ejecución: `O(n)`.
Espacio en el heap: `O(log(n))` memoria retenida más basura, consulte la nota a
continuación. Espacio en el stack: `O(log(n))`. donde `n` denota el número de
entradas clave-valor almacenadas en el árbol.

Nota: La iteración completa del árbol crea objetos temporales `O(n)` que se
recogerán como basura.

## Función `size`

```motoko no-repl
func size<X, Y>(t : Tree<X, Y>) : Nat
```

Determina el tamaño del árbol como el número de entradas clave-valor.

Ejemplo:

```motoko
import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";

let tree = RBTree.RBTree<Nat, Text>(Nat.compare);
tree.put(1, "uno");
tree.put(2, "dos");
tree.put(3, "tres");

RBTree.size(tree.share()) // 3 entradas
```

Tiempo de ejecución: `O(log(n))`. Espacio en el heap: `O(1)`. Espacio en el
stack: `O(log(n))`. donde `n` denota el número de entradas clave-valor
almacenadas en el árbol.
