# Bool

Tipo booleano y operaciones.

Mientras los operadores booleanos `_ and _` y `_ or _` son de cortocircuito,
evitando la computación del argumento derecho cuando es posible, las funciones
`logand(_, _)` y `logor(_, _)` son _estrictas_ y siempre evaluarán _ambos_ de
sus argumentos.

## Tipo `Bool`

```motoko no-repl
type Bool = Prim.Types.Bool
```

Booleanos con las constantes `true` y `false`.

## Función `toText`

```motoko no-repl
func toText(x : Bool) : Text
```

Conversión.

## Función `logand`

```motoko no-repl
func logand(x : Bool, y : Bool) : Bool
```

Devuelve `x and y`.

## Función `logor`

```motoko no-repl
func logor(x : Bool, y : Bool) : Bool
```

Devuelve `x or y`.

## Función `logxor`

```motoko no-repl
func logxor(x : Bool, y : Bool) : Bool
```

Devuelve el xor exclusivo de `x` y `y`, `x != y`.

## Función `lognot`

```motoko no-repl
func lognot(x : Bool) : Bool
```

Devuelve `not x`.

## Función `equal`

```motoko no-repl
func equal(x : Bool, y : Bool) : Bool
```

Devuelve `x == y`.

## Función `notEqual`

```motoko no-repl
func notEqual(x : Bool, y : Bool) : Bool
```

Devuelve `x != y`.

## Función `compare`

```motoko no-repl
func compare(x : Bool, y : Bool) : {#less; #equal; #greater}
```

Devuelve el orden de `x` y `y`, donde `false < true`.
