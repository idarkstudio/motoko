# Result

Manejo de errores con el tipo Result.

## Tipo `Result`

```motoko no-repl
type Result<Ok, Err> = {#ok : Ok; #err : Err}
```

`Result<Ok, Err>` es el tipo utilizado para devolver y propagar errores. Es un
tipo con las variantes `#ok(Ok)`, que representa el éxito y contiene un valor, y
`#err(Err)`, que representa un error y contiene un valor de error.

La forma más sencilla de trabajar con `Result`s es hacer coincidir patrones en
ellos:

Por ejemplo, dada una función `createUser(user : User) : Result<Id, String>`
donde `String` es un mensaje de error, podríamos usarla de la siguiente manera:

```motoko no-repl
switch(createUser(myUser)) {
  case (#ok(id)) { Debug.print("Created new user with id: " # id) };
  case (#err(msg)) { Debug.print("Failed to create user with the error: " # msg) };
}
```

## Función `equal`

```motoko no-repl
func equal<Ok, Err>(eqOk : (Ok, Ok) -> Bool, eqErr : (Err, Err) -> Bool, r1 : Result<Ok, Err>, r2 : Result<Ok, Err>) : Bool
```

## Función `compare`

```motoko no-repl
func compare<Ok, Err>(compareOk : (Ok, Ok) -> Order.Order, compareErr : (Err, Err) -> Order.Order, r1 : Result<Ok, Err>, r2 : Result<Ok, Err>) : Order.Order
```

## Función `chain`

```motoko no-repl
func chain<R1, R2, Error>(x : Result<R1, Error>, y : R1 -> Result<R2, Error>) : Result<R2, Error>
```

Permite la secuenciación de valores y funciones `Result` que devuelven `Result`s
ellos mismos.

```motoko
import Result "mo:base/Result";
type Result<T,E> = Result.Result<T, E>;
func largerThan10(x : Nat) : Result<Nat, Text> =
  if (x > 10) { #ok(x) } else { #err("Not larger than 10.") };

func smallerThan20(x : Nat) : Result<Nat, Text> =
  if (x < 20) { #ok(x) } else { #err("Not smaller than 20.") };

func between10And20(x : Nat) : Result<Nat, Text> =
  Result.chain(largerThan10(x), smallerThan20);

assert(between10And20(15) == #ok(15));
assert(between10And20(9) == #err("Not larger than 10."));
assert(between10And20(21) == #err("Not smaller than 20."));
```

## Función `flatten`

```motoko no-repl
func flatten<Ok, Error>(result : Result<Result<Ok, Error>, Error>) : Result<Ok, Error>
```

Aplana un `Result` anidado.

```motoko
import Result "mo:base/Result";
assert(Result.flatten<Nat, Text>(#ok(#ok(10))) == #ok(10));
assert(Result.flatten<Nat, Text>(#err("Wrong")) == #err("Wrong"));
assert(Result.flatten<Nat, Text>(#ok(#err("Wrong"))) == #err("Wrong"));
```

## Función `mapOk`

```motoko no-repl
func mapOk<Ok1, Ok2, Error>(x : Result<Ok1, Error>, f : Ok1 -> Ok2) : Result<Ok2, Error>
```

Mapea el tipo/valor `Ok`, dejando inalterado cualquier tipo/valor `Error`.

## Función `mapErr`

```motoko no-repl
func mapErr<Ok, Error1, Error2>(x : Result<Ok, Error1>, f : Error1 -> Error2) : Result<Ok, Error2>
```

Mapea el tipo/valor `Error`, dejando inalterado cualquier tipo/valor `Ok`.

## Función `fromOption`

```motoko no-repl
func fromOption<R, E>(x : ?R, err : E) : Result<R, E>
```

Crea un resultado a partir de una opción, incluyendo un valor de error para
manejar el caso `null`.

```motoko
import Result "mo:base/Result";
assert(Result.fromOption(?42, "err") == #ok(42));
assert(Result.fromOption(null, "err") == #err("err"));
```

## Función `toOption`

```motoko no-repl
func toOption<R, E>(r : Result<R, E>) : ?R
```

Crea una opción a partir de un resultado, convirtiendo todos los `#err` en
`null`.

```motoko
import Result "mo:base/Result";
assert(Result.toOption(#ok(42)) == ?42);
assert(Result.toOption(#err("err")) == null);
```

## Función `iterate`

```motoko no-repl
func iterate<Ok, Err>(res : Result<Ok, Err>, f : Ok -> ())
```

Aplica una función a un valor exitoso, pero descarta el resultado. Usa `iterar`
si solo te interesa el efecto secundario que produce `f`.

```motoko
import Result "mo:base/Result";
var counter : Nat = 0;
Result.iterate<Nat, Text>(#ok(5), func (x : Nat) { counter += x });
assert(counter == 5);
Result.iterate<Nat, Text>(#err("Wrong"), func (x : Nat) { counter += x });
assert(counter == 5);
```

## Función `isOk`

```motoko no-repl
func isOk(r : Result<Any, Any>) : Bool
```

## Función `isErr`

```motoko no-repl
func isErr(r : Result<Any, Any>) : Bool
```

## Función `assertOk`

```motoko no-repl
func assertOk(r : Result<Any, Any>)
```

Asegura que su argumento sea un resultado `#ok`, de lo contrario, se detiene.

## Función `assertErr`

```motoko no-repl
func assertErr(r : Result<Any, Any>)
```

Asegura que su argumento sea un resultado `#err`, de lo contrario, se detiene.

## Función `fromUpper`

```motoko no-repl
func fromUpper<Ok, Err>(result : {#Ok : Ok; #Err : Err}) : Result<Ok, Err>
```

Convierte un tipo de resultado en mayúsculas `#Ok`, `#Err` en un tipo de
resultado en minúsculas `#ok`, `#err`. En el IC, una convención común es usar
`#Ok` y `#Err` como las variantes de un tipo de resultado, pero en Motoko,
usamos `#ok` y `#err` en su lugar.

## Función `toUpper`

```motoko no-repl
func toUpper<Ok, Err>(result : Result<Ok, Err>) : {#Ok : Ok; #Err : Err}
```

Convierte un tipo de resultado en minúsculas `#ok`, `#err` en un tipo de
resultado en mayúsculas `#Ok`, `#Err`. En el IC, una convención común es usar
`#Ok` y `#Err` como las variantes de un tipo de resultado, pero en Motoko,
usamos `#ok` y `#err` en su lugar.
