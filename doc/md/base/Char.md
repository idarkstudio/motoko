# Char

Caracteres

## Tipo `Char`

```motoko no-repl
type Char = Prim.Types.Char
```

Caracteres representados como puntos de código Unicode.

## Function `toNat32`

```motoko no-repl
func toNat32(c : Char) : Nat32
```

Convierte el carácter `c` en una palabra que contiene su valor escalar Unicode.

## Function `fromNat32`

```motoko no-repl
func fromNat32(w : Nat32) : Char
```

Convierte `w` en un carácter. Genera una excepción si `w` no es un valor escalar
Unicode válido. El valor `w` es válido si, y solo si,
`w < 0xD800 or (0xE000 <= w and w <= 0x10FFFF)`.

## Function `toText`

```motoko no-repl
func toText(c : Char) : Text
```

Convierte el carácter `c` en un texto de un solo carácter.

## Función `isDigit`

```motoko no-repl
func isDigit(c : Char) : Bool
```

Devuelve `true` cuando `c` es un dígito decimal entre `0` y `9`, de lo contrario
`false`.

## Function `isWhitespace`

```motoko no-repl
func isWhitespace(c : Char) : Bool
```

Devuelve la propiedad _White_Space_ Unicode de `c`.

## Function `isLowercase`

```motoko no-repl
func isLowercase(c : Char) : Bool
```

Devuelve la propiedad _Lowercase_ Unicode de `c`.

## Function `isUppercase`

```motoko no-repl
func isUppercase(c : Char) : Bool
```

Devuelve la propiedad _Uppercase_ Unicode de `c`.

## Function `isAlphabetic`

```motoko no-repl
func isAlphabetic(c : Char) : Bool
```

Devuelve la propiedad _Alphabetic_ Unicode de `c`.

## Función `equal`

```motoko no-repl
func equal(x : Char, y : Char) : Bool
```

Devuelve `x == y`.

## Función `notEqual`

```motoko no-repl
func notEqual(x : Char, y : Char) : Bool
```

Devuelve `x != y`.

## Función `less`

```motoko no-repl
func less(x : Char, y : Char) : Bool
```

Devuelve `x < y`.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(x : Char, y : Char) : Bool
```

Devuelve `x <= y`.

## Función `greater`

```motoko no-repl
func greater(x : Char, y : Char) : Bool
```

Devuelve `x > y`.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(x : Char, y : Char) : Bool
```

Devuelve `x >= y`.

## Función `compare`

```motoko no-repl
func compare(x : Char, y : Char) : {#less; #equal; #greater}
```

Devuelve el orden de `x` e `y`.
