---
sidebar_position: 17
---

# Estado mutable

Cada actor en Motoko puede usar, pero nunca compartir directamente, estado
mutable interno.

Los datos inmutables pueden ser [compartidos entre actores](sharing.md), y
también manejados a través de los puntos de entrada externos de cada uno, que
funcionan como funciones compartibles. A diferencia de los datos compartibles,
una invariante clave del diseño de Motoko es que los datos mutables se mantienen
privados para el actor que los asigna y nunca se comparten de forma remota.

## Variables inmutables vs mutables

La sintaxis `var` declara variables mutables en un bloque de declaración:

```motoko name=init
let text  : Text = "abc";
let num  : Nat = 30;

var pair : (Text, Nat) = (text, num);
var text2 : Text = text;
```

La lista de declaraciones anterior declara cuatro variables. Las dos primeras
variables (`text` y `num`) son variables inmutables con alcance léxico. Las dos
variables finales (`pair` y `text2`) son variables mutables con alcance léxico.

## Asignación a memoria mutable

Las variables mutables permiten la asignación y las variables inmutables no.

Si intentas asignar nuevos valores a [`Text`](../base/Text.md) o `num`
anteriores, obtendrás errores de tipo estático porque estas variables son
inmutables.

Puedes actualizar libremente el valor de las variables mutables `pair` y `text2`
utilizando la sintaxis de asignación, escrita como `:=`, de la siguiente manera:

```motoko no-repl
text2 := text2 # "xyz";
pair := (text2, pair.1);
pair
```

En el ejemplo anterior, cada variable se actualiza en función de aplicar una
regla de actualización simple a sus valores actuales. Del mismo modo, un actor
procesa algunas llamadas realizando actualizaciones en sus variables mutables
privadas, utilizando la misma sintaxis de asignación que se muestra arriba.

### Operaciones de asignación especial

La operación de asignación `:=` es general y funciona para todos los tipos.

Motoko incluye operaciones de asignación especial que combinan la asignación con
una operación binaria. El valor asignado utiliza la operación binaria en un
operando dado y el contenido actual de la variable asignada.

Por ejemplo, los números permiten una combinación de asignación y suma:

```motoko
var num2 = 2;
num2 += 40;
num2
```

Después de la segunda línea, la variable `num2` contiene `42`, como se
esperaría.

Motoko también incluye otras combinaciones. Por ejemplo, podemos reescribir la
línea anterior que actualiza `text2` de manera más concisa como:

```motoko no-repl
text2 #= "xyz";
text2
```

Como con `+=`, esta forma combinada evita repetir el nombre de la variable
asignada en el lado derecho del operador de asignación especial `#=`.

La tabla completa de
[operadores de asignación](../reference/language-manual#assignment-operators)
enumera operaciones numéricas, lógicas y de texto sobre tipos apropiados como
números, booleanos y valores de texto, respectivamente.

## Lectura desde memoria mutable

Una vez que hayas actualizado cada variable, debes leer desde los contenidos
mutables. Esto no requiere una sintaxis especial.

Cada uso de una variable mutable se ve como el uso de una variable inmutable,
pero no actúa como tal. De hecho, su significado es más complejo. Como en muchos
otros lenguajes, la sintaxis de cada uso oculta el efecto de memoria que accede
a la celda de memoria identificada por esa variable y obtiene su valor actual.
Otros lenguajes de tradiciones funcionales generalmente exponen estos efectos
sintácticamente.

## Variables vinculadas con `var` vs `let`

Considera las siguientes dos declaraciones de variables, que se ven similares:

```motoko
let x : Nat = 0
```

```motoko
var x : Nat = 0
```

La única diferencia en su sintaxis es el uso de la palabra clave `let` frente a
`var` para definir la variable `x`, que en cada caso el programa inicializa en
`0`.

Sin embargo, estos programas tienen significados diferentes, y en el contexto de
programas más grandes, la diferencia en los significados afectará el significado
de cada aparición de `x`.

Para el primer programa, que usa `let`, cada aparición de `x` significa `0`.
Reemplazar cada aparición con `0` no cambiará el significado del programa.

Para el segundo programa, que usa `var`, cada aparición significa "lee y produce
el valor actual de la celda de memoria mutable llamada `x`". En este caso, el
valor de cada aparición está determinado por el estado dinámico del contenido de
la celda de memoria mutable llamada `x`.

Como se puede ver en las definiciones anteriores, existe un contraste
fundamental entre los significados de las variables vinculadas con `let` y las
vinculadas con `var`.

En programas grandes, ambos tipos de variables pueden ser útiles, y ninguno de
los dos sirve como un buen reemplazo para el otro. Sin embargo, las variables
vinculadas con `let` son más fundamentales.

Por ejemplo, en lugar de declarar `x` como una variable mutable que inicialmente
contiene `0`, podrías usar `y`, una variable inmutable que denota un arreglo
mutable con una entrada que contiene `0`:

```motoko
var x : Nat       = 0 ;
let y : [var Nat] = [var 0] ;
```

La sintaxis de lectura y escritura requerida para esta codificación reutiliza la
de los arreglos mutables, lo cual no es tan legible como la de las variables
vinculadas con `var`. Por ello, las lecturas y escrituras de la variable `x`
serán más fáciles de leer que las de la variable `y`.

Por esta razón práctica y otras, las variables vinculadas con `var` son un
aspecto central del diseño del lenguaje.

## Arreglos inmutables

Antes de discutir los [arreglos (arrays) mutables](#arreglos-mutables),
presentamos los arreglos inmutables, que comparten la misma sintaxis de
proyección pero no permiten actualizaciones mutables después de la asignación.

### Asignar un arreglo inmutable de constantes

```motoko
let a : [Nat] = [1, 2, 3] ;
```

El array `a` anterior contiene tres números naturales y tiene el tipo `[Nat]`.
En general, el tipo de un array inmutable es `[_]`, utilizando corchetes
cuadrados alrededor del tipo de los elementos del array, los cuales deben
compartir un único tipo común.

### Leer desde un índice de un array

Puedes leer desde un array utilizando la sintaxis habitual de corchetes `[` y
`]` alrededor del índice que deseas acceder:

```motoko no-repl
let x : Nat = a[2] + a[0] ;
```

Cada acceso a un arreglo en Motoko es seguro. Los accesos que están fuera de los
límites no accederán a la memoria de manera insegura, sino que harán que el
programa falle como con una falla de
[assertion](../getting-started/basic-concepts#errores-traps).

## El módulo [`Array`](../base/Array.md)

La biblioteca estándar de Motoko proporciona operaciones básicas para arreglos
inmutables y mutables. Puede ser importada de la siguiente manera:

```motoko no-repl
import Array "mo:base/Array";
```

Para obtener más información sobre el uso de arreglos, consulta las
descripciones de la biblioteca [array](../base/Array.md).

### Asignar un arreglo inmutable con contenido variable

Cada nuevo arreglo asignado por un programa contendrá un número variable de
elementos. Sin mutación, necesitas una forma de especificar esta familia de
elementos de una vez en el argumento de asignación.

Para satisfacer esta necesidad, el lenguaje Motoko proporciona la función de
asignación de arreglos de orden superior `Array.tabulate`, que asigna un nuevo
arreglo consultando una función de generación proporcionada por el usuario,
`gen`, para cada elemento.

```motoko no-repl
func tabulate<T>(size : Nat,  gen : Nat -> T) : [T]
```

La función `gen` especifica el arreglo como un valor de función de tipo flecha
`Nat → T`, donde `T` es el tipo final de los elementos del arreglo.

La función `gen` en realidad funciona como el arreglo durante su inicialización.
Recibe el índice del elemento del arreglo y produce el elemento de tipo `T` que
debe residir en ese índice del arreglo. El arreglo de salida asignado se popula
en función de esta especificación.

Por ejemplo, puedes primero asignar `array1` que consiste en algunas constantes
iniciales, luego actualizar funcionalmente algunos de los índices cambiándolos
de manera pura y funcional, para producir `array2`, un segundo arreglo que no
destruye el primero.

```motoko no-repl
let array1 : [Nat] = [1, 2, 3, 4, 6, 7, 8] ;

let array2 : [Nat] = Array.tabulate<Nat>(7, func(i:Nat) : Nat {
    if ( i == 2 or i == 5 ) { array1[i] * i } // change 3rd and 6th entries
    else { array1[i] } // no change to other entries
  }) ;
```

Aunque cambiamos `array1` a `array2` en un sentido funcional, observa que ambos
arreglos y ambas variables son inmutables.

## Arreglos mutables

Cada arreglo mutable en Motoko introduce un estado mutable privado del actor.

Debido a que el sistema de tipos de Motoko asegura que los actores remotos no
compartan su estado mutable, el sistema de tipos de Motoko introduce una
distinción clara entre arreglos mutables e inmutables que impacta en la
tipificación, subtipificación y las abstracciones del lenguaje para la
comunicación asíncrona.

Localmente, los arreglos mutables no pueden usarse en lugares donde se esperan
arreglos inmutables, ya que la definición de Motoko de
[subtipificación](../reference/language-manual#subtyping) para arreglos
distingue correctamente estos casos para garantizar la solidez del tipo. Además,
en términos de comunicación entre actores, los arreglos inmutables son seguros
para enviar y compartir, mientras que los arreglos mutables no pueden
compartirse ni enviarse en mensajes. A diferencia de los arreglos inmutables,
los arreglos mutables tienen tipos no compartibles.

### Asignar un arreglo mutable de constantes

Para indicar la asignación de arreglos mutables, la sintaxis de arreglos
mutables `[var _]` utiliza la palabra clave `var` tanto en las expresiones como
en las formas de tipo:

```motoko
let a : [var Nat] = [var 1, 2, 3] ;
```

Como se mencionó anteriormente, el arreglo `a` contiene tres números naturales,
pero tiene el tipo `[var Nat]`.

### Asignar un arreglo mutable con tamaño dinámico

Para asignar arreglos mutables de tamaño no constante, utiliza la función
`Array.init` de la biblioteca base y proporciona un valor inicial:

```motoko no-repl
func init<T>(size : Nat,  x : T) : [var T]
```

Por ejemplo:

```motoko no-repl
var size : Nat = 42 ;
let x : [var Nat] = Array.init<Nat>(size, 3);
```

La variable `size` no necesita ser constante aquí. El arreglo tendrá `size`
número de entradas, cada una con el valor inicial `3`.

### Actualizaciones mutables

Los arreglos mutables, cada uno con la forma de tipo `[var _]`, permiten
actualizaciones mutables mediante la asignación a un elemento individual. En
este caso, el elemento con índice `2` se actualiza de contener `3` a contener el
valor `42`:

```motoko
let a : [var Nat] = [var 1, 2, 3];
a[2] := 42;
a
```

### La subtipificación no permite que lo mutable se use como inmutable

La subtipificación en Motoko no permite que usemos un arreglo mutable de tipo
`[var Nat]` en lugares que esperan uno inmutable de tipo `[Nat]`.

Hay dos razones para esto. Primero, al igual que con todo estado mutable, los
arreglos mutables requieren reglas diferentes para una subtipificación sólida.
En particular, los arreglos mutables tienen una definición de subtipificación
menos flexible, necesariamente. Segundo, Motoko prohíbe el uso de arreglos
mutables en la [comunicación asíncrona](actors-async.md), donde el estado
mutable nunca se comparte.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
