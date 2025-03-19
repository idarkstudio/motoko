---
sidebar_position: 8
---

# Control de flujo (flow control)

Existen dos categorías clave de control de flujo:

- **Declarativo**: La estructura de algún valor guía tanto el control como la
  selección de la siguiente expresión a evaluar, como en las expresiones `if` y
  `switch`.

- **Imperativo**: El control cambia abruptamente según el comando del
  programador, abandonando el control de flujo regular. Ejemplos son `break` y
  `continue`, pero también `return` y `throw`.

El control de flujo imperativo a menudo va de la mano con cambios de estado y
otros efectos secundarios, como el manejo de errores y la entrada/salida.

## Retorno temprano de `func`

Normalmente, el resultado de una función es el valor de su cuerpo. A veces,
durante la evaluación del cuerpo, el resultado está disponible antes de que
termine la evaluación. En tales situaciones, se puede utilizar la construcción
`return <exp>` para abandonar el resto de la computación y salir inmediatamente
de la función con un resultado. De manera similar, donde esté permitido, se
puede usar `throw` para abandonar una computación con un error.

Cuando una función tiene un tipo de resultado unitario, se puede utilizar la
forma abreviada `return` en lugar de `return ()` equivalente.

## Loops and labels

Motoko proporciona varios tipos de estructuras de repetición, incluyendo:

- Expresiones `for` para iterar sobre miembros de datos estructurados.

- Expresiones `loop` para repetición programática, opcionalmente con una
  condición de terminación.

- Bucles `while` para repetición programática con una condición de entrada.

Cualquiera de estos puede ser precedido por un calificador `label <nombre>` para
darle al bucle un nombre simbólico. Los bucles con nombre son útiles para
cambiar el flujo de control de manera imperativa para continuar desde la entrada
o salida del bucle con nombre, como:

- Reingresar al bucle con `continue <nombre>`.

- Salir completamente del bucle con `break <nombre>`.

En el siguiente ejemplo, la expresión `for` itera sobre los caracteres de un
texto y abandona la iteración tan pronto como se encuentra un signo de
exclamación.

```motoko
import Debug "mo:base/Debug";
label letters for (c in "ran!!dom".chars()) {
  Debug.print(debug_show(c));
  if (c == '!') { break letters };
  // ...
}
```

### Labeled expressions

Hay otros dos aspectos de las etiquetas (`label`) que son menos comunes, pero
que resultan útiles en ciertas situaciones:

- Las `label` pueden tener tipos.

- Cualquier expresión, no solo los bucles, puede ser nombrada prefijándola con
  una etiqueta. `break` permite cortocircuitar la evaluación de la expresión al
  proporcionar un valor inmediato para su resultado. Esto es similar a salir de
  una función tempranamente usando `return`, pero sin la sobrecarga de declarar
  y llamar a una función.

La sintaxis para etiquetas con anotación de tipos es
`label <nombre> : <tipo> <expr>`, lo que significa que cualquier expresión puede
ser salida usando una construcción `break <nombre> <expr-alternativa>` que
devuelve el valor de `<expr-alternativa>` como el valor de `<expr>`,
cortocircuitando la evaluación de `<expr>`.

El uso juicioso de estas construcciones permite al programador centrarse en la
lógica principal del programa y manejar casos excepcionales mediante `break`.

```motoko
import Text "mo:base/Text";
import Iter "mo:base/Iter";

type Host = Text;
let formInput = "us@dfn";

let address = label exit : ?(Text, Host) {
  let splitted = Text.split(formInput, #char '@');
  let array = Iter.toArray<Text>(splitted);
  if (array.size() != 2) { break exit(null) };
  let account = array[0];
  let host = array[1];
  // if (not (parseHost(host))) { break exit(null) };
  ?(account, host)
}
```

Las expresiones comunes etiquetadas no permiten `continue`. En términos de
tipado, tanto `<expr>` como `<expr-alternativa>` deben ajustarse al tipo
declarado de la etiqueta (`<tipo>`). Si a una etiqueta solo se le da un
`<nombre>`, entonces su `<tipo>` por defecto es unitario (`()`). De manera
similar, un `break` sin una `<expr-alternativa>` es una abreviatura para el
valor unitario (`()`).

## Bloques de opciones y rupturas con `null`

Motoko te permite optar por usar valores `null`, rastreando posibles ocurrencias
de valores `null` utilizando tipos de opción de la forma `?T`. Esto es tanto
para animarte a evitar el uso de valores `null` cuando sea posible, como para
considerar la posibilidad de valores `null` cuando sea necesario. Motoko
simplifica el manejo de tipos de opción con una sintaxis dedicada: bloques de
opciones y rupturas con `null`.

El bloque de opción, `do ? <bloque>`, produce un valor de tipo `?T` cuando el
bloque `<bloque>` tiene tipo `T` y, lo que es más importante, introduce la
posibilidad de una ruptura desde `<bloque>`. Dentro de un `do ? <bloque>`, la
ruptura con `null` `<exp> !` verifica si el resultado de la expresión, `<exp>`,
de tipo de opción no relacionado, `?U`, es `null`. Si el resultado de `<exp>` es
`null`, el control sale inmediatamente del `do ? <bloque>` con el valor `null`.
De lo contrario, el resultado de `<exp>` debe ser un valor de opción `?v`, y la
evaluación de `<exp> !` procede con su contenido, `v` de tipo `U`.

El siguiente ejemplo define una función simple que evalúa expresiones
construidas a partir de números naturales, división y una prueba de cero,
codificada como un tipo variante:

<!--
TODO: make interactive
-->

```motoko file=../examples/option-block.mo

```

Para protegerse contra la división por `0` sin atrapar, la función `eval`
devuelve un resultado opcional, utilizando `null` para indicar un fallo.

Cada llamada recursiva se verifica si es `null` usando `!`, saliendo
inmediatamente del bloque externo `do ?`, y luego de la función misma, cuando el
resultado es `null`.

## Repetición con `loop`

La forma más sencilla de repetir indefinidamente una secuencia de expresiones
imperativas es utilizando la construcción `loop`:

```motoko no-repl
loop { <expr1>; <expr2>; ... }
```

El bucle solo puede ser abandonado con una construcción `return` o `break`.

Se puede agregar una condición de reingreso para permitir una repetición
condicional del bucle con `loop <body> while <cond>`.

El cuerpo de dicho bucle siempre se ejecuta al menos una vez.

## Bucles `while` con precondición

A veces se necesita una condición de entrada para proteger cada iteración de un
bucle. Para este tipo de repetición, utiliza la forma `while <cond> <body>` del
bucle:

```motoko no-repl
while (earned < need) { earned += earn() };
```

A diferencia de un `loop`, el cuerpo de un bucle `while` puede que nunca se
ejecute.

## Bucles `for` para iteración

Una iteración sobre elementos de una colección homogénea se puede realizar
utilizando un bucle `for`. Los valores se extraen de un iterador y se enlazan
con el patrón del bucle en cada iteración.

```motoko
let carsInStock = [
  ("Buick", 2020, 23.000),
  ("Toyota", 2019, 17.500),
  ("Audi", 2020, 34.900)
];
var inventory : { var value : Float } = { var value = 0.0 };
for ((model, year, price) in carsInStock.values()) {
  inventory.value += price;
};
inventory
```

## Usando `range` con un bucle `for`

La función `range` produce un iterador de tipo `Iter<Nat>` con el límite
inferior y superior dados, inclusivos.

El siguiente ejemplo de bucle imprime los números `0` a `10` en sus once
iteraciones:

```motoko
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
var i = 0;
for (j in Iter.range(0, 10)) {
  Debug.print(debug_show(j));
  assert(j == i);
  i += 1;
};
assert(i == 11);
```

Más generalmente, la función `range` es una `class` que construye iteradores
sobre secuencias de números naturales. Cada iterador de este tipo tiene el tipo
`Iter<Nat>`.

Como una función constructora, `range` tiene un tipo de función:

```motoko no-repl
(lower : Nat, upper : Int) -> Iter<Nat>
```

`Iter<Nat>` es un tipo de objeto iterador con un método `next` que produce
elementos opcionales, cada uno de tipo `?Nat`:

```motoko no-repl
type Iter<A> = {next : () -> ?A};
```

Para cada invocación, `next` devuelve un elemento opcional de tipo `?Nat`.

El valor `null` indica que la secuencia de iteración ha terminado.

Hasta llegar a `null`, cada valor no nulo, de la forma `?n` para algún número
`n`, contiene el siguiente elemento sucesivo en la secuencia de iteración.

## Usando `revRange`

La función `revRange` es una `class` que construye iteradores, cada uno de tipo
`Iter<Int>`. Como una función constructora, tiene un tipo de función:

```motoko no-repl
(upper : Int, lower : Int) -> Iter<Int>
```

A diferencia de `range`, la función `revRange` desciende en su secuencia de
iteración, desde un límite superior inicial hasta un límite inferior final.

## Usando iteradores de estructuras de datos específicas

Muchas estructuras de datos integradas vienen con iteradores predefinidos. La
siguiente tabla los enumera:

| Tipo                      | Nombre                   | Iterador | Elementos                       | Tipo de elemento          |
| ------------------------- | ------------------------ | -------- | ------------------------------- | ------------------------- |
| `[T]`                     | Arreglo de `T`​s         | `vals`   | Los miembros del arreglo        | `T`                       |
| `[T]`                     | Arreglo de `T`​s         | `keys`   | Los índices válidos del arreglo | [`Nat`](../base/Nat.md)   |
| `[var T]`                 | Arreglo mutable de `T`​s | `vals`   | Los miembros del arreglo        | `T`                       |
| `[var T]`                 | Arreglo mutable de `T`​s | `keys`   | Los índices válidos del arreglo | [`Nat`](../base/Nat.md)   |
| [`Text`](../base/Text.md) | Texto                    | `chars`  | Los caracteres del texto        | `Char`                    |
| [`Blob`](../base/Blob.md) | Blob                     | `vals`   | Los bytes del blob              | [`Nat8`](../base/Nat8.md) |

Las estructuras de datos definidas por el usuario pueden definir sus propios
iteradores. Siempre que se ajusten al tipo `Iter<A>` para algún tipo de elemento
`A`, estos se comportan como los integrados y pueden consumirse con bucles `for`
ordinarios.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
