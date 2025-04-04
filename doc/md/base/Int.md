# Int

Números enteros con precisión infinita (también conocidos como enteros grandes /
big integers).

La mayoría de las operaciones en números enteros (por ejemplo, la suma) están
disponibles como operadores integrados (por ejemplo, `-1 + 1`). Este módulo
proporciona funciones equivalentes y conversión a `Text`.

Importa desde la libreria base para usar este módulo.

```motoko name=import
import Int "mo:base/Int";
```

## Tipo `Int`

```motoko no-repl
type Int = Prim.Types.Int
```

Enteros con precisión infinita.

## Función `abs`

```motoko no-repl
func abs(x : Int) : Nat
```

Devuelve el valor absoluto de `x`.

Ejemplo:

```motoko include=import
Int.abs(-12) // => 12
```

## Función `toText`

```motoko no-repl
func toText(x : Int) : Text
```

Convierte un número entero en su representación textual. La representación
textual _no_ contiene guiones bajos para representar comas.

Ejemplo:

```motoko include=import
Int.toText(-1234) // => "-1234"
```

## Función `min`

```motoko no-repl
func min(x : Int, y : Int) : Int
```

Devuelve el mínimo entre `x` e `y`.

Ejemplo:

```motoko include=import
Int.min(2, -3) // => -3
```

## Función `max`

```motoko no-repl
func max(x : Int, y : Int) : Int
```

Devuelve el máximo entre `x` e `y`.

Ejemplo:

```motoko include=import
Int.max(2, -3) // => 2
```

## Función `hash`

```motoko no-repl
func hash(i : Int) : Hash.Hash
```

Calcula un hash a partir de los 32 bits menos significativos de `i`, ignorando
otros bits. @deprecated Para valores grandes de `Int`, considera usar una
función de hash personalizada que tenga en cuenta todos los bits del argumento.

## Función `hashAcc`

```motoko no-repl
func hashAcc(h1 : Hash.Hash, i : Int) : Hash.Hash
```

Calcula un hash acumulado a partir de `h1` y los 32 bits menos significativos de
`i`, ignorando otros bits en `i`. @deprecated Para valores grandes de `Int`,
considera usar una función de hash personalizada que tenga en cuenta todos los
bits del argumento.

## Función `equal`

```motoko no-repl
func equal(x : Int, y : Int) : Bool
```

Función de igualdad para tipos `Int`. Esto es equivalente a `x == y`.

Ejemplo:

```motoko include=import
Int.equal(-1, -1); // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Int>(1);
buffer1.add(-3);
let buffer2 = Buffer.Buffer<Int>(1);
buffer2.add(-3);
Buffer.equal(buffer1, buffer2, Int.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(x : Int, y : Int) : Bool
```

Función de desigualdad para tipos `Int`. Esto es equivalente a `x != y`.

Ejemplo:

```motoko include=import
Int.notEqual(-1, -2); // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(x : Int, y : Int) : Bool
```

Función "menor que" para tipos `Int`. Esto es equivalente a `x < y`.

Ejemplo:

```motoko include=import
Int.less(-2, 1); // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Int, y : Int) : Bool
```

Función "menor o igual que" para tipos `Int`. Esto es equivalente a `x <= y`.

Ejemplo:

```motoko include=import
Int.lessOrEqual(-2, 1); // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(x : Int, y : Int) : Bool
```

Función "mayor que" para tipos `Int`. Esto es equivalente a `x > y`.

Ejemplo:

```motoko include=import
Int.greater(1, -2); // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Int, y : Int) : Bool
```

Función "mayor o igual que" para tipos `Int`. Esto es equivalente a `x >= y`.

Ejemplo:

```motoko include=import
Int.greaterOrEqual(1, -2); // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.

## Función `compare`

```motoko no-repl
func compare(x : Int, y : Int) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Int`. Devuelve el `Order` (ya
sea `#less`, `#equal` o `#greater`) al comparar `x` con `y`.

Ejemplo:

```motoko include=import
Int.compare(-3, 2) // => #less
```

Esta función se puede usar como valor para una función de orden superior, como
una función de ordenación.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.sort([1, -2, -3], Int.compare) // => [-3, -2, 1]
```

## Función `neg`

```motoko no-repl
func neg(x : Int) : Int
```

Devuelve la negación de `x`, `-x`.

Ejemplo:

```motoko include=import
Int.neg(123) // => -123
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

## Función `add`

```motoko no-repl
func add(x : Int, y : Int) : Int
```

Devuelve la suma de `x` e `y`, `x + y`.

Sin desbordamiento ya que `Int` tiene precisión infinita.

Ejemplo:

```motoko include=import
Int.add(1, -2); // => -1
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `+` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `+` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft([1, -2, -3], 0, Int.add) // => -4
```

## Función `sub`

```motoko no-repl
func sub(x : Int, y : Int) : Int
```

Devuelve la diferencia de `x` e `y`, `x - y`.

Sin desbordamiento ya que `Int` tiene precisión infinita.

Ejemplo:

```motoko include=import
Int.sub(1, 2); // => -1
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `-` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `-` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft([1, -2, -3], 0, Int.sub) // => 4
```

## Función `mul`

```motoko no-repl
func mul(x : Int, y : Int) : Int
```

Devuelve el producto de `x` e `y`, `x * y`.

Sin desbordamiento ya que `Int` tiene precisión infinita.

Ejemplo:

```motoko include=import
Int.mul(-2, 3); // => -6
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `*` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `*` como un valor
de función en este momento.

Ejemplo:

```motoko include=import
import Array "mo:base/Array";
Array.foldLeft([1, -2, -3], 1, Int.mul) // => 6
```

## Función `div`

```motoko no-repl
func div(x : Int, y : Int) : Int
```

Devuelve la división entera con signo de `x` entre `y`, `x / y`. Redondea el
cociente hacia cero, lo cual es lo mismo que truncar los lugares decimales del
cociente.

Provoca una trampa cuando `y` es cero.

Ejemplo:

```motoko include=import
Int.div(6, -2); // => -3
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `/` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `/` como un valor
de función en este momento.

## Función `rem`

```motoko no-repl
func rem(x : Int, y : Int) : Int
```

Devuelve el resto de la división entera con signo de `x` entre `y`, `x % y`, que
se define como `x - x / y * y`.

Provoca una trampa cuando `y` es cero.

Ejemplo:

```motoko include=import
Int.rem(6, -4); // => 2
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `%` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `%` como un valor
de función en este momento.

## Función `pow`

```motoko no-repl
func pow(x : Int, y : Int) : Int
```

Devuelve `x` elevado a la potencia de `y`, `x ** y`.

Provoca una trampa cuando `y` es negativo o `y > 2 ** 32 - 1`. Sin
desbordamiento ya que `Int` tiene precisión infinita.

Ejemplo:

```motoko include=import
Int.pow(-2, 3); // => -8
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `**` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `**` como un
valor de función en este momento.
