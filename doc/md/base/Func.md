# Func

Funciones sobre funciones, creando funciones a partir de entradas más simples.

(Más comúnmente utilizado al programar en estilo funcional utilizando funciones
de orden superior.)

## Función `compose`

```motoko no-repl
func compose<A, B, C>(f : B -> C, g : A -> B) : A -> C
```

Importa desde la libreria base para usar este módulo.

```motoko name=import
import { compose; const; identity } = "mo:base/Func";
import Text = "mo:base/Text";
import Char = "mo:base/Char";
```

La composición de dos funciones `f` y `g` es una función que aplica `g` y luego
`f`.

Ejemplo:

```motoko include=import
let textFromNat32 = compose(Text.fromChar, Char.fromNat32);
assert textFromNat32(65) == "A";
```

## Función `identity`

```motoko no-repl
func identity<A>(x : A) : A
```

La función `identity` devuelve su argumento. Ejemplo:

```motoko include=import
assert identity(10) == 10;
assert identity(true) == true;
```

## Función `const`

```motoko no-repl
func const<A, B>(x : A) : B -> A
```

La función `const` es una función _curried_ que acepta un argumento `x` y luego
devuelve una función que descarta su argumento y siempre devuelve `x`.

Ejemplo:

```motoko include=import
assert const<Nat, Text>(10)("hello") == 10;
assert const(true)(20) == true;
```
