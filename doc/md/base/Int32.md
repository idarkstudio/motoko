# Int32

Proporciona funciones de utilidad en enteros con signo de 32 bits.

Tenga en cuenta que la mayoría de las operaciones están disponibles como
operadores integrados (por ejemplo, `1 + 1`).

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Int32 "mo:base/Int32";
```

## Tipo `Int32`

```motoko no-repl
type Int32 = Prim.Types.Int32
```

Enteros con signo de 32 bits.

## Valor `minimumValue`

```motoko no-repl
let minimumValue : Int32
```

Valor mínimo de entero de 32 bits, `-2 ** 15`.

Ejemplo:

```motoko include=import
Int32.minimumValue // => -32_768 : Int32
```

## Valor `maximumValue`

```motoko no-repl
let maximumValue : Int32
```

Valor máximo de entero de 32 bits, `+2 ** 15 - 1`.

Ejemplo:

```motoko include=import
Int32.maximumValue // => +32_767 : Int32
```

## Function `toInt`

```motoko no-repl
func toInt(_ : Int32) : Int
```

Convierte un entero con signo de 32 bits a un entero con signo de precisión
infinita.

Ejemplo:

```motoko include=import
Int32.toInt(12_345) // => 12_345 : Int
```

## Function `fromInt`

```motoko no-repl
func fromInt(_ : Int) : Int32
```

Convierte un entero con signo de precisión infinita a un entero con signo de 32
bits.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.fromInt(12_345) // => +12_345 : Int32
```

## Function `fromIntWrap`

```motoko no-repl
func fromIntWrap(_ : Int) : Int32
```

Convierte un entero con signo de precisión infinita a un entero con signo de 32
bits.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.fromIntWrap(-12_345) // => -12_345 : Int
```

## Function `fromInt16`

```motoko no-repl
func fromInt16(_ : Int16) : Int32
```

Convierte un entero con signo de 16 bits a un entero con signo de 32 bits.

Ejemplo:

```motoko include=import
Int32.fromInt16(-123) // => -123 : Int32
```

## Function `toInt16`

```motoko no-repl
func toInt16(_ : Int32) : Int16
```

Convierte un entero con signo de 32 bits a un entero con signo de 16 bits.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.toInt16(-123) // => -123 : Int16
```

## Function `fromInt64`

```motoko no-repl
func fromInt64(_ : Int64) : Int32
```

Convierte un entero con signo de 64 bits a un entero con signo de 32 bits.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.fromInt64(-12_345) // => -12_345 : Int32
```

## Function `toInt64`

```motoko no-repl
func toInt64(_ : Int32) : Int64
```

Convierte un entero con signo de 32 bits a un entero con signo de 64 bits.

Ejemplo:

```motoko include=import
Int32.toInt64(-12_345) // => -12_345 : Int64
```

## Function `fromNat32`

```motoko no-repl
func fromNat32(_ : Nat32) : Int32
```

Convierte un entero sin signo de 32 bits a un entero con signo de 32 bits.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.fromNat32(12_345) // => +12_345 : Int32
```

## Function `toNat32`

```motoko no-repl
func toNat32(_ : Int32) : Nat32
```

Convierte un entero con signo de 32 bits a un entero sin signo de 32 bits.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.toNat32(-1) // => 65_535 : Nat32 // desbordamiento
```

## Función `toText`

```motoko no-repl
func toText(x : Int32) : Text
```

Devuelve la representación de Text de `x`. La representación textual _no_
contiene guiones bajos para representar comas.

Ejemplo:

```motoko include=import
Int32.toText(-12345) // => "-12345"
```

## Función `abs`

```motoko no-repl
func abs(x : Int32) : Int32
```

Devuelve el valor absoluto de `x`.

Error cuando `x == -2 ** 15` (el valor mínimo de `Int32`).

Ejemplo:

```motoko include=import
Int32.abs(-12345) // => +12_345
```

## Función `min`

```motoko no-repl
func min(x : Int32, y : Int32) : Int32
```

Devuelve el mínimo entre `x` e `y`.

Ejemplo:

```motoko include=import
Int32.min(+2, -3) // => -3
```

## Función `max`

```motoko no-repl
func max(x : Int32, y : Int32) : Int32
```

Devuelve el máximo entre `x` e `y`.

Ejemplo:

```motoko include=import
Int32.max(+2, -3) // => +2
```

## Función `equal`

```motoko no-repl
func equal(x : Int32, y : Int32) : Bool
```

Función de igualdad para tipos `Int32`. Esto es equivalente a `x == y`.

Ejemplo:

```motoko include=import
Int32.equal(-1, -1); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Int32>(1);
buffer1.add(-3);
let buffer2 = Buffer.Buffer<Int32>(1);
buffer2.add(-3);
Buffer.equal(buffer1, buffer2, Int32.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(x : Int32, y : Int32) : Bool
```

Función de desigualdad para tipos `Int32`. Esto es equivalente a `x != y`.

Ejemplo:

```motoko include=import
Int32.notEqual(-1, -2); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(x : Int32, y : Int32) : Bool
```

Función "menor que" para tipos `Int32`. Esto es equivalente a `x < y`.

Ejemplo:

```motoko include=import
Int32.less(-2, 1); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Int32, y : Int32) : Bool
```

Función "menor o igual que" para tipos `Int32`. Esto es equivalente a `x <= y`.

Ejemplo:

```motoko include=import
Int32.lessOrEqual(-2, -2); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(x : Int32, y : Int32) : Bool
```

Función "mayor que" para tipos `Int32`. Esto es equivalente a `x > y`.

Ejemplo:

```motoko include=import
Int32.greater(-2, 1); // => false
```

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Int32, y : Int32) : Bool
```

Función "mayor o igual que" para tipos `Int32`. Esto es equivalente a `x >= y`.

Ejemplo:

```motoko include=import
Int32.greaterOrEqual(-2, -2); // => true
```

## Función `compare`

```motoko no-repl
func compare(x : Int32, y : Int32) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Int32`. Devuelve el `Order`
(ya sea `#less`, `#equal` o `#greater`) de comparar `x` con `y`.

Ejemplo:

```motoko include=import
Int32.compare(-3, 2) // => #less
```

Esta función se puede utilizar como valor para una función de orden superior,
como una función de ordenación.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.sort([1, -2, -3] : [Int32], Int32.compare) // => [-3, -2, 1]
```

## Función `neg`

```motoko no-repl
func neg(x : Int32) : Int32
```

Devuelve la negación de `x`, `-x`.

Error en caso de desbordamiento, es decir, para `neg(-2 ** 15)`.

Ejemplo:

```motoko include=import
Int32.neg(123) // => -123
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

## Función `add`

```motoko no-repl
func add(x : Int32, y : Int32) : Int32
```

Devuelve la suma de `x` e `y`, `x + y`.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.add(100, 23) // => +123
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int32, Int32>([1, -2, -3], 0, Int32.add) // => -4
```

## Función `sub`

```motoko no-repl
func sub(x : Int32, y : Int32) : Int32
```

Devuelve la diferencia de `x` e `y`, `x - y`.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.sub(123, 100) // => +23
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int32, Int32>([1, -2, -3], 0, Int32.sub) // => 4
```

## Función `mul`

```motoko no-repl
func mul(x : Int32, y : Int32) : Int32
```

Devuelve el producto de `x` e `y`, `x * y`.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.mul(12, 10) // => +120
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int32, Int32>([1, -2, -3], 1, Int32.mul) // => 6
```

## Función `div`

```motoko no-repl
func div(x : Int32, y : Int32) : Int32
```

Devuelve la división entera con signo de `x` entre `y`, `x / y`. Redondea el
cociente hacia cero, lo cual es lo mismo que truncar los lugares decimales del
cociente.

Error cuando `y` es cero.

Ejemplo:

```motoko include=import
Int32.div(123, 10) // => +12
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `/` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `/` como un valor
de función en este momento.

## Función `rem`

```motoko no-repl
func rem(x : Int32, y : Int32) : Int32
```

Devuelve el resto de la división entera con signo de `x` entre `y`, `x % y`, que
se define como `x - x / y * y`.

Error cuando `y` es cero.

Ejemplo:

```motoko include=import
Int32.rem(123, 10) // => +3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `%` como un valor
de función en este momento.

## Función `pow`

```motoko no-repl
func pow(x : Int32, y : Int32) : Int32
```

Devuelve `x` elevado a la potencia de `y`, `x ** y`.

Error en caso de desbordamiento/subdesbordamiento y cuando `y < 0 o y >= 32`.

Ejemplo:

```motoko include=import
Int32.pow(2, 10) // => +1_024
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**` como un
valor de función en este momento.

## Función `bitnot`

```motoko no-repl
func bitnot(x : Int32) : Int32
```

Devuelve la negación a nivel de bits de `x`, `^x`.

Ejemplo:

```motoko include=import
Int32.bitnot(-256 /* 0xff00 */) // => +255 // 0xff
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitand`

```motoko no-repl
func bitand(x : Int32, y : Int32) : Int32
```

Devuelve la operación "y" a nivel de bits de `x` y `y`, `x & y`.

Ejemplo:

```motoko include=import
Int32.bitand(0x0fff, 0x00f0) // => +240 // 0xf0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `&` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `&` como un valor
de función en este momento.

## Función `bitor`

```motoko no-repl
func bitor(x : Int32, y : Int32) : Int32
```

Devuelve la operación "o" a nivel de bits de `x` y `y`, `x | y`.

Ejemplo:

```motoko include=import
Int32.bitor(0x0f0f, 0x00f0) // => +4_095 // 0x0fff
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `|` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `|` como un valor
de función en este momento.

## Función `bitxor`

```motoko no-repl
func bitxor(x : Int32, y : Int32) : Int32
```

Devuelve la operación "o exclusivo" a nivel de bits de `x` y `y`, `x ^ y`.

Ejemplo:

```motoko include=import
Int32.bitxor(0x0fff, 0x00f0) // => +3_855 // 0x0f0f
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitshiftLeft`

```motoko no-repl
func bitshiftLeft(x : Int32, y : Int32) : Int32
```

Devuelve el desplazamiento a la izquierda a nivel de bits de `x` por `y`,
`x << y`. Los bits de la derecha del desplazamiento se llenan con ceros. Los
bits que desbordan a la izquierda, incluido el bit de signo, se descartan.

Para `y >= 32`, la semántica es la misma que para `bitshiftLeft(x, y % 32)`.
Para `y < 0`, la semántica es la misma que para `bitshiftLeft(x, y + y % 32)`.

Ejemplo:

```motoko include=import
Int32.bitshiftLeft(1, 8) // => +256 // 0x100 equivalente a `2 ** 8`.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<` como un
valor de función en este momento.

## Función `bitshiftRight`

```motoko no-repl
func bitshiftRight(x : Int32, y : Int32) : Int32
```

Devuelve el desplazamiento a la derecha con signo a nivel de bits de `x` por
`y`, `x >> y`. Se conserva el bit de signo y el lado izquierdo se llena con el
bit de signo. Los bits que desbordan a la derecha se descartan, es decir, no se
rotan hacia el lado izquierdo.

Para `y >= 32`, la semántica es la misma que para `bitshiftRight(x, y % 32)`.
Para `y < 0`, la semántica es la misma que para `bitshiftRight (x, y + y % 32)`.

Ejemplo:

```motoko include=import
Int32.bitshiftRight(1024, 8) // => +4 // equivalente a `1024 / (2 ** 8)`
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>>` como un
valor de función en este momento.

## Función `bitrotLeft`

```motoko no-repl
func bitrotLeft(x : Int32, y : Int32) : Int32
```

Devuelve la rotación a la izquierda a nivel de bits de `x` por `y`, `x <<> y`.
Cada bit que desborda a la izquierda se inserta nuevamente en el lado derecho.
El bit de signo se rota como otros bits, es decir, la rotación interpreta el
número como sin signo.

Cambia la dirección de rotación para `y` negativo. Para `y >= 32`, la semántica
es la misma que para `bitrotLeft(x, y % 32)`.

Ejemplo:

```motoko include=import
Int32.bitrotLeft(0x2001, 4) // => +18 // 0x12.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<>` como un
valor de función en este momento.

## Función `bitrotRight`

```motoko no-repl
func bitrotRight(x : Int32, y : Int32) : Int32
```

Devuelve la rotación a la derecha a nivel de bits de `x` por `y`, `x <>> y`.
Cada bit que desborda a la derecha se inserta nuevamente en el lado derecho. El
bit de signo se rota como otros bits, es decir, la rotación interpreta el número
como sin signo.

Cambia la dirección de rotación para `y` negativo. Para `y >= 32`, la semántica
es la misma que para `bitrotRight(x, y % 32)`.

Ejemplo:

```motoko include=import
Int32.bitrotRight(0x2010, 8) // => +4_128 // 0x01020.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<>>` como un
valor de función en este momento.

## Función `bittest`

```motoko no-repl
func bittest(x : Int32, p : Nat) : Bool
```

Devuelve el valor del bit `p` en `x`, `x & 2**p == 2**p`. Si `p >= 32`, la
semántica es la misma que para `bittest(x, p % 32)`. Esto es equivalente a
verificar si el bit `p`-ésimo está establecido en `x`, usando indexación 0.

Ejemplo:

```motoko include=import
Int32.bittest(128, 7) // => true
```

## Función `bitset`

```motoko no-repl
func bitset(x : Int32, p : Nat) : Int32
```

Devuelve el valor de establecer el bit `p` en `x` en `1`. Si `p >= 32`, la
semántica es la misma que para `bitset(x, p % 32)`.

Ejemplo:

```motoko include=import
Int32.bitset(0, 7) // => +128
```

## Función `bitclear`

```motoko no-repl
func bitclear(x : Int32, p : Nat) : Int32
```

Devuelve el valor de borrar el bit `p` en `x` en `0`. Si `p >= 32`, la semántica
es la misma que para `bitclear(x, p % 32)`.

Ejemplo:

```motoko include=import
Int32.bitclear(-1, 7) // => -129
```

## Función `bitflip`

```motoko no-repl
func bitflip(x : Int32, p : Nat) : Int32
```

Devuelve el valor de invertir el bit `p` en `x`. Si `p >= 32`, la semántica es
la misma que para `bitclear(x, p % 32)`.

Ejemplo:

```motoko include=import
Int32.bitflip(255, 7) // => +127
```

## Function `bitcountNonZero`

```motoko no-repl
func bitcountNonZero(x : Int32) : Int32
```

Devuelve la cantidad de bits no cero en `x`.

Ejemplo:

```motoko include=import
Int32.bitcountNonZero(0xff) // => +8
```

## Function `bitcountLeadingZero`

```motoko no-repl
func bitcountLeadingZero(x : Int32) : Int32
```

Devuelve la cantidad de bits cero principales en `x`.

Ejemplo:

```motoko include=import
Int32.bitcountLeadingZero(0x80) // => +8
```

## Function `bitcountTrailingZero`

```motoko no-repl
func bitcountTrailingZero(x : Int32) : Int32
```

Devuelve la cantidad de bits cero finales en `x`.

Ejemplo:

```motoko include=import
Int32.bitcountTrailingZero(0x0100) // => +8
```

## Función `addWrap`

```motoko no-repl
func addWrap(x : Int32, y : Int32) : Int32
```

Devuelve la suma de `x` e `y`, `x +% y`.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.addWrap(2 ** 14, 2 ** 14) // => -32_768 // desbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+%` como un
valor de función en este momento.

## Función `subWrap`

```motoko no-repl
func subWrap(x : Int32, y : Int32) : Int32
```

Devuelve la diferencia de `x` e `y`, `x -% y`.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.subWrap(-2 ** 15, 1) // => +32_767 // subdesbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-%` como un
valor de función en este momento.

## Función `mulWrap`

```motoko no-repl
func mulWrap(x : Int32, y : Int32) : Int32
```

Devuelve el producto de `x` e `y`, `x *% y`. Envuelve en caso de desbordamiento.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int32.mulWrap(2 ** 8, 2 ** 8) // => 0 // desbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*%` como un
valor de función en este momento.

## Función `powWrap`

```motoko no-repl
func powWrap(x : Int32, y : Int32) : Int32
```

Devuelve `x` elevado a la potencia de `y`, `x **% y`.

Envuelve en caso de desbordamiento/subdesbordamiento. Error si
`y < 0 o y >= 32`.

Ejemplo:

```motoko include=import

Int32.powWrap(2, 15) // => -32_768 // desbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**%` como un
valor de función en este momento.
