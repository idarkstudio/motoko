---
sidebar_position: 1
---

# Referencia de lenguaje

<!--
* targetting release 0.5.4
* [X] Categorise primitives and operations as arithmetic (A), logical (L), bitwise (B) and relational (R) and use these categories to concisely present categorized operators (unop, binop, relop, a(ssigning)op) etc.
* [ ] Various inline TBCs and TBRs and TODOs
* [ ] Typing of patterns
* [X] Variants
* [X] Object patterns
* [X] Import expressions
* [X] Complete draft of Try/Throw expressions and primitive Error/ErrorCode type
* [ ] Prelude
* [ ] Modules and static restriction
* [X] Type components and paths
* [ ] Prelude (move scattered descriptions of assorted prims like charToText here)
* [X] Split category R into E (Equality) and O (Ordering) if we don't want Bool to support O. (Actually renamed R to O, and defined ==/!= on _shared_ types.
* [X] Include actual grammar (extracted from menhir) in appendix?
* [ ] Prose description of definedness checks
* [ ] Platform changes: remove async expressions (and perhaps types); restrict await to shared calls.
* [X] Queries
* [X] Remove Shared type
* [X] Explain dot keys, dot vals and iterators
* [X] Debug expressions
* [X] Document punning in type record patterns: https://github.com/dfinity/motoko/pull/964
* [X] Update ErrorCode section
* [Floats] Literals type and operations
* [ ] Re-section so headings appear in content outline
-->

Esta página de referencia proporciona detalles técnicos de interés para los
siguientes públicos:

- Autores que brindan documentación de nivel superior sobre el lenguaje de
  programación Motoko.

- Expertos en compiladores interesados en los detalles de Motoko y su
  compilador.

- Programadores avanzados que desean aprender más sobre los detalles de bajo
  nivel de Motoko.

Esta página tiene la intención de proporcionar información de referencia
completa sobre Motoko, pero esta sección no proporciona texto explicativo ni
información de uso. Por lo tanto, esta sección generalmente no es adecuada para
lectores que son nuevos en lenguajes de programación o que buscan una
introducción general al uso de Motoko.

En esta documentación, el término "canister" se utiliza para referirse a un
contrato inteligente de Internet Computer.

## Sintaxis básica del lenguaje

Esta sección describe las convenciones básicas del lenguaje de Motoko.

### Espacios en blanco

Espacio, salto de línea, tabulación horizontal, retorno de carro, avance de
línea y alimentación de formulario se consideran como espacios en blanco. Los
espacios en blanco se ignoran pero se utilizan para separar palabras clave,
identificadores y operadores adyacentes.

En la definición de algunos lexemas, la referencia rápida utiliza el símbolo `␣`
para denotar un solo carácter de espacio en blanco.

### Comentarios

Los comentarios de una sola línea son todos los caracteres que siguen a `//`
hasta el final de la misma línea.

```motoko no-repl
// single line comment
x = 1
```

Los comentarios de una sola línea o de varias líneas son cualquier secuencia de
caracteres delimitada por `/*` y `*/`:

```motoko no-repl
/* multi-line comments
   look like this, as in C and friends */
```

Los comentarios delimitados por `/*` y `*/` pueden estar anidados, siempre y
cuando el anidamiento esté bien balanceado.

```motoko no-repl
/// I'm a documentation comment
/// for a function
```

Los comentarios de documentación comienzan con `///` seguido de un espacio hasta
el final de la línea, y se adjuntan a la definición inmediatamente después de
ellos.

Los comentarios de deprecación comienzan con `/// @deprecated` seguido de un
espacio hasta el final de la línea, y se adjuntan a la definición inmediatamente
después de ellos. Solo se reconocen delante de declaraciones `public`.

Todos los comentarios se tratan como espacios en blanco.

### Palabras clave (keywords)

Las siguientes palabras clave están reservadas y no se pueden utilizar como
identificadores:

```bnf

actor and assert async async* await await* break case catch class
composite continue debug debug_show do else false flexible finally for
from_candid func if ignore import in module not null persistent object or label
let loop private public query return shared stable switch system throw
to_candid true transient try type var while with
```

### Identificadores

Los identificadores son alfanuméricos, comienzan con una letra y pueden contener
guiones bajos:

```bnf
<id>   ::= Letter (Letter | Digit | _)*
Letter ::= A..Z | a..z
Digit  ::= 0..9
```

### Enteros

Los enteros se escriben como números naturales decimales o hexadecimales con el
prefijo `Ox`. Los dígitos siguientes pueden tener un guion bajo, que no afecta
al significado, antes de ellos.

```bnf
digit ::= ['0'-'9']
hexdigit ::= ['0'-'9''a'-'f''A'-'F']
num ::= digit ('_'? digit)*
hexnum ::= hexdigit ('_'? hexdigit)*
nat ::= num | "0x" hexnum
```

Los enteros negativos se pueden construir aplicando una operación de negación de
prefijo `-`.

### Flotantes

Los literales de punto flotante se escriben en notación científica decimal o
hexadecimal con prefijo `Ox`.

```bnf
let frac = num
let hexfrac = hexnum
let float =
    num '.' frac?
  | num ('.' frac?)? ('e' | 'E') sign? num
  | "0x" hexnum '.' hexfrac?
  | "0x" hexnum ('.' hexfrac?)? ('p' | 'P') sign? num
```

El 'e' (o 'E') precede a un exponente decimal en base 10; 'p' (o 'P') precede a
un exponente binario en base 2. En ambos casos, el exponente está en notación
decimal.

:::nota

El uso de la notación decimal, incluso para el exponente en base 2, se adhiere a
la sintaxis establecida de literales de punto flotante hexadecimal del lenguaje
`C`.

:::

### Caracteres

Un carácter es un carácter delimitado por comillas simples (`'`):

- Carácter Unicode en UTF-8.

- Nueva línea, retorno, tabulación, comillas simples o dobles escapadas con `\`.

- Carácter ASCII con prefijo `\` (por determinar).

- o Carácter Unicode válido y escapado en hexadecimal encerrado en `\u{` hexnum
  `}` (por determinar).

```bnf
ascii ::= ['\x00'-'\x7f']
ascii_no_nl ::= ['\x00'-'\x09''\x0b'-'\x7f']
utf8cont ::= ['\x80'-'\xbf']
utf8enc ::=
    ['\xc2'-'\xdf'] utf8cont
  | ['\xe0'] ['\xa0'-'\xbf'] utf8cont
  | ['\xed'] ['\x80'-'\x9f'] utf8cont
  | ['\xe1'-'\xec''\xee'-'\xef'] utf8cont utf8cont
  | ['\xf0'] ['\x90'-'\xbf'] utf8cont utf8cont
  | ['\xf4'] ['\x80'-'\x8f'] utf8cont utf8cont
  | ['\xf1'-'\xf3'] utf8cont utf8cont utf8cont
utf8 ::= ascii | utf8enc
utf8_no_nl ::= ascii_no_nl | utf8enc

escape ::= ['n''r''t''\\''\'''\"']

character ::=
  | [^'"''\\''\x00'-'\x1f''\x7f'-'\xff']
  | utf8enc
  | '\\'escape
  | '\\'hexdigit hexdigit
  | "\\u{" hexnum '}'
  | '\n'        // literal newline

char := '\'' character '\''
```

### Texto

Un literal de texto es una secuencia de caracteres delimitada por `"`:

```bnf
text ::= '"' character* '"'
```

Nota que un literal de texto puede abarcar varias líneas.

### Literales

```bnf
<lit> ::=                                     literals
  <nat>                                         natural
  <float>                                       float
  <char>                                        character
  <text>                                        Unicode text
```

Los literales son valores constantes. La validez sintáctica de un literal
depende de la precisión del tipo en el que se utiliza.

## Operadores y tipos

Para simplificar la presentación de los operadores disponibles, los operadores y
los tipos primitivos se clasifican en categorías básicas:

| Abreviatura | Categoría  | Operaciones admitidas              |
| ----------- | ---------- | ---------------------------------- |
| A           | Aritmética | Operaciones aritméticas            |
| L           | Lógica     | Operaciones lógicas/booleanas      |
| B           | Bitwise    | Operaciones bitwise y de envoltura |
| O           | Ordenado   | Comparación                        |
| T           | Texto      | Concatenación                      |

Algunos tipos tienen varias categorías. Por ejemplo, el tipo
[`Int`](../base/Int.md) es tanto aritmético (A) como ordenado (O) y admite tanto
la adición aritmética (`+`) como la comparación de menor que (`<`) entre otras
operaciones.

### Operadores unarios

| `<unop>` | Categoría |                    |
| -------- | --------- | ------------------ |
| `-`      | A         | Negación numérica  |
| `+`      | A         | Identidad numérica |
| `^`      | B         | Negación bitwise   |

### Operadores relacionales

|           |           |                                                      |
| --------- | --------- | ---------------------------------------------------- |
| `<relop>` | Categoría |                                                      |
| `==`      |           | Igual                                                |
| `!=`      |           | No igual                                             |
| `␣<␣`     | O         | Menor que (debe estar rodeado de espacios en blanco) |
| `␣>␣`     | O         | Mayor que (debe estar rodeado de espacios en blanco) |
| `<=`      | O         | Menor o igual                                        |
| `>=`      | O         | Mayor o igual                                        |

Toma en cuenta que la igualdad (`==`) y la desigualdad (`!=`) no tienen
categorías. En su lugar, la igualdad y la desigualdad se aplican a argumentos de
todos los tipos compartidos, incluyendo tipos no primitivos y tipos compuestos
como arreglos inmutables, registros y variantes.

La igualdad y la desigualdad son estructurales y se basan en el contenido
observable de sus operandos determinado por su tipo estático.

### Operadores binarios numéricos

| `<binop>` | Categoría |                |
| --------- | --------- | -------------- |
| `+`       | A         | Suma           |
| `-`       | A         | Resta          |
| `*`       | A         | Multiplicación |
| `/`       | A         | División       |
| `%`       | A         | Módulo         |
| `**`      | A         | Exponenciación |

### Operadores binarios de bits y envoltura

| `<binop>`           | Categoría |                                                            |
| ------------------- | --------- | ---------------------------------------------------------- |
| `&`                 | B         | Bitwise and                                                |
| <code>&#124;</code> | B         | Bitwise or                                                 |
| `^`                 | B         | Exclusive or                                               |
| `<<`                | B         | Shift left                                                 |
| `␣>>`               | B         | Shift right (debe estar precedido de un espacio en blanco) |
| `<<>`               | B         | Rotate left                                                |
| `<>>`               | B         | Rotate right                                               |
| `+%`                | A         | Suma (envoltura en caso de desbordamiento)                 |
| `-%`                | A         | Resta (envoltura en caso de desbordamiento)                |
| `*%`                | A         | Multiplicación (envoltura en caso de desbordamiento)       |
| `**%`               | A         | Exponenciación (envoltura en caso de desbordamiento)       |

### Operadores de texto

| `<binop>` | Categoría |               |
| --------- | --------- | ------------- |
| `#`       | T         | Concatenación |

### Operadores de asignación

| `:=`, `<unop>=`, `<binop>=` | Categoría |                                                                  |
| --------------------------- | --------- | ---------------------------------------------------------------- |
| `:=`                        | \*        | Asignación (actualización en el lugar)                           |
| `+=`                        | A         | Suma en el lugar                                                 |
| `-=`                        | A         | Resta en el lugar                                                |
| `*=`                        | A         | Multiplicación en el lugar                                       |
| `/=`                        | A         | División en el lugar                                             |
| `%=`                        | A         | Módulo en el lugar                                               |
| `**=`                       | A         | Exponenciación en el lugar                                       |
| `&=`                        | B         | And lógico en el lugar                                           |
| <code>&#124;=</code>        | B         | Or lógico en el lugar                                            |
| `^=`                        | B         | Or exclusivo en el lugar                                         |
| `<<=`                       | B         | Desplazamiento a la izquierda en el lugar                        |
| `>>=`                       | B         | Desplazamiento a la derecha en el lugar                          |
| `<<>=`                      | B         | Rotación a la izquierda en el lugar                              |
| `<>>=`                      | B         | Rotación a la derecha en el lugar                                |
| `+%=`                       | B         | Suma en el lugar (envoltura en caso de desbordamiento)           |
| `-%=`                       | B         | Resta en el lugar (envoltura en caso de desbordamiento)          |
| `*%=`                       | B         | Multiplicación en el lugar (envoltura en caso de desbordamiento) |
| `**%=`                      | B         | Exponenciación en el lugar (envoltura en caso de desbordamiento) |
| `#=`                        | T         | Concatenación en el lugar                                        |

La categoría de una asignación compuesta `<unop>=`/`<binop>=` se determina por
la categoría del operador `<unop>`/`<binop>`.

### Precedencia de operadores y palabras clave

La siguiente tabla define la precedencia relativa y la asociatividad de los
operadores y tokens, ordenados de menor a mayor precedencia. Los tokens en la
misma línea tienen la misma precedencia con la asociatividad indicada.

| Precedence | Associativity | Token                                                                                                                                        |
| ---------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| LOWEST     | none          | `if _ _` (no `else`), `loop _` (no `while`)                                                                                                  |
| (higher)   | none          | `else`, `while`                                                                                                                              |
| (higher)   | right         | `:=`, `+=`, `-=`, `*=`, `/=`, `%=`, `**=`, `#=`, `&=`, <code>&#124;=</code>, `^=`, `<<=`, `>>=`, `<<>=`, `<>>=`, `+%=`, `-%=`, `*%=`, `**%=` |
| (higher)   | left          | `:`                                                                                                                                          |
| (higher)   | left          | <code>&#124;></code>                                                                                                                         |
| (higher)   | left          | `or`                                                                                                                                         |
| (higher)   | left          | `and`                                                                                                                                        |
| (higher)   | none          | `==`, `!=`, `<`, `>`, `<=`, `>`, `>=`                                                                                                        |
| (higher)   | left          | `+`, `-`, `#`, `+%`, `-%`                                                                                                                    |
| (higher)   | left          | `*`, `/`, `%`, `*%`                                                                                                                          |
| (higher)   | left          | <code>&#124;</code>                                                                                                                          |
| (higher)   | left          | `&`                                                                                                                                          |
| (higher)   | left          | `^`                                                                                                                                          |
| (higher)   | none          | `<<`, `>>`, `<<>`, `<>>`                                                                                                                     |
| HIGHEST    | left          | `**`, `**%`                                                                                                                                  |

### Programas

La sintaxis de un **programa** `<prog>` es la siguiente:

```bnf
<prog> ::=             programs
  <imp>;* <dec>;*
```

Un programa es una secuencia de importaciones `<imp>;*` seguida de una secuencia
de declaraciones `<dec>;*` que termina con una declaración opcional de actor o
clase de actor. La declaración de actor o clase de actor determina el actor
principal, si lo hay, del programa.

Los programas compilados deben cumplir las siguientes restricciones adicionales:

- Una función `shared` solo puede aparecer como un campo público de un actor o
  clase de actor.

- Un programa puede contener como máximo una declaración de actor o clase de
  actor, es decir, el actor o clase de actor principal final.

- Cualquier declaración de clase de actor principal debe ser anónima. Si tiene
  un nombre, el nombre de la clase no debe usarse como un valor dentro de la
  clase y se informará como un identificador no disponible.

Estas restricciones no se aplican a programas interpretados.

Las últimas dos restricciones están diseñadas para prohibir la recursión de
clase de actor programática, a la espera del soporte del compilador.

Tenga en cuenta que los parámetros de una clase de actor deben tener un
[tipo compartido](#compartibilidad-shareability). Los parámetros de la clase de
actor final de un programa proporcionan acceso al/los argumento(s) de
instalación del canister correspondiente. El tipo Candid de este argumento se
determina por la proyección Candid del tipo Motoko del parámetro de la clase.

### Importaciones

La sintaxis de una **importación** `<imp>` es la siguiente:

```bnf
<imp> ::=                           imports
  import <pat> =? <url>

<url> ::=
  "<filepath>"                      Import module from relative <filepath>.mo
  "mo:<package-name>/<filepath>"    Import module from package
  "ic:<canisterid>"                 Import external actor by <canisterid>
  "canister:<name>"                 Import external actor by <name>
```

Una importación introduce un recurso que se refiere a un módulo de origen local,
un módulo de un paquete de módulos o un canister importado como actor. El
contenido del recurso se vincula a `<pat>`.

Aunque normalmente es un identificador simple, `<id>`, `<pat>` también puede ser
cualquier patrón compuesto que vincule componentes selectivos del recurso.

El patrón debe ser irrefutable.

### Librerías

La sintaxis de una **librería** que se puede referenciar en una importación es
la siguiente:

```bnf
<lib> ::=                                               Library
  <imp>;* module <id>? (: <typ>)? =? <obj-body>           Module
  <imp>;* <shared-pat>? actor <migration>? class          Actor class
    <id> <typ-params>? <pat> (: <typ>)? <class-body>
```

Una librería `<lib>` es una secuencia de importaciones `<imp>;*` seguida de:

- Una declaración de módulo con nombre o anónima, o

- Una declaración de clase de actor con nombre.

Las librerías almacenadas en archivos `.mo` pueden ser referenciadas mediante
declaraciones `import`.

En una librería de módulo, el nombre opcional `<id>?` solo es significativo
dentro de la librería y no determina el nombre de la librería al importarla. En
su lugar, el nombre importado de una librería es determinado por la declaración
`import`, lo que brinda a los clientes de la librería la libertad de elegir
nombres de librería para evitar conflictos.

Una librería de clase de actor, debido a que define tanto un constructor de tipo
como una función con nombre `<id>`, se importa como un módulo que define tanto
un tipo como una función con nombre `<id>`. El nombre `<id>` es obligatorio y no
puede ser omitido. Un constructor de clase de actor siempre es asíncrono, con un
tipo de retorno `async T` donde `T` es el tipo inferido del cuerpo de la clase.
Debido a que la construcción de actores es asíncrona, una instancia de una clase
de actor importada solo puede ser creada en un contexto asíncrono, es decir, en
el cuerpo de una función `shared` no-`query`, una función asíncrona, una
expresión `async` o una expresión `async*`.

### Sintaxis de declaración

La sintaxis de una declaración es la siguiente:

```bnf
<dec> ::=                                                               Declaration
  <exp>                                                                   Expression
  let <pat> = <exp>                                                       Immutable, trap on match failure
  let <pat> = <exp> else <block-or-exp>                                   Immutable, handle match failure
  var <id> (: <typ>)? = <exp>                                             Mutable
  <parenthetical>? <sort> <id>? (: <typ>)? =? <obj-body>                  Object
  <shared-pat>? func <id>? <typ-params>? <pat> (: <typ>)? =? <exp>        Function
  type <id> <type-typ-params>? = <typ>                                    Type
  <parenthetical>? <shared-pat>? <sort>? class                            Class
    <id>? <typ-params>? <pat> (: <typ>)? <class-body>

<obj-body> ::=           Object body
  { <dec-field>;* }       Field declarations

<class-body> ::=         Class body
  = <id>? <obj-body>      Object body, optionally binding <id> to 'this' instance
  <obj-body>              Object body

<sort> ::=
   persistent? actor
   module
   object

<parenthetical> ::=       Parenthetical expression
  ( <exp>? with <exp-field>;* )   Parenthetical combination/extension
```

La sintaxis de un calificador de función compartida con patrón de contexto de
llamada es la siguiente:

```bnf
<query> ::=
 composite? query

<shared-pat> ::=
  shared <query>? <pat>?
```

Para `<shared-pat>`, un `<pat>?` ausente es una forma abreviada del patrón
comodín `_`.

```bnf
<dec-field> ::=                                object declaration fields
  <vis>? <stab>? <dec>                           field

<vis> ::=                                      field visibility
  public
  private
  system

<stab> ::=                                     field stability (actor only)
  stable
  flexible
  transient                                      (equivalent to flexible)
```

El calificador de **visibilidad** `<vis>?` determina la accesibilidad de cada
campo `<id>` declarado por `<dec>`:

- Un calificador `<vis>?` ausente tiene como valor predeterminado la visibilidad
  `private`.

- La visibilidad `private` restringe el acceso a `<id>` al objeto, módulo o
  actor que lo contiene.

- La visibilidad `public` extiende la visibilidad `private` permitiendo el
  acceso externo a `<id>` utilizando la notación de punto `<exp>.<id>`.

- La visibilidad `system` extiende la visibilidad `private` permitiendo el
  acceso por parte del sistema en tiempo de ejecución.

- La visibilidad `system` solo puede aparecer en declaraciones `func` que son
  campos de actor, y **no debe** aparecer en ningún otro lugar.

El calificador de **estabilidad** `<stab>` determina el comportamiento de
**actualización** de los campos de actor:

- Un calificador de estabilidad debe aparecer en declaraciones `let` y `var` que
  son campos de actor. Dentro de un actor o clase de actor `persistent`, un
  calificador de estabilidad ausente tiene como valor predeterminado `stable`.
  Dentro de un actor o clase de actor no `persistent`, un calificador de
  estabilidad ausente tiene como valor predeterminado `flexible` (o
  `transient`). Las palabras clave `transient` y `flexible` son intercambiables.

- Los calificadores `<stab>` no deben aparecer en campos de objetos o módulos.

- El patrón en una declaración `stable let <pat> = <exp>` debe ser simple, donde
  un patrón `pat` es simple si consiste recursivamente en cualquiera de lo
  siguiente:

  - Un patrón de variable `<id>`.

  - Un patrón simple anotado `<pat> : <typ>`.

  - Un patrón simple entre paréntesis `( <pat> )`.

### Sintaxis de expresiones

La sintaxis de una expresión es la siguiente:

```bnf
<exp> ::=                                      Expressions
  <id>                                           Variable
  <lit>                                          Literal
  <unop> <exp>                                   Unary operator
  <exp> <binop> <exp>                            Binary operator
  <exp> <relop> <exp>                            Binary relational operator
  _                                              Placeholder expression
  <exp> |> <exp>                                 Pipe operator
  ( <exp>,* )                                    Tuple
  <exp> . <nat>                                  Tuple projection
  ? <exp>                                        Option injection
  { <exp-field>;* }                              Object
  { <exp> (and <exp>)* (with <exp-field>;+)? }   Object combination/extension
  # id <exp>?                                    Variant injection
  <exp> . <id>                                   Object projection/member access
  <exp> := <exp>                                 Assignment
  <unop>= <exp>                                  Unary update
  <exp> <binop>= <exp>                           Binary update
  [ var? <exp>,* ]                               Array
  <exp> [ <exp> ]                                Array indexing
  <shared-pat>? func <func_exp>                  Function expression
  <parenthetical>? <exp> <typ-args>? <exp>       Function call
  not <exp>                                      Negation
  <exp> and <exp>                                Conjunction
  <exp> or <exp>                                 Disjunction
  if <exp> <block-or-exp> (else <block-or-exp>)? Conditional
  switch <exp> { (case <pat> <block-or-exp>;)+ } Switch
  while <exp> <block-or-exp>                     While loop
  loop <block-or-exp> (while <exp>)?             Loop
  for ( <pat> in <exp> ) <block-or-exp>          Iteration
  label <id> (: <typ>)? <block-or-exp>           Label
  break <id> <exp>?                              Break
  continue <id>                                  Continue
  return <exp>?                                  Return
  <parenthetical>? async <block-or-exp>          Async expression
  await <block-or-exp>                           Await future (only in async)
  async* <block-or-exp>                          Delay an asynchronous computation
  await* <block-or-exp>                          Await a delayed computation (only in async)
  throw <exp>                                    Raise an error (only in async)
  try <block-or-exp> catch <pat> <block-or-exp>  Catch an error (only in async)
  try <block-or-exp> finally <block-or-exp>      Guard with cleanup
  try <block-or-exp> catch <pat> <block-or-exp> finally <block-or-exp>
                                                 Catch an error (only in async) and cleanup
  assert <block-or-exp>                          Assertion
  <exp> : <typ>                                  Type annotation
  <dec>                                          Declaration
  ignore <block-or-exp>                          Ignore value
  do <block>                                     Block as expression
  do ? <block>                                   Option block
  <exp> !                                        Null break
  debug <block-or-exp>                           Debug expression
  actor <exp>                                    Actor reference
  to_candid ( <exp>,* )                          Candid serialization
  from_candid <exp>                              Candid deserialization
  (system <exp> . <id>)                          System actor class constructor
  ( <exp> )                                      Parentheses

<block-or-exp> ::=
  <block>
  <exp>

<block> ::=
  { <dec>;* }
```

### Patrones

La sintaxis de un patrón es la siguiente:

```bnf
<pat> ::=                                      Patterns
  _                                              Wildcard
  <id>                                           Variable
  <unop>? <lit>                                  Literal
  ( <pat>,* )                                    Tuple or brackets
  { <pat-field>;* }                              Object pattern
  # <id> <pat>?                                  Variant pattern
  ? <pat>                                        Option
  <pat> : <typ>                                  Type annotation
  <pat> or <pat>                                 Disjunctive pattern

<pat-field> ::=                                Object pattern fields
  <id> (: <typ>) = <pat>                         Field
  <id> (: <typ>)                                 Punned field
```

## Sintaxis de tipos

Las expresiones de tipo se utilizan para especificar los tipos de argumentos,
restricciones en los parámetros de tipo, definiciones de constructores de tipo y
los tipos de subexpresiones en anotaciones de tipo.

```bnf
<typ> ::=                                     Type expressions
  <path> <type-typ-args>?                       Constructor
  <typ-sort>? { <typ-field>;* }                 Object
  { <typ-tag>;* }                               Variant
  { # }                                         Empty variant
  [ var? <typ> ]                                Array
  Null                                          Null type
  ? <typ>                                       Option
  <shared>? <typ-params>? <typ> -> <typ>        Function
  async <typ>                                   Future
  async* <typ>                                  Delayed, asynchronous computation
  ( ((<id> :)? <typ>),* )                       Tuple
  Any                                           Top
  None                                          Bottom
  <typ> and <typ>                               Intersection
  <typ> or <typ>                                Union
  Error                                         Errors/exceptions
  ( <typ> )                                     Parenthesized type


<typ-sort> ::= (actor | module | object)

<shared> ::=                                 Shared function type qualifier
  shared <query>?

<path> ::=                                   Paths
  <id>                                         Type identifier
  <path> . <id>                                Projection
```

Un `<sort>?` ausente abrevia `object`.

### Tipos primitivos

Motoko proporciona los siguientes identificadores de tipos primitivos,
incluyendo soporte para booleanos, enteros con y sin signo y palabras de máquina
de varios tamaños, caracteres y texto.

La categoría de un tipo determina los operadores (unarios, binarios,
relacionales y actualización in-place a través de asignación) aplicables a los
valores de ese tipo.

| Identificador                       | Categoría | Descripción                                                       |
| ----------------------------------- | --------- | ----------------------------------------------------------------- |
| [`Bool`](../base/Bool.md)           | L         | Valores booleanos `true` y `false` y operadores lógicos           |
| [`Char`](../base/Char.md)           | O         | Caracteres Unicode                                                |
| [`Text`](../base/Text.md)           | T, O      | Cadenas de texto Unicode con concatenación `_ # _` e iteración    |
| [`Float`](../base/Float.md)         | A, O      | Valores de punto flotante de 64 bits                              |
| [`Int`](../base/Int.md)             | A, O      | Valores enteros con signo con aritmética (sin límite)             |
| [`Int8`](../base/Int8.md)           | A, O      | Valores enteros con signo de 8 bits con aritmética verificada     |
| [`Int16`](../base/Int16.md)         | A, O      | Valores enteros con signo de 16 bits con aritmética verificada    |
| [`Int32`](../base/Int32.md)         | A, O      | Valores enteros con signo de 32 bits con aritmética verificada    |
| [`Int64`](../base/Int64.md)         | A, O      | Valores enteros con signo de 64 bits con aritmética verificada    |
| [`Nat`](../base/Nat.md)             | A, O      | Valores enteros no negativos con aritmética (sin límite)          |
| [`Nat8`](../base/Nat8.md)           | A, O      | Valores enteros no negativos de 8 bits con aritmética verificada  |
| [`Nat16`](../base/Nat16.md)         | A, O      | Valores enteros no negativos de 16 bits con aritmética verificada |
| [`Nat32`](../base/Nat32.md)         | A, O      | Valores enteros no negativos de 32 bits con aritmética verificada |
| [`Nat64`](../base/Nat64.md)         | A, O      | Valores enteros no negativos de 64 bits con aritmética verificada |
| [`Blob`](../base/Blob.md)           | O         | Bloques binarios con iteradores                                   |
| [`Principal`](../base/Principal.md) | O         | Principales                                                       |
| [`Error`](../base/Error.md)         |           | Valores de error (opacos)                                         |
| [`Region`](../base/Region.md)       |           | Objetos de región de memoria estable (opacos)                     |

Aunque muchos de estos tipos tienen soporte lingüístico para literales y
operadores, cada tipo primitivo también tiene una librería base homónima que
proporciona funciones y valores relacionados. Por ejemplo, la librería
[`Text`](../base/Text.md) proporciona funciones comunes sobre valores de `Text`.

### Tipo [`Bool`](../base/Bool.md)

El tipo [`Bool`](../base/Bool.md) de categoría L (Lógico) tiene los valores
`true` y `false` y es compatible con expresiones de una y dos ramas
`if _ <exp> (else <exp>)?`, `not <exp>`, `_ and _` y `_ or _`. Las expresiones
`if`, `and` y `or` son de cortocircuito.

<!--
TODO: Comparison.
-->

### Tipo `Char`

Un `Char` de categoría O (Ordenado) representa un carácter como un punto de
código en el conjunto de caracteres Unicode.

La función `Char.toNat32(c)` de la librería base convierte un valor `Char`, `c`,
a su punto de código [`Nat32`](../base/Nat32.md). La función `Char.fromNat32(n)`
convierte un valor [`Nat32`](../base/Nat32.md), `n`, en el rango _0x0..xD7FF_ o
_0xE000..0x10FFFF_ de puntos de código válidos a su valor `Char`; esta
conversión atrapa argumentos inválidos. La función `Char.toText(c)` convierte el
`Char` `c` en el valor de [`Text`](../base/Text.md) correspondiente, que es un
solo carácter.

### Tipo [`Text`](../base/Text.md)

El tipo [`Text`](../base/Text.md) de categorías T y O (Texto, Ordenado)
representa secuencias de caracteres Unicode, es decir, cadenas de texto. La
función `t.size` devuelve el número de caracteres en el valor
[`Text`](../base/Text.md) `t`. Las operaciones en valores de texto incluyen
concatenación (`_ # _`) e iteración secuencial sobre caracteres a través de
`t.chars` como en `for (c : Char in t.chars()) { …​ c …​ }`.

<!--
TODO: Comparison.
-->

### Tipo `Float`

El tipo `Float` representa valores de punto flotante de 64 bits de las
categorías A (Aritmética) y O (Ordenado).

La semántica de `Float` y sus operaciones se ajusta a la norma estándar
[IEEE 754-2019](https://ieeexplore.ieee.org/document/8766229) (Consultar
[Referencias](#referencias)).

Las funciones y valores comunes se definen en la librería base "base/Float".

### Tipos [`Int`](../base/Int.md) y [`Nat`](../base/Nat.md)

Los tipos [`Int`](../base/Int.md) y [`Nat`](../base/Nat.md) son números enteros
con signo y números naturales de las categorías A (Aritmética) y O (Ordenado).

Tanto [`Int`](../base/Int.md) como [`Nat`](../base/Nat.md) son de precisión
arbitraria, con solo la resta `-` en [`Nat`](../base/Nat.md) que atrapa en caso
de desbordamiento.

La relación de subtipo `Nat <: Int` se cumple, por lo que cada expresión de tipo
[`Nat`](../base/Nat.md) también es una expresión de tipo
[`Int`](../base/Int.md), pero no viceversa. En particular, cada valor de tipo
[`Nat`](../base/Nat.md) también es un valor de tipo [`Int`](../base/Int.md), sin
cambio de representación.

### Enteros acotados [`Int8`](../base/Int8.md), [`Int16`](../base/Int16.md), [`Int32`](../base/Int32.md) y [`Int64`](../base/Int64.md)

Los tipos [`Int8`](../base/Int8.md), [`Int16`](../base/Int16.md),
[`Int32`](../base/Int32.md) y [`Int64`](../base/Int64.md) representan enteros
con signo con precisión de 8, 16, 32 y 64 bits respectivamente. Todos tienen las
categorías A (Aritmética), B (Bitwise) y O (Ordenado).

Las operaciones que pueden causar desbordamiento o subdesbordamiento de la
representación son verificadas y generan un error.

Las operaciones `+%`, `-%`, `*%` y `**%` proporcionan acceso a la aritmética
modular de envoltura.

Como tipos bitwise, estos tipos admiten operaciones bitwise y (`&`), or (`|`) y
xor (`^`). Además, se pueden rotar a la izquierda (`<<>`), a la derecha (`<>>`)
y desplazar a la izquierda (`<<`), a la derecha (`>>`). El desplazamiento a la
derecha preserva el signo en complemento a dos. Todos los desplazamientos y
rotaciones se consideran módulo el ancho de bits del número.

Los tipos de enteros acotados no están en una relación de subtipo entre sí ni
con otros tipos aritméticos, y sus literales necesitan una anotación de tipo si
el tipo no se puede inferir del contexto, por ejemplo, `(-42 : Int16)`.

El módulo correspondiente en la librería base proporciona funciones de
conversión:

- Conversión a [`Int`](../base/Int.md).

- Conversiones verificadas y de envoltura desde [`Int`](../base/Int.md).

- Conversión de envoltura al tipo natural acotado del mismo tamaño.

### Naturales acotados [`Nat8`](../base/Nat8.md), [`Nat16`](../base/Nat16.md), [`Nat32`](../base/Nat32.md) y [`Nat64`](../base/Nat64.md)

Los tipos [`Nat8`](../base/Nat8.md), [`Nat16`](../base/Nat16.md),
[`Nat32`](../base/Nat32.md) y [`Nat64`](../base/Nat64.md) representan enteros
sin signo con precisión de 8, 16, 32 y 64 bits respectivamente. Todos tienen las
categorías A (Aritmética), B (Bitwise) y O (Ordenado).

Las operaciones que pueden causar desbordamiento o subdesbordamiento de la
representación son verificadas y generan un error.

Las operaciones `+%`, `-%`, `*%` y `**%` proporcionan acceso a las operaciones
modulares de envoltura.

Como tipos bitwise, estos tipos admiten operaciones bitwise y (`&`), or (`|`) y
xor (`^`). Además, se pueden rotar a la izquierda (`<<>`), a la derecha (`<>>`)
y desplazar a la izquierda (`<<`), a la derecha (`>>`). El desplazamiento a la
derecha es lógico. Todos los desplazamientos y rotaciones se consideran módulo
el ancho de bits del número.

El módulo correspondiente en la librería base proporciona funciones de
conversión:

- Conversión a [`Nat`](../base/Nat.md).

- Conversiones verificadas y de envoltura desde [`Nat`](../base/Nat.md).

- Conversión de envoltura al tipo de entero acotado y con signo del mismo
  tamaño.

### Tipo [`Blob`](../base/Blob.md)

El tipo [`Blob`](../base/Blob.md) de categoría O (Ordenado) representa bloques
binarios o secuencias de bytes. La función `b.size()` devuelve el número de
caracteres en el valor [`Blob`](../base/Blob.md) `b`. Las operaciones en valores
de blob incluyen la iteración secuencial sobre bytes a través de la función
`b.values()` como en `for (v : Nat8 in b.values()) { …​ v …​ }`.

### Tipo [`Principal`](../base/Principal.md)

El tipo [`Principal`](../base/Principal.md) de categoría O (Ordenado) representa
principales opacos como canisters y usuarios que se pueden utilizar para
identificar los llamadores de funciones compartidas y para la autenticación
simple. Aunque son opacos, los principales se pueden convertir en valores
binarios de [`Blob`](../base/Blob.md) para un hash más eficiente y otras
aplicaciones.

### Tipo de Error

Suponiendo la importación de la librería base:

```motoko no-repl
import E "mo:base/Error";
```

Los errores son valores opacos construidos y examinados con operaciones:

- `E.reject : Text -> Error`

- `E.code : Error -> E.ErrorCode`

- `E.message : Error -> Text`

El tipo `E.ErrorCode` es equivalente al tipo de variante:

```motoko no-repl
type ErrorCode = {
  // Fatal error.
  #system_fatal;
  // Transient error.
  #system_transient;
  // Response unknown due to missed deadline.
  #system_unknown;
  // Destination invalid.
  #destination_invalid;
  // Explicit reject by canister code.
  #canister_reject;
  // Canister trapped.
  #canister_error;
  // Future error code (with unrecognized numeric code).
  #future : Nat32;
  // Error issuing inter-canister call
  // (indicating destination queue full or freezing threshold crossed).
  #call_error : { err_code : Nat32 }
};
```

Un error construido `e = E.reject(t)` tiene `E.code(e) = #canister_reject` y
`E.message(e) = t`.

Los valores de [`Error`](../base/Error.md) pueden ser lanzados y capturados
dentro de una expresión `async` o una función `shared` solamente. Ver
[throw](#throw) y [try](#try).

Los errores con códigos diferentes a `#canister_reject`, es decir, errores del
sistema, pueden ser capturados y lanzados, pero no construidos por el usuario.

:::note

Salir de un bloque `async` o una función `shared` con un error del sistema que
no sea `#canister_reject` produce una copia del error con el código revisado
`#canister_reject` y el mensaje original de [`Text`](../base/Text.md). Esto
evita la falsificación programática de errores del sistema.

:::

:::note

En ICP, el acto de realizar una llamada a una función del canister puede fallar,
de modo que la llamada no se puede (y no se realizará). Esto puede ocurrir
debido a la falta de recursos del canister, típicamente porque la cola de
mensajes local para el canister de destino está llena, o porque realizar la
llamada reduciría el saldo de ciclos actual del canister llamador a un nivel por
debajo de su umbral de congelación. Estos fallos de llamada se informan lanzando
un [`Error`](../base/Error.md) con el código `#call_error { err_code = n }`,
donde `n` es el valor `err_code` no nulo devuelto por ICP. Al igual que otros
errores, los errores de llamada se pueden capturar y manejar utilizando
expresiones `try ... catch ...`, si se desea.

:::

### Tipo `Region`

El tipo `Region` representa regiones de memoria estables opacas. Los objetos de
región se asignan dinámicamente y pueden crecer de forma independiente.
Representan particiones aisladas de la memoria estable de IC.

El tipo de región es estable pero no compartido y sus objetos, que son de
estado, se pueden almacenar en variables y estructuras de datos estables.

Los objetos de tipo `Region` se crean y actualizan utilizando las funciones
proporcionadas por la librería base `Region`. Consulta
[regiones estables](../stable-memory/stable-regions.md) y la librería
[Region](../base/Region.md) para obtener más información.

### Tipos construidos

`<path> <type-typ-args>?` es la aplicación de un identificador de tipo o ruta,
ya sea incorporado (es decir, [`Int`](../base/Int.md)) o definido por el
usuario, a cero o más argumentos de tipo. Los argumentos de tipo deben cumplir
con los límites, si los hay, esperados por los parámetros de tipo del
constructor de tipo (consulte [Tipos bien formados](#well-formed-types)).

Aunque típicamente es un identificador de tipo, más generalmente, `<path>` puede
ser una secuencia separada por `.` de identificadores de actor, objeto o módulo
que termina en un identificador que accede a un componente de tipo de un valor
(por ejemplo, `Acme.Collections.List`).

### Tipos de objetos

`<typ-sort>? { <typ-field>;* }` especifica un tipo de objeto enumerando sus cero
o más **campos de tipo** nombrados.

Dentro de un tipo de objeto, los nombres de los campos deben ser distintos tanto
por nombre como por valor hash.

Los tipos de objeto que difieren solo en el orden de los campos son
equivalentes.

Cuando `<typ-sort>?` es `actor`, todos los campos tienen un tipo de función
`shared` para especificar mensajes.

### Tipos de variantes

`{ <typ-tag>;* }` especifica un tipo de variante enumerando sus campos de tipo
de variante como una secuencia de `<typ-tag>`.

Dentro de un tipo de variante, las etiquetas de sus variantes deben ser
distintas tanto por nombre como por valor hash.

Los tipos de variantes que difieren solo en el orden de sus campos de tipo de
variante son equivalentes.

`{ # }` especifica el tipo de variante vacío.

### Tipos de arreglos

`[ var? <typ> ]` especifica el tipo de arreglos con elementos de tipo `<typ>`.

Los arreglos son inmutables a menos que se especifique con el calificador `var`.

### Tipo Null

El tipo `Null` tiene un único valor, el literal `null`. `Null` es un subtipo de
la opción `? T`, para cualquier tipo `T`.

### Tipos de opción

`? <typ>` especifica el tipo de valores que son `null` o un valor propio de la
forma `? <v>` donde `<v>` tiene tipo `<typ>`.

### Tipos de funciones

El tipo `<shared>? <typ-params>? <typ1> -> <typ2>` especifica el tipo de
funciones que consumen parámetros de tipo opcionales `<typ-params>`, consumen un
parámetro de valor de tipo `<typ1>` y producen un resultado de tipo `<typ2>`.

Tanto `<typ1>` como `<typ2>` pueden hacer referencia a parámetros de tipo
declarados en `<typ-params>`.

Si `<typ1>` o `<typ2>` o ambos son un tipo de tupla, entonces la longitud de esa
tupla determina la _aridad_ del argumento o resultado del tipo de función. La
aridad es el número de argumentos o resultados que devuelve una función.

El calificador opcional `<shared>` especifica si el valor de la función es
compartido, lo que restringe aún más la forma de `<typ-params>`, `<typ1>` y
`<typ2>` (consulta [compartibilidad](#compartibilidad-shareability) a
continuación).

Ten en cuenta que una función `<shared>` puede ser `shared`, `shared query` o
`shared composite query`, lo que determina la persistencia de sus cambios de
estado.

### Tipos asíncronos

`async <typ>` especifica un futuro que produce un valor de tipo `<typ>`.

Los tipos de futuro suelen aparecer como el tipo de resultado de una función
`shared` que produce un valor `await`-able.

### Tipos async\*

`async* <typ>` especifica una computación asíncrona retrasada que produce un
valor de tipo `<typ>`.

Los tipos de computación suelen aparecer como el tipo de resultado de una
función `local` que produce un valor `await*`-able.

No pueden usarse como tipos de retorno de funciones `shared`.

### Tipos de tuplas

`( ((<id> :)? <typ>),* )` especifica el tipo de una tupla con cero o más
componentes ordenados.

El identificador opcional `<id>`, que nombra sus componentes, es solo para fines
de documentación y no se puede usar para acceder a los componentes. En
particular, los tipos de tupla que difieren solo en los nombres de los
componentes son equivalentes.

El tipo de tupla vacía `()` se llama _tipo unitario_.

### Tipo Any

El tipo `Any` es el tipo superior, es decir, el supertipo de todos los tipos.
Todos los valores tienen tipo `Any`.

### Tipo None

El tipo `None` es el tipo inferior, el subtipo de todos los demás tipos. Ningún
valor tiene tipo `None`.

Como un tipo vacío, `None` se puede usar para especificar el valor de retorno
imposible de un bucle infinito o un error incondicional.

### Tipo de intersección

La expresión de tipo `<typ1> and <typ2>` denota la **intersección** sintáctica
entre sus dos operandos de tipo, es decir, el tipo más grande que es un subtipo
de ambos. Si ambos tipos son incompatibles, la intersección es `None`.

La intersección es sintáctica, en el sentido de que no considera posibles
instanciaciones de variables de tipo. La intersección de dos variables de tipo
es `None`, a menos que sean iguales o que una se declare como un subtipo
(directo o indirecto) de la otra.

### Tipo de unión

La expresión de tipo `<typ1> or <typ2>` denota la **unión** sintáctica entre sus
dos operandos de tipo, es decir, el tipo más pequeño que es un supertipo de
ambos. Si ambos tipos son incompatibles, la unión es `Any`.

La unión es sintáctica, en el sentido de que no considera posibles
instanciaciones de variables de tipo. La unión de dos variables de tipo es la
unión de sus límites, a menos que las variables sean iguales o que una se
declare como un subtipo directo o indirecto de la otra.

### Tipo entre paréntesis

Una función que toma una tupla sintáctica inmediata de longitud `n >= 0` como su
dominio o rango es una función que toma y devuelve, respectivamente, `n`
valores.

Cuando se encierra el tipo de argumento o resultado de una función, que es en sí
mismo un tipo de tupla, `( <tuple-typ> )` declara que la función toma o devuelve
un único valor empaquetado de tipo `<tuple-type>`.

En todas las demás posiciones, `( <typ> )` tiene el mismo significado que
`<typ>`.

### Campos de tipo

```bnf
<typ-field> ::=                               Object type fields
  <id> : <typ>                                  Immutable value
  var <id> : <typ>                              Mutable value
  <id> <typ-params>? <typ1> : <typ2>            Function value (short-hand)
  type <id> <type-typ-params>? = <typ>          Type component
```

Un campo de tipo especifica el nombre y tipo de un campo de valor de un objeto,
o el nombre y definición de un componente de tipo de un objeto. Los nombres de
los campos de valor dentro de un solo tipo de objeto deben ser distintos y tener
hashes no colisionantes. Los nombres de los componentes de tipo dentro de un
solo tipo de objeto también deben ser distintos y tener hashes no colisionantes.
Los campos de valor y los componentes de tipo residen en espacios de nombres
separados y, por lo tanto, pueden tener nombres en común.

`<id> : <typ>`: Especifica un campo **inmutable**, llamado `<id>`, de tipo
`<typ>`.

`var <id> : <typ>`: Especifica un campo **mutable**, llamado `<id>`, de tipo
`<typ>`.

`type <id> <type-typ-params>? = <typ>`: Especifica un **componente de tipo**,
con nombre de campo `<id>`, abreviando el tipo parametrizado `<typ>`.

A diferencia de las declaraciones de tipo, un componente de tipo no es, en sí
mismo, recursivo, aunque puede abreviar un tipo recursivo existente. En
particular, el nombre `<id>` no está vinculado en `<typ>` ni en ningún otro
campo del tipo de objeto que lo contiene. El nombre `<id>` solo determina la
etiqueta que se utiliza al acceder a la definición a través de un registro de
este tipo utilizando la notación de punto.

### Campos de tipo de variante

```bnf
<typ-tag> ::=                                 Variant type fields
  # <id> : <typ>                                Tag
  # <id>                                        Unit tag (short-hand)
```

Un campo de tipo de variante especifica la etiqueta y el tipo de una única
variante de un tipo de variante que lo contiene. Las etiquetas dentro de un tipo
de variante deben ser distintas y tener hashes no colisionantes.

`# <id> : <typ>` especifica un campo inmutable, llamado `<id>` de tipo `<typ>`.
`# <id>` es un atajo para un campo inmutable, llamado `<id>` de tipo `()`.

### Sugar syntax

Cuando está encerrado por un tipo de objeto `actor`,
`<id> <typ-params>? <typ1> : <typ2>` es sugar syntax para un campo inmutable
llamado `<id>` de tipo de función `shared`
`shared <typ-params>? <typ1> → <typ2>`.

Cuando está encerrado por un tipo de objeto que no es `actor`,
`<id> <typ-params>? <typ1> : <typ2>` es sugar syntax para un campo inmutable
llamado `<id>` de tipo de función ordinaria `<typ-params>? <typ1> → <typ2>`.

### Parámetros de tipo

```bnf
<typ-params> ::=                              Type parameters
  < typ-param,* >
<typ-param>
  <id> <: <typ>                               Constrained type parameter
  <id>                                        Unconstrained type parameter
```

```bnf
<type-typ-params> ::=                         Type parameters to type constructors
  < typ-param,* >

<typ-params> ::=                              Function type parameters
  < typ-param,* >                             Type parameters
  < system (, <typ-param>*)) >                System capability prefixed type parameters

<typ-param>
  <id> <: <typ>                               Constrained type parameter
  <id>                                        Unconstrained type parameter

```

Un constructor de tipos puede ser parametrizado por un vector de parámetros de
tipo separados por comas, opcionalmente restringidos.

Una función, constructor de clase o tipo de función puede ser parametrizado por
un vector de parámetros de tipo separados por comas, opcionalmente restringidos.
El primero de estos puede ser el parámetro de tipo especial y pseudo `system`.

`<id> <: <typ>` declara un parámetro de tipo con la restricción `<typ>`.
Cualquier instancia de `<id>` debe ser un subtipo de `<typ>` en esa misma
instancia.

La sintaxis de azúcar `<id>` declara un parámetro de tipo con una restricción
implícita y trivial `Any`.

Los nombres de los parámetros de tipo en un vector deben ser distintos.

Todos los parámetros de tipo declarados en un vector están en el ámbito de sus
restricciones.

El parámetro de tipo pseudo `system` en los tipos de función indica que un valor
de ese tipo requiere la capacidad `system` para ser llamado y puede llamar a su
vez a funciones que requieren la capacidad `system` durante su ejecución.

### Argumentos de tipo

```bnf
<type-typ-args> ::=                           Type arguments to type constructors
  < <typ>,* >


<typ-args> ::=                                Type arguments to functions
  < <typ>,* >                                   Plain type arguments
  < system (, <typ>*) >                         System capability prefixed type arguments

```

Los constructores de tipos y las funciones pueden tomar argumentos de tipo.

El número de argumentos de tipo debe coincidir con el número de parámetros de
tipo declarados del constructor de tipo.

Para una función, el número de argumentos de tipo, cuando se proporciona, debe
coincidir con el número de parámetros de tipo declarados del tipo de la función.
Ten en cuenta que los argumentos de tipo en las aplicaciones de funciones
generalmente se pueden omitir y ser inferidos por el compilador.

Dado un vector de argumentos de tipo que instancian un vector de parámetros de
tipo, cada argumento de tipo debe satisfacer los límites instanciados del
parámetro de tipo correspondiente.

En las llamadas a funciones, proporcionar el argumento de tipo pseudo `system`
otorga la capacidad del sistema a la función que lo requiere.

La capacidad del sistema está disponible solo en los siguientes contextos
sintácticos:

- En el cuerpo de una expresión de actor o clase de actor.
- En el cuerpo de una función `shared` (no `query`), función asíncrona,
  expresión `async` o expresión `async*`.
- En el cuerpo de una función o clase que se declara con un parámetro de tipo
  pseudo `system`.
- En las funciones del sistema `preupgrade` y `postupgrade`.

Ningún otro contexto proporciona capacidades del sistema, incluyendo los métodos
`query` y `composite query`.

Los parámetros de tipo `<system>` de las funciones compartidas y asíncronas no
necesitan ser declarados.

### Tipos bien formados

Un tipo `T` está bien formado solo si, de manera recursiva, sus tipos
constituyentes están bien formados, y:

- Si `T` es `async U` o `async* U`, entonces `U` es compartido, y

- Si `T` es `shared <query>? U -> V`:

  - `U` es compartido y,
  - `V == ()` y `<query>?` está ausente, o
  - `V == async W` con `W` compartido, y

- Si `T` es `C<T0, …​, Tn>` donde:

  - Una declaración `type C<X0 <: U0, Xn <: Un> = …​` está en el alcance, y

  - `Ti <: Ui[ T0/X0, …​, Tn/Xn ]`, para cada `0 <= i <= n`.

- Si `T` es `actor { …​ }`, entonces todos los campos en `…​` son inmutables y
  tienen tipo de función `shared`.

### Subtipificación

Dos tipos `T`, `U` están relacionados por subtipificación, escrito `T <: U`,
cuando una de las siguientes condiciones es verdadera:

- `T` es igual a `U` (la subtipificación es _reflexiva_).

- `U` es igual a `Any`.

- `T` es igual a `None`.

- `T` es un parámetro de tipo `X` declarado con la restricción `U`.

- `T` es [`Nat`](../base/Nat.md) y `U` es [`Int`](../base/Int.md).

- `T` es una tupla `(T0, …​, Tn)`, `U` es una tupla `(U0, …​, Un)`, y para cada
  `0 <= i <= n`, `Ti <: Ui`.

- `T` es un tipo de arreglo inmutable `[ V ]`, `U` es un tipo de arreglo
  inmutable `[ W ]` y `V <: W`.

- `T` es un tipo de arreglo mutable `[ var V ]`, `U` es un tipo de arreglo
  mutable `[ var W ]` y `V == W`.

- `T` es `Null` y `U` es un tipo de opción `? W` para algún `W`.

- `T` es `? V`, `U` es `? W` y `V <: W`.

- `T` es un futuro `async V`, `U` es un futuro `async W`, y `V <: W`.

- `T` es un tipo de objeto `<typ-sort0> { fts0 }`, `U` es un tipo de objeto
  `<typ-sort1> { fts1 }` y

  - `<typ-sort0>` == `<typ-sort1>`, y, para todos los campos,

  - Si el campo `id : W` está en `fts1`, entonces `id : V` está en `fts0` y
    `V <: W`, y

  - Si el campo mutable `var id : W` está en `fts1`, entonces `var id : V` está
    en `fts0` y `V == W`.

    Es decir, el tipo de objeto `T` es un subtipo del tipo de objeto `U` si
    tienen el mismo tipo, cada campo mutable en `U` supertipa el mismo campo en
    `T` y cada campo mutable en `U` es mutable en `T` con un tipo equivalente.
    En particular, `T` puede especificar más campos que `U`. Ten en cuenta que
    esta cláusula define la subtipificación para todos los tipos de objeto, ya
    sea `module`, `object` o `actor`.

- `T` es un tipo de variante `{ fts0 }`, `U` es un tipo de variante `{ fts1 }` y

  - Si el campo `# id : V` está en `fts0`, entonces `# id : W` está en `fts1` y
    `V <: W`.

    Es decir, el tipo de variante `T` es un subtipo del tipo de variante `U` si
    cada campo de `T` subtipa el mismo campo de `U`. En particular, `T` puede
    especificar menos variantes que `U`.

- `T` es un tipo de función `<shared>? <X0 <: V0, ..., Xn <: Vn> T1 -> T2`, `U`
  es un tipo de función `<shared>? <X0 <: W0, ..., Xn <: Wn> U1 -> U2` y

  - `T` y `U` son ambos equivalentemente `<shared>?`, y

  - Asumiendo las restricciones `X0 <: W0, …​, Xn <: Wn`, entonces

    - para todo `i`, `Wi == Vi`, y

    - `U1 <: T1`, y

    - `T2 <: U2`.

      Es decir, el tipo de función `T` es un subtipo del tipo de función `U` si
      tienen la misma calificación `<shared>?`, tienen los mismos parámetros de
      tipo (módulo renombramiento) y asumiendo los límites en `U`, cada límite
      en `T` supertipa el límite de parámetro correspondiente en `U`
      (contravarianza), el dominio de `T` supertipa el dominio de `U`
      (contravarianza) y el rango de `T` subtipa el rango de `U` (covarianza).

- `T` (respectivamente `U`) es un tipo construido `C<V0, …​, Vn>` que es igual,
  por definición del constructor de tipo `C`, a `W`, y `W <: U` (respectivamente
  `U <: W`).

- Para algún tipo `V`, `T <: V` y `V <: U` (_transitividad_).

### Compartibilidad (Shareability)

Un tipo `T` es **compartido** si:

- Es `Any` o `None`, o

- Es un tipo primitivo que no sea [`Error`](../base/Error.md), o

- Es un tipo de opción `? V` donde `V` es compartido, o

- Es un tipo de tupla `(T0, …​, Tn)` donde todos los `Ti` son compartidos, o

- Es un tipo de arreglo inmutable `[V]` donde `V` es compartido, o

- Es un tipo de objeto donde todos los campos son inmutables y tienen tipo
  compartido, o

- Es un tipo de variante donde todas las etiquetas tienen tipo compartido, o

- Es un tipo de función compartida, o

- Es un tipo de `actor`.

### Estabilidad

La estabilidad extiende la compartibilidad para incluir tipos mutables. Más
precisamente:

Un tipo `T` es **estable** si es:

- `Any` o `None`, o

- Un tipo primitivo que no sea [`Error`](../base/Error.md), o

- Un tipo de opción `? V` donde `V` es estable, o

- Un tipo de tupla `(T0, …​, Tn)` donde todos los `Ti` son estables, o

- Un tipo de arreglo (mutable o inmutable) `[var? V]` donde `V` es estable, o

- Un tipo de `object` donde todos los campos tienen tipo estable, o

- Un tipo de variante donde todas las etiquetas tienen tipo estable, o

- Un tipo de función compartida, o

- Un tipo de `actor`.

Esta definición implica que todo tipo compartido es un tipo estable. Lo
contrario no es cierto: hay tipos que son estables pero no compartidos,
notablemente tipos con componentes mutables.

Los tipos de campos de actores declarados con el calificador `stable` deben
tener tipo estable.

El valor actual de dicho campo se conserva durante una actualización, mientras
que los valores de otros campos se reinicializan después de una actualización.

Nota: el tipo primitivo `Region` es estable.

## Semántica estática y dinámica

A continuación se presenta un resumen detallado de la semántica de los programas
de Motoko.

Para cada [forma de expresión](#sintaxis-de-expresión) y cada
[forma de declaración](#sintaxis-de-declaración), esta página resume su
semántica, tanto en términos estáticos basados en la tipificación como en
términos dinámicos basados en la evaluación del programa.

### Programas

Un programa `<imp>;* <dec>;*` tiene tipo `T` siempre que:

- `<dec>;*` tiene tipo `T` bajo el entorno estático inducido por las
  importaciones en `<imp>;*`.

Todas las declaraciones de tipo y valor dentro de `<dec>;*` son mutuamente
recursivas.

Un programa se evalúa mediante la evaluación transitiva de las importaciones,
vinculando sus valores a los identificadores en `<imp>;*` y luego evaluando la
secuencia de declaraciones en `<dec>;*`.

### Librerías

Las restricciones en la forma sintáctica de los módulos significan que las
librerías no pueden tener efectos secundarios.

Las importaciones de una librería son locales y no se reexportan en su interfaz.

Las importaciones múltiples de la misma librería se pueden deduplicar de forma
segura sin pérdida de efectos secundarios.

#### Librerías de módulos

Una librería `<imp>;* module <id>? (: <typ>)? =? <obj-body>` es una secuencia de
importaciones `<import>;*` seguida de una única declaración de módulo.

Una librería tiene un tipo de módulo `T` siempre que:

- `module <id>? (: <typ>)? =? <obj-body>` tiene un tipo (de módulo) `T` bajo el
  entorno estático inducido por las importaciones en `<import>;*`.

Una librería de módulos se evalúa mediante la evaluación transitiva de sus
importaciones, vinculando sus valores a los identificadores en `<imp>;*` y luego
evaluando `module <id>? =? <obj-body>`.

Si `(: <typ>)?` está presente, entonces `T` debe ser un subtipo de `<typ>`.

#### Librerías de clases de actores

La librería de clases de actores `<imp>;* <dec>` donde `<dec>` tiene la forma
`<shared-pat>? actor class <id> <typ-params>? <pat> (: <typ>)? <class-body>`
tiene el tipo:

```bnf
module {
  type <id> = T;
  <id> : (U1,...,Un) -> async T
}
```

Proporcionado que la declaración de la clase de actor `<dec>` tiene un tipo de
función `(U1, ...​, Un) -> async T` bajo el entorno estático inducido por las
importaciones en `<import>;*`.

Ten en cuenta que el tipo importado de la función `<id>` debe ser asíncrono.

Una librería de clases de actores se evalúa mediante la evaluación transitiva de
sus importaciones, vinculando sus valores a los identificadores en `<imp>;*`, y
evaluando el módulo derivado:

```bnf
module {
  <dec>
}
```

En ICP, si esta librería se importa como identificador `Lib`, entonces llamar a
`await Lib.<id>(<exp1>, ..., <expn>)`, instala una nueva instancia de la clase
de actor como un canister IC aislado, pasando los valores de `<exp1>`, ...​,
`<expn>` como argumentos de instalación, y devuelve una referencia a un actor
remoto de tipo `Lib.<id>`, es decir, `T`. La instalación es necesariamente
asíncrona.

#### Gestión de clases de actores

En ICP, el constructor principal de una clase de actor importada siempre crea un
nuevo principal e instala una nueva instancia de la clase como el código para
ese principal. Si bien esa es una forma de instalar un canister en ICP, no es la
única forma.

Para proporcionar un mayor control sobre la instalación de clases de actores,
Motoko dota a cada clase de actor importada de un constructor secundario
adicional, para su uso en ICP. Este constructor toma un primer argumento
adicional que personaliza la instalación. El constructor solo está disponible a
través de una sintaxis especial que resalta su funcionalidad `system`.

Dado algún constructor de clase de actor:

```motoko no-repl
Lib.<id> : (U1, ...​, Un) -> async T
```

Su constructor secundario se accede como `(system Lib.<id>)` con la
tipificación:

```motoko no-repl
(system Lib.<id>) :
  { #new : CanisterSettings;
    #install : Principal;
    #reinstall : actor {} ;
    #upgrade : actor {} }  ->
    (U1, ...​, Un) -> async T
```

donde:

```motoko no-repl
  type CanisterSettings = {
     settings : ?{
        controllers : ?[Principal];
        compute_allocation : ?Nat;
        memory_allocation : ?Nat;
        freezing_threshold : ?Nat;
     }
  }
```

Llamar a `(system Lib.<id>)(<exp>)(<exp1>, ...​, <expn>)` utiliza el primer
argumento `<exp>`, un valor de variante, para controlar la instalación del
canister más allá. Los argumentos `(<exp1>, ..., <expn>)` son simplemente los
argumentos del constructor declarados por el usuario de tipos `U1, ..., Un` que
también se pasarían al constructor principal.

Si `<exp>` es:

- `#new s`, donde `s` tiene tipo `CanisterSettings`:

  - La llamada crea un nuevo principal de ICP `p`, con configuraciones `s`, e
    instala la instancia en el principal `p`.

- `#install p`, donde `p` tiene tipo [`Principal`](../base/Principal.md):

  - La llamada instala el actor en un principal de ICP ya creado `p`. El
    principal debe estar vacío, sin código previamente instalado, o la llamada
    devolverá un error.

- `#upgrade a`, donde `a` tiene tipo (o supertipo) `actor {}`:

  - La llamada instala la instancia como una actualización del actor `a`,
    utilizando su almacenamiento estable actual para inicializar las variables
    estables y la memoria estable de la nueva instancia.

- `#reinstall a`, donde `a` tiene tipo (o supertipo) `actor {}`:

  - Reinstala la instancia sobre el actor existente `a`, descartando sus
    variables estables y memoria estable.

:::note

En ICP, llamar al constructor principal `Lib.<id>` es equivalente a llamar al
constructor secundario `(system Lib.<id>)` con el argumento
`(#new {settings = null})`, es decir, utilizando configuraciones
predeterminadas.

:::

:::note

En ICP, las llamadas a `Lib.<id>` y `(system Lib.<id>)(#new ...)` deben estar
provisionadas con suficientes ciclos para la creación de un nuevo principal.
Otras variantes de llamada utilizarán los ciclos del principal o actor ya
asignado.

:::

:::danger

El uso de `#upgrade a` puede ser inseguro. Motoko actualmente no verificará que
la actualización sea compatible con el código actualmente instalado en `a`. Una
futura extensión podría verificar la compatibilidad con una verificación
dinámica.

El uso de `#reinstall a` puede ser inseguro. Motoko no puede verificar que la
reinstalación sea compatible con el código actualmente instalado en el actor
`a`, incluso con una verificación dinámica. Un cambio en la interfaz podría
romper cualquier cliente existente de `a`. El estado actual de `a` se perderá.

:::

### Importaciones y URLs

Una importación `import <pat> =? <url>` declara un patrón `<pat>` vinculado al
contenido del literal de texto `<url>`.

`<url>` es un literal de texto que designa algún recurso: una librería local
especificada con una ruta relativa, un módulo nombrado de un paquete nombrado, o
un canister externo, referenciado por un id de canister numérico o por un alias
nombrado, e importado como un actor de Motoko.

En detalle, si `<url>` tiene la forma:

- `"<filepath>"`, entonces `<pat>` está vinculado al módulo de librería definido
  en el archivo `<filepath>.mo`. `<filepath>` se interpreta de manera relativa a
  la ubicación absoluta del archivo que lo contiene. Ten en cuenta que la
  extensión `.mo` es implícita y no debe incluirse en `<url>`. Por ejemplo,
  `import U "lib/Util"` define `U` para hacer referencia al módulo en el archivo
  local `./lib/Util`.

- `"mo:<package-name>/<path>"`, entonces `<pat>` está vinculado al módulo de
  librería definido en el archivo `<package-path>/<path>.mo` en el directorio
  `<package-path>` referenciado por el alias de paquete `<package-name>`. El
  mapeo de `<package-name>` a `<package-path>` se determina mediante un
  argumento de línea de comandos del compilador
  `--package <package-name> <package-path>`. Por ejemplo,
  `import L "mo:base/List"` define `L` para hacer referencia a la librería
  `List` en el alias de paquete `base`.

- `"ic:<canisterid>"`, entonces `<pat>` está vinculado a un actor de Motoko cuyo
  tipo de Motoko está determinado por la interfaz IDL del canister. La interfaz
  IDL del canister `<canisterid>` debe encontrarse en el archivo
  `<actorpath>/<canisterid>.did`. El compilador asume que `<actorpath>` se
  especifica mediante el argumento de línea de comandos
  `--actor-idl <actorpath>` y que el archivo `<actorpath>/<canisterid>.did`
  existe. Por ejemplo, `import C "ic:lg264-qjkae"` define `C` para hacer
  referencia al actor con el id de canister `lg264-qjkae` y el archivo IDL
  `lg264-qjkae.did`.

- `"canister:<name>"` es una referencia simbólica al alias de canister `<name>`.
  El compilador asume que el mapeo de `<name>` a `<canisterid>` se especifica
  mediante el argumento de línea de comandos
  `--actor-alias <name> ic:<canisterid>`. Si es así, `"canister:<name>"` es
  equivalente a `"ic:<cansterid>"` (ver arriba). Por ejemplo,
  `import C "canister:counter"` define `C` para hacer referencia al actor
  también conocido como `counter`.

La sensibilidad a mayúsculas y minúsculas de las referencias de archivos depende
del sistema operativo anfitrión, por lo que se recomienda no distinguir recursos
solo por el uso de mayúsculas y minúsculas en los nombres de archivo.

Al construir proyectos multi-canister con el
[IC SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install),
los programas de Motoko generalmente pueden importar canisters por alias (por
ejemplo, `import C "canister:counter"`), sin especificar ids de canister de bajo
nivel (por ejemplo, `import C "ic:lg264-qjkae"`). Las herramientas del SDK se
encargan de proporcionar los argumentos de línea de comandos apropiados al
compilador de Motoko).

Elecciones sensatas para `<pat>` son identificadores, como
[`Array`](../base/Array.md), o patrones de objetos como `{ cons; nil = empty }`,
que permiten la importación selectiva de campos individuales, bajo nombres
originales o otros nombres.

### Campos de declaración

Un campo de declaración `<vis>? <stab>? <dec>` define cero o más campos de un
actor u objeto, según el conjunto de variables definidas por `<dec>`.

Cualquier identificador vinculado por una declaración `public` aparece en el
tipo del objeto, módulo o actor que lo contiene y es accesible mediante la
notación de punto.

Un identificador vinculado por una declaración `private` o `system` se excluye
del tipo del objeto, módulo o actor que lo contiene y, por lo tanto, es
inaccesible.

En un actor o clase de actor `persistent`, todas las declaraciones son
implícitamente `stable` a menos que se declaren explícitamente de otra manera.
En un actor o clase de actor no `persistent`, todas las declaraciones son
implícitamente `transient` (equivalentemente `flexible`) a menos que se declaren
explícitamente de otra manera.

El campo de declaración tiene tipo `T` siempre que:

- `<dec>` tiene tipo `T`.

- Si `<stab>?` es `stable`, entonces `T` debe ser un tipo estable (ver
  [estabilidad](#stability)).

- Si `<stab>?` está ausente y el actor o clase de actor es `persistent`,
  entonces `T` debe ser un tipo estable (ver [estabilidad](#stabilidad)).

Los campos de actores declarados `transient` (o el legado `flexible`) pueden
tener cualquier tipo, pero no se conservarán a través de actualizaciones.

En ausencia de cualquier expresión de migración `<parenthetical>?`, las
secuencias de campos de declaración se evalúan en orden evaluando sus
declaraciones constituyentes, con la siguiente excepción:

- Durante una actualización únicamente, el valor de una declaración `stable` se
  obtiene de la siguiente manera:

  - Si la declaración estable se declaró previamente como estable en el actor
    retirado, su valor inicial se hereda del actor retirado.

  - Si la declaración estable no se declaró como estable en el actor retirado, y
    por lo tanto es nueva, su valor se obtiene evaluando `<dec>`.

- Para que una actualización sea segura:

  - Todo identificador estable declarado con tipo `T` en el actor retirado y
    declarado como estable y de tipo `U` en el actor de reemplazo, debe
    satisfacer `T <: U`.

Esta condición asegura que cada variable estable sea nueva, requiriendo
inicialización, o que su valor pueda heredarse de manera segura del actor
retirado. Ten en cuenta que las variables estables pueden eliminarse a través de
actualizaciones, o simplemente deprecarse mediante una actualización al tipo
`Any`.

#### Expresiones de migración

Las declaraciones de actores y clases de actores pueden especificar una
expresión de migración, utilizando una expresión `<parenthetical>` opcional con
un campo requerido llamado `migration`. El valor de este campo, una función, se
aplica a las variables estables de un actor actualizado, antes de inicializar
cualquier campo estable del actor declarado.

La expresión entre paréntesis debe cumplir las siguientes condiciones:

- Debe ser estática, es decir, no tener efectos secundarios inmediatos.
- Su campo `migration` debe estar presente y tener un tipo de función no
  compartida cuyo dominio y codominio sean ambos tipos de registro.
- Tanto el dominio como el codominio deben ser estables.
- Cualquier campo en el codominio debe declararse como un campo estable en el
  cuerpo del actor.
- El tipo de contenido del campo del codominio debe ser un subtipo del tipo de
  contenido del campo estable del actor.

La expresión de migración solo afecta las actualizaciones del actor y, de lo
contrario, se ignora durante la instalación fresca del actor.

En una actualización, el dominio de la función de migración se utiliza para
construir un registro de valores que contiene el contenido actual de los campos
estables correspondientes del actor retirado. Si falta uno de los campos, la
actualización falla y se aborta.

De lo contrario, obtenemos un registro de entrada de valores estables del tipo
apropiado.

La función de migración se aplica al registro de entrada. Si la aplicación
falla, la actualización se aborta.

De lo contrario, la aplicación produce un registro de salida de valores estables
cuyo tipo es el codominio.

Las declaraciones del actor se evalúan en orden evaluando cada declaración como
de costumbre, excepto que el valor de una declaración `stable` se obtiene de la
siguiente manera:

- Si la declaración estable está presente en el codominio, su valor inicial se
  obtiene del registro de salida.

- De lo contrario, si la declaración estable no está presente en el dominio y
  está declarada como estable en el actor retirado, entonces su valor inicial se
  obtiene del actor retirado.

- De lo contrario, su valor se obtiene evaluando el inicializador de la
  declaración.

Por lo tanto, el inicializador de una variable estable se ejecuta si la variable
no es producida por la función de migración y es consumida por la función de
migración (apareciendo en su dominio) o está ausente en el actor retirado.

Para que la actualización sea segura:

- Todo identificador estable declarado con tipo `U` en el dominio de la función
  de migración debe declararse como estable para algún tipo `T` en el actor
  retirado, con `T <: U`.

- Todo identificador estable declarado con tipo `T` en el actor retirado, no
  presente en el dominio o codominio, y declarado como estable y de tipo `U` en
  el actor de reemplazo, debe satisfacer `T <: U`.

Esta condición asegura que cada variable estable sea descartada o nueva,
requiriendo inicialización, o que su valor pueda consumirse de manera segura
desde la salida de la migración o del actor retirado.

El compilador emitirá una advertencia si una función de migración parece estar
descartando datos al consumir un campo y no producirlo. Las advertencias deben
considerarse cuidadosamente para verificar que cualquier pérdida de datos sea
intencional y no accidental.

#### Campos del sistema

La declaración `<dec>` de un campo `system` debe ser una declaración `func`
manifiesta con uno de los siguientes nombres y tipos:

| nombre        | tipo                                                          | descripción                         |
| ------------- | ------------------------------------------------------------- | ----------------------------------- |
| `heartbeat`   | `() -> async ()`                                              | Acción de heartbeat                 |
| `timer`       | `(Nat64 -> ()) -> async ()`                                   | Acción de temporizador              |
| `inspect`     | `{ caller : Principal; msg : <Variant>; arg : Blob } -> Bool` | Predicado de mensaje                |
| `preupgrade`  | `<system>() -> ()`                                            | Acción previa a la actualización    |
| `postupgrade` | `<system>() -> ()`                                            | Acción posterior a la actualización |

- `heartbeat`: Cuando se declara, se llama en cada latido (heartbeat) de la
  subred de Internet Computer, programando una llamada asíncrona a la función
  `heartbeat`. Debido a su tipo de retorno `async`, una función de heartbeat
  puede enviar mensajes y esperar resultados. El resultado de una llamada de
  heartbeat, incluyendo cualquier trap o error lanzado, es ignorado. El cambio
  de contexto implícito significa que el momento en que se ejecuta el cuerpo del
  heartbeat puede ser posterior al momento en que el heartbeat fue emitido por
  la subred.

- `timer`: Cuando se declara, se llama como respuesta a la expiración del
  temporizador global del canister. El temporizador global del canister puede
  ser manipulado con el argumento de la función pasada de tipo `Nat64 -> ()`
  (tomando un tiempo absoluto en nanosegundos) sobre el cual las librerías
  pueden construir sus propias abstracciones. Cuando no se declara (y en
  ausencia de la bandera `-no-timer`), esta acción del sistema es proporcionada
  con una implementación predeterminada por el compilador (adicionalmente,
  `setTimer` y `cancelTimer` están disponibles como primitivas).

- `inspect`: Cuando se declara, se llama como un predicado en cada mensaje de
  entrada (ingress) de Internet Computer, con la excepción de las llamadas de
  consulta HTTP. El valor de retorno, un [`Bool`](../base/Bool.md), indica si se
  debe aceptar o rechazar el mensaje dado. El tipo de argumento depende de la
  interfaz del actor que lo contiene (ver [inspect](#inspect)).

- `preupgrade`: Cuando se declara, se llama durante una actualización,
  inmediatamente antes de que los valores actuales de las variables estables del
  actor retirado se transfieran al actor de reemplazo. Su parámetro de tipo
  `<system>` se asume implícitamente y no necesita ser declarado.

- `postupgrade`: Cuando se declara, se llama durante una actualización,
  inmediatamente después de que el cuerpo del actor de reemplazo haya
  inicializado sus campos, heredando los valores de las variables estables del
  actor retirado, y antes de que se procese su primer mensaje. Su parámetro de
  tipo `<system>` se asume implícitamente y no necesita ser declarado.

:::danger

El uso de los métodos del sistema `preupgrade` y `postupgrade` no es
recomendado. Es propenso a errores y puede dejar un canister inutilizable. En
particular, si un método `preupgrade` entra en un estado de trap y no se puede
evitar que entre en trap por otros medios, entonces tu canister puede quedar en
un estado en el que ya no se puede actualizar. Según las mejores prácticas, se
debe evitar el uso de estos métodos si es posible.

:::

Estos métodos del sistema `preupgrade` y `postupgrade` brindan la oportunidad de
guardar y restaurar estructuras de datos en curso, por ejemplo, cachés, que se
representan mejor utilizando tipos no estables.

Durante una actualización, un error que ocurre en la llamada implícita a
`preupgrade()` o `postupgrade()` hace que toda la actualización entre en trap,
preservando el actor previo a la actualización.

##### `inspect`

Dado un registro de atributos de mensaje, esta función produce un
[`Bool`](../base/Bool.md) que indica si se debe aceptar o rechazar el mensaje
devolviendo `true` o `false`. La función es invocada por el sistema en cada
mensaje de entrada (ingress) emitido como una llamada de actualización de ICP,
excluyendo las llamadas de consulta no replicadas. Similar a una consulta,
cualquier efecto secundario de una invocación es transitorio y se descarta. Una
llamada que entra en trap debido a algún fallo tiene el mismo resultado que
devolver `false` (denegación del mensaje).

El tipo de argumento de `inspect` depende de la interfaz del actor que lo
contiene. En particular, el argumento formal de `inspect` es un registro de
campos de los siguientes tipos:

- `caller : Principal`: El principal, posiblemente anónimo, del llamador del
  mensaje.

- `arg : Blob`: El contenido binario crudo del argumento del mensaje.

- `msg : <variant>`: Una variante de funciones de decodificación, donde
  `<variant> == {…​; #<id>: () → T; …​}` contiene una variante por cada función
  `shared` o `shared query`, `<id>`, del actor. La etiqueta de la variante
  identifica la función a ser llamada; El argumento de la variante es una
  función que, cuando se aplica, devuelve el argumento (decodificado) de la
  llamada como un valor de tipo `T`.

El uso de una variante, etiquetada con `#<id>`, permite que el tipo de retorno,
`T`, de la función de decodificación varíe con el tipo de argumento (también
`T`) de la función compartida `<id>`.

El argumento de la variante es una función para que se pueda evitar el costo de
la decodificación del mensaje cuando sea apropiado.

:::danger

Un actor que no declare el campo del sistema `inspect` simplemente aceptará
todos los mensajes de entrada (ingress).

:::

:::note

Cualquier función `shared composite query` en la interfaz _no_ está incluida en
`<variant>` ya que, a diferencia de una `shared query`, solo puede ser invocada
como una llamada de consulta no replicada, nunca como una llamada de
actualización.

:::

### Secuencia de declaraciones

Una secuencia de declaraciones `<dec>;*` que ocurre en un bloque, un programa o
incrustada en la secuencia `<dec-field>;*` del cuerpo de un objeto tiene tipo
`T` siempre que:

- `<dec>;*` esté vacío y `T == ()`, o

- `<dec>;*` no esté vacío y:

  - Todos los identificadores de valor vinculados por `<dec>;*` sean distintos.

  - Todos los identificadores de tipo vinculados por `<dec>;*` sean distintos.

  - Bajo la suposición de que cada identificador de valor `<id>` en `<dec>;*`
    tiene tipo `var_id? Tid`, y asumiendo las definiciones de tipo en `<dec>;*`:

    - Cada declaración en `<dec>;*` esté bien tipada.

    - Cada identificador de valor `<id>` en los enlaces producidos por `<dec>;*`
      tenga tipo `var_id? Tid`.

    - Todas menos la última `<dec>` en `<dec>;*` de la forma `<exp>` tengan tipo
      `()`.

    - La última declaración en `<dec>;*` tenga tipo `T`.

Las declaraciones en `<dec>;*` se evalúan secuencialmente. La primera
declaración que entra en trap hace que toda la secuencia entre en trap. De lo
contrario, el resultado de la declaración es el valor de la última declaración
en `<dec>;*`. Además, el conjunto de enlaces de valor definidos por `<dec>;*` es
la unión de los enlaces introducidos por cada declaración en `<dec>;*`.

Es un error en tiempo de compilación si cualquier declaración en `<dec>;*`
podría requerir el valor de un identificador declarado en `<dec>;*` antes de que
se haya evaluado la declaración de ese identificador. Dichos errores de uso
antes de la definición se detectan mediante un análisis estático simple y
conservador que no se describe aquí.

### Patrones

Los patrones vinculan parámetros de función, declaran identificadores y
descomponen valores en sus partes constituyentes en los casos de una expresión
`switch`.

La coincidencia de un patrón con un valor puede tener éxito, vinculando los
identificadores correspondientes en el patrón con sus valores coincidentes, o
fallar. Por lo tanto, el resultado de una coincidencia es un enlace exitoso,
mapeando identificadores del patrón a valores, o un fallo.

Las consecuencias de un fallo en la coincidencia de patrones dependen del
contexto del patrón.

- En una aplicación de función o enlace `let`, el fallo al coincidir el patrón
  de argumento formal o el patrón `let` causa un error.

- En una rama `case` de una expresión `switch`, el fallo al coincidir el patrón
  de ese caso continúa con un intento de coincidir el siguiente caso del switch,
  entrando en trap solo cuando no queda ningún caso.

### Patrón comodín

El patrón comodín `_` coincide con un solo valor sin vincular su contenido a un
identificador.

### Patrón de identificador

El patrón de identificador `<id>` coincide con un solo valor y lo vincula al
identificador `<id>`.

### Patrón literal

El patrón literal `<unop>? <lit>` coincide con un solo valor contra el valor
constante del literal `<lit>` y falla si no son valores estructuralmente
iguales.

Solo para literales enteros, el `<unop>` opcional determina el signo del valor a
coincidir.

### Patrón de tupla

El patrón de tupla `( <pat>,* )` coincide con un valor de n-tupla contra una
n-tupla de patrones, donde tanto la tupla como el patrón deben tener el mismo
número de elementos. El conjunto de identificadores vinculados por cada
componente del patrón de tupla debe ser distinto.

El patrón de tupla vacío `()` se llama **patrón unitario**.

La coincidencia de patrones falla si uno de los patrones no coincide con el
elemento correspondiente del valor de la tupla. La coincidencia de patrones
tiene éxito si cada patrón coincide con el componente correspondiente del valor
de la tupla. El enlace devuelto por una coincidencia exitosa es la unión
disjunta de los enlaces devueltos por las coincidencias de los componentes.

### Patrón de objeto

El patrón de objeto `{ <pat-field>;* }` coincide con un valor de objeto, una
colección de valores de campo nombrados, contra una secuencia de campos de
patrón nombrados. El conjunto de identificadores vinculados por cada campo del
patrón de objeto debe ser distinto. Los nombres de los campos de patrón en el
patrón de objeto deben ser distintos.

Los patrones de objeto admiten la abreviatura (punning) para mayor concisión. Un
campo abreviado `<id>` es una forma abreviada de `<id> = <id>`. De manera
similar, un campo abreviado tipado `<id> : <typ>` es una forma abreviada de
`<id> = <id> : <typ>`. Ambos vinculan el valor coincidente del campo llamado
`<id>` al identificador `<id>`.

La coincidencia de patrones falla si uno de los campos de patrón no coincide con
el valor de campo correspondiente del objeto. La coincidencia de patrones tiene
éxito si cada campo de patrón coincide con el campo nombrado correspondiente del
objeto. El enlace devuelto por una coincidencia exitosa es la unión de los
enlaces devueltos por las coincidencias de los campos.

El `<typ-sort>` del tipo de objeto coincidente debe determinarse mediante una
anotación de tipo envolvente u otra información de tipo contextual.

### Patrón de variante

El patrón de variante `# <id> <pat>?` coincide con un valor de variante (de la
forma `# <id'> v`) contra un patrón de variante. Un `<pat>?` ausente es una
forma abreviada del patrón unitario (`()`). La coincidencia de patrones falla si
la etiqueta `<id'>` del valor es distinta de la etiqueta `<id>` del patrón (es
decir, `<id>` \<\> `<id'>`); o si las etiquetas son iguales pero el valor `v` no
coincide con el patrón `<pat>?`. La coincidencia de patrones tiene éxito si la
etiqueta del valor es `<id>` (es decir, `<id'>` = `<id>`) y el valor `v`
coincide con el patrón `<pat>?`. El enlace devuelto por una coincidencia exitosa
es simplemente el enlace devuelto por la coincidencia de `v` contra `<pat>?`.

### Patrón anotado

El patrón anotado `<pat> : <typ>` coincide con un valor de tipo `<typ>` contra
el patrón `<pat>`.

`<pat> : <typ>` no es una prueba de tipo dinámica, sino que se utiliza para
restringir los tipos de identificadores vinculados en `<pat>`, por ejemplo, en
el patrón de argumento de una función.

### Patrón de opción

El patrón de opción `? <pat>` coincide con un valor de tipo opción `? <typ>`.

La coincidencia falla si el valor es `null`. Si el valor es `? v`, para algún
valor `v`, entonces el resultado de coincidir `? <pat>` es el resultado de
coincidir `v` contra `<pat>`.

Por el contrario, el patrón literal `null` puede usarse para probar si un valor
de tipo opción es el valor `null` y no `? v` para algún `v`.

### Patrón de disyunción (or)

El patrón de disyunción `<pat1> or <pat2>` es un patrón disyuntivo.

El resultado de coincidir `<pat1> or <pat2>` contra un valor es el resultado de
coincidir `<pat1>`, si tiene éxito, o el resultado de coincidir `<pat2>`, si la
primera coincidencia falla.

Un patrón `or` puede contener patrones de identificador (`<id>`) con la
restricción de que ambas alternativas deben vincular el mismo conjunto de
identificadores. El tipo de cada identificador es el límite superior mínimo de
su tipo en `<pat1>` y `<pat2>`.

### Declaración de expresión

La declaración `<exp>` tiene tipo `T` siempre que la expresión `<exp>` tenga
tipo `T`. No declara enlaces.

La declaración `<exp>` se evalúa al resultado de evaluar `<exp>`, típicamente
por el efecto secundario de `<exp>`.

Nota que si `<exp>` aparece dentro de una secuencia de declaraciones, pero no
como la última declaración de esa secuencia, entonces `T` debe ser `()`.

### Declaración let

La declaración `let` `let <pat> = <exp>` tiene tipo `T` y declara los enlaces en
`<pat>` siempre que:

- `<exp>` tenga tipo `T`, y

- `<pat>` tenga tipo `T`.

La declaración `let <pat> = <exp>` evalúa `<exp>` a un resultado `r`. Si `r` es
`trap`, la declaración se evalúa a `trap`. Si `r` es un valor `v`, entonces la
evaluación procede coincidiendo el valor `v` contra `<pat>`. Si la coincidencia
falla, el resultado es `trap`. De lo contrario, el resultado es `v` y el enlace
de todos los identificadores en `<pat>` a sus valores coincidentes en `v`.

Todos los enlaces declarados por un `let`, si los hay, son inmutables.

### Declaración let-else

La declaración `let-else` `let <pat> = <exp> else <block-or-exp>` tiene tipo `T`
y declara los enlaces en `<pat>` siempre que:

- `<exp>` tenga tipo `T`,

- `<pat>` tenga tipo `T`, y

- `<block-or-exp>` tenga tipo `None`.

La declaración `let <pat> = <exp> else <block-or-exp>` evalúa `<exp>` a un
resultado `r`. Si `r` es `trap`, la declaración se evalúa a `trap`. Si `r` es un
valor `v`, entonces la evaluación procede coincidiendo el valor `v` contra
`<pat>`. Si la coincidencia tiene éxito, el resultado es `v` y el enlace de
todos los identificadores en `<pat>` a sus valores coincidentes en `v`.

Si la coincidencia falla, entonces la evaluación continúa con `<block-or-exp>`,
que, al tener tipo `None`, no puede proceder al final de la declaración, pero
aún puede alterar el flujo de control para, por ejemplo, `return` o `throw` para
salir de una función envolvente, `break` desde una expresión envolvente o
simplemente divergir.

Todos los enlaces declarados por un `let-else`, si los hay, son inmutables.

#### Manejo de fallos en la coincidencia de patrones

En presencia de patrones refutables, el patrón en una declaración `let` puede
fallar al coincidir con el valor de su expresión. En tales casos, la declaración
`let` se evaluará a un error. El compilador emite una advertencia para cualquier
declaración `let` que pueda entrar en trap debido a un fallo en la coincidencia
de patrones.

En lugar de entrar en trap, un usuario puede querer manejar explícitamente los
fallos en la coincidencia de patrones. La declaración `let-else`,
`let <pat> = <exp> else <block-or-exp>`, tiene una semántica estática y dinámica
casi idéntica a `let`, pero desvía el flujo de control del programa a
`<block-or-exp>` cuando la coincidencia de patrones falla, permitiendo la
recuperación del fallo. La expresión `else`, `<block-or-exp>`, debe tener tipo
`None` y típicamente sale de la declaración utilizando construcciones de control
de flujo imperativas como `throw`, `return`, `break` o funciones que no
retornan, como `Debug.trap(...)`, que producen un resultado de tipo `None`.
Cualquier advertencia de compilación que se produzca para un `let` puede
silenciarse manejando el posible fallo en la coincidencia de patrones utilizando
`let-else`.

### Declaración var

La declaración de variable `var <id> (: <typ>)? = <exp>` declara una variable
mutable `<id>` con valor inicial `<exp>`. El valor de la variable puede
actualizarse mediante asignación.

La declaración `var <id>` tiene tipo `()` siempre que:

- `<exp>` tenga tipo `T`; y

- Si la anotación `(:<typ>)?` está presente, entonces `T` == `<typ>`.

Dentro del alcance de la declaración, `<id>` tiene tipo `var T` (ver
[Asignación](#asignación)).

La evaluación de `var <id> (: <typ>)? = <exp>` procede evaluando `<exp>` a un
resultado `r`. Si `r` es `trap`, la declaración se evalúa a `trap`. De lo
contrario, `r` es algún valor `v` que determina el valor inicial de la variable
mutable `<id>`. El resultado de la declaración es `()` y `<id>` se vincula a una
nueva ubicación que contiene `v`.

### Declaración de tipo

La declaración `type <id> <type-typ-params>? = <typ>` declara un nuevo
constructor de tipo `<id>`, con parámetros de tipo opcionales
`<type-typ-params>` y definición `<typ>`.

La declaración `type C< X0 <: T0, …​, Xn <: Tn > = U` está bien formada siempre
que:

- Los parámetros de tipo `X0`, …​, `Xn` sean distintos, y

- Asumiendo las restricciones `X0 <: T0`, …​, `Xn <: Tn`:

  - Las restricciones `T0`, …​, `Tn` estén bien formadas.

  - La definición `U` esté bien formada.

  - Sea productiva (ver [Productividad](#productividad)).

  - Sea no expansiva (ver [Expansividad](#expansividad)).

En el alcance de la declaración `type C< X0<:T0, …​, Xn <: Tn > = U`, cualquier
tipo bien formado `C< U0, …​, Un >` es equivalente a su expansión
`U [ U0/X0, …​, Un/Xn ]`. Las expresiones de tipo distintas que se expanden a
tipos idénticos son intercambiables, independientemente de cualquier distinción
entre nombres de constructores de tipo. En resumen, la equivalencia entre tipos
es estructural, no nominal.

#### Productividad

Un tipo es **productivo** si la expansión recursiva de cualquier constructor de
tipo en su definición eventualmente produce un tipo distinto a la aplicación de
un constructor de tipo.

Motoko requiere que todas las declaraciones de tipo sean productivas.

Por ejemplo, las siguientes definiciones de tipo son todas productivas y
legales:

```motoko no-repl
  type Person = { first : Text; last : Text };

  type List<T> = ?(T, List<T>);

  type Fst<T, U> = T;

  type Ok<T> = Fst<Any, Ok<T>>;
```

Pero, en contraste, las siguientes definiciones de tipo no son productivas, ya
que cada definición entrará en un bucle después de una o más expansiones de su
cuerpo:

```motoko no-repl
  type C = C;

  type D<T, U> = D<U, T>;

  type E<T> = F<T>;
  type F<T> = E<T>;

  type G<T> = Fst<G<T>, Any>;
```

#### Expansividad

Un conjunto de declaraciones de tipo o clase mutuamente recursivas será
rechazado si el conjunto es **expansivo**.

La expansividad es un criterio sintáctico. Para determinar si un conjunto de
definiciones de tipo únicas o mutuamente recursivas es expansivo, por ejemplo:

```motoko no-repl
  type C<...,Xi,...> = T;
  ...
  type D<...,Yj,...> = U;
```

Toma estas definiciones y construye un grafo dirigido cuyos vértices son los
parámetros de tipo formales identificados por posición, `C#i`, con las
siguientes aristas etiquetadas con `{0,1}`:

- Para cada ocurrencia del parámetro `C#i` como argumento inmediato en la
  posición `j` del tipo `D<…​,C#i,…​>`, agrega una arista **no expansiva**
  etiquetada con `0`, `C#i -0-> D#j`.

- Para cada ocurrencia del parámetro `C#i` como subexpresión adecuada en la
  posición `j` del tipo `D<…​,T[C#i],..>`, agrega una arista **expansiva**
  etiquetada con `1`, `C#i -1-> D#j`.

El grafo es expansivo si, y solo si, contiene un ciclo con al menos una arista
expansiva.

Por ejemplo, la definición de tipo que instancia recursivamente `List` con el
mismo parámetro `T`, es no expansiva y se acepta:

```motoko no-repl
  type List<T> = ?(T, List<T>);
```

Una definición de aspecto similar que instancia recursivamente `Seq` con un tipo
más grande, `[T]`, que contiene `T`, es expansiva y se rechaza:

```motoko no-repl
  type Seq<T> = ?(T, Seq<[T]>);
```

- El tipo `List<T>` no es expansivo porque su grafo, `{ List#0 -0-> List#0 }`,
  aunque es cíclico, no tiene aristas expansivas.

- El tipo `Seq<T>`, por otro lado, es expansivo, porque su grafo,
  `{ Seq#0 -1-> Seq#0 }`, tiene un ciclo que incluye una arista expansiva.

### Declaración de objeto

La declaración `<sort> <id>? (: <typ>)? =? <obj-body>`, donde `<obj-body>` tiene
la forma `{ <dec-field>;* }`, declara un objeto con un identificador opcional
`<id>` y cero o más campos `<dec-field>;*`. Los campos pueden declararse con
visibilidad `public` o `private`; si se omite la visibilidad, por defecto es
`private`.

El calificador `<sort>` (uno de `persistent? actor <migration>?`, `module` u
`object`) especifica el `<typ-sort>` del tipo del objeto (`actor`, `module` u
`object`, respectivamente). El tipo impone restricciones sobre los tipos de los
campos públicos del objeto.

Sea `T = <typ-sort> { [var0] id0 : T0, …​ , [varn] idn : T0 }` el tipo del
objeto. Sea `<dec>;*` la secuencia de declaraciones incrustadas en
`<dec-field>;*`. La declaración del objeto tiene tipo `T` siempre que:

1. El tipo `T` esté bien formado para el tipo `<typ-sort>`, y

2. Bajo la suposición de que `<id> : T`,

   - La secuencia de declaraciones `<dec>;*` tiene tipo `Any` y declara los
     conjuntos disjuntos de identificadores privados y públicos, `Id_private` e
     `Id_public` respectivamente, con tipos `T(id)` para `id` en
     `Id == Id_private union Id_public`, y

   - `{ id0, …​, idn } == Id_public`, y

   - Para todo `i en 0 <= i <= n`, `[vari] Ti == T(idi)`.

3. Si `<sort>` es `module`, entonces las declaraciones en `<dec>;*` deben ser
   _estáticas_ (ver [declaraciones estáticas](#declaraciones-estaticas)).

Nota que el primer requisito impone restricciones adicionales sobre los tipos de
los campos de `T`. En particular, si el tipo es `actor`, entonces:

- Todos los campos públicos deben ser funciones `shared` inmutables no `var`. La
  interfaz pública de un actor solo puede proporcionar mensajería asíncrona a
  través de funciones compartidas.

Debido a que la construcción de un actor es asíncrona, una declaración de actor
solo puede ocurrir en un contexto asíncrono, es decir, en el cuerpo de una
función `shared` no `<query>`, una expresión `async` o una expresión `async*`.

La evaluación de `<sort>? <id>? =? { <dec-field>;* }` procede vinculando `<id>`,
si está presente, al valor eventual `v`, y evaluando las declaraciones en
`<dec>;*`. Si la evaluación de `<dec>;*` entra en trap, la declaración del
objeto también lo hace. De lo contrario, `<dec>;*` produce un conjunto de
enlaces para los identificadores en `Id`. Sean `v0`, …​, `vn` los valores o
ubicaciones vinculados a los identificadores `<id0>`, …​, `<idn>`. El resultado
de la declaración del objeto es el objeto
`v == <typ-sort> { <id0> = v1, …​, <idn> = vn}`.

Si `<id>?` está presente, la declaración vincula `<id>` a `v`. De lo contrario,
produce un conjunto vacío de enlaces.

Si `(: <typ>)?` está presente, entonces `T` debe ser un subtipo de `<typ>`.

:::danger

La declaración de un actor es implícitamente asíncrona, y el estado del actor
que lo contiene puede cambiar debido al procesamiento concurrente de otros
mensajes entrantes del actor. Es responsabilidad del programador protegerse
contra cambios de estado no sincronizados.

:::

#### Declaraciones estáticas

Una declaración es **estática** si es:

- Una declaración `type`.

- Una declaración `class`.

- Una declaración `let` con un patrón estático y una expresión estática.

- Una declaración de módulo, función u objeto que se descompone en una
  declaración `let` estática.

- Una expresión estática.

Una expresión es estática si es:

- Una expresión literal.

- Una tupla de expresiones estáticas.

- Un objeto de expresiones estáticas.

- Una variante u opción con una expresión estática.

- Un arreglo inmutable.

- Acceso a campos y proyección desde una expresión estática.

- Una expresión de módulo.

- Una expresión de función.

- Una declaración estática.

- Un `ignore` de una expresión estática.

- Un bloque, cuyas declaraciones son todas estáticas.

- Una anotación de tipo con una expresión estática.

Un patrón es estático si es:

- Un identificador.

- Un comodín.

- Una tupla de patrones estáticos.

- Una anotación de tipo con un patrón estático.

<!--
why not record patterns?
-->

Las frases estáticas están diseñadas para ser libres de efectos secundarios, lo
que permite la fusión de importaciones de librerías duplicadas.

### Declaración de función

La declaración de función
`<shared-pat>? func <id>? <typ-params>? <pat> (: <typ>)? =? <exp>` es azúcar
sintáctico para una declaración con nombre `let` o una declaración anónima de
una expresión de función.

Es decir, cuando `<id>?` está presente y la función tiene nombre:

```bnf
<shared-pat>? func <id> <typ-params>? <pat> (: <typ>)? =? <block-or-exp> :=
  let <id> = <shared-pat>? func <typ-params>? <pat> (: <typ>)? =? <block-or-exp>
```

Pero cuando `<id>?` está ausente y la función es anónima:

```bnf
<shared-pat>? func <typ-params>? <pat> (: <typ>)? =? <block-or-exp> :=
  <shared-pat>? func <typ-params>? <pat> (: <typ>)? =? <block-or-exp>
```

Las definiciones de funciones con nombre admiten la recursión, es decir, una
función con nombre puede llamarse a sí misma.

:::note

En el código compilado, las funciones `shared` solo pueden aparecer como campos

:::

### Declaración de clase

La declaración de clase
`<shared-pat>? <sort>? class <id>? <typ-params>? <pat> (: <typ>)? <class-body>`
es sugar syntax para un par de declaraciones de tipo y función:

```bnf
<shared-pat>? <sort>? class <id> <typ-params>? <pat> (: <typ>)? <class-body> :=
  type <id> <type-typ-params>? = <sort> { <typ-field>;* };
  <shared-pat>? func <id> <typ-params>? <pat> : async? <id> <typ-args> =
    async? <sort> <id_this>? <obj-body>
```

donde:

- `<shared-pat>?`, cuando está presente, requiere que `<sort>` ==
  `persistent? actor`, y proporciona acceso al `caller` de un constructor de
  `actor`, y

- `<typ-args>?` y `<type-typ-params>?` es la secuencia de identificadores de
  tipo vinculados por `<typ-params>?`, si los hay, y

- `<typ-field>;*` es el conjunto de tipos de campos públicos inferidos de
  `<dec-field>;*`.

- `<obj-body>` es el cuerpo del objeto de `<class-body>`.

- `<id_this>?` es el parámetro opcional **this** o **self** de `<class-body>`.

- `async?` está presente, si y solo si, `<sort>` == `persistent? actor`.

Nota que `<shared-pat>?` no debe ser de la forma `shared <query> <pat>?`: un
constructor, a diferencia de una función, no puede ser un `query` o
`composite query`.

Un `<shared-pat>?` ausente se establece por defecto en `shared` cuando `<sort>`
= `persistent? actor`.

Si `sort` es `persistent? actor`, entonces:

- `<typ-args>?` debe estar ausente o vacío, de modo que las clases `actor` no
  pueden tener parámetros de tipo.

- El tipo de `<pat>` debe ser compartido (ver
  [compartibilidad](#compartibilidad-shareability)).

- `(: <typ>)?`, si está presente, debe ser de la forma `: async T` para algún
  tipo de actor `T`. La instanciación de un actor es asíncrona.

Si `(: <typ>)` está presente, entonces el tipo
`<async?> <typ-sort> { <typ_field>;* }` debe ser un subtipo de la anotación
`<typ>`. En particular, la anotación se usa solo para verificar, pero no
afectar, el tipo inferido de la función `<id>`. `<typ-sort>` es simplemente
`<sort>` eliminando cualquier modificador `persistent?`.

La declaración de clase tiene el mismo tipo que la función `<id>` y se evalúa
como el valor de la función `<id>`.

### Identificadores

La expresión de identificador `<id>` tiene tipo `T` siempre que `<id>` esté en
el alcance, definido y declarado con tipo explícito o inferido `T`.

La expresión `<id>` se evalúa como el valor vinculado a `<id>` en el entorno de
evaluación actual.

### Literales

Un literal tiene tipo `T` solo cuando su valor está dentro del rango prescrito
de valores del tipo `T`.

La expresión literal (o constante) `<lit>` se evalúa como sí misma.

### Operadores unarios

El operador unario `<unop> <exp>` tiene tipo `T` siempre que:

- `<exp>` tenga tipo `T`, y

- La categoría de `<unop>` sea una categoría de `T`.

La expresión de operador unario `<unop> <exp>` evalúa `<exp>` a un resultado. Si
el resultado es un valor `v`, devuelve el resultado de `<unop> v`. Si el
resultado es `trap`, la expresión completa resulta en `trap`.

### Operadores binarios

La expresión de operador binario `<exp1> <binop> <exp2>` tiene tipo `T` siempre
que:

- `<exp1>` tenga tipo `T`.

- `<exp2>` tenga tipo `T`.

- La categoría de `<binop>` sea una categoría de `T`.

La expresión de operador binario `<exp1> <binop> <exp2>` evalúa `exp1` a un
resultado `r1`. Si `r1` es `trap`, la expresión resulta en `trap`.

De lo contrario, `exp2` se evalúa a un resultado `r2`. Si `r2` es `trap`, la
expresión resulta en `trap`.

De lo contrario, `r1` y `r2` son valores `v1` y `v2`, y la expresión devuelve el
resultado de `v1 <binop> v2`.

### Operadores relacionales

La expresión relacional `<exp1> <relop> <exp2>` tiene tipo
[`Bool`](../base/Bool.md) siempre que:

- `<exp1>` tenga tipo `T`.

- `<exp2>` tenga tipo `T`.

- `<relop>` sea igualdad `==` o desigualdad `!=`, `T` sea compartido, y `T` sea
  el tipo mínimo tal que `<exp1>` y `<exp2>` tengan tipo `T`.

- La categoría O (Ordenado) sea una categoría de `T` y `<relop>`.

La expresión de operador binario `<exp1> <relop> <exp2>` evalúa `<exp1>` a un
resultado `r1`. Si `r1` es `trap`, la expresión resulta en `trap`.

De lo contrario, `exp2` se evalúa a un resultado `r2`. Si `r2` es `trap`, la
expresión resulta en `trap`.

De lo contrario, `r1` y `r2` son valores `v1` y `v2`, y la expresión devuelve el
resultado booleano de `v1 <relop> v2`.

Para igualdad y desigualdad, el significado de `v1 <relop> v2` depende de la
elección en tiempo de compilación, estática, de `T`. Esto significa que solo los
tipos estáticos de `<exp1>` y `<exp2>` se consideran para la igualdad, y no los
tipos en tiempo de ejecución de `v1` y `v2`, que, debido al subtipado, pueden
ser más precisos que los tipos estáticos.

### Operadores de tubería y expresiones de marcador de posición

La expresión de tubería `<exp1> |> <exp2>` vincula el valor de `<exp1>` a la
expresión especial de marcador de posición `_`, que puede ser referenciada en
`<exp2>` y recursivamente en `<exp1>`. Referenciar la expresión de marcador de
posición fuera de una operación de tubería es un error en tiempo de compilación.

La expresión de tubería `<exp1> |> <exp2>` es simplemente azúcar sintáctica para
un enlace `let` a un identificador de marcador de posición, `p`:

```bnf
do { let p = <exp1>; <exp2> }
```

La expresión de marcador de posición `_` es solo azúcar sintáctica para la
expresión que hace referencia al identificador de marcador de posición:

```bnf
p
```

El identificador de marcador de posición, `p`, es un identificador fijo y
reservado que no puede ser vinculado por ninguna otra expresión o patrón que no
sea una operación de tubería, y solo se puede hacer referencia utilizando la
expresión de marcador de posición `_`.

`|>` tiene la menor precedencia entre todos los operadores, excepto `:`, y se
asocia a la izquierda.

El uso juicioso del operador de tubería permite expresar una expresión anidada
más complicada al pasar los argumentos de esa expresión a sus posiciones
anidadas dentro de esa expresión.

Por ejemplo:

```motoko no-repl
Iter.range(0, 10) |>
  Iter.toList _ |>
    List.filter<Nat>(_, func n { n % 3 == 0 }) |>
      { multiples = _ };
```

Esta puede ser una versión más legible de:

```motoko no-repl
{ multiples =
   List.filter<Nat>(
     Iter.toList(Iter.range(0, 10)),
     func n { n % 3 == 0 }) };
```

Arriba, cada aparición de `_` se refiere al valor del lado izquierdo de la
operación de tubería más cercana, después de asociar las tuberías anidadas a la
izquierda.

Tenga en cuenta que el orden de evaluación de los dos ejemplos es diferente,
pero siempre de izquierda a derecha.

:::note

Aunque sintácticamente idéntica, la expresión de marcador de posición es
semánticamente distinta y no debe confundirse con el patrón comodín `_`.

Las apariciones de estas formas se pueden distinguir por su papel sintáctico
como patrón o expresión.

:::

### Tuplas

La expresión de tupla `(<exp1>, …​, <expn>)` tiene tipo de tupla `(T1, …​, Tn)`,
siempre que `<exp1>`, …​, `<expn>` tengan tipos `T1`, …​, `Tn`.

La expresión de tupla `(<exp1>, …​, <expn>)` evalúa las expresiones `exp1` …​
`expn` en orden, entrando en trap tan pronto como alguna expresión `<expi>`
entre en trap. Si ninguna evaluación entra en trap y `exp1`, …​, `<expn>` se
evalúan a valores `v1`,…​,`vn`, entonces la expresión de tupla devuelve el valor
de tupla `(v1, …​ , vn)`.

La proyección de tupla `<exp> . <nat>` tiene tipo `Ti` siempre que `<exp>` tenga
tipo de tupla `(T1, …​, Ti, …​, Tn)`, `<nat>` == `i` y `1 <= i <= n`.

La proyección `<exp> . <nat>` evalúa `<exp>` a un resultado `r`. Si `r` es
`trap`, entonces el resultado es `trap`. De lo contrario, `r` debe ser una tupla
`(v1,…​,vi,…​,vn)` y el resultado de la proyección es el valor `vi`.

La expresión de tupla vacía `()` se llama **valor unitario**.

### Expresiones de opción

La expresión de opción `? <exp>` tiene tipo `? T` siempre que `<exp>` tenga tipo
`T`.

El literal `null` tiene tipo `Null`. Dado que `Null <: ? T` para cualquier `T`,
el literal `null` también tiene tipo `? T` y significa el valor "faltante" en el
tipo `? T`.

### Inyección de variante

La inyección de variante `# <id> <exp>` tiene tipo de variante `{# id T}`
siempre que:

- `<exp>` tenga tipo `T`.

La inyección de variante `# <id>` es simplemente azúcar sintáctica para
`# <id> ()`.

La inyección de variante `# <id> <exp>` evalúa `<exp>` a un resultado `r`. Si
`r` es `trap`, entonces el resultado es `trap`. De lo contrario, `r` debe ser un
valor `v` y el resultado de la inyección es el valor etiquetado `# <id> v`.

La etiqueta y el contenido de un valor de variante pueden probarse y accederse
utilizando un [patrón de variante](#patrón-de-variante).

### Objetos

Los objetos pueden escribirse en forma literal `{ <exp-field>;* }`, que consiste
en una lista de campos de expresión:

```bnf
<exp-field> ::=                                Object expression fields
  var? <id> (: <typ>) = <exp>                    Field
  var? <id> (: <typ>)                            Punned field
```

Tal literal de objeto, a veces llamado registro, es equivalente a la declaración
de objeto `object { <dec-field>;* }`, donde los campos de declaración se
obtienen de los campos de expresión anteponiendo a cada uno de ellos
`public let`, o simplemente `public` en el caso de campos `var`. Sin embargo, a
diferencia de las declaraciones, la lista de campos no vincula cada `<id>` como
un nombre local dentro del literal, es decir, los nombres de los campos no están
en el alcance de las expresiones de los campos.

Las expresiones de objeto admiten **abreviaturas (punning)** para mayor
concisión. Un campo abreviado `<id>` es una forma abreviada de `<id> = <id>`; de
manera similar, un campo abreviado tipado `<id> : <typ>` es una forma abreviada
de `<id> = <id> : <typ>`. Ambos asocian el campo llamado `<id>` con el valor del
identificador `<id>`.

### Combinación/extensión de objetos

Los objetos pueden combinarse y/o extenderse utilizando las palabras clave `and`
y `with`.

Una expresión de registro `{ <exp> (and <exp>)* (with <exp-field>;+)? }` fusiona
los objetos o módulos especificados como expresiones base y aumenta el resultado
para que también contenga los campos especificados. La cláusula
`with <exp-field>;+` puede omitirse cuando aparecen al menos dos bases y ninguna
tiene etiquetas de campo comunes. Por lo tanto, la lista de campos sirve para:

- Desambiguar etiquetas de campo que aparecen más de una vez en las bases.
- Definir nuevos campos.
- Sobrescribir campos existentes y sus tipos.
- Agregar nuevos campos `var`.
- Redefinir campos `var` existentes de alguna base para evitar aliasing.

El tipo resultante está determinado por los tipos estáticos de las bases y los
campos dados explícitamente.

Cualquier campo `var` de alguna base debe sobrescribirse en la lista de campos
explícitos. Esto evita la introducción de alias de campos `var`.

La expresión de registro
`{ <exp1> and ... <expn> with <exp-field1>; ... <exp_fieldn>; }` tiene tipo `T`
siempre que:

- El registro `{ <exp-field1>; ... <exp_fieldm>; }` tenga tipo de registro
  `{ field_tys } == { var? <id1> : U1; ... var? <idm> : Um }`.

- Sea `newfields == { <id1> , ..., <idm> }` el conjunto de nombres de nuevos
  campos.

- Considerando campos de valor:

  - La expresión base `<expi>` tiene tipo de objeto o módulo
    `sorti { field_tysi } == sorti { var? <idi1> : Ti1, …​, var? <idik> : Tik }`
    donde `sorti <> Actor`.

  Sea `fields(i) == { <idi1>, ..., <idik> }` el conjunto de nombres de campos
  estáticos de la base `i`. Entonces:

  - `fields(i)` es disjunto de `newfields` (posiblemente aplicando subtipado al
    tipo de `<expi>`).

  - Ningún campo en `field_tysi` es un campo `var`.

  - `fields(i)` es disjunto de `fields(j)` para `j < i`.

- Considerando campos de tipo:

  - La expresión base `<expi>` tiene tipo de objeto o módulo
    `sorti { typ_fieldsi } == sorti { type <idj1> = … , …, type <idik> = … }`
    donde `sorti <> Actor`.

  - `typ_fieldsi` _coincide_ con `typ_fieldsj` para `j < i`.

- `T` es `{ typ_fieldsi fields_tys1 ... typ_fieldsm fields_tysm field_tys }`.

Aquí, dos secuencias de campos de tipo coinciden solo cuando cualquier dos
campos de tipo con el mismo nombre en cada secuencia tienen definiciones
equivalentes.

<!--
Note that the case for type fields is simpler than the value fields case only because the clause `with <exp-field1>; ... <exp_fieldn>` cannot contain type fields.
-->

### Expresión de registro

La expresión de registro
`{ <exp1> and ... <expn> with <exp-field1>; ... <exp_fieldm>; }` evalúa los
registros `<exp1>` hasta `<expn>` y `{ exp-field1; ... <exp_fieldm }` a
resultados `r1` hasta `rn` y `r`, entrando en trap en el primer resultado que
sea un error. Si ninguna de las expresiones produce un error, los resultados son
objetos `sort1 { f1 }`, `sortn { fn }` y `object { f }`, donde `f1` ... `fn` y
`f` son mapas de identificadores a valores o ubicaciones mutables.

El resultado de la expresión completa es el valor `object { g }` donde `g` es el
mapa parcial con dominio `fields(1) union fields(n) union newfields` que mapea
identificadores a valores o ubicaciones únicos, de modo que `g(<id>) = fi(<id>)`
si `<id>` está en `fields(i)`, para algún `i`, o `f(<id>)` si `<id>` está en
`newfields`.

### Proyección de objeto (acceso a miembros)

La proyección de objeto `<exp> . <id>` tiene tipo `var? T` siempre que `<exp>`
tenga tipo de objeto
`sort { var1? <id1> : T1, …​, var? <id> : T, …​, var? <idn> : Tn }` para algún
tipo `sort`.

La proyección de objeto `<exp> . <id>` evalúa `<exp>` a un resultado `r`. Si `r`
es `trap`, entonces el resultado es `trap`. De lo contrario, `r` debe ser un
valor de objeto `{ <id1> = v1,…​, id = v, …​, <idm> = vm }` y el resultado de la
proyección es el valor `w` obtenido del valor o ubicación `v` en el campo `id`.

Si `var` está ausente de `var? T`, entonces el valor `w` es simplemente el valor
`v` del campo inmutable `<id>`. De lo contrario:

- Si la proyección ocurre como el objetivo de una expresión de asignación,
  entonces `w` es simplemente `v`, la ubicación mutable en el campo `<id>`.

- De lo contrario, `w` (de tipo `T`) es el valor actualmente almacenado en la
  ubicación mutable `v` en el campo `<id>`.

### Acceso especial a miembros

El acceso de iterador `<exp> . <id>` tiene tipo `T` siempre que `<exp>` tenga
tipo `U`, y `U`, `<id>` y `T` estén relacionados por una fila de la siguiente
tabla:

|                           |         |                         |                                                        |
| ------------------------- | ------- | ----------------------- | ------------------------------------------------------ |
| U                         | `<id>`  | T                       | Descripción                                            |
| [`Text`](../base/Text.md) | `size`  | [`Nat`](../base/Nat.md) | Tamaño (o longitud) en caracteres                      |
| [`Text`](../base/Text.md) | `chars` | `{ next: () -> Char? }` | Iterador de caracteres, de primero a último            |
|                           |         |                         |                                                        |
| [`Blob`](../base/Blob.md) | `size`  | [`Nat`](../base/Nat.md) | Tamaño en bytes                                        |
| [`Blob`](../base/Blob.md) | `vals`  | `{ next: () -> Nat8? }` | Iterador de bytes, de primero a último                 |
|                           |         |                         |                                                        |
| `[var? T]`                | `size`  | [`Nat`](../base/Nat.md) | Número de elementos                                    |
| `[var? T]`                | `get`   | `Nat -> T`              | Función de lectura indexada                            |
| `[var? T]`                | `keys`  | `{ next: () -> Nat? }`  | Iterador de índices, en orden ascendente               |
| `[var? T]`                | `vals`  | `{ next: () -> T? }`    | Iterador de valores, en orden ascendente               |
| `[var T]`                 | `put`   | `(Nat, T) -> ()`        | Función de escritura indexada (solo arreglos mutables) |

La proyección `<exp> . <id>` evalúa `<exp>` a un resultado `r`. Si `r` es
`trap`, entonces el resultado es `trap`. De lo contrario, `r` debe ser un valor
de tipo `U` y el resultado de la proyección es un valor de tipo `T` cuya
semántica se da en la columna de Descripción de la tabla anterior.

:::note

Los miembros `chars`, `vals`, `keys` y `vals` producen objetos iteradores con
estado que pueden ser consumidos por expresiones `for` (ver [for](#for)).

:::

### Asignación

La asignación `<exp1> := <exp2>` tiene tipo `()` siempre que:

- `<exp1>` tenga tipo `var T`.

- `<exp2>` tenga tipo `T`.

La expresión de asignación `<exp1> := <exp2>` evalúa `<exp1>` a un resultado
`r1`. Si `r1` es `trap`, la expresión resulta en `trap`.

De lo contrario, `exp2` se evalúa a un resultado `r2`. Si `r2` es `trap`, la
expresión resulta en `trap`.

De lo contrario, `r1` y `r2` son respectivamente una ubicación `v1`, un
identificador mutable, un elemento de un arreglo mutable o un campo mutable de
un objeto, y un valor `v2`. La expresión actualiza el valor actual almacenado en
`v1` con el nuevo valor `v2` y devuelve la tupla vacía `()`.

### Asignación compuesta unaria

La asignación compuesta unaria `<unop>= <exp>` tiene tipo `()` siempre que:

- `<exp>` tenga tipo `var T`.

- La categoría de `<unop>` sea una categoría de `T`.

La asignación compuesta unaria `<unop>= <exp>` evalúa `<exp>` a un resultado
`r`. Si `r` es `trap`, la evaluación entra en trap; de lo contrario, `r` es una
ubicación que almacena el valor `v` y `r` se actualiza para contener el valor
`<unop> v`.

### Asignación compuesta binaria

La asignación compuesta binaria `<exp1> <binop>= <exp2>` tiene tipo `()` siempre
que:

- `<exp1>` tenga tipo `var T`.

- `<exp2>` tenga tipo `T`.

- La categoría de `<binop>` sea una categoría de `T`.

Para el operador binario `<binop>`, la expresión de asignación compuesta
`<exp1> <binop>= <exp2>` evalúa `<exp1>` a un resultado `r1`. Si `r1` es `trap`,
la expresión resulta en `trap`. De lo contrario, `exp2` se evalúa a un resultado
`r2`. Si `r2` es `trap`, la expresión resulta en `trap`.

De lo contrario, `r1` y `r2` son respectivamente una ubicación `v1`, un
identificador mutable, un elemento de un arreglo mutable o un campo mutable de
un objeto, y un valor `v2`. La expresión actualiza el valor actual, `w`,
almacenado en `v1` con el nuevo valor `w <binop> v2` y devuelve la tupla vacía
`()`.

### Arreglos

La expresión `[ var? <exp>,* ]` tiene tipo `[var? T]` siempre que cada expresión
`<exp>` en la secuencia `<exp>,*` tenga tipo T.

La expresión de arreglo `[ var <exp0>, …​, <expn> ]` evalúa las expresiones
`exp0` …​ `expn` en orden, entrando en trap tan pronto como alguna expresión
`<expi>` entre en trap. Si ninguna evaluación entra en trap y `exp0`, …​,
`<expn>` se evalúan a valores `v0`,…​,`vn`, entonces la expresión de arreglo
devuelve el valor de arreglo `[var? v0, …​ , vn]` de tamaño `n+1`.

### Indexación de arreglos

La expresión de indexación de arreglos `<exp1> [ <exp2> ]` tiene tipo `var? T`
siempre que:

- `<exp>` tenga tipo de arreglo mutable o inmutable `[var? T1]`.

La expresión `<exp1> [ <exp2> ]` evalúa `exp1` a un resultado `r1`. Si `r1` es
`trap`, entonces el resultado es `trap`.

De lo contrario, `exp2` se evalúa a un resultado `r2`. Si `r2` es `trap`, la
expresión resulta en `trap`.

De lo contrario, `r1` es un valor de arreglo, `var? [v0, …​, vn]`, y `r2` es un
número natural `i`. Si `i > n`, la expresión de índice devuelve `trap`.

De lo contrario, la expresión de índice devuelve el valor `v`, obtenido de la
siguiente manera:

- Si `var` está ausente de `var? T`, entonces el valor `v` es el valor constante
  `vi`.

De lo contrario,

- Si la indexación ocurre como el objetivo de una expresión de asignación,
  entonces `v` es la ubicación mutable `i`-ésima en el arreglo.

- De lo contrario, `v` es `vi`, el valor actualmente almacenado en la ubicación
  `i`-ésima del arreglo.

### Llamadas a funciones

La expresión de llamada a función `<parenthetical>? <exp1> <T0,…​,Tn>? <exp2>`
tiene tipo `T` siempre que:

- La función `<exp1>` tenga tipo de función
  `<shared>? < X0 <: V0, ..., Xn <: Vn > U1-> U2`.

- Si `<T0,…​,Tn>?` está ausente pero n > 0, entonces existen `T0, …​, Tn`
  mínimos inferidos por el compilador tales que:

- Cada argumento de tipo satisface los límites del parámetro de tipo
  correspondiente: para cada `1 <= i <= n`, `Ti <: [T0/X0, …​, Tn/Xn]Vi`.

- El argumento `<exp2>` tiene tipo `[T0/X0, …​, Tn/Xn]U1`.

- `T == [T0/X0, …​, Tn/Xn]U2`.

La expresión de llamada `<exp1> <T0,…​,Tn>? <exp2>` evalúa `exp1` a un resultado
`r1`. Si `r1` es `trap`, entonces el resultado es `trap`.

De lo contrario, `exp2` se evalúa a un resultado `r2`. Si `r2` es `trap`, la
expresión resulta en `trap`.

De lo contrario, `r1` es un valor de función,
`<shared-pat>? func <X0 <: V0, …​, n <: Vn> <pat1> { <exp> }` (para algún
entorno implícito), y `r2` es un valor `v2`. Si `<shared-pat>` está presente y
es de la forma `shared <query>? <pat>`, entonces la evaluación continúa
coincidiendo el valor de registro `{caller = p}` con `<pat>`, donde `p` es el
[`Principal`](../base/Principal.md) que invoca la función, típicamente un
usuario o un canister. La coincidencia continúa coincidiendo `v1` con `<pat1>`.
Si la coincidencia de patrones tiene éxito con algunos enlaces, entonces la
evaluación devuelve el resultado de `<exp>` en el entorno del valor de función
no mostrado, extendido con esos enlaces. De lo contrario, alguna coincidencia de
patrones ha fallado y la llamada resulta en `trap`.

Un `<parenthetical>`, cuando está presente, modifica los atributos dinámicos del
envío del mensaje (siempre que el tipo de retorno `T` sea de la forma `async U`,
es decir, un futuro). Los atributos reconocidos son:

- `cycles : Nat` para adjuntar ciclos.
- `timeout : Nat32` para introducir un tiempo de espera para la ejecución de
  mensajes de mejor esfuerzo.

:::note

La condición de exhaustividad en las expresiones de función `shared` asegura que
la coincidencia de patrones de argumentos no pueda fallar (ver
[funciones](#funciones)).

:::

:::note

Las llamadas a funciones locales con tipo de retorno `async` y funciones
`shared` pueden fallar debido a la falta de recursos del canister. Dichos fallos
resultarán en que la llamada lance inmediatamente un error con `code`
`#call_error { err_code = n }`, donde `n` es el valor `err_code` no cero
devuelto por ICP.

Versiones anteriores de Motoko entraban en trap en tales situaciones, lo que
dificultaba que el canister llamante mitigara tales fallos. Ahora, un llamante
puede manejar estos errores utilizando expresiones `try ... catch ...`
envolventes, si lo desea.

:::

### Funciones

La expresión de función
`<shared-pat>? func < X0 <: T0, …​, Xn <: Tn > <pat1> (: U2)? =? <block-or-exp>`
tiene tipo `<shared>? < X0 <: T0, ..., Xn <: Tn > U1-> U2` si, bajo la
suposición de que `X0 <: T0, …​, Xn <: Tn`:

- `<shared-pat>?` es de la forma `shared <query>? <pat>` si y solo si
  `<shared>?` es `shared <query>?` (los modificadores `<query>` deben coincidir,
  es decir, ambos están ausentes, ambos son `query`, o ambos son
  `composite query`).

- Todos los tipos en `T0, …​, Tn` y `U2` están bien formados y bien
  restringidos.

- El patrón `<pat>` tiene _tipo de contexto_ `{ caller : Principal }`.

- El patrón `<pat1>` tiene tipo `U1`.

- Si la función es `shared`, entonces `<pat>` y `<pat1>` deben ser exhaustivos.

- La expresión `<block-or-exp>` tiene tipo de retorno `U2` bajo la suposición de
  que `<pat1>` tiene tipo `U1`.

`<shared-pat>? func <typ-params>? <pat1> (: <typ>)? =? <block-or-exp>` se evalúa
como un valor de función denotado
`<shared-pat>? func <typ-params>? <pat1> = <exp>`, que almacena el código de la
función junto con los enlaces del entorno de evaluación actual necesarios para
evaluar las llamadas al valor de la función.

Nota que una función `<shared-pat>` puede ser `shared <pat>`,
`shared query <pat>` o `shared composite query <pat>`.

- Una función `shared <pat>` puede ser invocada desde un llamante remoto. A
  menos que cause un error, los efectos en el destinatario persisten más allá de
  la finalización de la llamada.

- Una función `shared query <pat>` también puede ser invocada desde un llamante
  remoto, pero los efectos en el destinatario son transitorios y se descartan
  una vez que la llamada ha finalizado con un resultado (ya sea un valor o un
  error).

- Una función `shared composite query <pat>` solo puede ser invocada como un
  mensaje de entrada, no desde un llamante remoto. Al igual que una consulta,
  los efectos en el destinatario son transitorios y se descartan una vez que la
  llamada ha finalizado con un resultado, ya sea un valor o un error. Además,
  los cambios de estado intermedios realizados por la llamada no son observables
  por ninguno de sus destinatarios `query` o `composite query`.

En cualquier caso, `<pat>` proporciona acceso a un valor de contexto que
identifica al _llamante_ de la función compartida.

:::note

El tipo de contexto es un registro para permitir la extensión con más campos en
futuras versiones.

:::

Las funciones compartidas tienen diferentes capacidades dependiendo de su
calificación como `shared`, `shared query` o `shared composite query`.

Una función `shared` puede llamar a cualquier función `shared` o `shared query`,
pero no a ninguna función `shared composite query`. Una función `shared query`
no puede llamar a ninguna función `shared`, `shared query` o
`shared composite query`. Una función `shared composite query` puede llamar a
cualquier función `shared query` o `shared composite query`, pero no a ninguna
función `shared`.

Todas las variedades de funciones compartidas pueden llamar a funciones no
compartidas.

Las consultas compuestas, aunque son componibles, solo pueden ser llamadas
externamente, como desde un frontend, y no pueden ser iniciadas desde un actor.

### Bloques

La expresión de bloque `{ <dec>;* }` tiene tipo `T` siempre que la última
declaración en la secuencia `<dec>;*` tenga tipo `T`. Todos los identificadores
declarados en el bloque deben ser identificadores de tipo distintos o
identificadores de valor distintos y están en el alcance de la definición de
todas las demás declaraciones en el bloque.

Los enlaces de los identificadores declarados en `{ dec;* }` son locales al
bloque.

El sistema de tipos asegura que un identificador de valor no pueda ser evaluado
antes de que su declaración haya sido evaluada, evitando errores en tiempo de
ejecución a costa de rechazar algunos programas bien comportados.

Los identificadores cuyos tipos no pueden inferirse a partir de su declaración,
pero se usan en una referencia hacia adelante, pueden requerir una anotación de
tipo adicional (ver [patrón anotado](#patrón-anotado)) para satisfacer el
verificador de tipos.

La expresión de bloque `{ <dec>;* }` evalúa cada declaración en `<dec>;*` en
secuencia (orden del programa). La primera declaración en `<dec>;*` que resulta
en un error hace que el bloque resulte en `trap`, sin evaluar las declaraciones
posteriores.

### Do

La expresión `do` `do <block>` permite el uso de un bloque como una expresión,
en posiciones donde la sintaxis no permitiría directamente un bloque.

La expresión `do <block>` tiene tipo `T` siempre que `<block>` tenga tipo `T`.

La expresión `do` evalúa `<block>` y devuelve su resultado.

### Bloque de opción

El bloque de opción `do ? <block>` introduce el manejo de valores nulos en un
ámbito.

La expresión `do ? <block>` tiene tipo `?T` siempre que `<block>` tenga tipo
`T`.

La expresión `do ? <block>` evalúa `<block>` y devuelve su resultado como un
valor opcional.

Dentro de `<block>`, la expresión de ruptura nula `<exp1> !` sale del bloque
`do ?` más cercano con el valor `null` siempre que `<exp1>` tenga el valor
`null`, o continúa la evaluación con el contenido del valor opcional de
`<exp1>`. (Ver [Ruptura nula](#ruptura-nula)).

Los bloques de opción se anidan, y el objetivo de una ruptura nula está
determinado por el bloque de opción más cercano que lo contiene.

### Ruptura nula

La expresión de ruptura nula `<exp> !` invoca el manejo de valores nulos en un
ámbito y devuelve el contenido de un valor opcional o cambia el flujo de control
cuando el valor es `null`.

Tiene tipo `T` siempre que:

- La expresión aparezca en el cuerpo, `<block>`, de un bloque de opción
  envolvente de la forma `do ? <block>` (ver [bloque de opción](#do-opt)).

- `<exp>` tenga tipo opcional `? T`.

La expresión `<exp> !` evalúa `<exp>` a un resultado `r`. Si `r` es `trap`,
entonces el resultado es `trap`; si `r` es `null`, la ejecución se interrumpe
con el valor `null` desde el bloque de opción más cercano de la forma
`do ? <block>`; de lo contrario, `r` es `? v` y la ejecución continúa con el
valor `v`.

### Not

La expresión `not` `not <exp>` tiene tipo [`Bool`](../base/Bool.md) siempre que
`<exp>` tenga tipo [`Bool`](../base/Bool.md).

Si `<exp>` se evalúa como `trap`, la expresión devuelve `trap`. De lo contrario,
`<exp>` se evalúa como un valor booleano `v` y la expresión devuelve `not v`, la
negación booleana de `v`.

### And

La expresión `and` `<exp1> and <exp2>` tiene tipo [`Bool`](../base/Bool.md)
siempre que `<exp1>` y `<exp2>` tengan tipo [`Bool`](../base/Bool.md).

La expresión `<exp1> and <exp2>` evalúa `exp1` a un resultado `r1`. Si `r1` es
`trap`, la expresión resulta en `trap`. De lo contrario, `r1` es un valor
booleano `v`. Si `v == false`, la expresión devuelve el valor `false` (sin
evaluar `<exp2>`). De lo contrario, la expresión devuelve el resultado de
evaluar `<exp2>`.

### Or

La expresión `or` `<exp1> or <exp2>` tiene tipo [`Bool`](../base/Bool.md)
siempre que `<exp1>` y `<exp2>` tengan tipo [`Bool`](../base/Bool.md).

La expresión `<exp1> or <exp2>` evalúa `exp1` a un resultado `r1`. Si `r1` es
`trap`, la expresión resulta en `trap`. De lo contrario, `r1` es un valor
booleano `v`. Si `v == true`, la expresión devuelve el valor `true` sin evaluar
`<exp2>`. De lo contrario, la expresión devuelve el resultado de evaluar
`<exp2>`.

### If

La expresión `if <exp1> <exp2> (else <exp3>)?` tiene tipo `T` siempre que:

- `<exp1>` tenga tipo [`Bool`](../base/Bool.md).

- `<exp2>` tenga tipo `T`.

- `<exp3>` esté ausente y `() <: T`.

- `<exp3>` esté presente y tenga tipo `T`.

La expresión evalúa `<exp1>` a un resultado `r1`. Si `r1` es `trap`, el
resultado es `trap`. De lo contrario, `r1` es el valor `true` o `false`. Si `r1`
es `true`, el resultado es el resultado de evaluar `<exp2>`. De lo contrario,
`r1` es `false` y el resultado es `()` (si `<exp3>` está ausente) o el resultado
de `<exp3>` (si `<exp3>` está presente).

### Switch

La expresión `switch` `switch <exp> { (case <pat> <block-or-exp>;)+ }` tiene
tipo `T` siempre que:

- `<exp>` tenga tipo `U`.

- Para cada caso `case <pat> <block-or-exp>` en la secuencia
  `(case <pat> <block-or-exp>;)+`.

- El patrón `<pat>` tenga tipo `U`.

- La expresión `<block-or-exp>` tenga tipo `T`.

La expresión evalúa `<exp>` a un resultado `r`. Si `r` es `trap`, el resultado
es `trap`. De lo contrario, `r` es algún valor `v`. Sea
`case <pat> <block-or-exp>;` el primer caso en `(case <pat> <block-or-exp>;)+`
tal que `<pat>` coincida con `v` para algún enlace de identificadores a valores.
Entonces, el resultado del `switch` es el resultado de evaluar `<block-or-exp>`
bajo ese enlace. Si ningún caso tiene un patrón que coincida con `v`, el
resultado del `switch` es `trap`.

### While

La expresión `while <exp1> <exp2>` tiene tipo `()` siempre que:

- `<exp1>` tenga tipo [`Bool`](../base/Bool.md).

- `<exp2>` tenga tipo `()`.

La expresión evalúa `<exp1>` a un resultado `r1`. Si `r1` es `trap`, el
resultado es `trap`. De lo contrario, `r1` es el valor `true` o `false`. Si `r1`
es `true`, el resultado es el resultado de reevaluar `while <exp1> <exp2>`. De
lo contrario, el resultado es `()`.

### Loop

La expresión `loop <block-or-exp>` tiene tipo `None` siempre que
`<block-or-exp>` tenga tipo `()`.

La expresión evalúa `<block-or-exp>` a un resultado `r1`. Si `r1` es `trap`, el
resultado es `trap`. De lo contrario, el resultado es el resultado de reevaluar
`loop <block-or-exp>`.

### Loop-while

La expresión `loop <block-or-exp1> while <exp2>` tiene tipo `()` siempre que:

- `<block-or-exp1>` tenga tipo `()`.

- `<exp2>` tenga tipo [`Bool`](../base/Bool.md).

La expresión evalúa `<block-or-exp1>` a un resultado `r1`. Si `r1` es `trap`, el
resultado es `trap`. De lo contrario, la evaluación continúa con `<exp2>`,
produciendo el resultado `r2`. Si `r2` es `trap`, el resultado es `trap`. De lo
contrario, si `r2` es `true`, el resultado es el resultado de reevaluar
`loop <block-or-exp1> while <exp2>`. De lo contrario, `r2` es `false` y el
resultado es `()`.

### For

La expresión de iterador `for ( <pat> in <exp1> ) <block-or-exp2>` tiene tipo
`()` siempre que:

- `<exp1>` tenga tipo `{ next : () → ?T }`.

- El patrón `<pat>` tenga tipo `T`.

- La expresión `<block-or-exp2>` tenga tipo `()` (en el entorno extendido con
  los enlaces de `<pat>`).

La expresión `for` es azúcar sintáctica para lo siguiente, donde `x` y `l` son
identificadores frescos:

```bnf
for ( <pat> in <exp1> ) <block-or-exp2> :=
  {
    let x = <exp1>;
    label l loop {
      switch (x.next()) {
        case (? <pat>) <block-or-exp2>;
        case (null) break l;
      }
    }
  }
```

En particular, el bucle `for` entrará en trap si la evaluación de `<exp1>` entra
en trap; tan pronto como `x.next()` entre en trap, o el valor de `x.next()` no
coincida con el patrón `<pat>`, o cuando `<block-or-exp2>` entre en trap.

:::note

Aunque son de propósito general, los bucles `for` se usan comúnmente para
consumir iteradores producidos por
[acceso especial a miembros](#acceso-especial-a-miembros), por ejemplo, para
iterar sobre los índices (`a.keys()`) o los valores (`a.values()`) de algún
arreglo `a`.

:::

### Etiqueta (Label)

La expresión de etiqueta `label <id> (: <typ>)? <block-or-exp>` tiene tipo `T`
siempre que:

- `(: <typ>)?` esté ausente y `T` sea unitario; o `(: <typ>)?` esté presente y
  `T == <typ>`.

- `<block-or-exp>` tenga tipo `T` en el entorno estático extendido con
  `label l : T`.

El resultado de evaluar `label <id> (: <typ>)? <block-or-exp>` es el resultado
de evaluar `<block-or-exp>`.

### Bucles etiquetados

Si `<exp>` en `label <id> (: <typ>)? <exp>` es una construcción de bucle:

- `while (exp2) <block-or-exp1>`.

- `loop <block-or-exp1> (while (<exp2>))?`.

- `for (<pat> in <exp2>) <block-or-exp1>`.

El cuerpo, `<exp1>`, del bucle está implícitamente envuelto en
`label <id_continue> (…​)`, lo que permite la continuación temprana del bucle
mediante la evaluación de la expresión `continue <id>`.

`<id_continue>` es un identificador fresco que solo puede ser referenciado por
`continue <id>`, a través de su expansión implícita a `break <id_continue>`.

### Break

La expresión `break <id>` es equivalente a `break <id> ()`.

La expresión `break <id> <exp>` tiene tipo `None` siempre que:

- La etiqueta `<id>` esté declarada con tipo `label <id> : T`.

- `<exp>` tenga tipo `T`.

La evaluación de `break <id> <exp>` evalúa `<exp>` a algún resultado `r`. Si `r`
es `trap`, el resultado es `trap`. Si `r` es un valor `v`, la evaluación
abandona el cálculo actual hasta la declaración envolvente dinámicamente más
cercana `label <id> …​` usando el valor `v` como el resultado de esa expresión
etiquetada.

### Continue

La expresión `continue <id>` es equivalente a `break <id_continue>`, donde
`<id_continue>` está implícitamente declarado alrededor de los cuerpos de las
construcciones de bucle etiquetadas con `<id>` (ver
[bucles etiquetados](#bucles-etiquetados)).

### Return

La expresión `return` es equivalente a `return ()`.

La expresión `return <exp>` tiene tipo `None` siempre que:

- `<exp>` tenga tipo `T`.

- y una de las siguientes condiciones:

  - `T` es el tipo de retorno de la función envolvente más cercana sin una
    expresión `async` intermedia.

  - `async T` es el tipo de la expresión `async` envolvente más cercana, quizás
    implícita, sin una declaración de función intermedia.

La expresión `return` sale de la invocación de la función correspondiente o
completa la expresión `async` o `async*` correspondiente con el resultado de
`<exp>`.

### Async

La expresión `async` `<parenthetical>? async <block-or-exp>` tiene tipo
`async T` siempre que:

- `<block-or-exp>` tenga tipo `T`.

- `T` sea compartido.

Cualquier etiqueta de control de flujo en el alcance de `async <block-or-exp>`
no está en el alcance de `<block-or-exp>`. Sin embargo, `<block-or-exp>` puede
declarar y usar sus propias etiquetas locales.

El tipo de retorno implícito en `<block-or-exp>` es `T`. Es decir, la expresión
de retorno, `<exp0>`, implícita o explícita, para cualquier expresión
`return <exp0>?` envuelta, debe tener tipo `T`.

La evaluación de `async <block-or-exp>` encola un mensaje para evaluar
`<block-or-exp>` en el actor envolvente más cercano o en el nivel superior.
Inmediatamente devuelve un futuro de tipo `async T` que puede usarse para
`await` el resultado de la evaluación pendiente de `<exp>`.

La presencia de `<parenthetical>` modifica la semántica de la expresión `async`
para:

- Adjuntar ciclos con el atributo `cycles : Nat`.
- Imponer un tiempo de espera (observado al esperar el resultado) con el
  atributo `timeout : Nat32`.

:::note

Debido a que implica mensajería, la evaluación de una expresión `async` puede
fallar debido a la falta de recursos del canister.

Tales fallos resultarán en que la llamada lance inmediatamente un error con
`code` `#call_error { err_code = n }`, donde `n` es el valor `err_code` no cero
devuelto por ICP.

Versiones anteriores de Motoko entraban en trap en tales situaciones, lo que
dificultaba que el productor de la expresión `async` mitigara tales fallos.
Ahora, el productor puede manejar estos errores usando una expresión
`try ... catch ...` envolvente, si lo desea.

:::

### Await

La expresión `await` `await <exp>` tiene tipo `T` siempre que:

- `<exp>` tenga tipo `async T`.

- `T` sea compartido.

- El `await` esté explícitamente envuelto por una expresión `async` o aparezca
  en el cuerpo de una función `shared`.

La expresión `await <exp>` evalúa `<exp>` a un resultado `r`. Si `r` es `trap`,
la evaluación devuelve `trap`. De lo contrario, `r` es un futuro. Si el `futuro`
está incompleto, es decir, su evaluación aún está pendiente, `await <exp>`
suspende la evaluación de la expresión `async` o función `shared` envolvente más
cercana, agregando la suspensión a la cola de espera del `futuro`. La ejecución
de la suspensión se reanuda una vez que el futuro se complete, si es que lo
hace. Si el futuro se completa con el valor `v`, entonces `await <exp>` suspende
la evaluación y programa la reanudación de la ejecución con el valor `v`. Si el
futuro se completa con un valor de error `e`, entonces `await <exp>` suspende la
evaluación y programa la reanudación de la ejecución relanzando el error `e`.

Suspender el cálculo en `await`, independientemente del estado dinámico del
futuro, asegura que todos los cambios de estado tentativos y los envíos de
mensajes previos al `await` se confirmen y sean irrevocables.

:::danger

Entre la suspensión y la reanudación de un cálculo, el estado del actor
envolvente puede cambiar debido al procesamiento concurrente de otros mensajes
entrantes del actor. Es responsabilidad del programador protegerse contra
cambios de estado no sincronizados.

El uso de `await` indica que el cálculo confirmará su estado actual y suspenderá
la ejecución.

:::

:::note

Debido a que implica mensajería adicional, un `await` en un futuro completado
puede, en raras circunstancias, fallar debido a la falta de recursos del
canister. Tales fallos resultarán en que la llamada lance inmediatamente un
error con `code` `#call_error { err_code = n }`, donde `n` es el valor
`err_code` no cero devuelto por ICP.

El error se produce de manera inmediata, sin suspender ni confirmar el estado.
Versiones anteriores de Motoko entraban en trap en tales situaciones, lo que
dificultaba que el consumidor del `await` mitigara tales fallos. Ahora, el
consumidor puede manejar estos errores usando una expresión `try ... catch ...`
envolvente, si lo desea.

:::

### Async\*

La expresión `async*` `async* <block-or-exp>` tiene tipo `async* T` siempre que:

- `<block-or-exp>` tenga tipo `T`.

- `T` sea compartido.

Cualquier etiqueta de control de flujo en el alcance de `async* <block-or-exp>`
no está en el alcance de `<block-or-exp>`. Sin embargo, `<block-or-exp>` puede
declarar y usar sus propias etiquetas locales.

El tipo de retorno implícito en `<block-or-exp>` es `T`. Es decir, la expresión
de retorno, `<exp0>`, implícita o explícita, para cualquier expresión
`return <exp0>?` envuelta, debe tener tipo `T`.

La evaluación de `async* <block-or-exp>` produce un cálculo retrasado para
evaluar `<block-or-exp>`. Inmediatamente devuelve un valor de tipo `async* T`.
El cálculo retrasado puede ejecutarse usando `await*`, produciendo una
evaluación del cálculo `<block-or-exp>`.

:::danger

Nota que `async <block-or-exp>` tiene el efecto de programar una única
evaluación asíncrona de `<exp>`, independientemente de si su resultado, un
futuro, se consume con un `await`. Además, cada consumo adicional con un `await`
simplemente devuelve el resultado anterior, sin repetir el cálculo.

En comparación, `async* <block-or_exp>`, no tiene efecto hasta que su valor se
consume con un `await*`. Además, cada consumo adicional con un `await*`
desencadenará una nueva evaluación de `<block-or-exp>`, incluyendo efectos
repetidos.

Ten cuidado con esta distinción, y otras diferencias, al refactorizar código.

:::

:::note

Las construcciones `async*` y `await*` correspondientes son útiles para abstraer
eficientemente código asíncrono en funciones reutilizables. En comparación,
llamar a una función local que devuelve un tipo `async` adecuado requiere
confirmar el estado y suspender la ejecución con cada `await` de su resultado,
lo que puede ser indeseable.

:::

### Await\*

La expresión `await*` `await* <exp>` tiene tipo `T` siempre que:

- `<exp>` tenga tipo `async* T`.

- `T` sea compartido.

- El `await*` esté explícitamente envuelto por una expresión `async` o aparezca
  en el cuerpo de una función `shared`.

La expresión `await* <exp>` evalúa `<exp>` a un resultado `r`. Si `r` es `trap`,
la evaluación devuelve `trap`. De lo contrario, `r` es un cálculo retrasado
`<block-or-exp>`. La evaluación de `await* <exp>` procede con la evaluación de
`<block-or-exp>`, ejecutando el cálculo retrasado.

:::danger

Durante la evaluación de `<block-or-exp>`, el estado del actor envolvente puede
cambiar debido al procesamiento concurrente de otros mensajes entrantes del
actor. Es responsabilidad del programador protegerse contra cambios de estado no
sincronizados.

:::

:::note

A diferencia de `await`, que, independientemente del estado dinámico del futuro,
asegura que todos los cambios de estado tentativos y los envíos de mensajes
previos al `await` se confirmen y sean irrevocables, `await*` no confirma ningún
cambio de estado por sí mismo, ni suspende el cálculo. En su lugar, la
evaluación procede inmediatamente según `<block-or-exp>`, el valor de `<exp>`,
confirmando el estado y suspendiendo la ejecución cada vez que `<block-or-exp>`
lo haga, pero no de otra manera.

:::

:::note

La evaluación de un bloque `async*` retrasado es sincrónica mientras sea
posible, cambiando a asíncrona cuando sea necesario debido a un `await`
adecuado.

El uso de `await*` indica que el cálculo _puede_ confirmar el estado y suspender
la ejecución durante la evaluación de `<block-or-exp>`, es decir, que la
evaluación de `<block-or-exp>` puede realizar cero o más `await` adecuados y
puede intercalarse con la ejecución de otros mensajes concurrentes.

:::

### Throw

La expresión `throw` `throw <exp>` tiene tipo `None` siempre que:

- `<exp>` tenga tipo [`Error`](../base/Error.md).

- El `throw` esté explícitamente envuelto por una expresión `async` o aparezca
  en el cuerpo de una función `shared`.

La expresión `throw <exp>` evalúa `<exp>` a un resultado `r`. Si `r` es `trap`,
la evaluación devuelve `trap`. De lo contrario, `r` es un valor de error `e`. La
ejecución procede desde la cláusula `catch` de la expresión `try` envolvente más
cercana `try <block-or-exp1> catch <pat> <block-or-exp2>` cuyo patrón `<pat>`
coincida con el valor `e`. Si no existe tal expresión `try`, `e` se almacena
como el resultado erróneo del valor `async` de la expresión `async`, `async*` o
invocación de función `shared` envolvente más cercana.

### Try

La expresión `try` `try <block-or-exp1> catch <pat> <block-or-exp2>` tiene tipo
`T` siempre que:

- `<block-or-exp1>` tenga tipo `T`.

- `<pat>` tenga tipo [`Error`](../base/Error.md) y `<block-or-exp2>` tenga tipo
  `T` en el contexto extendido con `<pat>`.

- El `try` esté explícitamente envuelto por una expresión `async` o aparezca en
  el cuerpo de una función `shared`.

La expresión `try <block-or-exp1> catch <pat> <block-or-exp2>` evalúa
`<block-or-exp1>` a un resultado `r`. Si la evaluación de `<block-or-exp1>`
lanza un valor de error `e` no capturado, el resultado del `try` es el resultado
de evaluar `<block-or-exp2>` bajo los enlaces determinados por la coincidencia
de `e` con `pat`.

:::note

Debido a que el tipo [`Error`](../base/Error.md) es opaco, la coincidencia de
patrones no puede fallar. El sistema de tipos asegura que `<pat>` sea un patrón
comodín o identificador irrefutable.

:::

La expresión `try` puede proporcionarse con una cláusula `finally` de limpieza
para facilitar la reversión estructurada de cambios de estado temporales (por
ejemplo, para liberar un bloqueo). La cláusula `catch` anterior puede omitirse
en presencia de una cláusula `finally`.

Esta forma es
`try <block-or-exp1> (catch <pat> <block-or-exp2>)? finally <block-or-exp3>`, y
la evaluación procede como se describió anteriormente con la adición crucial de
que cada ruta de control que sale de `<block-or-exp1>` o `<block-or-exp2>`
ejecutará la expresión `<block-or-exp3>` de valor unitario antes de que la
expresión `try` completa produzca su resultado. La expresión de limpieza también
se ejecutará cuando el procesamiento después de un `await` intermedio
(directamente o indirectamente como `await*`) entre en trap.

:::danger

El código dentro de un bloque `finally` debe terminar rápidamente y no entrar en
trap. Un bloque `finally` que entra en trap no liberará su ranura en la tabla de
callbacks, lo que puede impedir una futura actualización. En esta situación, el
canister debe detenerse explícitamente antes de intentar nuevamente la
actualización. Además, se debe tener cuidado de liberar cualquier recurso que
pueda haber quedado adquirido debido a la trap. El canister puede reiniciarse
después de la actualización.

:::

Ver [Tipo Error](#tipo-error).

### Assert

La expresión `assert` `assert <exp>` tiene tipo `()` siempre que `<exp>` tenga
tipo [`Bool`](../base/Bool.md).

La expresión `assert <exp>` evalúa `<exp>` a un resultado `r`. Si `r` es `trap`,
la evaluación devuelve `trap`. De lo contrario, `r` es un valor booleano `v`. El
resultado de `assert <exp>` es:

- El valor `()`, cuando `v` es `true`.

- `trap`, cuando `v` es `false`.

### Anotación de tipo

La expresión de anotación de tipo `<exp> : <typ>` tiene tipo `T` siempre que:

- `<typ>` sea `T`.

- `<exp>` tenga tipo `U` donde `U <: T`.

La anotación de tipo puede usarse para ayudar al verificador de tipos cuando no
puede determinar el tipo de `<exp>` de otra manera o cuando se desea restringir
el tipo inferido, `U` de `<exp>` a un supertipo menos informativo `T` siempre
que `U <: T`.

El resultado de evaluar `<exp> : <typ>` es el resultado de evaluar `<exp>`.

:::note

Las anotaciones de tipo no tienen costo en tiempo de ejecución y no pueden
usarse para realizar las conversiones hacia abajo (checked o unchecked)
disponibles en otros lenguajes orientados a objetos.

:::

### Serialización Candid

La expresión de serialización Candid `to_candid ( <exp>,*)` tiene tipo
[`Blob`](../base/Blob.md) siempre que:

- `(<exp>,*)` tenga tipo `(T1,…​,Tn)`, y cada `Ti` sea compartido.

La expresión `to_candid ( <exp>,* )` evalúa la secuencia de expresiones
`( <exp>,* )` a un resultado `r`. Si `r` es `trap`, la evaluación devuelve
`trap`. De lo contrario, `r` es una secuencia de valores Motoko `vs`. El
resultado de evaluar `to_candid ( <exp>,* )` es algún blob Candid
`b = encode((T1,...,Tn))(vs)`, codificando `vs`.

La expresión de deserialización Candid `from_candid <exp>` tiene tipo
`?(T1,…​,Tn)` siempre que:

- `?(T1,…​,Tn)` sea el tipo esperado del contexto.

- `<exp>` tenga tipo [`Blob`](../base/Blob.md).

- `?(T1,…​,Tn)` sea compartido.

La expresión `from_candid <exp>` evalúa `<exp>` a un resultado `r`. Si `r` es
`trap`, la evaluación devuelve `trap`. De lo contrario, `r` es un blob binario
`b`. Si `b` se decodifica en Candid a una secuencia de valores Candid `Vs` de
tipo `ea((T1,...,Tn))`, entonces el resultado de `from_candid` es `?v` donde
`v = decode((T1,...,Tn))(Vs)`. Si `b` se decodifica en Candid a una secuencia de
valores Candid `Vs` que no es del tipo Candid `ea((T1,...,Tn))` (pero está bien
formada en algún otro tipo), entonces el resultado es `null`. Si `b` no es la
codificación de ningún valor Candid bien tipado, sino algún blob binario
arbitrario, entonces el resultado de `from_candid` es un error.

Informalmente, aquí `ea(_)` es la traducción de secuencias de tipos Motoko a
Candid y `encode/decode((T1,...,Tn))(_)` son traducciones de valores
Motoko-Candid dirigidas por tipos.

<!--
ea(_) is defined in design doc motoko/design/IDL-Motoko.md, but `encode` and `decode` are not explicitly defined anywhere except in the implementation.
-->

:::note

La operación `from_candid` devuelve `null` cuando el argumento es una
codificación Candid válida pero del tipo incorrecto. Entra en trampa si el blob
no es una codificación Candid válida en absoluto.

:::

:::note

Las operaciones `to_candid` y `from_candid` son operadores sintácticos, no
funciones de primera clase, y deben aplicarse completamente en la sintaxis.

:::

:::danger

La codificación Candid de un valor como un blob no es única, y el mismo valor
puede tener muchas representaciones Candid diferentes como un blob. Por esta
razón, los blobs nunca deben usarse para, por ejemplo, calcular hashes de
valores o determinar igualdad, ya sea entre versiones del compilador o incluso
entre diferentes programas.

:::

### Declaración

La expresión de declaración `<dec>` tiene tipo `T` siempre que la declaración
`<dec>` tenga tipo `T`.

La evaluación de la expresión `<dec>` procede evaluando `<dec>`, devolviendo el
resultado de `<dec>` pero descartando los enlaces introducidos por `<dec>`, si
los hay.

La expresión `<dec>` es en realidad una forma abreviada de la expresión de
bloque `do { <dec> }`.

### Ignore

La expresión `ignore <exp>` tiene tipo `()` siempre que la expresión `<exp>`
tenga tipo `Any`.

La expresión `ignore <exp>` evalúa `<exp>`, típicamente por algún efecto
secundario, pero descarta su valor.

La declaración `ignore` es útil para evaluar una expresión dentro de una
secuencia de declaraciones cuando esa expresión tiene un tipo no unitario, y la
declaración más simple `<exp>` sería incorrecta en términos de tipos. Entonces,
la semántica es equivalente a `let _ = <exp> : Any`.

### Debug

La expresión `debug` `debug <block-or-exp>` tiene tipo `()` siempre que la
expresión `<block-or-exp>` tenga tipo `()`.

Cuando el programa se compila o interpreta con la bandera (predeterminada)
`--debug`, la evaluación de la expresión `debug <exp>` procede evaluando
`<block-or-exp>`, devolviendo el resultado de `<block-or-exp>`.

Cuando el programa se compila o interpreta con la bandera `--release`, la
evaluación de la expresión `debug <exp>` devuelve inmediatamente el valor
unitario `()`. El código de `<block-or-exp>` nunca se ejecuta, ni se incluye en
el binario compilado.

### Referencias de actores

La referencia de actor `actor <exp>` tiene el tipo esperado `T` siempre que:

- La expresión se use en un contexto que espera una expresión de tipo `T`,
  típicamente como el sujeto de una anotación de tipo, declaración tipada o
  argumento de función.

- `T` es algún tipo de actor `actor { …​ }`.

- `<exp>` tiene tipo [`Text`](../base/Text.md).

El argumento `<exp>` debe ser, o evaluarse a, el formato textual de un
identificador de canister, especificado en otro lugar; de lo contrario, la
expresión entra en trampa. El resultado de la expresión es un valor de actor que
representa ese canister.

La validez del identificador del canister y su tipo declarado `T` son promesas y
se toman en confianza.

Un identificador de canister inválido o un tipo incorrecto pueden manifestarse,
si es que lo hacen, como un fallo dinámico posterior al llamar a una función en
la interfaz proclamada del actor, que fallará o será rechazada.

:::note

El argumento de `actor` no debe incluir el localizador de recursos `ic:`
utilizado para especificar una `import`. Por ejemplo, use `actor "lg264-qjkae"`,
no `actor "ic:lg264-qjkae"`.

:::

:::danger

Aunque no comprometen la seguridad de tipos, las referencias de actores pueden
introducir fácilmente errores dinámicos latentes. Por lo tanto, las referencias
de actores deben usarse con moderación y solo cuando sea necesario.

:::

### Paréntesis

La expresión entre paréntesis `( <exp> )` tiene tipo `T` siempre que `<exp>`
tenga tipo `T`.

El resultado de evaluar `( <exp> )` es el resultado de evaluar `<exp>`.

### Subsunción

Siempre que `<exp>` tenga tipo `T` y `T <: U`, con `T` subtipo de `U`, entonces,
en virtud de la subsunción implícita, `<exp>` también tiene tipo `U` sin
sintaxis adicional.

En general, esto significa que una expresión de un tipo más específico puede
aparecer donde se espera una expresión de un tipo más general, siempre que los
tipos específico y general estén relacionados por subtipado. Este cambio
estático de tipo no tiene costo en tiempo de ejecución.

## Referencias

- **IEEE Standard for Floating-Point Arithmetic**, en IEEE Std 754-2019
  (Revisión de IEEE 754-2008), vol., no., pp.1-84, 22 de julio de 2019, doi:
  10.1109/IEEESTD.2019.8766229.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
