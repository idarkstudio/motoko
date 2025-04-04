# Nat32

Proporciona funciones de utilidad en enteros sin signo de 32 bits.

Tenga en cuenta que la mayoría de las operaciones están disponibles como
operadores integrados (por ejemplo, `1 + 1`).

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Nat32 "mo:base/Nat32";
```

## Tipo `Nat32`

```motoko no-repl
type Nat32 = Prim.Types.Nat32
```

Números naturales de 32 bits.

## Valor `maximumValue`

```motoko no-repl
let maximumValue : Nat32
```

Máximo número natural de 32 bits. `2 ** 32 - 1`.

Ejemplo:

```motoko include=import
Nat32.maximumValue; // => 65536 : Nat32
```

## Function `toNat`

```motoko no-repl
func toNat(_ : Nat32) : Nat
```

Convierte un entero sin signo de 32 bits en un entero sin signo con precisión
infinita.

Ejemplo:

```motoko include=import
Nat32.toNat(123); // => 123 : Nat
```

## Function `fromNat`

```motoko no-repl
func fromNat(_ : Nat) : Nat32
```

Convierte un entero sin signo con precisión infinita en un entero sin signo de
32 bits.

Genera un error en caso de desbordamiento.

Ejemplo:

```motoko include=import
Nat32.fromNat(123); // => 123 : Nat32
```

## Función `fromNat16`

```motoko no-repl
func fromNat16(x : Nat16) : Nat32
```

Convierte un entero sin signo de 16 bits en un entero sin signo de 32 bits.

Ejemplo:

```motoko include=import
Nat32.fromNat16(123); // => 123 : Nat32
```

## Función `toNat16`

```motoko no-repl
func toNat16(x : Nat32) : Nat16
```

Convierte un entero sin signo de 32 bits en un entero sin signo de 16 bits.

Genera un error en caso de desbordamiento.

Ejemplo:

```motoko include=import
Nat32.toNat16(123); // => 123 : Nat16
```

## Función `fromNat64`

```motoko no-repl
func fromNat64(x : Nat64) : Nat32
```

Convierte un entero sin signo de 64 bits en un entero sin signo de 32 bits.

Genera un error en caso de desbordamiento.

Ejemplo:

```motoko include=import
Nat32.fromNat64(123); // => 123 : Nat32
```

## Función `toNat64`

```motoko no-repl
func toNat64(x : Nat32) : Nat64
```

Convierte un entero sin signo de 32 bits en un entero sin signo de 64 bits.

Ejemplo:

```motoko include=import
Nat32.toNat64(123); // => 123 : Nat64
```

## Function `fromIntWrap`

```motoko no-repl
func fromIntWrap(_ : Int) : Nat32
```

Convierte un entero con signo de precisión infinita en un entero sin signo de 32
bits.

Se envuelve en caso de desbordamiento/subdesbordamiento.

Ejemplo:

```motoko include=import
Nat32.fromIntWrap(123 : Int); // => 123 : Nat32
```

## Función `toText`

```motoko no-repl
func toText(x : Nat32) : Text
```

Convierte `x` en su representación textual. La representación textual _no_
contiene guiones bajos para representar comas.

Ejemplo:

```motoko include=import
Nat32.toText(1234); // => "1234" : Text
```

## Función `min`

```motoko no-repl
func min(x : Nat32, y : Nat32) : Nat32
```

Devuelve el mínimo entre `x` e `y`.

Ejemplo:

```motoko include=import
Nat32.min(123, 200); // => 123 : Nat32
```

## Función `max`

```motoko no-repl
func max(x : Nat32, y : Nat32) : Nat32
```

Devuelve el máximo entre `x` e `y`.

Ejemplo:

```motoko include=import
Nat32.max(123, 200); // => 200 : Nat32
```

## Función `equal`

```motoko no-repl
func equal(x : Nat32, y : Nat32) : Bool
```

Función de igualdad para tipos Nat32. Esto es equivalente a `x == y`.

Ejemplo:

```motoko include=import
ignore Nat32.equal(1, 1); // => true
(1 : Nat32) == (1 : Nat32) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Nat32>(3);
let buffer2 = Buffer.Buffer<Nat32>(3);
Buffer.equal(buffer1, buffer2, Nat32.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(x : Nat32, y : Nat32) : Bool
```

Función de desigualdad para tipos Nat32. Esto es equivalente a `x != y`.

Ejemplo:

```motoko include=import
ignore Nat32.notEqual(1, 2); // => true
(1 : Nat32) != (2 : Nat32) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(x : Nat32, y : Nat32) : Bool
```

Función "menor que" para tipos Nat32. Esto es equivalente a `x < y`.

Ejemplo:

```motoko include=import
ignore Nat32.less(1, 2); // => true
(1 : Nat32) < (2 : Nat32) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Nat32, y : Nat32) : Bool
```

Función "menor o igual que" para tipos Nat32. Esto es equivalente a `x <= y`.

Ejemplo:

```motoko include=import
ignore Nat32.lessOrEqual(1, 2); // => true
(1 : Nat32) <= (2 : Nat32) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(x : Nat32, y : Nat32) : Bool
```

Función "mayor que" para tipos Nat32. Esto es equivalente a `x > y`.

Ejemplo:

```motoko include=import
ignore Nat32.greater(2, 1); // => true
(2 : Nat32) > (1 : Nat32) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Nat32, y : Nat32) : Bool
```

Función "mayor o igual que" para tipos Nat32. Esto es equivalente a `x >= y`.

Ejemplo:

```motoko include=import
ignore Nat32.greaterOrEqual(2, 1); // => true
(2 : Nat32) >= (1 : Nat32) // => true
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.

## Función `compare`

```motoko no-repl
func compare(x : Nat32, y : Nat32) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Nat32`. Devuelve el `Order`
(ya sea `#less`, `#equal` o `#greater`) al comparar `x` con `y`.

Ejemplo:

```motoko include=import
Nat32.compare(2, 3) // => #less
```

Esta función se puede utilizar como valor para una función de orden superior,
como una función de ordenación.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.sort([2, 3, 1] : [Nat32], Nat32.compare) // => [1, 2, 3]
```

## Función `add`

```motoko no-repl
func add(x : Nat32, y : Nat32) : Nat32
```

Devuelve la suma de `x` e `y`, `x + y`. Genera en error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat32.add(1, 2); // => 3
(1 : Nat32) + (2 : Nat32) // => 3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat32, Nat32>([2, 3, 1], 0, Nat32.add) // => 6
```

## Función `sub`

```motoko no-repl
func sub(x : Nat32, y : Nat32) : Nat32
```

Devuelve la diferencia de `x` e `y`, `x - y`. Genera en error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat32.sub(2, 1); // => 1
(2 : Nat32) - (1 : Nat32) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat32, Nat32>([2, 3, 1], 20, Nat32.sub) // => 14
```

## Función `mul`

```motoko no-repl
func mul(x : Nat32, y : Nat32) : Nat32
```

Devuelve el producto de `x` e `y`, `x * y`. Genera en error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat32.mul(2, 3); // => 6
(2 : Nat32) * (3 : Nat32) // => 6
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft<Nat32, Nat32>([2, 3, 1], 1, Nat32.mul) // => 6
```

## Función `div`

```motoko no-repl
func div(x : Nat32, y : Nat32) : Nat32
```

Devuelve el cociente de `x` dividido por `y`, `x / y`. Genera en error cuando
`y` es cero.

Ejemplo:

```motoko include=import
ignore Nat32.div(6, 2); // => 3
(6 : Nat32) / (2 : Nat32) // => 3
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `/` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `/` como un valor
de función en este momento.

## Función `rem`

```motoko no-repl
func rem(x : Nat32, y : Nat32) : Nat32
```

Devuelve el resto de la división de `x` por `y`, `x % y`. Genera en error cuando
`y` es cero.

Ejemplo:

```motoko include=import
ignore Nat32.rem(6, 4); // => 2
(6 : Nat32) % (4 : Nat32) // => 2
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `%` como un valor
de función en este momento.

## Función `pow`

```motoko no-repl
func pow(x : Nat32, y : Nat32) : Nat32
```

Devuelve la potencia de `x` a `y`, `x ** y`. Genera en error en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat32.pow(2, 3); // => 8
(2 : Nat32) ** (3 : Nat32) // => 8
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**` como un
valor de función en este momento.

## Función `bitnot`

```motoko no-repl
func bitnot(x : Nat32) : Nat32
```

Devuelve la negación a nivel de bits de `x`, `^x`.

Ejemplo:

```motoko include=import
ignore Nat32.bitnot(0); // => 65535
^(0 : Nat32) // => 65535
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `^` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `^` como un valor
de función en este momento.

## Función `bitand`

```motoko no-repl
func bitand(x : Nat32, y : Nat32) : Nat32
```

Devuelve la operación de bits "y" de `x` y `y`, `x & y`.

Ejemplo:

```motoko include=import
ignore Nat32.bitand(0, 1); // => 0
(0 : Nat32) & (1 : Nat32) // => 0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `&` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `&` como un valor
de función en este momento.

## Función `bitor`

```motoko no-repl
func bitor(x : Nat32, y : Nat32) : Nat32
```

Devuelve la operación de bits "o" de `x` y `y`, `x | y`.

Ejemplo:

```motoko include=import
ignore Nat32.bitor(0, 1); // => 1
(0 : Nat32) | (1 : Nat32) // => 1
```

## Función `bitxor`

```motoko no-repl
func bitxor(x : Nat32, y : Nat32) : Nat32
```

Devuelve el resultado de la operación de bits "o exclusivo" entre `x` e `y`,
`x ^ y`.

Ejemplo:

```motoko include=import
ignore Nat32.bitxor(0, 1); // => 1
(0 : Nat32) ^ (1 : Nat32) // => 1
```

## Función `bitshiftLeft`

```motoko no-repl
func bitshiftLeft(x : Nat32, y : Nat32) : Nat32
```

Devuelve el resultado de desplazar `x` a la izquierda `y` veces a nivel de bits,
`x << y`.

Ejemplo:

```motoko include=import
ignore Nat32.bitshiftLeft(1, 3); // => 8
(1 : Nat32) << (3 : Nat32) // => 8
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<` como un
valor de función en este momento.

## Función `bitshiftRight`

```motoko no-repl
func bitshiftRight(x : Nat32, y : Nat32) : Nat32
```

Devuelve el resultado de desplazar `x` a la derecha `y` veces a nivel de bits,
`x >> y`.

Ejemplo:

```motoko include=import
ignore Nat32.bitshiftRight(8, 3); // => 1
(8 : Nat32) >> (3 : Nat32) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>>` como un
valor de función en este momento.

## Función `bitrotLeft`

```motoko no-repl
func bitrotLeft(x : Nat32, y : Nat32) : Nat32
```

Devuelve el resultado de rotar `x` a la izquierda `y` veces a nivel de bits,
`x <<> y`.

Ejemplo:

```motoko include=import
ignore Nat32.bitrotLeft(2, 1); // => 4
(2 : Nat32) <<> (1 : Nat32) // => 4
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<<>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<<>` como un
valor de función en este momento.

## Función `bitrotRight`

```motoko no-repl
func bitrotRight(x : Nat32, y : Nat32) : Nat32
```

Devuelve el resultado de rotar `x` a la derecha `y` veces a nivel de bits,
`x <>> y`.

Ejemplo:

```motoko include=import
ignore Nat32.bitrotRight(1, 1); // => 32768
(1 : Nat32) <>> (1 : Nat32) // => 32768
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `<>>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<>>` como un
valor de función en este momento.

## Función `bittest`

```motoko no-repl
func bittest(x : Nat32, p : Nat) : Bool
```

Devuelve el valor del bit `p mod 32` en `x`,
`(x & 2^(p mod 32)) == 2^(p mod 32)`. Esto es equivalente a verificar si el bit
`p` está activado en `x`, utilizando indexación desde 0.

Ejemplo:

```motoko include=import
Nat32.bittest(5, 2); // => true
```

## Función `bitset`

```motoko no-repl
func bitset(x : Nat32, p : Nat) : Nat32
```

Devuelve el valor de establecer el bit `p mod 32` en `x` en 1.

Ejemplo:

```motoko include=import
Nat32.bitset(0, 2); // => 4
```

## Función `bitclear`

```motoko no-repl
func bitclear(x : Nat32, p : Nat) : Nat32
```

Devuelve el valor de establecer el bit `p mod 32` en `x` en 0.

Ejemplo:

```motoko include=import
Nat32.bitclear(5, 2); // => 1
```

## Función `bitflip`

```motoko no-repl
func bitflip(x : Nat32, p : Nat) : Nat32
```

Devuelve el valor de invertir el bit `p mod 32` en `x`.

Ejemplo:

```motoko include=import
Nat32.bitflip(5, 2); // => 1
```

## Function `bitcountNonZero`

```motoko no-repl
func bitcountNonZero(x : Nat32) : Nat32
```

Devuelve la cantidad de bits no cero en `x`.

Ejemplo:

```motoko include=import
Nat32.bitcountNonZero(5); // => 2
```

## Function `bitcountLeadingZero`

```motoko no-repl
func bitcountLeadingZero(x : Nat32) : Nat32
```

Devuelve la cantidad de bits cero principales en `x`.

Ejemplo:

```motoko include=import
Nat32.bitcountLeadingZero(5); // => 13
```

## Function `bitcountTrailingZero`

```motoko no-repl
func bitcountTrailingZero(x : Nat32) : Nat32
```

Devuelve la cantidad de bits cero finales en `x`.

Ejemplo:

```motoko include=import
Nat32.bitcountTrailingZero(5); // => 0
```

## Función `addWrap`

```motoko no-repl
func addWrap(x : Nat32, y : Nat32) : Nat32
```

Devuelve la suma de `x` e `y`, `x +% y`. Se envuelve en caso de desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat32.addWrap(65532, 5); // => 1
(65532 : Nat32) +% (5 : Nat32) // => 1
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `+%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+%` como un
valor de función en este momento.

## Función `subWrap`

```motoko no-repl
func subWrap(x : Nat32, y : Nat32) : Nat32
```

Devuelve la diferencia de `x` e `y`, `x -% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat32.subWrap(1, 2); // => 65535
(1 : Nat32) -% (2 : Nat32) // => 65535
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `-%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-%` como un
valor de función en este momento.

## Función `mulWrap`

```motoko no-repl
func mulWrap(x : Nat32, y : Nat32) : Nat32
```

Devuelve el producto de `x` e `y`, `x *% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat32.mulWrap(655, 101); // => 619
(655 : Nat32) *% (101 : Nat32) // => 619
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `*%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*%` como un
valor de función en este momento.

## Función `powWrap`

```motoko no-repl
func powWrap(x : Nat32, y : Nat32) : Nat32
```

Devuelve `x` elevado a la potencia de `y`, `x **% y`. Se envuelve en caso de
desbordamiento.

Ejemplo:

```motoko include=import
ignore Nat32.powWrap(2, 32); // => 0
(2 : Nat32) **% (32 : Nat32) // => 0
```

Nota: La razón por la cual esta función está definida en esta biblioteca (además
del operador `**%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**%` como un
valor de función en este momento.
