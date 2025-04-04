# Float

Doble precisión (64 bits) números de punto flotante en la representación
IEEE 754.

Este módulo contiene constantes comunes de punto flotante y funciones de
utilidad.

Notación para valores especiales en la documentación a continuación: `+inf`:
Infinito positivo `-inf`: Infinito negativo `NaN`: "no es un número" (puede
tener diferentes valores de bit de signo, pero `NaN != NaN` independientemente
del signo).

Nota: Los números de punto flotante tienen una precisión limitada y las
operaciones pueden resultar en errores numéricos.

Ejemplos de errores numéricos:

```motoko
0.1 + 0.1 + 0.1 == 0.3 // => false
```

```motoko
1e16 + 1.0 != 1e16 // => false
```

(y muchos más casos)

Aviso:

- Comparación de números de punto flotante con `==` o `!=` se desaconseja. En su
  lugar, es mejor comparar números de punto flotante con una tolerancia
  numérica, llamada epsilon.

  Ejemplo:

  ```motoko
  import Float "mo:base/Float";
  let x = 0.1 + 0.1 + 0.1;
  let y = 0.3;

  let epsilon = 1e-6; // Esto depende del caso de aplicación (necesita un análisis de errores numéricos).
  Float.equalWithin(x, y, epsilon) // => true
  ```

- Para la precisión absoluta, se recomienda codificar el número de fracción como
  un par de un Nat para la base y un Nat para el exponente (punto decimal).

Signo de NaN:

- El signo de NaN solo se aplica mediante `abs`, `neg` y `copySign`. Otras
  operaciones pueden tener un bit de signo arbitrario para los resultados NaN.

## Tipo `Float`

```motoko no-repl
type Float = Prim.Types.Float
```

Numero de punto flotante de 64 bits.

## Valor `pi`

```motoko no-repl
let pi : Float
```

Radio de la circunferencia de un círculo a su diámetro. Nota: Precisión
limitada.

## Valor `e`

```motoko no-repl
let e : Float
```

Base de los logaritmos naturales. Nota: Precisión limitada.

## Función `isNaN`

```motoko no-repl
func isNaN(number : Float) : Bool
```

Determina si el `número` es un `NaN` ("Not a Number" en la representación de
punto flotante). Notas:

- La prueba de igualdad de `NaN` consigo mismo u otro número siempre es `false`.
- Existen muchas representaciones internas de `NaN`, como `NaN` positivo y
  negativo, `NaN` señalizado y silencioso, cada uno con muchas representaciones
  de bits diferentes.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.isNaN(0.0/0.0) // => true
```

## Function `abs`

```motoko no-repl
func abs(x : Float) : Float
```

Devuelve el valor absoluto de `x`.

Casos especiales:

```
abs(+inf) => +inf
abs(-inf) => +inf
abs(-NaN)  => +NaN
abs(-0.0) => 0.0
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.abs(-1.2) // => 1.2
```

## Function `sqrt`

```motoko no-repl
func sqrt(x : Float) : Float
```

Devuelve la raíz cuadrada de `x`.

Casos especiales:

```
sqrt(+inf) => +inf
sqrt(-0.0) => -0.0
sqrt(x)    => NaN if x < 0.0
sqrt(NaN)  => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.sqrt(6.25) // => 2.5
```

## Function `ceil`

```motoko no-repl
func ceil(x : Float) : Float
```

Devuelve el número entero flotante más pequeño mayor o igual a `x`.

Casos especiales:

```
ceil(+inf) => +inf
ceil(-inf) => -inf
ceil(NaN)  => NaN
ceil(0.0)  => 0.0
ceil(-0.0) => -0.0
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.ceil(1.2) // => 2.0
```

## Function `floor`

```motoko no-repl
func floor(x : Float) : Float
```

Devuelve el número entero flotante más grande menor o igual a `x`.

Casos especiales:

```
floor(+inf) => +inf
floor(-inf) => -inf
floor(NaN)  => NaN
floor(0.0)  => 0.0
floor(-0.0) => -0.0
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.floor(1.2) // => 1.0
```

## Function `trunc`

```motoko no-repl
func trunc(x : Float) : Float
```

Devuelve el número entero flotante más cercano no mayor en magnitud que `x`.
Esto es equivalente a devolver `x` con truncar sus lugares decimales.

Casos especiales:

```
trunc(+inf) => +inf
trunc(-inf) => -inf
trunc(NaN)  => NaN
trunc(0.0)  => 0.0
trunc(-0.0) => -0.0
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.trunc(2.75) // => 2.0
```

## Function `nearest`

```motoko no-repl
func nearest(x : Float) : Float
```

Devuelve el número entero flotante más cercano a `x`. Un lugar decimal de
exactamente .5 se redondea hacia arriba para `x > 0` y hacia abajo para `x < 0`.

Casos especiales:

```
nearest(+inf) => +inf
nearest(-inf) => -inf
nearest(NaN)  => NaN
nearest(0.0)  => 0.0
nearest(-0.0) => -0.0
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.nearest(2.75) // => 3.0
```

## Function `copySign`

```motoko no-repl
func copySign(x : Float, y : Float) : Float
```

Devuelve `x` si `x` e `y` tienen el mismo signo, de lo contrario `x` con el
signo negado.

El bit de signo de cero, infinito y `NaN` se considera.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.copySign(1.2, -2.3) // => -1.2
```

## Function `min`

```motoko no-repl
func min(x : Float, y : Float) : Float
```

Devuelve el valor más pequeño de `x` e `y`.

Casos especiales:

```
min(NaN, y) => NaN for any Float y
min(x, NaN) => NaN for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.min(1.2, -2.3) // => -2.3 (with numerical imprecision)
```

## Function `max`

```motoko no-repl
func max(x : Float, y : Float) : Float
```

Devuelve el valor más grande de `x` e `y`.

Casos especiales:

```
max(NaN, y) => NaN for any Float y
max(x, NaN) => NaN for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.max(1.2, -2.3) // => 1.2
```

## Function `sin`

```motoko no-repl
func sin(x : Float) : Float
```

Devuelve el seno del ángulo en radianes `x`.

Casos especiales:

```
sin(+inf) => NaN
sin(-inf) => NaN
sin(NaN) => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.sin(Float.pi / 2) // => 1.0
```

## Function `cos`

```motoko no-repl
func cos(x : Float) : Float
```

Devuelve el coseno del ángulo en radianes `x`.

Casos especiales:

```
cos(+inf) => NaN
cos(-inf) => NaN
cos(NaN)  => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.cos(Float.pi / 2) // => 0.0 (with numerical imprecision)
```

## Function `tan`

```motoko no-repl
func tan(x : Float) : Float
```

Devuelve la tangente del ángulo en radianes `x`.

Casos especiales:

```
tan(+inf) => NaN
tan(-inf) => NaN
tan(NaN)  => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.tan(Float.pi / 4) // => 1.0 (with numerical imprecision)
```

## Function `arcsin`

```motoko no-repl
func arcsin(x : Float) : Float
```

Devuleve el seno inverso de `x` en radianes.

Casos especiales:

```
arcsin(x)   => NaN if x > 1.0
arcsin(x)   => NaN if x < -1.0
arcsin(NaN) => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.arcsin(1.0) // => Float.pi / 2
```

## Function `arccos`

```motoko no-repl
func arccos(x : Float) : Float
```

Devuelve el coseno inverso de `x` en radianes.

Casos especiales:

```
arccos(x)  => NaN if x > 1.0
arccos(x)  => NaN if x < -1.0
arcos(NaN) => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.arccos(1.0) // => 0.0
```

## Function `arctan`

```motoko no-repl
func arctan(x : Float) : Float
```

Devuelve el arcotangente de `x` en radianes.

Casos especiales:

```
arctan(+inf) => pi / 2
arctan(-inf) => -pi / 2
arctan(NaN)  => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.arctan(1.0) // => Float.pi / 4
```

## Function `arctan2`

```motoko no-repl
func arctan2(y : Float, x : Float) : Float
```

Dado `(y,x)`, devuelve el arcotangente en radianes de `y/x` basado en los signos
de ambos valores para determinar el cuadrante correcto.

Casos especiales:

```
arctan2(0.0, 0.0)   => 0.0
arctan2(-0.0, 0.0)  => -0.0
arctan2(0.0, -0.0)  => pi
arctan2(-0.0, -0.0) => -pi
arctan2(+inf, +inf) => pi / 4
arctan2(+inf, -inf) => 3 * pi / 4
arctan2(-inf, +inf) => -pi / 4
arctan2(-inf, -inf) => -3 * pi / 4
arctan2(NaN, x)     => NaN for any Float x
arctan2(y, NaN)     => NaN for any Float y
```

Ejemplo:

```motoko
import Float "mo:base/Float";

let sqrt2over2 = Float.sqrt(2) / 2;
Float.arctan2(sqrt2over2, sqrt2over2) // => Float.pi / 4
```

## Function `exp`

```motoko no-repl
func exp(x : Float) : Float
```

Devuelve el valor de `e` elevado a la potencia de `x`.

Casos especiales:

```
exp(+inf) => +inf
exp(-inf) => 0.0
exp(NaN)  => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.exp(1.0) // => Float.e
```

## Function `log`

```motoko no-repl
func log(x : Float) : Float
```

Devuelve el logaritmo natural (base-`e`) de `x`.

Casos especiales:

```
log(0.0)  => -inf
log(-0.0) => -inf
log(x)    => NaN if x < 0.0
log(+inf) => +inf
log(NaN)  => NaN
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.log(Float.e) // => 1.0
```

## Función `format`

```motoko no-repl
func format(fmt : {#fix : Nat8; #exp : Nat8; #gen : Nat8; #exact}, x : Float) : Text
```

Formateo. `format(fmt, x)` formatea `x` a `Text` de acuerdo con la directiva de
formato `fmt`, que puede tener una de las siguientes formas:

- `#fix prec` como formato de punto fijo con `prec` dígitos
- `#exp prec` como formato exponencial con `prec` dígitos
- `#gen prec` como formato genérico con `prec` dígitos
- `#exact` como formato exacto que se puede decodificar sin pérdida.

`-0.0` se formatea con el bit de signo negativo. El infinito positivo se
formatea como "inf". El infinito negativo se formatea como "-inf".

Nota: La precisión numérica y el formato de texto pueden variar entre las
versiones de Motoko y la configuración del tiempo de ejecución. Además, `NaN`
puede imprimirse de manera diferente, es decir, "NaN" o "nan", omitiendo
potencialmente el signo `NaN`.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.format(#exp 3, 123.0) // => "1.230e+02"
```

## Function `toText`

```motoko no-repl
func toText(_ : Float) : Text
```

Conversión a Text. Utiliza `format(fmt, x)` para un control más detallado.

`-0.0` se formatea con el bit de signo negativo. El infinito positivo se
formatea como `inf`. El infinito negativo se formatea como `-inf`. `NaN` se
formatea como `NaN` o `-NaN` dependiendo de su bit de signo.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.toText(0.12) // => "0.12"
```

## Function `toInt64`

```motoko no-repl
func toInt64(_ : Float) : Int64
```

Conversión a Int64 truncando el Float, equivalente a `toInt64(trunc(f))`

Genera una excepción si el número de punto flotante es más grande o más pequeño
que el Int64 representable. También genera una excepción para `inf`, `-inf` y
`NaN`.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.toInt64(-12.3) // => -12
```

## Function `fromInt64`

```motoko no-repl
func fromInt64(_ : Int64) : Float
```

Conversión desde Int64.

Nota: El número de punto flotante puede ser impreciso para Int64 grandes o
pequeños.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.fromInt64(-42) // => -42.0
```

## Function `toInt`

```motoko no-repl
func toInt(_ : Float) : Int
```

Conversión a Int.

Genera un error para `inf`, `-inf` y `NaN`.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.toInt(1.2e6) // => +1_200_000
```

## Function `fromInt`

```motoko no-repl
func fromInt(_ : Int) : Float
```

Conversión desde Int. Puede resultar en `Inf`.

Nota: El número de punto flotante puede ser impreciso para valores Int grandes o
pequeños. Devuelve `inf` si el entero es mayor que el número de punto flotante
máximo. Devuelve `-inf` si el entero es menor que el número de punto flotante
mínimo.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.fromInt(-123) // => -123.0
```

## Función `equal`

```motoko no-repl
func equal(x : Float, y : Float) : Bool
```

Devuelve `x == y`. @deprecated Utiliza `Float.equalWithin()` ya que esta función
no considera errores numéricos.

## Función `notEqual`

```motoko no-repl
func notEqual(x : Float, y : Float) : Bool
```

Devuelve `x != y`. @deprecated Utiliza `Float.notEqualWithin()` ya que esta
función no considera errores numéricos.

## Función `equalWithin`

```motoko no-repl
func equalWithin(x : Float, y : Float, epsilon : Float) : Bool
```

Determina si `x` es igual a `y` dentro de la tolerancia definida de `epsilon`.
El `epsilon` considera errores numéricos, ver comentario anterior. Equivalente a
`Float.abs(x - y) <= epsilon` para un epsilon no negativo.

Genera un error si `epsilon` es negativo o `NaN`.

Casos especiales:

```
equalWithin(+0.0, -0.0, epsilon) => true for any `epsilon >= 0.0`
equalWithin(-0.0, +0.0, epsilon) => true for any `epsilon >= 0.0`
equalWithin(+inf, +inf, epsilon) => true for any `epsilon >= 0.0`
equalWithin(-inf, -inf, epsilon) => true for any `epsilon >= 0.0`
equalWithin(x, NaN, epsilon)     => false for any x and `epsilon >= 0.0`
equalWithin(NaN, y, epsilon)     => false for any y and `epsilon >= 0.0`
```

Ejemplo:

```motoko
import Float "mo:base/Float";

let epsilon = 1e-6;
Float.equalWithin(-12.3, -1.23e1, epsilon) // => true
```

## Función `notEqualWithin`

```motoko no-repl
func notEqualWithin(x : Float, y : Float, epsilon : Float) : Bool
```

Determina si `x` no es igual a `y` dentro de la tolerancia definida de
`epsilon`. El `epsilon` considera errores numéricos, ver comentario anterior.
Equivalente a `not equal(x, y, epsilon)`.

Genera un error si `epsilon` es negativo o `NaN`.

Casos especiales:

```
notEqualWithin(+0.0, -0.0, epsilon) => false for any `epsilon >= 0.0`
notEqualWithin(-0.0, +0.0, epsilon) => false for any `epsilon >= 0.0`
notEqualWithin(+inf, +inf, epsilon) => false for any `epsilon >= 0.0`
notEqualWithin(-inf, -inf, epsilon) => false for any `epsilon >= 0.0`
notEqualWithin(x, NaN, epsilon)     => true for any x and `epsilon >= 0.0`
notEqualWithin(NaN, y, epsilon)     => true for any y and `epsilon >= 0.0`
```

Ejemplo:

```motoko
import Float "mo:base/Float";

let epsilon = 1e-6;
Float.notEqualWithin(-12.3, -1.23e1, epsilon) // => false
```

## Función `less`

```motoko no-repl
func less(x : Float, y : Float) : Bool
```

Devuelve `x < y`.

Casos especiales:

```
less(+0.0, -0.0) => false
less(-0.0, +0.0) => false
less(NaN, y)     => false for any Float y
less(x, NaN)     => false for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.less(Float.e, Float.pi) // => true
```

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Float, y : Float) : Bool
```

Devuelve `x <= y`.

Casos especiales:

```
lessOrEqual(+0.0, -0.0) => true
lessOrEqual(-0.0, +0.0) => true
lessOrEqual(NaN, y)     => false for any Float y
lessOrEqual(x, NaN)     => false for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.lessOrEqual(0.123, 0.1234) // => true
```

## Función `greater`

```motoko no-repl
func greater(x : Float, y : Float) : Bool
```

Devuelve `x > y`.

Casos especiales:

```
greater(+0.0, -0.0) => false
greater(-0.0, +0.0) => false
greater(NaN, y)     => false for any Float y
greater(x, NaN)     => false for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.greater(Float.pi, Float.e) // => true
```

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Float, y : Float) : Bool
```

Devuelve `x >= y`.

Casos especiales:

```
greaterOrEqual(+0.0, -0.0) => true
greaterOrEqual(-0.0, +0.0) => true
greaterOrEqual(NaN, y)     => false for any Float y
greaterOrEqual(x, NaN)     => false for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.greaterOrEqual(0.1234, 0.123) // => true
```

## Función `compare`

```motoko no-repl
func compare(x : Float, y : Float) : {#less; #equal; #greater}
```

Define un orden total de `x` e `y` para su uso en la clasificación.

Nota: Se desaconseja utilizar esta operación para determinar la igualdad o
desigualdad por dos razones:

- No considera errores numéricos, ver comentario anterior. Utilice
  `equalWithin(x, y, epsilon)` o `notEqualWithin(x, y, epsilon)` para probar la
  igualdad o desigualdad, respectivamente.
- Los `NaN` se consideran iguales si su signo coincide, lo cual es diferente a
  la igualdad estándar por `==` o al usar `equal()` o `notEqual()`.

Orden total:

- NaN negativo (sin distinción entre NaN negativo señalizado y silencioso)
- Infinito negativo
- Números negativos (incluidos los números subnormales negativos en orden
  estándar)
- Cero negativo (`-0.0`)
- Cero positivo (`+0.0`)
- Números positivos (incluidos los números subnormales positivos en orden
  estándar)
- Infinito positivo
- NaN positivo (sin distinción entre NaN positivo señalizado y silencioso)

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.compare(0.123, 0.1234) // => #less
```

## Función `neg`

```motoko no-repl
func neg(x : Float) : Float
```

Devuelve la negación de `x`, `-x`.

Cambia el bit de signo para infinito.

Casos especiales:

```
neg(+inf) => -inf
neg(-inf) => +inf
neg(+NaN) => -NaN
neg(-NaN) => +NaN
neg(+0.0) => -0.0
neg(-0.0) => +0.0
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.neg(1.23) // => -1.23
```

## Función `add`

```motoko no-repl
func add(x : Float, y : Float) : Float
```

Devuelve la suma de `x` e `y`, `x + y`.

Nota: Pueden ocurrir errores numéricos, ver comentario anterior.

Casos especiales:

```
add(+inf, y)    => +inf if y is any Float except -inf and NaN
add(-inf, y)    => -inf if y is any Float except +inf and NaN
add(+inf, -inf) => NaN
add(NaN, y)     => NaN for any Float y
```

El mismo caso se aplica conmutativamente, es decir, para `add(y, x)`.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.add(1.23, 0.123) // => 1.353
```

## Función `sub`

```motoko no-repl
func sub(x : Float, y : Float) : Float
```

Devuelve la diferencia de `x` e `y`, `x - y`.

Nota: Pueden ocurrir errores numéricos, ver comentario anterior.

Casos especiales:

```
sub(+inf, y)    => +inf if y is any Float except +inf or NaN
sub(-inf, y)    => -inf if y is any Float except -inf and NaN
sub(x, +inf)    => -inf if x is any Float except +inf and NaN
sub(x, -inf)    => +inf if x is any Float except -inf and NaN
sub(+inf, +inf) => NaN
sub(-inf, -inf) => NaN
sub(NaN, y)     => NaN for any Float y
sub(x, NaN)     => NaN for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.sub(1.23, 0.123) // => 1.107
```

## Función `mul`

```motoko no-repl
func mul(x : Float, y : Float) : Float
```

Devuelve el producto de `x` e `y`, `x * y`.

Nota: Pueden ocurrir errores numéricos, ver comentario anterior.

Casos especiales:

```
mul(+inf, y) => +inf if y > 0.0
mul(-inf, y) => -inf if y > 0.0
mul(+inf, y) => -inf if y < 0.0
mul(-inf, y) => +inf if y < 0.0
mul(+inf, 0.0) => NaN
mul(-inf, 0.0) => NaN
mul(NaN, y) => NaN for any Float y
```

El mismo caso se aplica conmutativamente, es decir, para `mul(y, x)`.

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.mul(1.23, 1e2) // => 123.0
```

## Función `div`

```motoko no-repl
func div(x : Float, y : Float) : Float
```

Devuelve la división de `x` por `y`, `x / y`.

Nota: Pueden ocurrir errores numéricos, ver comentario anterior.

Casos especiales:

```
div(0.0, 0.0) => NaN
div(x, 0.0)   => +inf for x > 0.0
div(x, 0.0)   => -inf for x < 0.0
div(x, +inf)  => 0.0 for any x except +inf, -inf, and NaN
div(x, -inf)  => 0.0 for any x except +inf, -inf, and NaN
div(+inf, y)  => +inf if y >= 0.0
div(+inf, y)  => -inf if y < 0.0
div(-inf, y)  => -inf if y >= 0.0
div(-inf, y)  => +inf if y < 0.0
div(NaN, y)   => NaN for any Float y
div(x, NaN)   => NaN for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.div(1.23, 1e2) // => 0.0123
```

## Función `rem`

```motoko no-repl
func rem(x : Float, y : Float) : Float
```

Devuelve el resto de la división de punto flotante `x % y`, que se define como
`x - trunc(x / y) * y`.

Nota: Pueden ocurrir errores numéricos, ver comentario anterior.

Casos especiales:

```
rem(0.0, 0.0) => NaN
rem(x, y)     => +inf if sign(x) == sign(y) for any x and y not being +inf, -inf, or NaN
rem(x, y)     => -inf if sign(x) != sign(y) for any x and y not being +inf, -inf, or NaN
rem(x, +inf)  => x for any x except +inf, -inf, and NaN
rem(x, -inf)  => x for any x except +inf, -inf, and NaN
rem(+inf, y)  => NaN for any Float y
rem(-inf, y)  => NaN for any Float y
rem(NaN, y)   => NaN for any Float y
rem(x, NaN)   => NaN for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.rem(7.2, 2.3) // => 0.3 (with numerical imprecision)
```

## Función `pow`

```motoko no-repl
func pow(x : Float, y : Float) : Float
```

Devuelve `x` elevado a la potencia de `y`, `x ** y`.

Nota: Pueden ocurrir errores numéricos, ver comentario anterior.

Casos especiales:

```
pow(+inf, y)    => +inf for any y > 0.0 including +inf
pow(+inf, 0.0)  => 1.0
pow(+inf, y)    => 0.0 for any y < 0.0 including -inf
pow(x, +inf)    => +inf if x > 0.0 or x < 0.0
pow(0.0, +inf)  => 0.0
pow(x, -inf)    => 0.0 if x > 0.0 or x < 0.0
pow(0.0, -inf)  => +inf
pow(x, y)       => NaN if x < 0.0 and y is a non-integral Float
pow(-inf, y)    => +inf if y > 0.0 and y is a non-integral or an even integral Float
pow(-inf, y)    => -inf if y > 0.0 and y is an odd integral Float
pow(-inf, 0.0)  => 1.0
pow(-inf, y)    => 0.0 if y < 0.0
pow(-inf, +inf) => +inf
pow(-inf, -inf) => 1.0
pow(NaN, y)     => NaN if y != 0.0
pow(NaN, 0.0)   => 1.0
pow(x, NaN)     => NaN for any Float x
```

Ejemplo:

```motoko
import Float "mo:base/Float";

Float.pow(2.5, 2.0) // => 6.25
```
