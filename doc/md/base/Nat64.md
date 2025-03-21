# Nat64

Proporciona funciones de utilidad en enteros sin signo de 64 bits.

Tenga en cuenta que la mayoría de las operaciones están disponibles como
operadores integrados (por ejemplo, `1 + 1`).

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Nat64 "mo:base/Nat64";
```

## Tipo `Nat64`

```motoko no-repl
type Nat64 = Prim.Types.Nat64
```

Números naturales de 64 bits.

## Valor `maximumValue`

```motoko no-repl
let maximumValue : Nat64
```

Máximo número natural de 64 bits. `2 ** 64 - 1`.

Ejemplo:

```motoko include=import
Nat64.maximumValue; // => 18446744073709551615 : Nat64
```

## Valor `toNat`

```motoko no-repl
let toNat : Nat64 -> Nat
```

Convierte un entero sin signo de 64 bits a un entero sin signo con precisión
infinita.

Ejemplo:

```motoko include=import
Nat64.toNat(123); // => 123 : Nat
```

## Valor `fromNat`

```motoko no-repl
let fromNat : Nat -> Nat64
```

Convierte un entero sin signo con precisión infinita a un entero sin signo de 64
bits.

Genera un error en caso de desbordamiento.

Ejemplo:

```motoko include=import
Nat64.fromNat(123); // => 123 : Nat64
```

## Función `fromNat32`

```motoko no-repl
func fromNat32(x : Nat32) : Nat64
```

Convierte un entero sin signo de 32 bits a un entero sin signo de 64 bits.

Ejemplo:

```motoko include=import
Nat64.fromNat32(123); // => 123 : Nat64
```

## Función `toNat32`

```motoko no-repl
func toNat32(x : Nat64) : Nat32
```

Convierte un entero sin signo de 64 bits a un entero sin signo de 32 bits.

Genera un error en caso de desbordamiento.

Ejemplo:

```motoko include=import
Nat64.toNat32(123); // => 123 : Nat32
```

## Valor `fromIntWrap`

```motoko no-repl
let fromIntWrap : Int -> Nat64
```

Convierte un entero con signo con precisión infinita a un entero sin signo de 64
bits.

Genera un error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Nat64.fromIntWrap(123); // => 123 : Nat64
```

## Función `toText`

```motoko no-repl
func toText(x : Nat64) : Text
```

Convierte `x` a su representación textual. La representación textual no contiene
guiones bajos para representar comas.

Ejemplo:

```motoko include=import
Nat64.toText(1234); // => "1234" : Text
```

## Función `min`

```motoko no-repl
func min(x : Nat64, y : Nat64) : Nat64
```

Devuelve el mínimo entre `x` e `y`.

Ejemplo:

```motoko include=import
Nat64.min(123, 456); // => 123 : Nat64
```

## Función `max`

```motoko no-repl
func max(x : Nat64, y : Nat64) : Nat64
```

Devuelve el máximo entre `x` e `y`.

Ejemplo:

```motoko include=import
Nat64.max(123, 456); // => 456 : Nat64
```

## Función `equal`

```motoko no-repl
func equal(x : Nat64, y : Nat64) : Bool
```

Función de igualdad para tipos Nat64. Esto es equivalente a `x == y`.

Ejemplo:

```motoko include=import
ignore Nat64.equal(1, 1); // => true
(1 : Nat64) == (1 : Nat64) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Nat64>(3);
let buffer2 = Buffer.Buffer<Nat64>(3);
Buffer.equal(buffer1, buffer2, Nat64.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(x : Nat64, y : Nat64) : Bool
```

Función de desigualdad para tipos Nat64. Esto es equivalente a `x != y`.

Ejemplo:

```motoko include=import
ignore Nat64.notEqual(1, 2); // => true
(1 : Nat64) != (2 : Nat64) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(x : Nat64, y : Nat64) : Bool
```

Función "menor que" para tipos Nat64. Esto es equivalente a `x < y`.

Ejemplo:

```motoko include=import
ignore Nat64.less(1, 2); // => true
(1 : Nat64) < (2 : Nat64) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Nat64, y : Nat64) : Bool
```

Función "menor o igual que" para tipos Nat64. Esto es equivalente a `x <= y`.

Ejemplo:

```motoko include=import
ignore Nat64.lessOrEqual(1, 2); // => true
(1 : Nat64) <= (2 : Nat64) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(x : Nat64, y : Nat64) : Bool
```

Función "mayor que" para tipos Nat64. Esto es equivalente a `x > y`.

Ejemplo:

```motoko include=import
ignore Nat64.greater(2, 1); // => true
(2 : Nat64) > (1 : Nat64) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Nat64, y : Nat64) : Bool
```

Función "mayor o igual que" para tipos Nat64. Esto es equivalente a `x >= y`.

Ejemplo:

```motoko include=import
ignore Nat64.greaterOrEqual(2, 1); // => true
(2 : Nat64) >= (1 : Nat64) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.

## Función `compare`

```motoko no-repl
func compare(x : Nat64, y : Nat64) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Nat64`. Devuelve el `Orden`
(ya sea `#less`, `#equal` o `#greater`) de comparar `x` con `y`.

Ejemplo:

```motoko include=import
Nat64.compare(2, 3) // => #less
```

Esta función se puede utilizar como valor para una función de orden superior,
como una función de ordenación.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.sort([2, 3, 1] : [Nat64], Nat64.compare) // => [1, 2, 3]
```

## Función `add`

```motoko no-repl
func add(x : Nat64, y : Nat64) : Nat64
```

Devuelve la suma de `x` e `y`, `x + y`. Genera un error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat64.add(1, 2); // => 3
(1 : Nat64) + (2 : Nat64) // => 3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat64, Nat64>([2, 3, 1], 0, Nat64.add) // => 6
```

## Función `sub`

```motoko no-repl
func sub(x : Nat64, y : Nat64) : Nat64
```

Devuelve la diferencia de `x` e `y`, `x - y`. Genera un error en caso de
subdesbordamiento.

Ejemplo:

```motoko include=import
ignore Nat64.sub(3, 1); // => 2
(3 : Nat64) - (1 : Nat64) // => 2
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat64, Nat64>([2, 3, 1], 10, Nat64.sub) // => 4
```

## Función `mul`

```motoko no-repl
func mul(x : Nat64, y : Nat64) : Nat64
```

Devuelve el producto de `x` e `y`, `x * y`. Genera un error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat64.mul(2, 3); // => 6
(2 : Nat64) * (3 : Nat64) // => 6
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat64, Nat64>([2, 3, 1], 1, Nat64.mul) // => 6
```

## Función `div`

```motoko no-repl
func div(x : Nat64, y : Nat64) : Nat64
```

Devuelve el cociente de `x` dividido por `y`, `x / y`. Genera un error cuando
`y` es cero.

Ejemplo:

```motoko include=import
ignore Nat64.div(6, 2); // => 3
(6 : Nat64) / (2 : Nat64) // => 3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `/` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `/` como un valor
de función en este momento.

## Función `rem`

```motoko no-repl
func rem(x : Nat64, y : Nat64) : Nat64
```

Devuelve el resto de la división de `x` por `y`, `x % y`. Genera un error cuando
`y` es cero.

Ejemplo:

```motoko include=import
ignore Nat64.rem(6, 4); // => 2
(6 : Nat64) % (4 : Nat64) // => 2
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `%` como un valor
de función en este momento.

## Función `pow`

```motoko no-repl
func pow(x : Nat64, y : Nat64) : Nat64
```

Devuelve `x` elevado a la potencia de `y`, `x ** y`. Genera un error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat64.pow(2, 3); // => 8
(2 : Nat64) ** (3 : Nat64) // => 8
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**` como un
valor de función en este momento.

## Función `bitnot`

```motoko no-repl
func bitnot(x : Nat64) : Nat64
```

Devuelve la negación a nivel de bits de `x`, `^x`.

Ejemplo:

```motoko include=import
ignore Nat64.bitnot(0); // => 18446744073709551615
^(0 : Nat64) // => 18446744073709551615
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitand`

```motoko no-repl
func bitand(x : Nat64, y : Nat64) : Nat64
```

Devuelve la operación de "y" a nivel de bits de `x` y `y`, `x & y`.

Ejemplo:

```motoko include=import
ignore Nat64.bitand(1, 3); // => 1
(1 : Nat64) & (3 : Nat64) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `&` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `&` como un valor
de función en este momento.

## Función `bitor`

```motoko no-repl
func bitor(x : Nat64, y : Nat64) : Nat64
```

Devuelve la operación de "o" a nivel de bits de `x` y `y`, `x | y`.

Ejemplo:

```motoko include=import
ignore Nat64.bitor(1, 3); // => 3
(1 : Nat64) | (3 : Nat64) // => 3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `|` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `|` como un valor
de función en este momento.

## Función `bitxor`

```motoko no-repl
func bitxor(x : Nat64, y : Nat64) : Nat64
```

Devuelve la operación de "o exclusivo" a nivel de bits de `x` y `y`, `x ^ y`.

Ejemplo:

```motoko include=import
ignore Nat64.bitxor(1, 3); // => 2
(1 : Nat64) ^ (3 : Nat64) // => 2
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitshiftLeft`

```motoko no-repl
func bitshiftLeft(x : Nat64, y : Nat64) : Nat64
```

Devuelve el desplazamiento a la izquierda a nivel de bits de `x` por `y`,
`x << y`.

Ejemplo:

```motoko include=import
ignore Nat64.bitshiftLeft(1, 3); // => 8
(1 : Nat64) << (3 : Nat64) // => 8
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<` como un
valor de función en este momento.

## Función `bitshiftRight`

```motoko no-repl
func bitshiftRight(x : Nat64, y : Nat64) : Nat64
```

Devuelve el desplazamiento a la derecha a nivel de bits de `x` por `y`,
`x >> y`.

Ejemplo:

```motoko include=import
ignore Nat64.bitshiftRight(8, 3); // => 1
(8 : Nat64) >> (3 : Nat64) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>>` como un
valor de función en este momento.

## Función `bitrotLeft`

```motoko no-repl
func bitrotLeft(x : Nat64, y : Nat64) : Nat64
```

Devuelve la rotación a la izquierda a nivel de bits de `x` por `y`, `x <<> y`.

Ejemplo:

```motoko include=import
ignore Nat64.bitrotLeft(1, 3); // => 8
(1 : Nat64) <<> (3 : Nat64) // => 8
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<>` como un
valor de función en este momento.

## Función `bitrotRight`

```motoko no-repl
func bitrotRight(x : Nat64, y : Nat64) : Nat64
```

Devuelve la rotación a la derecha a nivel de bits de `x` por `y`, `x <>> y`.

Ejemplo:

```motoko include=import
ignore Nat64.bitrotRight(8, 3); // => 1
(8 : Nat64) <>> (3 : Nat64) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<>>` como un
valor de función en este momento.

## Función `bittest`

```motoko no-repl
func bittest(x : Nat64, p : Nat) : Bool
```

Devuelve el valor del bit `p mod 64` en `x`,
`(x & 2^(p mod 64)) == 2^(p mod 64)`. Esto es equivalente a verificar si el bit
`p` está activado en `x`, utilizando indexación desde 0.

Ejemplo:

```motoko include=import
Nat64.bittest(5, 2); // => true
```

## Función `bitset`

```motoko no-repl
func bitset(x : Nat64, p : Nat) : Nat64
```

Devuelve el valor de establecer el bit `p mod 64` en `x` a `1`.

Ejemplo:

```motoko include=import
Nat64.bitset(5, 1); // => 7
```

## Función `bitclear`

```motoko no-repl
func bitclear(x : Nat64, p : Nat) : Nat64
```

Devuelve el valor de borrar el bit `p mod 64` en `x` a `0`.

Ejemplo:

```motoko include=import
Nat64.bitclear(5, 2); // => 1
```

## Función `bitflip`

```motoko no-repl
func bitflip(x : Nat64, p : Nat) : Nat64
```

Devuelve el valor de invertir el bit `p mod 64` en `x`.

Ejemplo:

```motoko include=import
Nat64.bitflip(5, 2); // => 1
```

## Valor `bitcountNonZero`

```motoko no-repl
let bitcountNonZero : (x : Nat64) -> Nat64
```

Devuelve la cantidad de bits no cero en `x`.

Ejemplo:

```motoko include=import
Nat64.bitcountNonZero(5); // => 2
```

## Valor `bitcountLeadingZero`

```motoko no-repl
let bitcountLeadingZero : (x : Nat64) -> Nat64
```

Devuelve la cantidad de bits cero principales en `x`.

Ejemplo:

```motoko include=import
Nat64.bitcountLeadingZero(5); // => 61
```

## Valor `bitcountTrailingZero`

```motoko no-repl
let bitcountTrailingZero : (x : Nat64) -> Nat64
```

Devuelve la cantidad de bits cero finales en `x`.

Ejemplo:

```motoko include=import
Nat64.bitcountTrailingZero(16); // => 4
```

## Función `addWrap`

```motoko no-repl
func addWrap(x : Nat64, y : Nat64) : Nat64
```

Devuelve la suma de `x` y `y`, `x +% y`. Se envuelve en caso de desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat64.addWrap(Nat64.maximumValue, 1); // => 0
Nat64.maximumValue +% (1 : Nat64) // => 0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+%` como un
valor de función en este momento.

## Función `subWrap`

```motoko no-repl
func subWrap(x : Nat64, y : Nat64) : Nat64
```

Devuelve la diferencia de `x` y `y`, `x -% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat64.subWrap(0, 1); // => 18446744073709551615
(0 : Nat64) -% (1 : Nat64) // => 18446744073709551615
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-%` como un
valor de función en este momento.

## Función `mulWrap`

```motoko no-repl
func mulWrap(x : Nat64, y : Nat64) : Nat64
```

Devuelve el producto de `x` y `y`, `x *% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat64.mulWrap(4294967296, 4294967296); // => 0
(4294967296 : Nat64) *% (4294967296 : Nat64) // => 0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*%` como un
valor de función en este momento.

## Función `powWrap`

```motoko no-repl
func powWrap(x : Nat64, y : Nat64) : Nat64
```

Devuelve `x` elevado a la potencia de `y`, `x **% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat64.powWrap(2, 64); // => 0
(2 : Nat64) **% (64 : Nat64) // => 0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**%` como un
valor de función en este momento.
