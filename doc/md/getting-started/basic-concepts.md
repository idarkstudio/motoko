---
sidebar_position: 2
---

# Conceptos y términos básicos

Motoko está diseñado para programación distribuida con **actores**. Cuando se
programa en ICP con Motoko, cada actor representa un contrato inteligente de
canister en ICP con una interfaz Candid. Dentro de Motoko, el término actor se
utiliza para referirse a cualquier canister creado en cualquier lenguaje que se
implemente en ICP. El papel de Motoko es facilitar la creación y el uso
programático de estos actores una vez implementados.

Antes de comenzar a escribir canisters en Motoko, debes familiarizarte con
algunos de los conceptos y términos básicos específicos de Motoko.

## Valores

### Valores primitivos

Motoko soporta los siguientes tipos y valores primitivos:

- [`Bool`](../base/Bool.md): Valores booleanos (`true` y `false`).

- [`Int`](../base/Int.md): Enteros (…​,`-2`, `-1`, `0`, `1`, `2`, …​) -
  variantes acotadas y no acotadas.

- [`Nat`](../base/Nat.md): Números naturales (`0`, `1`, `2`, …​) - variantes
  acotadas y no acotadas.

- `Char`: Caracteres de texto Unicode (`'a'`, `'B'`, `'☃'`).

- [`Text`](../base/Text.md): Valores de texto de cadenas de caracteres Unicode.

Por defecto, los **enteros** y los **números naturales** son **no acotados** y
no desbordan. En su lugar, utilizan representaciones que crecen para acomodar
cualquier número finito.

Por razones prácticas, Motoko también incluye tipos **acotados** para enteros y
números naturales, distintos de las versiones predeterminadas. Cada variante
acotada tiene un ancho de bits fijo (uno de `8`, `16`, `32`, `64`) que determina
el rango de valores representables, y cada una conlleva el potencial de
desbordamiento. Exceder un límite es un fallo en tiempo de ejecución que hace
que el programa genere un [error (trap)](#errores-traps).

No hay desbordamientos no verificados ni no capturados en Motoko, excepto en
situaciones bien definidas, para operaciones de **envoltura** explícitas,
indicadas por un carácter `%` convencional en el operador. El lenguaje
proporciona primitivas integradas para convertir entre estas diversas
representaciones numéricas.

### Valores no primitivos

Motoko permite tipos definidos por el usuario y cada una de las siguientes
formas de valores no primitivos y tipos asociados:

- [Tuplas](../reference/language-manual#tuplas), incluido el valor unitario (la
  "tupla vacía").

- [Arreglos](../reference/language-manual#arreglos) con variantes tanto
  **inmutables** como **mutables**.

- [Objetos](../reference/language-manual#objetos) con campos y métodos nombrados
  y desordenados.

- [Variantes](../reference/language-manual#tipos-variantes) con constructores
  nombrados y valores de carga útil opcionales.

- [Valores de función](../reference/language-manual#funciones), incluidas
  [funciones compartibles](../writing-motoko/sharing.md).

- [Valores asíncronos](../reference/language-manual#asíncronos), también
  conocidos como **promesas** o **futuros**.

- [Valores de error](../reference/language-manual#tipo-error) que llevan la
  carga útil de excepciones y fallos del sistema.

Para definiciones precisas del lenguaje de valores primitivos y no primitivos,
consulta la [referencia del lenguaje](../reference/language-manual).

## Impresión de valores

La función `print`, de la biblioteca base [`Debug`](../base/Debug.md), acepta
una cadena de texto de tipo [`Text`](../base/Text.md) como entrada y produce el
valor unitario de tipo unitario o `()` como salida.

Dado que los valores unitarios no contienen información, todos los valores de
tipo unitario son idénticos, por lo que la función `print` no produce un
resultado interesante. En lugar de un resultado, la función `print` tiene el
efecto de emitir la cadena de texto en forma legible para humanos en la terminal
de salida. Las funciones que tienen efectos secundarios, como emitir salida o
modificar el estado, a menudo se denominan **impuras**. Las funciones que
simplemente devuelven valores sin efectos secundarios adicionales se denominan
**puras**.

Puedes transformar la mayoría de los valores de Motoko en cadenas de texto
legibles para humanos con fines de depuración, sin tener que escribir esas
transformaciones manualmente. La primitiva `debug_show` permite convertir una
gran clase de valores en valores de tipo [`Text`](../base/Text.md).

## Sintaxis del programa Motoko

Cada programa de Motoko está compuesto por **declaraciones** y **expresiones**
cuyas clases sintácticas son distintas pero
[relacionadas](../reference/language-manual).

Las declaraciones introducen **variables inmutables**, **estado mutable**,
**actores**, **objetos**, **clases** y otros tipos. Las declaraciones pueden ser
mutuamente recursivas, pero en los casos en que no lo son, permiten semánticas
de sustitución, como reemplazar valores con un valor igual.

Las expresiones describen cálculos que involucran estas nociones.

Para implementar un programa válido en ICP, el programa debe consistir en una
expresión de actor introducida con la palabra clave `actor`.

Como punto de partida, el siguiente fragmento de código consta de dos
declaraciones para las variables `x` e `y` seguidas de una expresión para formar
un solo programa:

```motoko
let x = 1;
let y = x + 1;
x * y + x;
```

Este programa tiene un tipo de [`Nat`](../base/Nat.md) (número natural) y,
cuando se ejecuta, se evalúa en el valor [`Nat`](../base/Nat.md) de `3`.

Este programa es una lista de declaraciones que consta de tres declaraciones:

1. Variable inmutable `x`, a través de la declaración `let x = 1;`.

2. Variable inmutable `y`, a través de la declaración `let y = x + 1;`.

3. Una variable sin nombre e implícita que contiene el valor de la expresión
   final, `x * y + x`.

La expresión `x * y + x` ilustra que cada expresión se puede considerar como una
declaración cuando sea necesario, ya que el lenguaje declara implícitamente una
variable sin nombre con el valor de resultado de esa expresión.

Cuando la expresión aparece como la declaración final, esta expresión puede
tener cualquier tipo. Aquí, la expresión `x * y + x` tiene el tipo
[`Nat`](../base/Nat.md).

Las expresiones que no aparecen al final, sino dentro de la lista de
declaraciones, deben tener un tipo de unidad `()`.

Las restricciones de tipo de unidad se pueden ignorar utilizando explícitamente
la palabra clave `ignore` para descartar cualquier valor de resultado no
utilizado.

## Alcance léxico

Una lista de declaraciones no es en sí misma una expresión, por lo que no se
puede declarar otra variable con su valor final.

Se pueden formar **expresiones de bloque** a partir de una lista de
declaraciones al encerrarla entre llaves coincidentes. Los bloques solo se
permiten como subexpresiones de expresiones de flujo de control como `if`,
`loop`, `case`, etc. Una expresión de bloque produce un valor y, cuando se
encierra entre paréntesis, puede ocurrir dentro de una expresión compuesta más
grande.

:::note

Se proporcionan formas particulares de bloques para facilitar el procesamiento
de datos que pueden faltar o estar incompletos. Estos se describen en
[bloques de opción](../writing-motoko/pattern-matching.md#option-blocks-for-streamlined-processing-of-optional-data).

:::

En todos los demás lugares, se utiliza `do { ... }` para representar expresiones
de bloque y distinguir los bloques de los literales de objetos. Por ejemplo,
`do {}` es el bloque vacío de tipo `()`, mientras que `{}` es un registro vacío
de tipo de registro `{}`. Esta forma de bloque preserva la autonomía de la lista
de declaraciones y su elección de nombres de variables. Esto significa que los
ámbitos de las variables pueden anidarse, pero no pueden interferir a medida que
se anidan. Los teóricos del lenguaje llaman a esta idea **alcance léxico**.

Además de la claridad matemática, el principal beneficio práctico del alcance
léxico es la seguridad y su uso en la construcción de sistemas compuestos de
forma segura. Específicamente, Motoko ofrece propiedades de composición muy
sólidas. Por ejemplo, anidar tu programa dentro de un programa en el que no
confías no puede redefinir arbitrariamente tus variables con diferentes
significados.

## Sonoridad de tipos

Cada expresión de Motoko que pasa la verificación de tipos se considera **bien
tipada**. El **tipo** de una expresión de Motoko sirve como una promesa del
lenguaje al desarrollador sobre el comportamiento futuro del programa, si se
ejecuta.

En primer lugar, cada programa bien tipado se evaluará sin comportamiento
indefinido. Existe un espacio preciso de programas significativos. El sistema de
tipos garantiza que los programas se mantengan dentro de él y que todos los
programas bien tipados tengan un significado preciso.

Además, los tipos hacen una predicción precisa sobre el resultado del programa.
Si cede el control, el programa generará un **valor de resultado** que coincide
con el del programa original.

En ambos casos, las vistas estáticas y dinámicas del programa están vinculadas y
coinciden con el sistema de tipos estáticos. Este acuerdo es el principio
central de un sistema de tipos estáticos y se ofrece en Motoko como un aspecto
fundamental de su diseño.

El mismo sistema de tipos también garantiza que las interacciones asíncronas
coincidan entre las vistas estáticas y dinámicas del programa, y que los
mensajes resultantes generados nunca se desajusten en tiempo de ejecución. Este
acuerdo es similar en espíritu a los acuerdos de tipo de argumento de
llamador/llamado y tipo de retorno que uno espera en un lenguaje tipado.

## Anotaciones de tipo y variables

Las variables relacionan nombres estáticos y tipos estáticos con valores
dinámicos que solo están presentes en tiempo de ejecución.

En este sentido, los tipos de Motoko proporcionan una forma de documentación
confiable y verificada por el compilador en el código fuente del programa.

Considera este programa muy corto:

```motoko
let x : Nat = 1
```

En este ejemplo, el compilador infiere que la expresión `1` tiene el tipo
[`Nat`](../base/Nat.md), y que `x` tiene el mismo tipo.

En este caso, podemos omitir esta anotación sin cambiar el significado del
programa:

```motoko
let x = 1
```

Excepto en algunas situaciones esotéricas que involucran la sobrecarga de
operadores, las anotaciones de tipo no suelen afectar el significado del
programa mientras se ejecuta. Si se omiten y el compilador acepta el programa,
como es el caso anterior, el programa tiene el mismo significado y
comportamiento que tenía originalmente.

Sin embargo, a veces el compilador requiere anotaciones de tipo para inferir
otras suposiciones y verificar el programa en su conjunto. Cuando se agregan y
el compilador aún acepta el programa, se puede confirmar que las anotaciones
agregadas son consistentes con las existentes.

## Errores y mensajes de tipo

Motoko es un lenguaje de programación de tipado estático. Esto significa que el
compilador rechazará cualquier programa que contenga código obviamente no
coherente.

Por ejemplo, si bien se permite sumar dos números, sumar un número a un valor de
texto no tiene sentido para el compilador de Motoko y se marca como un error que
debe corregirse antes de que el código se pueda ejecutar o implementar.

Las reglas que Motoko aplica para verificar la corrección del código antes de
compilarlo y ejecutarlo se llaman su sistema de tipos. El sistema de tipos de
Motoko detectará y rechazará errores estáticos, como aplicar una función al
número incorrecto de argumentos o a argumentos del tipo incorrecto.

El sistema de tipos es una característica de seguridad que evita una serie de
errores que de lo contrario tendrían que detectarse y reportarse en tiempo de
ejecución, cuando sería difícil o imposible abordarlos.

## Libreria base de Motoko

Por diversas razones prácticas de ingeniería de lenguajes, el diseño de Motoko
se esfuerza por minimizar los tipos y operaciones incorporados.

En su lugar, siempre que sea posible, la libreria base de Motoko proporciona los
tipos y operaciones que hacen que el lenguaje se sienta completo. Sin embargo,
esta libreria base aún está en desarrollo y sigue siendo incompleta.

La [libreria base de Motoko](../base/index.md) enumera una selección de módulos,
centrándose en características principales utilizadas en los ejemplos que es
poco probable que cambien radicalmente. Es probable que las API de la libreria
base evolucionen con el tiempo y, en particular, crezcan en tamaño y número a
medida que Motoko madure.

Para importar desde la libreria base, utiliza la palabra clave `import`. Dale un
nombre de módulo local para introducir, en este ejemplo `D` para "**D**ebug", y
una URL donde la declaración `import` puede localizar el módulo importado:

```motoko file=../examples/print.mo

```

En este caso, importamos código Motoko con el prefijo `mo:`, especificamos la
ruta `base/`, seguida del nombre de archivo del módulo `Debug.mo` sin su
extensión.

## Errores (Traps)

Algunos errores (traps), como la división por cero, la indexación de matrices
fuera de rango y el fallo en la coincidencia de patrones, no son prevenidos por
el sistema de tipos, sino que causan fallas dinámicas llamadas **traps**.

Debido a que el significado de la ejecución es indefinido después de una trampa,
la ejecución del código termina abortando en la trampa.

:::note

Las traps que ocurren dentro de los mensajes de los actores son más sutiles: no
abortan todo el actor, sino que evitan que ese mensaje en particular continúe,
deshaciendo cualquier cambio de estado aún no confirmado. Los otros mensajes del
actor continuarán la ejecución. Esto tiene implicaciones de seguridad sutiles,
así que asegúrese de consultar las recomendaciones de seguridad relevantes.

:::

Ocasionalmente puede ser útil forzar una trampa incondicional con un mensaje
definido por el usuario.

La biblioteca [`Debug`](../base/Debug.md) proporciona la función `trap(t)` para
este propósito, que se puede utilizar en cualquier contexto:

```motoko
import Debug "mo:base/Debug";

Debug.trap("oops!");
```

Las **Assertions** te permiten atrapar condicionalmente cuando una prueba
booleana no se cumple, pero continuar la ejecución en caso contrario:

```motoko no-repl
let n = 65535;
assert n % 2 == 0; // traps when n not even
```

Porque una afirmación puede tener éxito y, por lo tanto, continuar con la
ejecución, solo se puede usar en un contexto donde se espera un valor de tipo
`()`.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
