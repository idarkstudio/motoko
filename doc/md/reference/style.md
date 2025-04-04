---
sidebar_position: 3
---

# Guías de estilo de Motoko

Para aumentar la legibilidad y uniformidad del código fuente de Motoko, la guía
de estilo proporciona sugerencias para formatear el código fuente de Motoko y
otras convenciones básicas.

## Diseño

### Espaciado

- Coloque espacios alrededor de los operadores aritméticos, excepto para agrupar
  visualmente subexpresiones de operadores con mayor prioridad.

  ```motoko no-repl
  let z = - 2*x + 3*y + 4*(x*x + y*y);
  ```

- Coloque espacios alrededor de los operadores de comparación, operadores
  booleanos y operadores de asignación.

  ```motoko no-repl
  4 + 5 <= 5 + 4;
  not (a or b and not c);
  v := 0;
  v += 1;
  ```

- Coloque espacios alrededor de '='.

  ```motoko no-repl
  var v = 0;
  let r = { a = 1; b = 2 };
  ```

- Analogamente, coloque espacios alrededor de `:`.

  ```motoko no-repl
  var v : Nat = 0;
  func foo(x : Nat, y : Nat) : Nat { x + y }
  func bar((x, y) : (Nat, Nat)) : Nat { x + y }
  let w = 1 ^ 0xff : Nat16;
  ```

  La razón: ':' es para declaraciones lo que '=' es para definiciones. Además,
  el lado izquierdo de una anotación de tipo puede ser generalmente una
  expresión o patrón complejo arbitrario.

- Coloque un espacio después de una coma o punto y coma, pero no antes.

  ```motoko no-repl
  let tuple = (1, 2, 3);
  let record = { a = 1; b = 2; c = 3 };
  ```

- Coloque espacios dentro de las llaves, a menos que sean una variante o un
  registro simple.

  ```motoko no-repl
  func f() { 0 };
  f({ a = 1; b = 2; c = 3 });
  f({a = 1; b = 2});  // okay as well

  type Vec3D = { x : Float; y : Float; y : Float };
  type Order = { #less; #equal; #more };

  type Order = {#less; #equal; #more};  // okay as well
  type Proc = {h : Nat; w : Nat} -> {#ok; #fail};
  ```

- Coloque espacios dentro de los corchetes si se extienden en varias líneas.

  ```motoko no-repl
  foo(
    firstArgument,
    ( longTupleComponent, anotherLongExpression,
      moreLongExpression
    ),
    [ 1, 2, 3,
      4, 5, 6,
    ],
    { field1 = 4; field2 = 5;
      field3 = 6;
    }
  );
  ```

- Coloca un espacio entre las palabras clave de las declaraciones y sus
  operadores.

  ```motoko no-repl
  if (f()) A else B;
  for (x in xs.values()) { ... };
  switch (compare(x, y)) {
    case (#less) { A };
    case (_) { B };
  }

  assert (x < 100);
  await (async (0));
  ```

- No coloque un espacio entre una etiqueta de función o variante y su tupla de
  argumentos o alrededor de una lista de parámetros de tipo genérico.

  ```motoko no-repl
  type Pair<X> = (X, X);
  type Id = <X>(X) -> X;

  let ok = #ok(5);

  func id<X>(x : X) : X { x };
  id<Nat>(5);
  ```

- Coloque un espacio entre una función y su argumento si no es una tupla o una
  expresión entre paréntesis (ver [paréntesis](#paréntesis)) o un registro
  utilizado como lista de parámetros con nombre (ver
  [selección de tipos](#selección-de-tipos)).

  ```motoko no-repl
  sin 0.0;
  g [1, 2, 3];
  f{arg1 = 0; arg2 = 0};
  ```

Razón: `g[1]` en particular se interpretará incorrectamente como una operación
de indexación.

- No coloque un espacio alrededor de los operadores de acceso como `.`, `?`, `!`
  o corchetes de índice.

  ```motoko no-repl
  foo(bar).baz[5]().boo;
  foom(?(bam()! + 1));
  ```

  ### Saltos de línea

  - Elija un margen derecho fijo para las líneas y rompa las definiciones o
    expresiones. 80 todavía se considera un límite adecuado por muchos.

  ```motoko no-repl
  let sum = a + b + 2*c + d +
    e + f + g + h + i + k +
    l + m + n + o + p;

  // Or:
  let sum =
    a + b + 2*c + d + e +
    f + g + h + i + k + l +
    m + n + o + p;
  ```

  Razón: Entre otras razones, este estilo de formato:

  1.  Evita que el código se oculte a la derecha en una ventana.

  2.  Evita saltos de línea aleatorios en diferencias lado a lado. Por ejemplo,
      como se muestra en GitHub u otras herramientas de revisión de código
      similares.

  3.  Permite una visualización más agradable en papel, sitios web u otros
      medios.

- Rompe las líneas después de un operador.

  ```motoko no-repl
  a + b + c +
    d + f;

  foo(bar, baz).
    boo();
  ```

- Al dividir las definiciones o llamadas de funciones con listas de argumentos
  largas, coloca cada argumento en una línea separada.

  Además, considera usar registros para listas de parámetros largas, consulta
  [picking types](#picking-types).

  ```motoko no-repl
  func someFunction(
    arg1 : FirstType,
    arg2 : SecondType,
    anotherArg : Nat,
    yetAnother : [Type],
    func : Nat -> Nat,
  ) : Nat {
    ...
  };

  someFunction(
    veryLongArgumentExpression,
    anotherVeryLongArgumentExpression,
    3,
    aNestedFunctionCall(
      alsoWithLongArguments,
      andMoreSuchArguments,
    ),
    moreLongishArgument,
  );
  ```

  Razón: Esto evita pasar por alto un argumento al leer el código y evita volver
  a romper líneas al cambiar una de las expresiones.

### Sangría

- Cada nivel de sangría debe ser de 2 espacios.

  ```motoko no-repl
  actor A {
    public func f() {
      return;
    }
  }
  ```

  Razón: There may be a lot of nesting. Using only 2 spaces avoids wasting
  screen estate.

- Indentation should not depend on the lexical contents of previous lines.

  In particular, do not vertically align indentation with inner characters from
  previous lines.

  ```motoko no-repl
  let x = someFunction(
    arg1, arg2, arg3, arg4, arg5);               // Do this.

  let x = someFunction(arg1, arg2, arg3,
    arg4, arg5);                                 // Or this.

  let x =
    someFunction(arg1, arg2, arg3, arg4, arg5);  // Or this.

  let x = someFunction(                          // Or this.
    longArg1,
    longArg2,
    longArg3,
    longArg4,
    longArg5,
  );

  // COUNTER EXAMPLE!
  let x = someFunction(arg1, arg2, arg3,
                       arg4, arg5);              // DO NOT DO THIS!
  ```

  Razón: Hay muchos problemas con la alineación vertical, por ejemplo:

  1.  Se desperdicia mucho espacio horizontal.

  2.  Crea niveles de sangría inconsistentes que obstruyen la estructura del
      código.

  3.  Puede generar cambios de alineación al modificar una línea, lo cual,
      incluso cuando se automatiza con editores, infla y obstruye las
      diferencias.

  4.  Rompe por completo con las fuentes de ancho variable.

  Regla general: no debe haber sangría que no sea múltiplo de 2.

- No uses tabulaciones.

  Razón: La interpretación de las tabulaciones varía ampliamente entre
  herramientas y se pierden o se muestran incorrectamente en muchos contextos,
  como páginas web, diferencias, etc.

### Agrupación

- Separa las definiciones complejas de varias líneas con líneas vacías. Las de
  una sola línea pueden colocarse en líneas consecutivas.

  ```motoko no-repl
  func foo() {
    // This function does a lot of interesting stuff.
    // It's definition takes multiple lines.
  }

  func boo() {
    // This is another complicated function.
    // It's definition also takes multiple lines.
  }

  func add(x : Nat, y : Nat) { return x + y };
  func mul(x : Nat, y : Nat) { return x * y };
  ```

- Separa grupos lógicos de definiciones con dos líneas vacías. Agrega un
  comentario de una línea como un "encabezado de sección" para cada grupo.

  ```motoko no-repl
  // A very large class
  class MuffleMiff(n : Nat) {

    // Accessors

    public func miffMuff() : Text {
      ...
    }

    public func sniffMiff() : Nat {
      ...
    }

    // Mutators

    public func clearMurk() {
      ...
    }

    public func addMuff(name : Text) {
      ...
    }

    // Processing

    public func murkMuffle(param : List<Gnobble>) {
      ...
    }

    public func transformSneezler() {
      ...
    }

    // Internal State

    var miffCount = 0;
    var mabbleMap = Map<Nat, Text>();

  }
  ```

  ### Comentarios

  - Utiliza comentarios de línea (`//...`). Utiliza comentarios de bloque
    (`/* ... */`) solo cuando estés comentando en medio de una línea o para
    comentar partes de código durante el desarrollo.

  ```motoko no-repl
  // The following function runs the current
  // pallaboom on a given snibble. It returns
  // suitable plexus if it can.
  func paBoom(s : Snibble) : Handle<Plexus> {
    let puglet = initPugs(s.crick, 0 /* size */, #local);
  /* Don't do the odd stuff yet...
    ...
    ...
  */
    return polyfillNexus(puglet);  // for now
  }
  ```

  Razón: Los comentarios de línea facilitan la inserción, eliminación o
  intercambio de líneas individuales.

- Coloque comentarios cortos que expliquen una sola línea al final de la línea,
  separados por al menos 2 espacios.

  ```motoko no-repl
  paBoom(getSnibble());  // create new snibble
  ```

- Coloca los comentarios de varias líneas antes de una línea de código, con la
  misma sangría que el código que describe.

  ```motoko no-repl
  func f() {
    // Try to invoke the current pallaboom with
    // the previous snibble. If that succeeds,
    // we have the new plexus; if not, complain.
    let plexusHandle = paBoom(getSnibble());
  }
  ```

- Capitaliza los comentarios que están en líneas separadas. Utiliza un punto
  final adecuado para las oraciones.

## Puntuación

### Punto y coma

- Motoko uniformemente requiere un punto y coma para separar expresiones o
  declaraciones locales en un bloque, independientemente de si la declaración
  anterior termina en '}'.

  Razón: Esto es diferente a otros lenguajes de estilo C, que tienden a tener
  reglas bastante ad hoc.

- Coloca un punto y coma después de la última expresión en un bloque, a menos
  que todo el bloque esté escrito en una sola línea.

  Lo mismo aplica para los tipos.

  ```motoko no-repl
  // No ; needed before closing } on same line

  type Vec3D = {x : Float; y : Float; z : Float};
  type Result<A> = {#ok : A; #error : Text};

  func add(x : Nat, y : Nat) : Nat { return x + y };

  // End last case with ;

  type Address = {
    first : Text;
    last : Text;
    street : Text;
    nr : Nat;
    zip : Nat;
    city : Text;
  };

  type Expr = {
    #const : Float;
    #add : (Expr, Expr);
    #mul : (Expr, Expr);
  };

  func eval(e : Expr) : Float {
    switch (e) {
      case (#const(x)) { x };
      case (#add(e1, e2)) { eval(e1) + eval(e2) };
      case (#mul(e1, e2)) { eval(e1) * eval(e2) };
    };
  }
  ```

  Razón: Terminar consistentemente las líneas con punto y coma simplifica
  agregar, eliminar o intercambiar líneas.

### Llaves

- Coloca llaves alrededor de los cuerpos de las funciones, ramas `if` o `case`,
  y cuerpos de bucles, a menos que aparezcan anidadas como una expresión y solo
  contengan una única expresión.

  ```motoko no-repl
  func f(x) { f1(x); f2(x) };

  let abs = if (v >= 0) v else -v;
  let val = switch (f()) { case (#ok(x)) x; case (_) 0 };
  func succ(x : Nat) : Nat = x + 1;
  ```

- Usa un diseño "estilo C" para subexpresiones entre llaves que abarcan varias
  líneas.

  ```motoko no-repl
  func f() {
    return;
  };

  if (cond) {
    foo();
  } else {
    bar();
  };

  switch (opt) {
    case (?x) {
      f(x);
    };
    case (null) {};
  };
  ```

  ### Paréntesis

  - Motoko admite el estilo "sin paréntesis", lo que significa que los
    paréntesis son opcionales en la mayoría de los lugares, como en las listas
    de parámetros de funciones o en los operandos de las declaraciones, cuando
    encierran una expresión que ya está entre corchetes. Por ejemplo, una tupla,
    un objeto o un arreglo, o una constante o identificador simple.

  ```motoko no-repl
  type Op = Nat -> Nat;
  let a2 = Array.map<Nat, Nat>(func x { x + 1 }, a);

  let y = f x;
  let z = f {};
  let choice = if flag { f1() } else { f2() };

  switch opt {
    case null { tryAgain() };
    case _ { proceed() };
  };
  ```

- Evita el uso excesivo del estilo sin paréntesis.

  En particular, no omitas paréntesis y llaves en las declaraciones al mismo
  tiempo.

  ```motoko no-repl
  // COUNTER EXAMPLES!
  let choice = if flag x + y else z;  // DO NOT DO THIS!

  switch val {
    case 0 f();    // DO NOT DO THIS!
    case n n + 1;  // OR THIS!
  };
  ```

  Razón: Omitir ambos al mismo tiempo hace que el código sea más difícil de
  leer, ya que hay menos indicio visual de cómo se agrupa.

- De manera similar, no omitas los paréntesis alrededor de los parámetros de
  función si la función también tiene parámetros de tipo.

  ```motoko no-repl
  // COUNTER EXAMPLE!
  foo<Nat> 0;   // DO NOT DO THIS!
  ```

- Omitir paréntesis alrededor de los tipos de argumentos de un tipo de función
  con un solo argumento y sin parámetros de tipo.

  Pero no omitirlos cuando las funciones o clases también tienen parámetros de
  tipo.

  ```motoko no-repl
  type Inv = Nat -> Nat;
  type Id = <T>(T) -> T;
  type Get = <X>(C<X>) -> X;

  // COUNTER EXAMPLE!
  type Get = <X>C<X> -> X;   // DO NOT DO THIS!
  ```

  ### Varios

  - Usa `_` para agrupar dígitos en números.

    Agrupa de 3 dígitos en números decimales y de 4 en notación hexadecimal.

  ```motoko no-repl
  let billion = 1_000_000_000;
  let pi = 3.141_592_653_589_793_12;
  let mask : Nat32 = 0xff00_ff0f;
  ```

## Nomenclatura

### Estilo

- Utiliza `UpperCamelCase` para los nombres de tipos (incluyendo clases o
  parámetros de tipo), nombres de módulos y nombres de actores.

- Utiliza `lowerCamelCase` para todos los demás nombres, incluyendo constantes y
  campos de variantes.

  ```motoko no-repl
  module MoreMuff {
    type FileSize = Nat;
    type Weekday = {#monday; #tuesday; #wednesday};
    type Pair<X> = (X, X);

    class Container<X, Y>() { ... };

    func getValue<Name>(name : Name) : Pair<Name> { ... };

    let zero = 0;
    let pair = getValue<Text>("opus");
    var nifty : Nat = 0;

    object obj { ... };

    actor ServerProxy { ... };
  };
  ```

  Razón: La convención general es usar mayúsculas para entidades "estáticas"
  como tipos y minúsculas para valores "dinámicos". Los módulos y actores son
  bastante estáticos y pueden exportar tipos. Los objetos generalmente no
  exportan tipos y tienden a ser utilizados principalmente como valores
  dinámicos.

- Escribe los acrónimos como palabras regulares.

  ```motoko no-repl
  type HttpHeader = ...;
  func getUrl() { ... };
  let urlDigest = ...;
  ```

- No uses nombres de identificadores que comiencen con un guion bajo `_`,
  excepto para documentar que una variable en un patrón no se usa
  intencionalmente.

  ```motoko no-repl
  let (width, _color, name) = rumpler();
  ...  // _color is not used here

  func foo(x : Nat, _futureFlag : Bool) { ... };
  ```

  Razón: Un verificador de tipos puede advertir sobre identificadores no
  utilizados, lo cual se puede suprimir al anteponer explícitamente `_` a su
  nombre para documentar la intención.

  Esto se alinea con el uso de la palabra clave `_` para comodines de patrones.

### Convenciones

- El nombre de las funciones que devuelven un valor debe describir ese valor.

  Evita los prefijos redundantes de `get`.

  ```motoko no-repl
  dict.size();
  list.first();
  sum(array);
  ```

- El nombre de las funciones que realizan efectos secundarios u operaciones
  complejas debe describir esa operación.

  ```motoko no-repl
  dict.clear();
  dict.set(key, value);
  let result = traverse(graph);
  ```

- El nombre de las funciones de predicado que devuelven
  [`Bool`](../base/Bool.md) debe usar un prefijo `es` o `tiene` o una
  descripción similar de la propiedad probada.

  ```motoko no-repl
  class Set<X>() {
    public func size() : Nat { ... };

    public func add(x : X) { ... };
    public func remove(x : X) { ... };

    public func isEmpty() : Bool { ... };
    public func contains(x : X) : Bool { ... };
  };
  ```

- Las funciones que convierten a o desde un tipo `X` se llaman `toX` y `fromX`,
  respectivamente, si la fuente o el destino es el objeto del que la función es
  un método, o el tipo principal del módulo en el que aparece esta función.

- En clases u objetos, utiliza un nombre que termine con `_` para distinguir las
  variables privadas de los getters.

  ```motoko no-repl
  class Cart(length_ : Nat) {
    var width_ = 0;

    public func length() : Nat { return length_ };
    public func width() : Nat { return width_ };
  }
  ```

  Razón: En Motoko, las funciones son valores de primera clase, por lo que las
  funciones y otros identificadores de valor comparten el mismo espacio de
  nombres.

  No se deben utilizar identificadores con un guion bajo `_` al principio para
  estado privado, ya que eso indica un nombre no utilizado (ver
  [estilo](#estilo)).

- Utiliza nombres más largos y descriptivos para identificadores globales o
  públicos, o aquellos con un alcance amplio, y nombres cortos para los locales
  con un alcance pequeño.

  Está bien utilizar identificadores de un solo carácter cuando no hay nada
  interesante que decir, especialmente cuando se utiliza el mismo esquema de
  nomenclatura de manera consistente.

  ```motoko no-repl
  func map(x : Nat, y : Nat) : Nat { x + y };

  func eval(e : Expr) : Nat {
    let n =
      switch (e) {
        case (#neg(e1)) { - eval(e1) };
        case (#add(e1, e2)) { eval(e1) + eval(e2) };
        case (#mul(e1, e2)) { eval(e1) * eval(e2) };
      };
    Debug.print(n);
    return n;
  };
  ```

  Razón: Contrariamente a la creencia popular, los nombres locales demasiado
  habladores pueden disminuir la legibilidad en lugar de aumentarla, al aumentar
  el nivel de ruido.

- En casos adecuados, utiliza la forma en plural para describir una colección de
  elementos, como una lista o un array.

  Esto también funciona para nombres cortos.

  ```motoko no-repl
  func foreach<X>(xs : [X], f : X -> ()) {
    for (x in xs.values()) { f(x) }
  }
  ```

## Tipos

### Anotaciones de tipo

- Coloca anotaciones de tipo en las definiciones que involucren tipos numéricos
  de ancho fijo, para desambiguar el tipo de operadores y constantes aritméticas
  sobrecargadas.

  ```motoko no-repl
  let mask : Nat32 = 0xfc03_ff00;
  let pivot : Nat32 = (size + 1)/2;
  let vec : [Int16] = [1, 3, -4, 0];
  ```

  :::note

  Utiliza constantes de punto flotante para forzar el tipo `Float` sin una
  anotación adicional. De manera similar, utiliza un signo `+` explícito para
  producir un valor positivo de tipo [`Int`](../base/Int.md) en lugar de
  [`Nat`](../base/Nat.md), si se desea.

  :::

  ```motoko no-repl
  let zero = 1.0;    // type Float
  let offset = +1;   // type Int
  ```

- De manera similar, coloca anotaciones de tipo en línea en expresiones
  aritméticas con tipos diferentes a [`Nat`](../base/Nat.md) o
  [`Int`](../base/Int.md).

  ```motoko no-repl
  if (x & mask == (1 : Nat32)) { ... };
  ```

  :::note

  La necesidad de anotar constantes en casos como este es una limitación del
  sistema de tipos de Motoko que esperamos abordar pronto.

  :::

  No se necesita una anotación en los argumentos de la función, ya que su tipo
  generalmente se infiere de la función. La única excepción es cuando ese
  argumento tiene un tipo genérico y se han omitido los argumentos de tipo.

  ```motoko no-repl
  func foo(len : Nat32, vec : [Nat16]) { ... };
  func bar<X>(x : X) { ... };

  foo(3, [0, 1, 2]);
  bar<Nat16>(0);
  bar(0 : Nat16);
  ```

- Coloca anotaciones de tipo en variables mutables, a menos que su tipo sea
  obvio.

  ```motoko no-repl
  var name = "Motoko";
  var balance = 0;

  func f(i : Int) {
    var j = i;
  };

  var balance : Int = 0;
  var obj : Class = foo();
  ```

  Razón: Debido a la subtipificación, inferir el tipo a partir de la
  inicialización no necesariamente deduciría el tipo deseado. Por ejemplo,
  `balance` tendría tipo [`Nat`](../base/Nat.md) sin la anotación, descartando
  asignaciones de enteros.

- Coloque anotaciones de tipo en todos los campos públicos de una clase.

  ```motoko no-repl
  class C(init_ : Nat) {
    public let init : Nat = init_;
    public var count : Nat = 0;
  }
  ```

- Omitir anotaciones de tipo de retorno de funciones cuando el tipo es `()`.

  ```motoko no-repl
  func twiceF() { f(); f() };  // no need to write ": ()"
  ```

- Omitir anotaciones de tipo en las funciones cuando se pasan como argumentos.

  ```motoko no-repl
  Array.map<Nat, Nat>(func n {n + 1}, a);
  ```

- Coloca anotaciones de tipo en las definiciones que involucren tipos numéricos
  diferentes a [`Nat`](../base/Nat.md) o [`Int`](../base/Int.md), para resolver
  la sobrecarga entre operadores aritméticos y constantes.

  ```motoko no-repl
  let mask : Nat32 = 0xfc03_ff00;
  let offset : Nat32 = size + 1;
  ```

  ### Selección de tipos

  - Utiliza [`Nat`](../base/Nat.md) para cualquier valor entero que no pueda ser
    negativo.

  - Utiliza `NatN` o `IntN` de ancho fijo solo cuando se almacenan muchos
    valores y el uso de espacio es importante, cuando se requiere manipulación
    de bits a nivel bajo o cuando se deben cumplir tipos impuestos por
    requisitos externos, como otros canisters.

  - Evita la proliferación de tipos de opción y, por lo tanto, de `null`.

    Limita su uso al menor alcance posible. Descarta el caso de `null` y utiliza
    tipos no opcionales siempre que sea posible.

  - Considera utilizar registros en lugar de tuplas cuando haya más de 2 o 3
    componentes. Los registros son simplemente objetos simples con campos
    nombrados.

    Ten en cuenta que los tipos de registro no necesitan ser declarados, sino
    que se pueden utilizar en su lugar.

  ```motoko no-repl
    func nodeInfo(node : Node) : {parent : Node; left : Node; right : Node} { ... }
  ```

- Considera usar variantes en lugar de [`Bool`](../base/Bool.md) para
  representar opciones binarias.

  Ten en cuenta que los tipos de variantes no necesitan ser declarados, pero se
  pueden usar en su lugar.

  ```motoko no-repl
  func capitalization(word : Text) : {#upper; #lower} { ... }
  ```

- Donde sea posible, utiliza el tipo de retorno `()` para las funciones cuyo
  propósito principal es mutar el estado o causar otros efectos secundarios.

  ```motoko no-repl
  class Set<X>() {
    public func add(x : X) { ... };
    public func remove(x : X) { ... };
    ...
  };
  ```

- Considera usar un registro (un objeto con solo datos) como argumento para
  listas de parámetros largas.

  ```motoko no-repl
  func process({seed : Float; delta : Float; data : [Record]; config : Config}) : Thing {
    ...
  };

  process{config = Config(); data = read(); delta = 0.01; seed = 1.0};
  ```

  Razón: Esto expresa parámetros con nombre. De esta manera, los argumentos se
  pueden reordenar libremente en el lugar de la llamada y se evita que los
  llamadores los pasen accidentalmente en el orden incorrecto.

- Las funciones de orden superior, como las funciones que toman un argumento de
  devolución de llamada, deben colocar el parámetro de la función al final.

  Razón: Hace que los lugares de llamada sean más legibles y, en ausencia de
  currificación, no tiene sentido colocar la función primero, como a menudo se
  haría en lenguajes funcionales.

- No utilices valores centinela, como `-1`, para representar valores no válidos.

  Utiliza en su lugar el tipo de opción.

  ```motoko no-repl
  func lookup(x : key) : ?Nat { ... }
  ```

- Los datos son inmutables en Motoko a menos que se especifique lo contrario.

  Utiliza los tipos y definiciones de mutabilidad (`var`) con cuidado y solo
  donde sea necesario.

  Razón: Los datos mutables no se pueden comunicar ni compartir entre actores.
  Son más propensos a errores y mucho más difíciles de razonar formalmente,
  especialmente cuando se trata de concurrencia.

## Características

### Declaraciones

- Utiliza bucles `for` en lugar de bucles `while` para iterar sobre un rango
  numérico o un contenedor.

  ```motoko no-repl
  for (i in Iter.range(1, 10)) { ... };
  for (x in array.values()) { ... };
  ```

  Razón: Los bucles `for` son menos propensos a errores y más fáciles de leer.

  - Utiliza `if` o `switch` como expresiones cuando sea apropiado.

  ```motoko no-repl
  func abs(i : Int) : Int { if (i < 0) -i else i };

  let delta = switch mode { case (#up) +1; case (#dn) -1 };
  ```

- Motoko requiere que todas las expresiones en un bloque tengan tipo `()`, para
  evitar resultados descartados accidentalmente.

  Usa `ignore` para descartar explícitamente los resultados. No uses `ignore`
  cuando no sea necesario.

  ```motoko no-repl
  ignore async f();  // fire of a computation
  ```

- Motoko permite omitir el `return` al final de una función, porque un bloque se
  evalúa a su última expresión.

  Utiliza esto cuando una función es corta y está en estilo "funcional", es
  decir, la función no contiene un flujo de control complejo o efectos
  secundarios.

  Utiliza `return` explícito al final cuando la función contiene otros `return`
  o un flujo de control imperativo.

  ```motoko no-repl
  func add(i : Nat, j : Nat) : Nat { i + j };

  func foo(a : Float, b : Float) : Float {
    let c = a*a + b*b;
    c + 2*c*c;
  };

  func gcd(i : Nat, j : Nat) : Nat {
    if (j == 0) i else gcd(j, i % j);
  };

  func gcd2(i : Nat, j : Nat) : Nat {
    var a = i;
    var b = j;
    while (b > 0) {
      let c = a;
      a := b;
      b := c % b;
    };
    return a;
  };
  ```

### Objetos y registros

- Usa la sintaxis abreviada de objetos `{x1 = e1; …​ ; xN = eN}` cuando uses
  objetos como registros simples, es decir, estructuras de datos sin estado
  privado y sin métodos.

- Usa `object` cuando crees objetos singleton.

- Limita el uso de objetos a registros siempre que sea posible.

  **Razón:** Solo los registros pueden enviarse como parámetros o resultados de
  mensajes y pueden almacenarse en variables estables. Los objetos con métodos
  también son más costosos de crear y representar en memoria.

- Usa objetos completos solo como un medio para encapsular estado o
  comportamiento.

### Clases

- Usa `class` para crear múltiples objetos con la misma forma.

- Nombra las clases según su funcionalidad conceptual, no su implementación,
  excepto cuando sea necesario distinguir múltiples implementaciones diferentes
  del mismo concepto. Por ejemplo, `OrderedMap` vs `HashMap`.

- Las clases son tanto definiciones de tipos como funciones de fábrica para
  objetos.

  No uses clases a menos que ambos roles sean intencionales; usa alias de tipos
  simples o funciones que devuelvan un objeto en otros casos.

- No abuses de las clases.

  Usa un módulo que defina un tipo simple y funciones sobre él cuando sea
  apropiado. Usa clases solo como un medio para encapsular estado o
  comportamiento.

  **Razón:** Los objetos con métodos tienen desventajas sobre los tipos de
  registro simples con funciones separadas (ver arriba).

- Si los valores de una clase están destinados a ser enviables (compartidos), la
  clase debe proporcionar un par de métodos `share`/`unshare` que conviertan
  a/desde una representación compartible, por ejemplo, como un registro.

  :::note

  Para clases inmutables, puede parecer más natural hacer que `unshare` sea una
  especie de función estática. Sin embargo, incluso para las inmutables, puede
  depender de los argumentos del constructor (como una función de ordenación),
  por lo que un patrón como `Map(compareInt).unshare(x)` parece apropiado.

  :::

- Por el momento, evita sobrecargar las clases con demasiados métodos, ya que
  actualmente es costoso.

  Limítate a un conjunto suficientemente pequeño de métodos canónicos y
  convierte los menos esenciales que puedan implementarse sobre esos en
  funciones dentro del módulo envolvente.

- Usa módulos para clases o métodos "estáticos".

### Módulos

- Usa `module` para agrupar definiciones, incluyendo tipos, y crear un espacio
  de nombres para ellos.

- Cuando sea aplicable, nombra los módulos según el tipo o clase principal que
  implementan o para el que proporcionan funciones.

- Limita cada módulo a un concepto/tipo/clase principal o una familia
  estrechamente relacionada de conceptos/tipos/clases.

<!--
=== To be extended
-->

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
