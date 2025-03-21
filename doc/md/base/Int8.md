# Int8

Proporciona funciones de utilidad para enteros con signo de 8 bits.

Tenga en cuenta que la mayoría de las operaciones están disponibles como
operadores integrados (por ejemplo, `1 + 1`).

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Int8 "mo:base/Int8";
```

## Tipo `Int8`

```motoko no-repl
type Int8 = Prim.Types.Int8
```

Enteros con signo de 8 bits.

## Valor `minimumValue`

```motoko no-repl
let minimumValue : Int8
```

Valor mínimo de un entero de 8 bits, `-2 ** 7`.

Ejemplo:

```motoko include=import
Int8.minimumValue // => -128
```

## Valor `maximumValue`

```motoko no-repl
let maximumValue : Int8
```

Valor máximo de un entero de 8 bits, `+2 ** 7 - 1`.

Ejemplo:

```motoko include=import
Int8.maximumValue // => +127
```

## Valor `toInt`

```motoko no-repl
let toInt : Int8 -> Int
```

Convierte un entero con signo de 8 bits a un entero con signo de precisión
infinita.

Ejemplo:

```motoko include=import
Int8.toInt(123) // => 123 : Int
```

## Valor `fromInt`

```motoko no-repl
let fromInt : Int -> Int8
```

Convierte un entero con signo de precisión infinita a un entero con signo de 8
bits.

Genera una Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.fromInt(123) // => +123 : Int8
```

## Valor `fromIntWrap`

```motoko no-repl
let fromIntWrap : Int -> Int8
```

Convierte un entero con signo de precisión infinita a un entero con signo de 8
bits.

Realiza un ciclo en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.fromIntWrap(-123) // => -123 : Int
```

## Valor `fromInt16`

```motoko no-repl
let fromInt16 : Int16 -> Int8
```

Convierte un entero con signo de 16 bits a un entero con signo de 8 bits.

Genera una Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.fromInt16(123) // => +123 : Int8
```

## Valor `toInt16`

```motoko no-repl
let toInt16 : Int8 -> Int16
```

Convierte un entero con signo de 8 bits a un entero con signo de 16 bits.

Ejemplo:

```motoko include=import
Int8.toInt16(123) // => +123 : Int16
```

## Valor `fromNat8`

```motoko no-repl
let fromNat8 : Nat8 -> Int8
```

Convierte un entero sin signo de 8 bits a un entero con signo de 8 bits.

Realiza un ciclo en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.fromNat8(123) // => +123 : Int8
```

## Valor `toNat8`

```motoko no-repl
let toNat8 : Int8 -> Nat8
```

Convierte un entero con signo de 8 bits a un entero sin signo de 8 bits.

Realiza un ciclo en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.toNat8(-1) // => 255 : Nat8 // subdesbordamiento
```

## Función `toText`

```motoko no-repl
func toText(x : Int8) : Text
```

Convierte un número entero a su representación textual.

Ejemplo:

```motoko include=import
Int8.toText(-123) // => "-123"
```

## Función `abs`

```motoko no-repl
func abs(x : Int8) : Int8
```

Devuelve el valor absoluto de `x`.

Genera una Error cuando `x == -2 ** 7` (el valor mínimo de `Int8`).

Ejemplo:

```motoko include=import
Int8.abs(-123) // => +123
```

## Función `min`

```motoko no-repl
func min(x : Int8, y : Int8) : Int8
```

Devuelve el mínimo entre `x` e `y`.

Ejemplo:

```motoko include=import
Int8.min(+2, -3) // => -3
```

## Función `max`

```motoko no-repl
func max(x : Int8, y : Int8) : Int8
```

Devuelve el máximo entre `x` e `y`.

Ejemplo:

```motoko include=import
Int8.max(+2, -3) // => +2
```

## Función `equal`

```motoko no-repl
func equal(x : Int8, y : Int8) : Bool
```

Función de igualdad para tipos `Int8`. Esto es equivalente a `x == y`.

Ejemplo:

```motoko include=import
Int8.equal(-1, -1); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Int8>(1);
buffer1.add(-3);
let buffer2 = Buffer.Buffer<Int8>(1);
buffer2.add(-3);
Buffer.equal(buffer1, buffer2, Int8.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(x : Int8, y : Int8) : Bool
```

Función de desigualdad para tipos `Int8`. Esto es equivalente a `x != y`.

Ejemplo:

```motoko include=import
Int8.notEqual(-1, -2); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(x : Int8, y : Int8) : Bool
```

Función "menor que" para tipos `Int8`. Esto es equivalente a `x < y`.

Ejemplo:

```motoko include=import
Int8.less(-2, 1); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Int8, y : Int8) : Bool
```

Función "menor o igual que" para tipos `Int8`. Esto es equivalente a `x <= y`.

Ejemplo:

```motoko include=import
Int8.lessOrEqual(-2, -2); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(x : Int8, y : Int8) : Bool
```

Función "mayor que" para tipos `Int8`. Esto es equivalente a `x > y`.

Ejemplo:

```motoko include=import
Int8.greater(-2, -3); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Int8, y : Int8) : Bool
```

Función "mayor o igual que" para tipos `Int8`. Esto es equivalente a `x >= y`.

Ejemplo:

```motoko include=import
Int8.greaterOrEqual(-2, -2); // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.

## Función `compare`

```motoko no-repl
func compare(x : Int8, y : Int8) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Int8`. Devuelve el `Order` (ya
sea `#less`, `#equal` o `#greater`) de comparar `x` con `y`.

Ejemplo:

```motoko include=import
Int8.compare(-3, 2) // => #less
```

Esta función se puede usar como valor para una función de orden superior, como
una función de ordenación.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.sort([1, -2, -3] : [Int8], Int8.compare) // => [-3, -2, 1]
```

## Función `neg`

```motoko no-repl
func neg(x : Int8) : Int8
```

Devuelve la negación de `x`, `-x`.

Genera una Error en caso de desbordamiento, es decir, para `neg(-2 ** 7)`.

Ejemplo:

```motoko include=import
Int8.neg(123) // => -123
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

## Función `add`

```motoko no-repl
func add(x : Int8, y : Int8) : Int8
```

Devuelve la suma de `x` e `y`, `x + y`.

Genera una Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.add(100, 23) // => +123
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int8, Int8>([1, -2, -3], 0, Int8.add) // => -4
```

## Función `sub`

```motoko no-repl
func sub(x : Int8, y : Int8) : Int8
```

Devuelve la diferencia de `x` e `y`, `x - y`.

Genera una Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.sub(123, 23) // => +100
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int8, Int8>([1, -2, -3], 0, Int8.sub) // => 4
```

## Función `mul`

```motoko no-repl
func mul(x : Int8, y : Int8) : Int8
```

Devuelve el producto de `x` e `y`, `x * y`.

Error en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.mul(12, 10) // => +120
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Int8, Int8>([1, -2, -3], 1, Int8.mul) // => 6
```

## Función `div`

```motoko no-repl
func div(x : Int8, y : Int8) : Int8
```

Devuelve la división entera con signo de `x` entre `y`, `x / y`. Redondea el
cociente hacia cero, lo cual es lo mismo que truncar los lugares decimales del
cociente.

Error cuando `y` es cero.

Ejemplo:

```motoko include=import
Int8.div(123, 10) // => +12
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `/` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `/` como un valor
de función en este momento.

## Función `rem`

```motoko no-repl
func rem(x : Int8, y : Int8) : Int8
```

Devuelve el resto de la división entera con signo de `x` entre `y`, `x % y`, que
se define como `x - x / y * y`.

Error cuando `y` es cero.

Ejemplo:

```motoko include=import
Int8.rem(123, 10) // => +3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `%` como un valor
de función en este momento.

## Función `pow`

```motoko no-repl
func pow(x : Int8, y : Int8) : Int8
```

Devuelve `x` elevado a la potencia de `y`, `x ** y`.

Error en caso de desbordamiento/subdesbordamiento y cuando `y < 0 o y >= 8`.

Ejemplo:

```motoko include=import
Int8.pow(2, 6) // => +64
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**` como un
valor de función en este momento.

## Función `bitnot`

```motoko no-repl
func bitnot(x : Int8) : Int8
```

Devuelve la negación a nivel de bits de `x`, `^x`.

Ejemplo:

```motoko include=import
Int8.bitnot(-16 /* 0xf0 */) // => +15 // 0x0f
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitand`

```motoko no-repl
func bitand(x : Int8, y : Int8) : Int8
```

Devuelve la operación "y" a nivel de bits de `x` y `y`, `x & y`.

Ejemplo:

```motoko include=import
Int8.bitand(0x1f, 0x70) // => +16 // 0x10
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `&` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `&` como un valor
de función en este momento.

## Función `bitor`

```motoko no-repl
func bitor(x : Int8, y : Int8) : Int8
```

Devuelve la operación "o" a nivel de bits de `x` y `y`, `x | y`.

Ejemplo:

```motoko include=import
Int8.bitor(0x0f, 0x70) // => +127 // 0x7f
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `|` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `|` como un valor
de función en este momento.

## Función `bitxor`

```motoko no-repl
func bitxor(x : Int8, y : Int8) : Int8
```

Devuelve la operación "o exclusivo" a nivel de bits de `x` y `y`, `x ^ y`.

Ejemplo:

```motoko include=import
Int8.bitxor(0x70, 0x7f) // => +15 // 0x0f
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitshiftLeft`

```motoko no-repl
func bitshiftLeft(x : Int8, y : Int8) : Int8
```

Devuelve el desplazamiento a la izquierda a nivel de bits de `x` por `y`,
`x << y`. Los bits de la derecha del desplazamiento se llenan con ceros. Los
bits que desbordan a la izquierda, incluido el bit de signo, se descartan.

Para `y >= 8`, la semántica es la misma que para `bitshiftLeft(x, y % 8)`. Para
`y < 0`, la semántica es la misma que para `bitshiftLeft(x, y + y % 8)`.

Ejemplo:

```motoko include=import
Int8.bitshiftLeft(1, 4) // => +16 // 0x10 equivalente a `2 ** 4`.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<` como un
valor de función en este momento.

## Función `bitshiftRight`

```motoko no-repl
func bitshiftRight(x : Int8, y : Int8) : Int8
```

Devuelve el desplazamiento a la derecha con signo a nivel de bits de `x` por
`y`, `x >> y`. Se conserva el bit de signo y el lado izquierdo se llena con el
bit de signo. Los bits que desbordan a la derecha se descartan, es decir, no se
rotan hacia el lado izquierdo.

Para `y >= 8`, la semántica es la misma que para `bitshiftRight(x, y % 8)`. Para
`y < 0`, la semántica es la misma que para `bitshiftRight (x, y + y % 8)`.

Ejemplo:

```motoko include=import
Int8.bitshiftRight(64, 4) // => +4 // equivalente a `64 / (2 ** 4)`
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>>` como un
valor de función en este momento.

## Función `bitrotLeft`

```motoko no-repl
func bitrotLeft(x : Int8, y : Int8) : Int8
```

Devuelve la rotación a la izquierda a nivel de bits de `x` por `y`, `x <<> y`.
Cada bit que desborda a la izquierda se inserta nuevamente en el lado derecho.
El bit de signo se rota como los demás bits, es decir, la rotación interpreta el
número como sin signo.

Cambia la dirección de rotación para `y` negativo. Para `y >= 8`, la semántica
es la misma que para `bitrotLeft(x, y % 8)`.

Ejemplo:

```motoko include=import
Int8.bitrotLeft(0x11 /* 0b0001_0001 */, 2) // => +68 // 0b0100_0100 == 0x44.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<>` como un
valor de función en este momento.

## Función `bitrotRight`

```motoko no-repl
func bitrotRight(x : Int8, y : Int8) : Int8
```

Devuelve la rotación a la derecha a nivel de bits de `x` por `y`, `x <>> y`.
Cada bit que desborda a la derecha se inserta nuevamente en el lado derecho. El
bit de signo se rota como los demás bits, es decir, la rotación interpreta el
número como sin signo.

Cambia la dirección de rotación para `y` negativo. Para `y >= 8`, la semántica
es la misma que para `bitrotRight(x, y % 8)`.

Ejemplo:

```motoko include=import
Int8.bitrotRight(0x11 /* 0b0001_0001 */, 1) // => -120 // 0b1000_1000 == 0x88.
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<>>` como un
valor de función en este momento.

## Función `bittest`

```motoko no-repl
func bittest(x : Int8, p : Nat) : Bool
```

Devuelve el valor del bit `p` en `x`, `x & 2**p == 2**p`. Si `p >= 8`, la
semántica es la misma que para `bittest(x, p % 8)`. Esto es equivalente a
verificar si el bit `p`-ésimo está establecido en `x`, usando indexación
desde 0.

Ejemplo:

```motoko include=import
Int8.bittest(64, 6) // => true
```

## Función `bitset`

```motoko no-repl
func bitset(x : Int8, p : Nat) : Int8
```

Devuelve el valor de establecer el bit `p` en `x` en `1`. Si `p >= 8`, la
semántica es la misma que para `bitset(x, p % 8)`.

Ejemplo:

```motoko include=import
Int8.bitset(0, 6) // => +64
```

## Función `bitclear`

```motoko no-repl
func bitclear(x : Int8, p : Nat) : Int8
```

Devuelve el valor de borrar el bit `p` en `x` en `0`. Si `p >= 8`, la semántica
es la misma que para `bitclear(x, p % 8)`.

Ejemplo:

```motoko include=import
Int8.bitclear(-1, 6) // => -65
```

## Función `bitflip`

```motoko no-repl
func bitflip(x : Int8, p : Nat) : Int8
```

Devuelve el valor de invertir el bit `p` en `x`. Si `p >= 8`, la semántica es la
misma que para `bitclear(x, p % 8)`.

Ejemplo:

```motoko include=import
Int8.bitflip(127, 6) // => +63
```

## Valor `bitcountNonZero`

```motoko no-repl
let bitcountNonZero : (x : Int8) -> Int8
```

Devuelve la cantidad de bits no cero en `x`.

Ejemplo:

```motoko include=import
Int8.bitcountNonZero(0x0f) // => +4
```

## Valor `bitcountLeadingZero`

```motoko no-repl
let bitcountLeadingZero : (x : Int8) -> Int8
```

Devuelve la cantidad de bits cero principales en `x`.

Ejemplo:

```motoko include=import
Int8.bitcountLeadingZero(0x08) // => +4
```

## Valor `bitcountTrailingZero`

```motoko no-repl
let bitcountTrailingZero : (x : Int8) -> Int8
```

Devuelve la cantidad de bits cero finales en `x`.

Ejemplo:

```motoko include=import
Int8.bitcountTrailingZero(0x10) // => +4
```

## Función `addWrap`

```motoko no-repl
func addWrap(x : Int8, y : Int8) : Int8
```

Devuelve la suma de `x` e `y`, `x +% y`.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.addWrap(2 ** 6, 2 ** 6) // => -128 // desbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+%` como un
valor de función en este momento.

## Función `subWrap`

```motoko no-repl
func subWrap(x : Int8, y : Int8) : Int8
```

Devuelve la diferencia de `x` e `y`, `x -% y`.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.subWrap(-2 ** 7, 1) // => +127 // subdesbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-%` como un
valor de función en este momento.

## Función `mulWrap`

```motoko no-repl
func mulWrap(x : Int8, y : Int8) : Int8
```

Devuelve el producto de `x` e `y`, `x *% y`. Envuelve en caso de desbordamiento.

Envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Int8.mulWrap(2 ** 4, 2 ** 4) // => 0 // desbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*%` como un
valor de función en este momento.

## Función `powWrap`

```motoko no-repl
func powWrap(x : Int8, y : Int8) : Int8
```

Devuelve `x` elevado a la potencia de `y`, `x **% y`.

Envuelve en caso de desbordamiento/subdesbordamiento. Error si `y < 0 o y >= 8`.

Ejemplo:

```motoko include=import
Int8.powWrap(2, 7) // => -128 // desbordamiento
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**%` como un
valor de función en este momento.
