# Text

Funciones de utilidad para valores de `Text`.

Un valor de `Text` representa texto legible por humanos como una secuencia de
caracteres de tipo `Char`.

```motoko
let text = "Hello!";
let size = text.size(); // 6
let iter = text.chars(); // iterator ('H', 'e', 'l', 'l', 'o', '!')
let concat = text # " 👋"; // "Hello! 👋"
```

El módulo `"mo:base/Text"` define operaciones adicionales en valores de `Text`.

Importa el módulo desde la biblioteca base:

```motoko name=import
import Text "mo:base/Text";
```

Nota: Los valores de `Text` se representan como cuerdas de secuencias de
caracteres UTF-8 con concatenación O(1).

## Tipo `Text`

```motoko no-repl
type Text = Prim.Types.Text
```

El tipo correspondiente a los valores primitivos de `Text`.

```motoko
let hello = "Hello!";
let emoji = "👋";
let concat = hello # " " # emoji; // "Hello! 👋"
```

## Valor `fromChar`

```motoko no-repl
let fromChar : (c : Char) -> Text
```

Convierte el `Char` dado en un valor de `Text`.

```motoko include=import
let text = Text.fromChar('A'); // "A"
```

## Función `fromArray`

```motoko no-repl
func fromArray(a : [Char]) : Text
```

Convierte el `[Char]` dado en un valor de `Text`.

```motoko include=import
let text = Text.fromArray(['A', 'v', 'o', 'c', 'a', 'd', 'o']); // "Avocado"
```

Tiempo de ejecución: O(a.size()) Espacio: O(a.size())

## Función `fromVarArray`

```motoko no-repl
func fromVarArray(a : [var Char]) : Text
```

Convierte el `[var Char]` dado en un valor de `Text`.

```motoko include=import
let text = Text.fromVarArray([var 'E', 'g', 'g', 'p', 'l', 'a', 'n', 't']); // "Eggplant"
```

Tiempo de ejecución: O(a.size()) Espacio: O(a.size())

## Función `toIter`

```motoko no-repl
func toIter(t : Text) : Iter.Iter<Char>
```

Itera sobre cada valor `Char` en el `Text` dado.

Equivalente a llamar al método `t.chars()` donde `t` es un valor de `Text`.

```motoko include=import
import { print } "mo:base/Debug";

for (c in Text.toIter("abc")) {
  print(debug_show c);
}
```

## Función `toArray`

```motoko no-repl
func toArray(t : Text) : [Char]
```

Crea un nuevo `Array` que contiene los caracteres del `Text` dado.

Equivalente a `Iter.toArray(t.chars())`.

```motoko include=import
assert Text.toArray("Café") == ['C', 'a', 'f', 'é'];
```

Tiempo de ejecución: O(t.size()) Espacio: O(t.size())

## Función `toVarArray`

```motoko no-repl
func toVarArray(t : Text) : [var Char]
```

Crea un nuevo `Array` mutable que contiene los caracteres del `Text` dado.

Equivalente a `Iter.toArrayMut(t.chars())`.

```motoko include=import
assert Text.toVarArray("Café") == [var 'C', 'a', 'f', 'é'];
```

Tiempo de ejecución: O(t.size()) Espacio: O(t.size())

## Función `fromIter`

```motoko no-repl
func fromIter(cs : Iter.Iter<Char>) : Text
```

Crea un valor de `Text` a partir de un iterador de `Char`.

```motoko include=import
let text = Text.fromIter(['a', 'b', 'c'].vals()); // "abc"
```

## Función `fromList`

```motoko no-repl
func fromList(cs : List.List<Char>) : Text
```

Crea un texto a partir de una lista de caracteres. Ejemplo:

```motoko include=initialize
fromList(?('H', ?('e', ?('l', ?('l', ?('o', null))))));
// => "Hello"
```

Tiempo de ejecución: O(size cs) Espacio: O(size cs)

## Función `toList`

```motoko no-repl
func toList(t : Text) : List.List<Char>
```

Crea una lista de caracteres a partir de un texto. Ejemplo:

```motoko include=initialize
toList("Hello");
// => ?('H', ?('e', ?('l', ?('l', ?('o', null)))))
```

Tiempo de ejecución: O(t.size()) Espacio: O(t.size())

## Función `size`

```motoko no-repl
func size(t : Text) : Nat
```

Devuelve el número de caracteres en el `Text` dado.

Equivalente a llamar a `t.size()` donde `t` es un valor de `Text`.

```motoko include=import
let size = Text.size("abc"); // 3
```

## Función `hash`

```motoko no-repl
func hash(t : Text) : Hash.Hash
```

Devuelve un hash obtenido mediante el algoritmo `djb2`
([más detalles](http://www.cse.yorku.ca/~oz/hash.html)).

```motoko include=import
let hash = Text.hash("abc");
```

Nota: este algoritmo está destinado a ser utilizado en estructuras de datos en
lugar de como una función hash criptográfica.

## Función `concat`

```motoko no-repl
func concat(t1 : Text, t2 : Text) : Text
```

Devuelve `t1 # t2`, donde `#` es el operador de concatenación de `Text`.

```motoko include=import
let a = "Hello";
let b = "There";
let together = a # b; // "HelloThere"
let withSpace = a # " " # b; // "Hello There"
let togetherAgain = Text.concat(a, b); // "HelloThere"
```

## Función `equal`

```motoko no-repl
func equal(t1 : Text, t2 : Text) : Bool
```

Devuelve `t1 == t2`.

## Función `notEqual`

```motoko no-repl
func notEqual(t1 : Text, t2 : Text) : Bool
```

Devuelve `t1 != t2`.

## Función `less`

```motoko no-repl
func less(t1 : Text, t2 : Text) : Bool
```

Devuelve `t1 < t2`.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(t1 : Text, t2 : Text) : Bool
```

Devuelve `t1 <= t2`.

## Función `greater`

```motoko no-repl
func greater(t1 : Text, t2 : Text) : Bool
```

Devuelve `t1 > t2`.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(t1 : Text, t2 : Text) : Bool
```

Devuelve `t1 >= t2`.

## Función `compare`

```motoko no-repl
func compare(t1 : Text, t2 : Text) : {#less; #equal; #greater}
```

Compara `t1` y `t2` lexicográficamente.

```motoko include=import
import { print } "mo:base/Debug";

print(debug_show Text.compare("abc", "abc")); // #equal
print(debug_show Text.compare("abc", "def")); // #less
print(debug_show Text.compare("abc", "ABC")); // #greater
```

## Función `join`

```motoko no-repl
func join(sep : Text, ts : Iter.Iter<Text>) : Text
```

Une un iterador de valores `Text` con un delimitador dado.

```motoko include=import
let joined = Text.join(", ", ["a", "b", "c"].vals()); // "a, b, c"
```

## Función `map`

```motoko no-repl
func map(t : Text, f : Char -> Char) : Text
```

Aplica una función a cada carácter en un valor de `Text`, devolviendo los
resultados concatenados de `Char`.

```motoko include=import
// Replace all occurrences of '?' with '!'
let result = Text.map("Motoko?", func(c) {
  if (c == '?') '!'
  else c
});
```

## Función `translate`

```motoko no-repl
func translate(t : Text, f : Char -> Text) : Text
```

Devuelve el resultado de aplicar `f` a cada carácter en `ts`, concatenando los
valores de texto intermedios.

```motoko include=import
// Replace all occurrences of '?' with "!!"
let result = Text.translate("Motoko?", func(c) {
  if (c == '?') "!!"
  else Text.fromChar(c)
}); // "Motoko!!"
```

## Tipo `Pattern`

```motoko no-repl
type Pattern = {#char : Char; #text : Text; #predicate : (Char -> Bool)}
```

Un patrón `p` describe una secuencia de caracteres. Un patrón tiene una de las
siguientes formas:

- `#char c` coincide con la secuencia de un solo carácter, `c`.
- `#text t` coincide con la secuencia de texto de varios caracteres `t`.
- `#predicate p` coincide con cualquier secuencia de un solo carácter `c` que
  cumpla con el predicado `p(c)`.

Una _coincidencia_ para `p` es cualquier secuencia de caracteres que coincida
con el patrón `p`.

```motoko include=import
let charPattern = #char 'A';
let textPattern = #text "phrase";
let predicatePattern : Text.Pattern = #predicate (func(c) { c == 'A' or c == 'B' }); // matches "A" or "B"
```

## Función `split`

```motoko no-repl
func split(t : Text, p : Pattern) : Iter.Iter<Text>
```

Divide el `Text` de entrada con el `Pattern` especificado.

Dos campos están separados por exactamente una coincidencia.

```motoko include=import
let words = Text.split("This is a sentence.", #char ' ');
Text.join("|", words) // "This|is|a|sentence."
```

## Función `tokens`

```motoko no-repl
func tokens(t : Text, p : Pattern) : Iter.Iter<Text>
```

Devuelve una secuencia de tokens del `Text` de entrada delimitados por el
`Pattern` especificado, derivado de principio a fin. Un "token" es una
subsecuencia maximal no vacía de `t` que no contiene una coincidencia con el
patrón `p`. Dos tokens pueden estar separados por una o más coincidencias de
`p`.

```motoko include=import
let tokens = Text.tokens("this needs\n an   example", #predicate (func(c) { c == ' ' or c == '\n' }));
Text.join("|", tokens) // "this|needs|an|example"
```

## Función `contains`

```motoko no-repl
func contains(t : Text, p : Pattern) : Bool
```

Devuelve `true` si el `Text` de entrada contiene una coincidencia con el
`Pattern` especificado.

```motoko include=import
Text.contains("Motoko", #text "oto") // true
```

## Función `startsWith`

```motoko no-repl
func startsWith(t : Text, p : Pattern) : Bool
```

Devuelve `true` si el `Text` de entrada comienza con un prefijo que coincide con
el `Pattern` especificado.

```motoko include=import
Text.startsWith("Motoko", #text "Mo") // true
```

## Función `endsWith`

```motoko no-repl
func endsWith(t : Text, p : Pattern) : Bool
```

Devuelve `true` si el `Text` de entrada termina con un sufijo que coincide con
el `Pattern` especificado.

```motoko include=import
Text.endsWith("Motoko", #char 'o') // true
```

## Función `replace`

```motoko no-repl
func replace(t : Text, p : Pattern, r : Text) : Text
```

Devuelve el texto de entrada `t` con todas las coincidencias del patrón `p`
reemplazadas por el texto `r`.

```motoko include=import
let result = Text.replace("abcabc", #char 'a', "A"); // "AbcAbc"
```

## Función `stripStart`

```motoko no-repl
func stripStart(t : Text, p : Pattern) : ?Text
```

Elimina una ocurrencia del `Pattern` dado del principio del `Text` de entrada.
Si deseas eliminar múltiples instancias del patrón, utiliza `Text.trimStart()`
en su lugar.

```motoko include=import
// Try to strip a nonexistent character
let none = Text.stripStart("abc", #char '-'); // null
// Strip just one '-'
let one = Text.stripStart("--abc", #char '-'); // ?"-abc"
```

## Función `stripEnd`

```motoko no-repl
func stripEnd(t : Text, p : Pattern) : ?Text
```

Elimina una ocurrencia del `Pattern` dado del final del `Text` de entrada. Si
deseas eliminar múltiples instancias del patrón, utiliza `Text.trimEnd()` en su
lugar.

```motoko include=import
// Try to strip a nonexistent character
let none = Text.stripEnd("xyz", #char '-'); // null
// Strip just one '-'
let one = Text.stripEnd("xyz--", #char '-'); // ?"xyz-"
```

## Función `trimStart`

```motoko no-repl
func trimStart(t : Text, p : Pattern) : Text
```

Recorta el `Pattern` dado desde el principio del `Text` de entrada. Si solo
deseas eliminar una instancia del patrón, utiliza `Text.stripStart()` en su
lugar.

```motoko include=import
let trimmed = Text.trimStart("---abc", #char '-'); // "abc"
```

## Función `trimEnd`

```motoko no-repl
func trimEnd(t : Text, p : Pattern) : Text
```

Recorta el `Pattern` dado desde el final del `Text` de entrada. Si solo deseas
eliminar una instancia del patrón, utiliza `Text.stripEnd()` en su lugar.

```motoko include=import
let trimmed = Text.trimEnd("xyz---", #char '-'); // "xyz"
```

## Función `trim`

```motoko no-repl
func trim(t : Text, p : Pattern) : Text
```

Recorta el `Pattern` dado tanto desde el principio como desde el final del
`Text` de entrada.

```motoko include=import
let trimmed = Text.trim("---abcxyz---", #char '-'); // "abcxyz"
```

## Función `compareWith`

```motoko no-repl
func compareWith(t1 : Text, t2 : Text, cmp : (Char, Char) -> {#less; #equal; #greater}) : {#less; #equal; #greater}
```

Compara `t1` y `t2` utilizando la función de comparación de caracteres
proporcionada.

```motoko include=import
import Char "mo:base/Char";

Text.compareWith("abc", "ABC", func(c1, c2) { Char.compare(c1, c2) }) // #greater
```

## Valor `encodeUtf8`

```motoko no-repl
let encodeUtf8 : Text -> Blob
```

Devuelve un `Blob` codificado en UTF-8 a partir del `Text` dado.

```motoko include=import
let blob = Text.encodeUtf8("Hello");
```

## Valor `decodeUtf8`

```motoko no-repl
let decodeUtf8 : Blob -> ?Text
```

Intenta decodificar el `Blob` dado como UTF-8. Devuelve `null` si el blob no es
válido UTF-8.

```motoko include=import
let text = Text.decodeUtf8("\48\65\6C\6C\6F"); // ?"Hello"
```

## Valor `toLowercase`

```motoko no-repl
let toLowercase : Text -> Text
```

Devuelve el argumento de texto en minúsculas. ADVERTENCIA: Compatible con
Unicode solo cuando se compila, no cuando se interpreta.

```motoko include=import
let text = Text.toLowercase("Good Day"); // ?"good day"
```

## Valor `toUppercase`

```motoko no-repl
let toUppercase : Text -> Text
```

Devuelve el argumento de texto en mayúsculas. Compatible con Unicode.
ADVERTENCIA: Compatible con Unicode solo cuando se compila, no cuando se
interpreta.

```motoko include=import
let text = Text.toUppercase("Good Day"); // ?"GOOD DAY"
```
