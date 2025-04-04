# Nat8

Proporciona funciones de utilidad para enteros sin signo de 8 bits.

Tenga en cuenta que la mayoría de las operaciones están disponibles como
operadores integrados (por ejemplo, `1 + 1`).

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Nat8 "mo:base/Nat8";
```

## Tipo `Nat8`

```motoko no-repl
type Nat8 = Prim.Types.Nat8
```

Números naturales de 8 bits.

## Valor `maximumValue`

```motoko no-repl
let maximumValue : Nat8
```

Máximo número natural de 8 bits. `2 ** 8 - 1`.

Ejemplo:

```motoko include=import
Nat8.maximumValue; // => 255 : Nat8
```

## Function `toNat`

```motoko no-repl
func toNat(_ : Nat8) : Nat
```

Convierte un entero sin signo de 8 bits en un entero sin signo con precisión
infinita.

Ejemplo:

```motoko include=import
Nat8.toNat(123); // => 123 : Nat
```

## Function `fromNat`

```motoko no-repl
func fromNat(_ : Nat) : Nat8
```

Convierte un entero sin signo con precisión infinita en un entero sin signo de 8
bits.

Genera un error en caso de desbordamiento.

Ejemplo:

```motoko include=import
Nat8.fromNat(123); // => 123 : Nat8
```

## Function `fromNat16`

```motoko no-repl
func fromNat16(_ : Nat16) : Nat8
```

Convierte un entero sin signo de 16 bits en un entero sin signo de 8 bits.

Genera un error en caso de desbordamiento.

Ejemplo:

```motoko include=import
Nat8.fromNat16(123); // => 123 : Nat8
```

## Function `toNat16`

```motoko no-repl
func toNat16(_ : Nat8) : Nat16
```

Convierte un entero sin signo de 8 bits en un entero sin signo de 16 bits.

Ejemplo:

```motoko include=import
Nat8.toNat16(123); // => 123 : Nat16
```

## Function `fromIntWrap`

```motoko no-repl
func fromIntWrap(_ : Int) : Nat8
```

Convierte un entero con signo con precisión infinita en un entero sin signo de 8
bits.

Realiza un ciclo en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Nat8.fromIntWrap(123); // => 123 : Nat8
```

## Función `toText`

```motoko no-repl
func toText(x : Nat8) : Text
```

Convierte `x` en su representación textual.

Ejemplo:

```motoko include=import
Nat8.toText(123); // => "123" : Text
```

## Función `min`

```motoko no-repl
func min(x : Nat8, y : Nat8) : Nat8
```

Devuelve el mínimo entre `x` e `y`.

Ejemplo:

```motoko include=import
Nat8.min(123, 200); // => 123 : Nat8
```

## Función `max`

```motoko no-repl
func max(x : Nat8, y : Nat8) : Nat8
```

Devuelve el máximo entre `x` e `y`.

Ejemplo:

```motoko include=import
Nat8.max(123, 200); // => 200 : Nat8
```

## Función `equal`

```motoko no-repl
func equal(x : Nat8, y : Nat8) : Bool
```

Función de igualdad para tipos Nat8. Esto es equivalente a `x == y`.

Ejemplo:

```motoko include=import
ignore Nat8.equal(1, 1); // => true
(1 : Nat8) == (1 : Nat8) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Nat8>(3);
let buffer2 = Buffer.Buffer<Nat8>(3);
Buffer.equal(buffer1, buffer2, Nat8.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(x : Nat8, y : Nat8) : Bool
```

Función de desigualdad para tipos Nat8. Esto es equivalente a `x != y`.

Ejemplo:

```motoko include=import
ignore Nat8.notEqual(1, 2); // => true
(1 : Nat8) != (2 : Nat8) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(x : Nat8, y : Nat8) : Bool
```

Función "menor que" para tipos Nat8. Esto es equivalente a `x < y`.

Ejemplo:

```motoko include=import
ignore Nat8.less(1, 2); // => true
(1 : Nat8) < (2 : Nat8) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Nat8, y : Nat8) : Bool
```

Función "menor o igual que" para tipos Nat8. Esto es equivalente a `x <= y`.

Ejemplo:

```motoko include=import
ignore Nat.lessOrEqual(1, 2); // => true
1 <= 2 // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(x : Nat8, y : Nat8) : Bool
```

Función "mayor que" para tipos Nat8. Esto es equivalente a `x > y`.

Ejemplo:

```motoko include=import
ignore Nat8.greater(2, 1); // => true
(2 : Nat8) > (1 : Nat8) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Nat8, y : Nat8) : Bool
```

Función "mayor o igual que" para tipos Nat8. Esto es equivalente a `x >= y`.

Ejemplo:

```motoko include=import
ignore Nat8.greaterOrEqual(2, 1); // => true
(2 : Nat8) >= (1 : Nat8) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.

## Función `compare`

```motoko no-repl
func compare(x : Nat8, y : Nat8) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Nat8`. Devuelve el `Orden` (ya
sea `#less`, `#equal` o `#greater`) de comparar `x` con `y`.

Ejemplo:

```motoko include=import
Nat8.compare(2, 3) // => #less
```

Esta función se puede utilizar como valor para una función de orden superior,
como una función de ordenación.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.sort([2, 3, 1] : [Nat8], Nat8.compare) // => [1, 2, 3]
```

## Función `add`

```motoko no-repl
func add(x : Nat8, y : Nat8) : Nat8
```

Devuelve la suma de `x` e `y`, `x + y`. Genera un error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat8.add(1, 2); // => 3
(1 : Nat8) + (2 : Nat8) // => 3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat8, Nat8>([2, 3, 1], 0, Nat8.add) // => 6
```

## Función `sub`

```motoko no-repl
func sub(x : Nat8, y : Nat8) : Nat8
```

Devuelve la diferencia de `x` e `y`, `x - y`. Genera un error en caso de
subdesbordamiento.

Ejemplo:

```motoko include=import
ignore Nat8.sub(2, 1); // => 1
(2 : Nat8) - (1 : Nat8) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat8, Nat8>([2, 3, 1], 20, Nat8.sub) // => 14
```

## Función `mul`

```motoko no-repl
func mul(x : Nat8, y : Nat8) : Nat8
```

Devuelve el producto de `x` e `y`, `x * y`. Genera un error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat8.mul(2, 3); // => 6
(2 : Nat8) * (3 : Nat8) // => 6
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat8, Nat8>([2, 3, 1], 1, Nat8.mul) // => 6
```

## Función `div`

```motoko no-repl
func div(x : Nat8, y : Nat8) : Nat8
```

Devuelve el cociente de `x` dividido por `y`, `x / y`. Genera un error cuando
`y` es cero.

Ejemplo:

```motoko include=import
ignore Nat8.div(6, 2); // => 3
(6 : Nat8) / (2 : Nat8) // => 3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `/` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `/` como un valor
de función en este momento.

## Función `rem`

```motoko no-repl
func rem(x : Nat8, y : Nat8) : Nat8
```

Devuelve el resto de la división de `x` por `y`, `x % y`. Genera un error cuando
`y` es cero.

Ejemplo:

```motoko include=import
ignore Nat8.rem(6, 4); // => 2
(6 : Nat8) % (4 : Nat8) // => 2
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `%` como un valor
de función en este momento.

## Función `pow`

```motoko no-repl
func pow(x : Nat8, y : Nat8) : Nat8
```

Devuelve `x` elevado a la potencia de `y`, `x ** y`. Genera un error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat8.pow(2, 3); // => 8
(2 : Nat8) ** (3 : Nat8) // => 8
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**` como un
valor de función en este momento.

## Función `bitnot`

```motoko no-repl
func bitnot(x : Nat8) : Nat8
```

Devuelve la negación a nivel de bits de `x`, `^x`.

Ejemplo:

```motoko include=import
ignore Nat8.bitnot(0); // => 255
^(0 : Nat8) // => 255
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitand`

```motoko no-repl
func bitand(x : Nat8, y : Nat8) : Nat8
```

Devuelve el resultado de la operación bitwise and de `x` y `y`, `x & y`.

Ejemplo:

```motoko include=import
ignore Nat8.bitand(3, 2); // => 2
(3 : Nat8) & (2 : Nat8) // => 2
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `&` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `&` como un valor
de función en este momento.

## Función `bitor`

```motoko no-repl
func bitor(x : Nat8, y : Nat8) : Nat8
```

Devuelve el resultado de la operación bitwise or de `x` y `y`, `x | y`.

Ejemplo:

```motoko include=import
ignore Nat8.bitor(3, 2); // => 3
(3 : Nat8) | (2 : Nat8) // => 3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `|` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `|` como un valor
de función en este momento.

## Función `bitxor`

```motoko no-repl
func bitxor(x : Nat8, y : Nat8) : Nat8
```

Devuelve el resultado de la operación bitwise exclusive or de `x` y `y`,
`x ^ y`.

Ejemplo:

```motoko include=import
ignore Nat8.bitxor(3, 2); // => 1
(3 : Nat8) ^ (2 : Nat8) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitshiftLeft`

```motoko no-repl
func bitshiftLeft(x : Nat8, y : Nat8) : Nat8
```

Devuelve el resultado de desplazar `x` a la izquierda `y` veces, `x << y`.

Ejemplo:

```motoko include=import
ignore Nat8.bitshiftLeft(1, 2); // => 4
(1 : Nat8) << (2 : Nat8) // => 4
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<` como un
valor de función en este momento.

## Función `bitshiftRight`

```motoko no-repl
func bitshiftRight(x : Nat8, y : Nat8) : Nat8
```

Devuelve el resultado de desplazar `x` a la derecha `y` veces, `x >> y`.

Ejemplo:

```motoko include=import
ignore Nat8.bitshiftRight(4, 2); // => 1
(4 : Nat8) >> (2 : Nat8) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>>` como un
valor de función en este momento.

## Función `bitrotLeft`

```motoko no-repl
func bitrotLeft(x : Nat8, y : Nat8) : Nat8
```

Devuelve el resultado de rotar `x` a la izquierda `y` veces, `x <<> y`.

Ejemplo:

```motoko include=import
ignore Nat8.bitrotLeft(128, 1); // => 1
(128 : Nat8) <<> (1 : Nat8) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<>` como un
valor de función en este momento.

## Función `bitrotRight`

```motoko no-repl
func bitrotRight(x : Nat8, y : Nat8) : Nat8
```

Devuelve el resultado de rotar `x` a la derecha `y` veces, `x <>> y`.

Ejemplo:

```motoko include=import
ignore Nat8.bitrotRight(1, 1); // => 128
(1 : Nat8) <>> (1 : Nat8) // => 128
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<>>` como un
valor de función en este momento.

## Función `bittest`

```motoko no-repl
func bittest(x : Nat8, p : Nat) : Bool
```

Devuelve el valor del bit `p mod 8` en `x`, `(x & 2^(p mod 8)) == 2^(p mod 8)`.
Esto es equivalente a verificar si el bit `p` está activado en `x`, utilizando
indexación desde 0.

Ejemplo:

```motoko include=import
Nat8.bittest(5, 2); // => true
```

## Función `bitset`

```motoko no-repl
func bitset(x : Nat8, p : Nat) : Nat8
```

Devuelve el valor de establecer el bit `p mod 8` en `x` a `1`.

Ejemplo:

```motoko include=import
Nat8.bitset(5, 1); // => 7
```

## Función `bitclear`

```motoko no-repl
func bitclear(x : Nat8, p : Nat) : Nat8
```

Devuelve el valor de limpiar el bit `p mod 8` en `x` a `0`.

Ejemplo:

```motoko include=import
Nat8.bitclear(5, 2); // => 1
```

## Función `bitflip`

```motoko no-repl
func bitflip(x : Nat8, p : Nat) : Nat8
```

Devuelve el valor de invertir el bit `p mod 8` en `x`.

Ejemplo:

```motoko include=import
Nat8.bitflip(5, 2); // => 1
```

## Function `bitcountNonZero`

```motoko no-repl
func bitcountNonZero(x : Nat8) : Nat8
```

Devuelve la cantidad de bits no cero en `x`.

Ejemplo:

```motoko include=import
Nat8.bitcountNonZero(5); // => 2
```

## Function `bitcountLeadingZero`

```motoko no-repl
func bitcountLeadingZero(x : Nat8) : Nat8
```

Devuelve la cantidad de bits cero principales en `x`.

Ejemplo:

```motoko include=import
Nat8.bitcountLeadingZero(5); // => 5
```

## Function `bitcountTrailingZero`

```motoko no-repl
func bitcountTrailingZero(x : Nat8) : Nat8
```

Devuelve la cantidad de bits cero finales en `x`.

Ejemplo:

```motoko include=import
Nat8.bitcountTrailingZero(6); // => 1
```

## Función `addWrap`

```motoko no-repl
func addWrap(x : Nat8, y : Nat8) : Nat8
```

Devuelve la suma de `x` y `y`, `x +% y`. Se envuelve en caso de desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat8.addWrap(230, 26); // => 0
(230 : Nat8) +% (26 : Nat8) // => 0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+%` como un
valor de función en este momento.

## Función `subWrap`

```motoko no-repl
func subWrap(x : Nat8, y : Nat8) : Nat8
```

Devuelve la diferencia de `x` y `y`, `x -% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat8.subWrap(0, 1); // => 255
(0 : Nat8) -% (1 : Nat8) // => 255
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-%` como un
valor de función en este momento.

## Función `mulWrap`

```motoko no-repl
func mulWrap(x : Nat8, y : Nat8) : Nat8
```

Devuelve el producto de `x` y `y`, `x *% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat8.mulWrap(230, 26); // => 92
(230 : Nat8) *% (26 : Nat8) // => 92
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*%` como un
valor de función en este momento.

## Función `powWrap`

```motoko no-repl
func powWrap(x : Nat8, y : Nat8) : Nat8
```

Devuelve `x` elevado a la potencia de `y`, `x **% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat8.powWrap(2, 8); // => 0
(2 : Nat8) **% (8 : Nat8) // => 0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**%` como un
valor de función en este momento.
