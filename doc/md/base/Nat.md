# Nat

Números naturales con precisión infinita.

La mayoría de las operaciones en números naturales (por ejemplo, la suma) están
disponibles como operadores integrados (por ejemplo, `1 + 1`). Este módulo
proporciona funciones equivalentes y conversión a `Text`.

Importa desde la librería base para usar este módulo.

```motoko name=import
import Nat "mo:base/Nat";
```

## Tipo `Nat`

```motoko no-repl
type Nat = Prim.Types.Nat
```

Números naturales con precisión infinita.

## Función `toText`

```motoko no-repl
func toText(n : Nat) : Text
```

Convierte un número natural en su representación textual. La representación
textual no contiene guiones bajos para representar comas.

Ejemplo:

```motoko include=import
Nat.toText 1234 // => "1234"
```

## Función `fromText`

```motoko no-repl
func fromText(text : Text) : ?Nat
```

Crea un número natural a partir de su representación textual. Devuelve `null` si
la entrada no es un número natural válido.

Nota: La representación textual no debe contener guiones bajos.

Ejemplo:

```motoko include=import
Nat.fromText "1234" // => ?1234
```

## Función `min`

```motoko no-repl
func min(x : Nat, y : Nat) : Nat
```

Devuelve el mínimo entre `x` e `y`.

Ejemplo:

```motoko include=import
Nat.min(1, 2) // => 1
```

## Función `max`

```motoko no-repl
func max(x : Nat, y : Nat) : Nat
```

Devuelve el máximo entre `x` e `y`.

Ejemplo:

```motoko include=import
Nat.max(1, 2) // => 2
```

## Función `equal`

```motoko no-repl
func equal(x : Nat, y : Nat) : Bool
```

Función de igualdad para tipos `Nat`. Esto es equivalente a `x == y`.

Ejemplo:

```motoko include=import
ignore Nat.equal(1, 1); // => true
1 == 1 // => true
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Nat>(3);
let buffer2 = Buffer.Buffer<Nat>(3);
Buffer.equal(buffer1, buffer2, Nat.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(x : Nat, y : Nat) : Bool
```

Función de desigualdad para tipos `Nat`. Esto es equivalente a `x != y`.

Ejemplo:

```motoko include=import
ignore Nat.notEqual(1, 2); // => true
1 != 2 // => true
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(x : Nat, y : Nat) : Bool
```

Función "menor que" para tipos `Nat`. Esto es equivalente a `x < y`.

Ejemplo:

```motoko include=import
ignore Nat.less(1, 2); // => true
1 < 2 // => true
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Nat, y : Nat) : Bool
```

Función "menor o igual que" para tipos `Nat`. Esto es equivalente a `x <= y`.

Ejemplo:

```motoko include=import
ignore Nat.lessOrEqual(1, 2); // => true
1 <= 2 // => true
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(x : Nat, y : Nat) : Bool
```

Función "mayor que" para tipos `Nat`. Esto es equivalente a `x > y`.

Ejemplo:

```motoko include=import
ignore Nat.greater(2, 1); // => true
2 > 1 // => true
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Nat, y : Nat) : Bool
```

Función "mayor o igual que" para tipos `Nat`. Esto es equivalente a `x >= y`.

Ejemplo:

```motoko include=import
ignore Nat.greaterOrEqual(2, 1); // => true
2 >= 1 // => true
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.

## Función `compare`

```motoko no-repl
func compare(x : Nat, y : Nat) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Nat`. Devuelve el `Order` (ya
sea `#less`, `#equal` o `#greater`) al comparar `x` con `y`.

Ejemplo:

```motoko include=import
Nat.compare(2, 3) // => #less
```

Esta función se puede usar como valor para una función de orden superior, como
una función de ordenación.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.sort([2, 3, 1], Nat.compare) // => [1, 2, 3]
```

## Función `add`

```motoko no-repl
func add(x : Nat, y : Nat) : Nat
```

Devuelve la suma de `x` e `y`, `x + y`. Este operador nunca provocará
desbordamiento porque `Nat` tiene precisión infinita.

Ejemplo:

```motoko include=import
ignore Nat.add(1, 2); // => 3
1 + 2 // => 3
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `+` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft([2, 3, 1], 0, Nat.add) // => 6
```

## Función `sub`

```motoko no-repl
func sub(x : Nat, y : Nat) : Nat
```

Devuelve la diferencia entre `x` e `y`, `x - y`. Genera una trampa en caso de
desbordamiento por debajo de `0`.

Ejemplo:

```motoko include=import
ignore Nat.sub(2, 1); // => 1
// Agrega una anotación de tipo para evitar una advertencia sobre la resta
2 - 1 : Nat // => 1
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft([2, 3, 1], 10, Nat.sub) // => 4
```

## Función `mul`

```motoko no-repl
func mul(x : Nat, y : Nat) : Nat
```

Devuelve el producto de `x` e `y`, `x * y`. Este operador nunca provocará
desbordamiento porque `Nat` tiene precisión infinita.

Ejemplo:

```motoko include=import
ignore Nat.mul(2, 3); // => 6
2 * 3 // => 6
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `*` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft([2, 3, 1], 1, Nat.mul) // => 6
```

## Función `div`

```motoko no-repl
func div(x : Nat, y : Nat) : Nat
```

Devuelve la división entera sin signo de `x` entre `y`, `x / y`. Genera una
trampa cuando `y` es cero.

El cociente se redondea hacia abajo, lo cual es equivalente a truncar los
lugares decimales del cociente.

Ejemplo:

```motoko include=import
ignore Nat.div(6, 2); // => 3
6 / 2 // => 3
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `/` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `/` como un valor
de función en este momento.

## Función `rem`

```motoko no-repl
func rem(x : Nat, y : Nat) : Nat
```

Devuelve el resto de la división entera sin signo de `x` entre `y`, `x % y`.
Genera una trampa cuando `y` es cero.

Ejemplo:

```motoko include=import
ignore Nat.rem(6, 4); // => 2
6 % 4 // => 2
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `%` como un valor
de función en este momento.

## Función `pow`

```motoko no-repl
func pow(x : Nat, y : Nat) : Nat
```

Devuelve `x` elevado a la potencia de `y`, `x ** y`. Genera una trampa cuando
`y > 2^32`. Este operador nunca provocará desbordamiento porque `Nat` tiene
precisión infinita.

Ejemplo:

```motoko include=import
ignore Nat.pow(2, 3); // => 8
2 ** 3 // => 8
```

Nota: La razón por la cual esta función está definida en esta librería (además
del operador `**` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**` como un
valor de función en este momento.

## Función `bitshiftLeft`

```motoko no-repl
func bitshiftLeft(x : Nat, y : Nat32) : Nat
```

Devuelve el desplazamiento a la izquierda (conceptual) de `x` por `y`,
`x * (2 ** y)`.

Ejemplo:

```motoko include=import
Nat.bitshiftLeft(1, 3); // => 8
```

Nota: La razón por la cual esta función está definida en esta librería (en
ausencia del operador `<<`) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. Si bien `Nat` no está definido en
términos de patrones de bits, conceptualmente se puede considerar como tal, y la
operación se proporciona como una versión de alto rendimiento de la regla
aritmética correspondiente.

## Función `bitshiftRight`

```motoko no-repl
func bitshiftRight(x : Nat, y : Nat32) : Nat
```

Devuelve el desplazamiento a la derecha (conceptual) de `x` por `y`,
`x / (2 ** y)`.

Ejemplo:

```motoko include=import
Nat.bitshiftRight(8, 3); // => 1
```

Nota: La razón por la cual esta función está definida en esta librería (en
ausencia del operador `>>`) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. Si bien `Nat` no está definido en
términos de patrones de bits, conceptualmente se puede considerar como tal, y la
operación se proporciona como una versión de alto rendimiento de la regla
aritmética correspondiente.
