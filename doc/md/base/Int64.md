# Int64

Proporciona funciones de utilidad en enteros con signo de 64 bits.

Tenga en cuenta que la mayoría de las operaciones están disponibles como
operadores integrados (por ejemplo, `1 + 1`).

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Int64 "mo:base/Int64";
```

## Tipo `Int64`

```motoko no-repl
type Int64 = Prim.Types.Int64
```

Enteros con signo de 64 bits.

## Valor `minimumValue`

```motoko no-repl
let minimumValue : Int64
```

Valor mínimo de entero de 64 bits, `-2 ** 63`.

Ejemplo:

```motoko include=import
Int64.minimumValue // => -9_223_372_036_854_775_808
```

## Valor `maximumValue`

```motoko no-repl
let maximumValue : Int64
```

Valor máximo de entero de 64 bits, `+2 ** 63 - 1`.

Ejemplo:

```motoko include=import
Int64.maximumValue // => +9_223_372_036_854_775_807
```

## Function `toInt`

```motoko no-repl
func toInt(_ : Int64) : Int
```

Convierte un entero con signo de 64 bits a un entero con signo de precisión
infinita.

Ejemplo:

```motoko include=import
Int64.toInt(123_456) // => 123_456 : Int
```

## Function `fromInt`

```motoko no-repl
func fromInt(_ : Int) : Int64
```

Convierte un entero con signo de precisión infinita a un entero con signo de 64
bits.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.fromInt(123_456) // => +123_456 : Int64
```

## Function `fromInt32`

```motoko no-repl
func fromInt32(_ : Int32) : Int64
```

Convierte un entero con signo de 32 bits a un entero con signo de 64 bits.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.fromInt32(-123_456) // => -123_456 : Int64
```

## Function `toInt32`

```motoko no-repl
func toInt32(_ : Int64) : Int32
```

Convierte un entero con signo de 64 bits a un entero con signo de 32 bits.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.toInt32(-123_456) // => -123_456 : Int32
```

## Function `fromIntWrap`

```motoko no-repl
func fromIntWrap(_ : Int) : Int64
```

Convierte un entero con signo de precisión infinita a un entero con signo de 64
bits.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.fromIntWrap(-123_456) // => -123_456 : Int64
```

## Function `fromNat64`

```motoko no-repl
func fromNat64(_ : Nat64) : Int64
```

Convierte un entero sin signo de 64 bits a un entero con signo de 64 bits.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.fromNat64(123_456) // => +123_456 : Int64
```

## Function `toNat64`

```motoko no-repl
func toNat64(_ : Int64) : Nat64
```

Convierte un entero con signo de 64 bits a un entero sin signo de 64 bits.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.toNat64(-1) // => 18_446_744_073_709_551_615 : Nat64 // underflow
```

## Función `toText`

```motoko no-repl
func toText(x : Int64) : Text
```

Devuelve la representación de Text de `x`. La representación textual _no_
contiene guiones bajos para representar comas.

Ejemplo:

```motoko include=import
Int64.toText(-123456) // => "-123456"
```

## Función `abs`

```motoko no-repl
func abs(x : Int64) : Int64
```

Devuelve el valor absoluto de `x`.

Error cuando `x == -2 ** 63` (el valor mínimo de `Int64`).

Ejemplo:

```motoko include=import
Int64.abs(-123456) // => +123_456
```

## Función `min`

```motoko no-repl
func min(x : Int64, y : Int64) : Int64
```

Devuelve el mínimo entre `x` e `y`.

Ejemplo:

```motoko include=import
Int64.min(+2, -3) // => -3
```

## Función `max`

```motoko no-repl
func max(x : Int64, y : Int64) : Int64
```

Devuelve el máximo entre `x` e `y`.

Ejemplo:

```motoko include=import
Int64.max(+2, -3) // => +2
```

## Función `equal`

```motoko no-repl
func equal(x : Int64, y : Int64) : Bool
```

Función de igualdad para tipos `Int64`. Esto es equivalente a `x == y`.

Ejemplo:

```motoko include=import
Int64.equal(-1, -1); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Int64>(1);
buffer1.add(-3);
let buffer2 = Buffer.Buffer<Int64>(1);
buffer2.add(-3);
Buffer.equal(buffer1, buffer2, Int64.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(x : Int64, y : Int64) : Bool
```

Función de desigualdad para tipos `Int64`. Esto es equivalente a `x != y`.

Ejemplo:

```motoko include=import
Int64.notEqual(-1, -2); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(x : Int64, y : Int64) : Bool
```

Función "menor que" para tipos `Int64`. Esto es equivalente a `x < y`.

Ejemplo:

```motoko include=import
Int64.less(-2, 1); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Int64, y : Int64) : Bool
```

Función "menor o igual que" para tipos `Int64`. Esto es equivalente a `x <= y`.

Ejemplo:

```motoko include=import
Int64.lessOrEqual(-2, -2); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(x : Int64, y : Int64) : Bool
```

Función "mayor que" para tipos `Int64`. Esto es equivalente a `x > y`.

Ejemplo:

```motoko include=import
Int64.greater(-2, -3); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Int64, y : Int64) : Bool
```

Función "mayor o igual que" para tipos `Int64`. Esto es equivalente a `x >= y`.

Ejemplo:

```motoko include=import
Int64.greaterOrEqual(-2, -2); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.

## Función `compare`

```motoko no-repl
func compare(x : Int64, y : Int64) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Int64`. Devuelve el `Order`
(ya sea `#less`, `#equal` o `#greater`) de comparar `x` con `y`.

Ejemplo:

```motoko include=import
Int64.compare(-3, 2) // => #less
```

Esta función se puede utilizar como valor para una función de orden superior,
como una función de ordenación.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.sort([1, -2, -3] : [Int64], Int64.compare) // => [-3, -2, 1]
```

## Función `neg`

```motoko no-repl
func neg(x : Int64) : Int64
```

Devuelve la negación de `x`, `-x`.

Error en caso de desbordamiento, es decir, para `neg(-2 ** 63)`.

Ejemplo:

```motoko include=import
Int64.neg(123) // => -123
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

## Función `add`

```motoko no-repl
func add(x : Int64, y : Int64) : Int64
```

Devuelve la suma de `x` e `y`, `x + y`.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.add(1234, 123) // => +1_357
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int64, Int64>([1, -2, -3], 0, Int64.add) // => -4
```

## Función `sub`

```motoko no-repl
func sub(x : Int64, y : Int64) : Int64
```

Devuelve la diferencia de `x` e `y`, `x - y`.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.sub(123, 100) // => +23
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int64, Int64>([1, -2, -3], 0, Int64.sub) // => 4
```

## Función `mul`

```motoko no-repl
func mul(x : Int64, y : Int64) : Int64
```

Devuelve el producto de `x` e `y`, `x * y`.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.mul(123, 10) // => +1_230
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int64, Int64>([1, -2, -3], 1, Int64.mul) // => 6
```

## Función `div`

```motoko no-repl
func div(x : Int64, y : Int64) : Int64
```

Devuelve la división entera con signo de `x` entre `y`, `x / y`. Redondea el
cociente hacia cero, lo cual es lo mismo que truncar los lugares decimales del
cociente.

Error cuando `y` es cero.

Ejemplo:

```motoko include=import
Int64.div(123, 10) // => +12
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `/` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `/` como un valor
de función en este momento.

## Función `rem`

```motoko no-repl
func rem(x : Int64, y : Int64) : Int64
```

Devuelve el resto de la división entera con signo de `x` entre `y`, `x % y`, que
se define como `x - x / y * y`.

Error cuando `y` es cero.

Ejemplo:

```motoko include=import
Int64.rem(123, 10) // => +3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `%` como un valor
de función en este momento.

## Función `pow`

```motoko no-repl
func pow(x : Int64, y : Int64) : Int64
```

Devuelve `x` elevado a la potencia de `y`, `x ** y`.

Error en caso de desbordamiento/subdesbordamiento y cuando `y < 0 o y >= 64`.

Ejemplo:

```motoko include=import
Int64.pow(2, 10) // => +1_024
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**` como un
valor de función en este momento.

## Función `bitnot`

```motoko no-repl
func bitnot(x : Int64) : Int64
```

Devuelve la negación a nivel de bits de `x`, `^x`.

Ejemplo:

```motoko include=import
Int64.bitnot(-256 /* 0xffff_ffff_ffff_ff00 */) // => +255 // 0xff
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitand`

```motoko no-repl
func bitand(x : Int64, y : Int64) : Int64
```

Devuelve la operación "y" a nivel de bits de `x` y `y`, `x & y`.

Ejemplo:

```motoko include=import
Int64.bitand(0xffff, 0x00f0) // => +240 // 0xf0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `&` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `&` como un valor
de función en este momento.

## Función `bitor`

```motoko no-repl
func bitor(x : Int64, y : Int64) : Int64
```

Devuelve la operación "o" a nivel de bits de `x` y `y`, `x | y`.

Ejemplo:

```motoko include=import
Int64.bitor(0xffff, 0x00f0) // => +65_535 // 0xffff
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `|` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `|` como un valor
de función en este momento.

## Función `bitxor`

```motoko no-repl
func bitxor(x : Int64, y : Int64) : Int64
```

Devuelve la operación "o exclusivo" a nivel de bits de `x` y `y`, `x ^ y`.

Ejemplo:

```motoko include=import
Int64.bitxor(0xffff, 0x00f0) // => +65_295 // 0xff0f
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitshiftLeft`

```motoko no-repl
func bitshiftLeft(x : Int64, y : Int64) : Int64
```

Devuelve el desplazamiento a la izquierda a nivel de bits de `x` por `y`,
`x << y`. Los bits de la derecha del desplazamiento se llenan con ceros. Los
bits que desbordan a la izquierda, incluido el bit de signo, se descartan.

Para `y >= 64`, la semántica es la misma que para `bitshiftLeft(x, y % 64)`.
Para `y < 0`, la semántica es la misma que para `bitshiftLeft(x, y + y % 64)`.

Ejemplo:

```motoko include=import
Int64.bitshiftLeft(1, 8) // => +256 // 0x100 equivalente a `2 ** 8`.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<` como un
valor de función en este momento.

## Función `bitshiftRight`

```motoko no-repl
func bitshiftRight(x : Int64, y : Int64) : Int64
```

Devuelve el desplazamiento a la derecha con signo a nivel de bits de `x` por
`y`, `x >> y`. Se conserva el bit de signo y el lado izquierdo se llena con el
bit de signo. Los bits que desbordan a la derecha se descartan, es decir, no se
rotan hacia el lado izquierdo.

Para `y >= 64`, la semántica es la misma que para `bitshiftRight(x, y % 64)`.
Para `y < 0`, la semántica es la misma que para `bitshiftRight (x, y + y % 64)`.

Ejemplo:

```motoko include=import
Int64.bitshiftRight(1024, 8) // => +4 // equivalente a `1024 / (2 ** 8)`
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>>` como un
valor de función en este momento.

## Función `bitrotLeft`

```motoko no-repl
func bitrotLeft(x : Int64, y : Int64) : Int64
```

Devuelve la rotación a la izquierda a nivel de bits de `x` por `y`, `x <<> y`.
Cada bit que desborda a la izquierda se inserta nuevamente en el lado derecho.
El bit de signo se rota como otros bits, es decir, la rotación interpreta el
número como sin signo.

Cambia la dirección de rotación para `y` negativo. Para `y >= 64`, la semántica
es la misma que para `bitrotLeft(x, y % 64)`.

Ejemplo:

```motoko include=import

Int64.bitrotLeft(0x2000_0000_0000_0001, 4) // => +18 // 0x12.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<>` como un
valor de función en este momento.

## Función `bitrotRight`

```motoko no-repl
func bitrotRight(x : Int64, y : Int64) : Int64
```

Devuelve la rotación a la derecha a nivel de bits de `x` por `y`, `x <>> y`.
Cada bit que desborda a la derecha se inserta nuevamente en el lado derecho. El
bit de signo se rota como otros bits, es decir, la rotación interpreta el número
como sin signo.

Cambia la dirección de rotación para `y` negativo. Para `y >= 64`, la semántica
es la misma que para `bitrotRight(x, y % 64)`.

Ejemplo:

```motoko include=import
Int64.bitrotRight(0x0002_0000_0000_0001, 48) // => +65538 // 0x1_0002.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<>>` como un
valor de función en este momento.

## Función `bittest`

```motoko no-repl
func bittest(x : Int64, p : Nat) : Bool
```

Devuelve el valor del bit `p` en `x`, `x & 2**p == 2**p`. Si `p >= 64`, la
semántica es la misma que para `bittest(x, p % 64)`. Esto es equivalente a
verificar si el bit `p` está establecido en `x`, usando indexación desde 0.

Ejemplo:

```motoko include=import
Int64.bittest(128, 7) // => true
```

## Función `bitset`

```motoko no-repl
func bitset(x : Int64, p : Nat) : Int64
```

Devuelve el valor de establecer el bit `p` en `x` en `1`. Si `p >= 64`, la
semántica es la misma que para `bitset(x, p % 64)`.

Ejemplo:

```motoko include=import
Int64.bitset(0, 7) // => +128
```

## Función `bitclear`

```motoko no-repl
func bitclear(x : Int64, p : Nat) : Int64
```

Devuelve el valor de borrar el bit `p` en `x` en `0`. Si `p >= 64`, la semántica
es la misma que para `bitclear(x, p % 64)`.

Ejemplo:

```motoko include=import
Int64.bitclear(-1, 7) // => -129
```

## Función `bitflip`

```motoko no-repl
func bitflip(x : Int64, p : Nat) : Int64
```

Devuelve el valor de invertir el bit `p` en `x`. Si `p >= 64`, la semántica es
la misma que para `bitclear(x, p % 64)`.

Ejemplo:

```motoko include=import
Int64.bitflip(255, 7) // => +127
```

## Function `bitcountNonZero`

```motoko no-repl
func bitcountNonZero(x : Int64) : Int64
```

Devuelve la cantidad de bits no cero en `x`.

Ejemplo:

```motoko include=import
Int64.bitcountNonZero(0xffff) // => +16
```

## Function `bitcountLeadingZero`

```motoko no-repl
func bitcountLeadingZero(x : Int64) : Int64
```

Devuelve la cantidad de bits cero principales en `x`.

Ejemplo:

```motoko include=import
Int64.bitcountLeadingZero(0x8000_0000) // => +32
```

## Function `bitcountTrailingZero`

```motoko no-repl
func bitcountTrailingZero(x : Int64) : Int64
```

Devuelve la cantidad de bits cero finales en `x`.

Ejemplo:

```motoko include=import
Int64.bitcountTrailingZero(0x0201_0000) // => +16
```

## Función `addWrap`

```motoko no-repl
func addWrap(x : Int64, y : Int64) : Int64
```

Devuelve la suma de `x` e `y`, `x +% y`.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.addWrap(2 ** 62, 2 ** 62) // => -9_223_372_036_854_775_808 // desbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+%` como un
valor de función en este momento.

## Función `subWrap`

```motoko no-repl
func subWrap(x : Int64, y : Int64) : Int64
```

Devuelve la diferencia de `x` e `y`, `x -% y`.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.subWrap(-2 ** 63, 1) // => +9_223_372_036_854_775_807 // underflow
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-%` como un
valor de función en este momento.

## Función `mulWrap`

```motoko no-repl
func mulWrap(x : Int64, y : Int64) : Int64
```

Devuelve el producto de `x` e `y`, `x *% y`. Envuelve en caso de desbordamiento.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int64.mulWrap(2 ** 32, 2 ** 32) // => 0 // overflow
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*%` como un
valor de función en este momento.

## Función `powWrap`

```motoko no-repl
func powWrap(x : Int64, y : Int64) : Int64
```

Devuelve `x` elevado a la potencia de `y`, `x **% y`.

Envuelve en caso de desbordamiento/subdesbordamiento. Error si
`y < 0 o y >= 64`.

Ejemplo:

```motoko include=import
Int64.powWrap(2, 63) // => -9_223_372_036_854_775_808 // overflow
```

Note: The reason why this function is defined in this library (in addition to
the existing `+%` operator) is so that you can use it as a function value to
pass to a higher order function. It is not possible to use `+%` as a function
value at the moment.
