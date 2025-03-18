# Blob

Módulo para trabajar con Blobs: secuencias inmutables de bytes.

Los Blobs representan secuencias de bytes. Son inmutables, iterables, pero no
indexables y pueden estar vacíos.

Las secuencias de bytes también se representan a menudo como `[Nat8]`, es decir,
un arreglo de bytes, pero esta representación es actualmente mucho menos
compacta que `Blob`, ya que toma 4 bytes físicos para representar cada byte
lógico en la secuencia. Si deseas manipular Blobs, se recomienda que conviertas
los Blobs a `[var Nat8]` o `Buffer<Nat8>`, realices la manipulación y luego los
conviertas de vuelta.

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Blob "mo:base/Blob";
```

Algunas características incorporadas no listadas en este módulo:

- Puedes crear un literal de `Blob` a partir de un literal de `Text`, siempre
  que el contexto espere una expresión de tipo `Blob`.
- `b.size() : Nat` devuelve el número de bytes en el blob `b`;
- `b.vals() : Iter.Iter<Nat8>` devuelve un iterador para enumerar los bytes del
  blob `b`.

Por ejemplo:

```motoko include=import
import Debug "mo:base/Debug";
import Nat8 "mo:base/Nat8";

let blob = "\00\00\00\ff" : Blob; // literales de blob, donde cada byte está delimitado por una barra invertida y se representa en hexadecimal
let blob2 = "charsもあり" : Blob; // también puedes usar caracteres en los literales
let numBytes = blob.size(); // => 4 (devuelve el número de bytes en el Blob)
for (byte : Nat8 in blob.vals()) { // iterador sobre el Blob
  Debug.print(Nat8.toText(byte))
}
```

## Tipo `Blob`

```motoko no-repl
type Blob = Prim.Types.Blob
```

## Función `fromArray`

```motoko no-repl
func fromArray(bytes : [Nat8]) : Blob
```

Crea un `Blob` a partir de un arreglo de bytes (`[Nat8]`), copiando cada
elemento.

Ejemplo:

```motoko include=import
let bytes : [Nat8] = [0, 255, 0];
let blob = Blob.fromArray(bytes); // => "\00\FF\00"
```

## Función `fromArrayMut`

```motoko no-repl
func fromArrayMut(bytes : [var Nat8]) : Blob
```

Crea un `Blob` a partir de un arreglo mutable de bytes (`[var Nat8]`), copiando
cada elemento.

Ejemplo:

```motoko include=import
let bytes : [var Nat8] = [var 0, 255, 0];
let blob = Blob.fromArrayMut(bytes); // => "\00\FF\00"
```

## Función `toArray`

```motoko no-repl
func toArray(blob : Blob) : [Nat8]
```

Convierte un `Blob` en un arreglo de bytes (`[Nat8]`), copiando cada elemento.

Ejemplo:

```motoko include=import
let blob = "\00\FF\00" : Blob;
let bytes = Blob.toArray(blob); // => [0, 255, 0]
```

## Función `toArrayMut`

```motoko no-repl
func toArrayMut(blob : Blob) : [var Nat8]
```

Convierte un `Blob` en un arreglo mutable de bytes (`[var Nat8]`), copiando cada
elemento.

Ejemplo:

```motoko include=import
let blob = "\00\FF\00" : Blob;
let bytes = Blob.toArrayMut(blob); // => [var 0, 255, 0]
```

## Función `hash`

```motoko no-repl
func hash(blob : Blob) : Nat32
```

Devuelve el hash (no criptográfico) de `blob`.

Ejemplo:

```motoko include=import
let blob = "\00\FF\00" : Blob;
Blob.hash(blob) // => 1_818_567_776
```

## Función `compare`

```motoko no-repl
func compare(b1 : Blob, b2 : Blob) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Blob` comparando el valor de
los bytes. Devuelve el `Order` (ya sea `#less`, `#equal` o `#greater`)
comparando `blob1` con `blob2`.

Ejemplo:

```motoko include=import
let blob1 = "\00\00\00" : Blob;
let blob2 = "\00\FF\00" : Blob;
Blob.compare(blob1, blob2) // => #less
```

## Función `equal`

```motoko no-repl
func equal(blob1 : Blob, blob2 : Blob) : Bool
```

Función de igualdad para tipos `Blob`. Esto es equivalente a `blob1 == blob2`.

Ejemplo:

```motoko include=import
let blob1 = "\00\FF\00" : Blob;
let blob2 = "\00\FF\00" : Blob;
ignore Blob.equal(blob1, blob2);
blob1 == blob2 // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Blob>(3);
let buffer2 = Buffer.Buffer<Blob>(3);
Buffer.equal(buffer1, buffer2, Blob.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(blob1 : Blob, blob2 : Blob) : Bool
```

Función de desigualdad para tipos `Blob`. Esto es equivalente a
`blob1 != blob2`.

Ejemplo:

```motoko include=import
let blob1 = "\00\AA\AA" : Blob;
let blob2 = "\00\FF\00" : Blob;
ignore Blob.notEqual(blob1, blob2);
blob1 != blob2 // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(blob1 : Blob, blob2 : Blob) : Bool
```

Función "menor que" para tipos `Blob`. Esto es equivalente a `blob1 < blob2`.

Ejemplo:

```motoko include=import
let blob1 = "\00\AA\AA" : Blob;
let blob2 = "\00\FF\00" : Blob;
ignore Blob.less(blob1, blob2);
blob1 < blob2 // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(blob1 : Blob, blob2 : Blob) : Bool
```

Función "menor o igual que" para tipos `Blob`. Esto es equivalente a
`blob1 <= blob2`.

Ejemplo:

```motoko include=import
let blob1 = "\00\AA\AA" : Blob;
let blob2 = "\00\FF\00" : Blob;
ignore Blob.lessOrEqual(blob1, blob2);
blob1 <= blob2 // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(blob1 : Blob, blob2 : Blob) : Bool
```

Función "mayor que" para tipos `Blob`. Esto es equivalente a `blob1 > blob2`.

Ejemplo:

```motoko include=import
let blob1 = "\BB\AA\AA" : Blob;
let blob2 = "\00\00\00" : Blob;
ignore Blob.greater(blob1, blob2);
blob1 > blob2 // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(blob1 : Blob, blob2 : Blob) : Bool
```

Función "mayor o igual que" para tipos `Blob`. Esto es equivalente a
`blob1 >= blob2`.

Ejemplo:

```motoko include=import
let blob1 = "\BB\AA\AA" : Blob;
let blob2 = "\00\00\00" : Blob;
ignore Blob.greaterOrEqual(blob1, blob2);
blob1 >= blob2 // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.
