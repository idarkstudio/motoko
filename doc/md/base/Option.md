# Option

Nulos seguros

Los valores opcionales se pueden ver como un `null` seguro. Un valor de tipo
`?Int` se puede construir con `null` o `?42`. La forma más sencilla de acceder
al contenido de un opcional es utilizar el emparejamiento de patrones:

```motoko
let optionalInt1 : ?Int = ?42;
let optionalInt2 : ?Int = null;

let int1orZero : Int = switch optionalInt1 {
  case null 0;
  case (?int) int;
};
assert int1orZero == 42;

let int2orZero : Int = switch optionalInt2 {
  case null 0;
  case (?int) int;
};
assert int2orZero == 0;
```

Las funciones en este módulo capturan algunas operaciones comunes al trabajar
con opcionales que pueden ser más concisas que utilizar el emparejamiento de
patrones.

## Función `get`

```motoko no-repl
func get<T>(x : ?T, default : T) : T
```

Desenvuelve un valor opcional, con un valor predeterminado, es decir,
`get(?x, d) = x` y `get(null, d) = d`.

## Función `getMapped`

```motoko no-repl
func getMapped<A, B>(x : ?A, f : A -> B, default : B) : B
```

Desenvuelve un valor opcional utilizando una función, o devuelve el valor
predeterminado, es decir, `option(?x, f, d) = f x` y `option(null, f, d) = d`.

## Función `map`

```motoko no-repl
func map<A, B>(x : ?A, f : A -> B) : ?B
```

Aplica una función al valor envuelto. Los `null` se mantienen sin cambios.

```motoko
import Option "mo:base/Option";
assert Option.map<Nat, Nat>(?42, func x = x + 1) == ?43;
assert Option.map<Nat, Nat>(null, func x = x + 1) == null;
```

## Función `iterate`

```motoko no-repl
func iterate<A>(x : ?A, f : A -> ())
```

Aplica una función al valor envuelto, pero descarta el resultado. Utiliza
`iterate` si solo estás interesado en el efecto secundario que produce `f`.

```motoko
import Option "mo:base/Option";
var counter : Nat = 0;
Option.iterate(?5, func (x : Nat) { counter += x });
assert counter == 5;
Option.iterate(null, func (x : Nat) { counter += x });
assert counter == 5;
```

## Función `apply`

```motoko no-repl
func apply<A, B>(x : ?A, f : ?(A -> B)) : ?B
```

Aplica una función opcional a un valor opcional. Devuelve `null` si al menos uno
de los argumentos es `null`.

## Función `chain`

```motoko no-repl
func chain<A, B>(x : ?A, f : A -> ?B) : ?B
```

Aplica una función a un valor opcional. Devuelve `null` si el argumento es
`null`, o si la función devuelve `null`.

## Función `flatten`

```motoko no-repl
func flatten<A>(x : ??A) : ?A
```

Dado un valor opcional opcional, elimina una capa de opcionalidad.

```motoko
import Option "mo:base/Option";
assert Option.flatten(?(?(42))) == ?42;
assert Option.flatten(?(null)) == null;
assert Option.flatten(null) == null;
```

## Función `make`

```motoko no-repl
func make<A>(x : A) : ?A
```

Crea un valor opcional a partir de un valor definido.

```motoko
import Option "mo:base/Option";
assert Option.make(42) == ?42;
```

## Función `isSome`

```motoko no-repl
func isSome(x : ?Any) : Bool
```

Devuelve verdadero si el argumento no es `null`, de lo contrario devuelve falso.

## Función `isNull`

```motoko no-repl
func isNull(x : ?Any) : Bool
```

Devuelve verdadero si el argumento es `null`, de lo contrario devuelve falso.

## Función `equal`

```motoko no-repl
func equal<A>(x : ?A, y : ?A, eq : (A, A) -> Bool) : Bool
```

Devuelve verdadero si los argumentos opcionales son iguales según la función de
igualdad proporcionada, de lo contrario devuelve falso.

## Función `assertSome`

```motoko no-repl
func assertSome(x : ?Any)
```

Asegura que el valor no sea `null`; falla en caso contrario. @deprecated
Option.assertSome se eliminará pronto; en su lugar, utiliza una expresión de
aserción.

## Función `assertNull`

```motoko no-repl
func assertNull(x : ?Any)
```

Asegura que el valor _sea_ `null`; falla en caso contrario. @deprecated
Option.assertNull se eliminará pronto; en su lugar, utiliza una expresión de
aserción.

## Función `unwrap`

```motoko no-repl
func unwrap<T>(x : ?T) : T
```

Desenvuelve un valor opcional, es decir, `unwrap(?x) = x`.

@deprecated Option.unwrap no es seguro y falla si el argumento es `null`; se
eliminará pronto; en su lugar, utiliza una expresión `switch` o `do?`.
