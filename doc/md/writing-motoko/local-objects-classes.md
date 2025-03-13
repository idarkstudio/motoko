---
sidebar_position: 13
---

# Objetos y clases

<!--
TODO: Move examples into doc/modules/language-guide/examples
-->

En Motoko, un objeto es simplemente una colección de campos nombrados que
contienen valores. Estos valores pueden ser datos simples o valores de
funciones. Además, cada campo puede ser mutable o inmutable.

Un objeto simple que contiene solo campos de datos es como un registro en una
base de datos. Cuando los campos son inmutables y tienen tipos compartidos, el
objeto en sí es compartible y puede enviarse y recibirse desde funciones
compartidas.

Cuando los campos contienen valores de funciones, los objetos de Motoko pueden
representar objetos tradicionales con métodos, familiares en la programación
orientada a objetos (OOP). Desde una perspectiva de OOP, un objeto es una
abstracción definida por el comportamiento de sus métodos. Los métodos se
utilizan típicamente para modificar u observar algún estado encapsulado (es
decir, oculto) de un objeto. Los programas de Motoko se benefician de la
capacidad de encapsular el estado como objetos con tipos abstractos. El
[estado mutable](mutable-state.md) introduce declaraciones de estado mutable en
forma de variables declaradas con `var`. Usando tales declaraciones de manera
privada en su cuerpo, un objeto puede encapsular el estado, declarando métodos
públicos que lo acceden y actualizan.

Por diseño, los objetos con campos o métodos mutables no pueden enviarse a
actores remotos. Si eso estuviera permitido, un receptor tendría que recibir una
referencia remota al objeto local, rompiendo el aislamiento del modelo de
actores al permitir actualizaciones remotas al estado local. O bien, el receptor
tendría que recibir una copia del objeto local. Entonces, el efecto de cualquier
cambio en la copia no se reflejaría en el original, lo que llevaría a confusión.

Para compensar esta limitación necesaria, los objetos `actor` son compartibles,
pero siempre se ejecutan de manera remota. Se comunican solo con datos
compartibles de Motoko. Los objetos locales interactúan de maneras menos
restrictivas entre sí y pueden pasar cualquier dato de Motoko a los métodos de
los demás, incluidos otros objetos. En la mayoría de los demás aspectos, los
objetos y clases locales son contrapartes no compartibles de los objetos y
clases de actores.

## Ejemplo

El siguiente ejemplo ilustra una ruta de evolución general para los programas de
Motoko. Cada objeto tiene el potencial de ser refactorizado en un servicio al
convertir el objeto local en un objeto actor.

Considera la siguiente declaración de objeto del valor de objeto `counter`:

```motoko
object counter {
  var count = 0;
  public func inc() { count += 1 };
  public func read() : Nat { count };
  public func bump() : Nat {
    inc();
    read()
  };
};
```

Esta declaración introduce una única instancia de objeto llamada `counter`. El
desarrollador expone tres funciones públicas `inc`, `read` y `bump` utilizando
la palabra clave `public` para declarar cada una en el cuerpo del objeto. El
cuerpo del objeto, al igual que una expresión de bloque, consiste en una lista
de declaraciones.

Además de estas tres funciones, el objeto tiene una variable mutable privada
`count`, que almacena el recuento actual y que inicialmente es cero.

## Tipos de objetos

Este objeto `counter` tiene el siguiente tipo de objeto, escrito como una lista
de pares campo-tipo, encerrados entre llaves `{` y `}`:

```motoko no-repl
{
  inc  : () -> () ;
  read : () -> Nat ;
  bump : () -> Nat ;
}
```

Cada tipo de campo consta de un identificador, dos puntos `:`, y un tipo para el
contenido del campo. Aquí, cada campo es una función y, por lo tanto, tiene la
forma de un tipo de flecha (`_ -> _`).

En la declaración de `object`, la variable `count` no se declaró explícitamente
como `public` ni como `private`.

Por defecto, todas las declaraciones en un bloque de objeto son `private`. En
consecuencia, el tipo de `count` no aparece en el tipo del objeto. Su nombre y
presencia son inaccesibles desde el exterior.

Al no exponer este detalle de implementación, el objeto tiene un tipo más
general con menos campos y, como resultado, es intercambiable con objetos que
tienen la misma interfaz pero una implementación diferente.

Para ilustrar el punto anterior, considera esta variación de la declaración de
`counter` anterior, llamada `byteCounter`:

```motoko
import Nat8 "mo:base/Nat8";
object byteCounter {
  var count : Nat8 = 0;
  public func inc() { count += 1 };
  public func read() : Nat { Nat8.toNat(count) };
  public func bump() : Nat { inc(); read() };
};
```

Este objeto tiene el mismo tipo que el anterior, y por lo tanto, desde el punto
de vista de la verificación de tipos, este objeto es intercambiable con el
anterior:

```motoko no-repl
{
  inc  : () -> () ;
  read : () -> Nat ;
  bump : () -> Nat ;
}
```

Esta versión no utiliza la misma implementación del campo `counter`. En lugar de
usar un número natural ordinario ([`Nat`](../base/Nat.md)), esta versión utiliza
un número natural de tamaño de byte, tipo [`Nat8`](../base/Nat8.md), cuyo tamaño
es siempre de ocho bits.

Como tal, la operación `inc` puede fallar con un desbordamiento para este
objeto, pero nunca para el anterior, que en su lugar podría llenar la memoria
del programa.

Ninguna implementación de un contador está exenta de cierta complejidad. En este
caso, comparten un tipo común.

El tipo común abstrae las diferencias en las implementaciones de los objetos,
protegiendo al resto de la aplicación de sus detalles de implementación.

Los tipos de objetos también pueden tener [subtipos](object-subtyping.md), lo
que permite que un objeto con un tipo más específico pase como un objeto de un
tipo más general, por ejemplo, para pasar como un objeto con menos campos.

## Clases de objetos y actores

**Clases de objetos**: Una familia de objetos relacionados para realizar una
tarea con un estado inicial personalizable. Motoko proporciona una construcción
sintáctica, llamada definición de `class`, que simplifica la creación de objetos
del mismo tipo e implementación.

**Clases de actores**: Una clase de objetos que expone un
[servicio](async-data.md) utilizando comportamiento asíncrono. La construcción
correspondiente en Motoko es una [clase de actor](actor-classes.md), que sigue
un diseño similar pero distinto.

## Clases de objetos

En Motoko, un objeto encapsula estado, y una `class` de objetos es un paquete de
dos entidades que comparten un nombre común.

Considera este ejemplo de `class` para contadores que comienzan en cero:

```motoko no-repl
class Counter() {
  var c = 0;
  public func inc() : Nat {
    c += 1;
    return c;
  }
};
```

El valor de esta definición es que podemos construir nuevos contadores, cada uno
comenzando con su propio estado único, inicialmente en cero:

```motoko no-repl
let c1 = Counter();
let c2 = Counter();
```

Cada uno es independiente:

```motoko no-repl
let x = c1.inc();
let y = c2.inc();
(x, y)
```

Podrías lograr los mismos resultados escribiendo una función que devuelve un
objeto:

```motoko
func Counter() : { inc : () -> Nat } =
  object {
    var c = 0;
    public func inc() : Nat { c += 1; c }
  };
```

Observa que el tipo de retorno de esta función constructora es un tipo de
objeto:

```motoko no-repl
{ inc : () -> Nat }
```

Es posible que desees nombrar este tipo como `Counter` para usarlo en
declaraciones de tipo adicionales:

```motoko no-repl
type Counter = { inc : () -> Nat };
```

La sintaxis de la palabra clave `class` mostrada anteriormente es una
abreviatura para estas dos definiciones de `Counter`: una función de fábrica
`Counter` que construye objetos y el tipo `Counter` de estos objetos. Las clases
no proporcionan ninguna funcionalidad nueva más allá de esta conveniencia.

### Constructor de clase

Una clase de objetos define una función constructora que puede llevar cero o más
argumentos de datos y cero o más argumentos de tipo.

El ejemplo de `Counter` anterior no tiene ninguno de estos. El siguiente ejemplo
toma dos argumentos de datos, `arg1` y `arg2`, con `Type1` y `Type2` como los
tipos de estos argumentos, respectivamente.

```motoko no-repl
class MyClass(arg1: Type1, arg2: Type2) {
  // class body here
};
```

Por ejemplo, puedes escribir una clase `Counter` que toma un argumento de tipo
`Nat` y un argumento de tipo `Bool`:

```motoko no-repl
import Nat "mo:base/Nat";

persistent actor {

  class Counter(init : Nat, flag : Bool) {
    var c = init;
    var f = flag;
    public func inc() : Nat {
      if f {
        c += 1;
      };
      return c;
    };
  };

}
```

Los argumentos de tipo, si los hay, parametrizan tanto el tipo como la función
constructora de la clase.

Los argumentos de datos, si los hay, parametrizan solo la función constructora
de la clase.

#### Argumentos de datos

Supongamos que deseas inicializar el contador con algún valor distinto de cero.
Puedes proporcionar ese valor como un argumento de datos al constructor de la
`class`:

```motoko
class Counter(init : Nat) {
  var c = init;
  public func inc() : Nat { c += 1; c };
};
```

Este parámetro está disponible para todos los métodos. Por ejemplo, puedes
`resetear` el `Counter` a su valor inicial, un parámetro:

```motoko
class Counter(init : Nat) {
  var c = init;
  public func inc() : Nat { c += 1; c };
  public func reset() { c := init };
};
```

#### Argumentos de tipo

Supongamos que quieres que el contador lleve datos que cuenta, como un `Buffer`
especializado.

Cuando las clases usan o contienen datos de tipo arbitrario, llevan un argumento
de tipo. Esto es equivalente a un parámetro de tipo para un tipo desconocido, al
igual que con las funciones.

El alcance de este parámetro de tipo abarca toda la `class` con los parámetros
de datos. Como tal, los métodos de la clase pueden usar estos parámetros de tipo
sin reintroducirlos.

```motoko
import Buffer "mo:base/Buffer";

class Counter<X>(init : Buffer.Buffer<X>) {
  var buffer = init.clone();
  public func add(x : X) : Nat {
    buffer.add(x);
    buffer.size()
  };

  public func reset() {
    buffer := init.clone()
  };
};
```

#### Anotación de tipo

El constructor de la clase también puede llevar una anotación de tipo para su
tipo de retorno. Cuando se proporciona, Motoko verifica que esta anotación de
tipo sea compatible con el cuerpo de la clase, que es una definición de objeto.
Esta verificación asegura que cada objeto producido por el constructor cumpla
con la especificación proporcionada.

Por ejemplo, repite el `Counter` como un buffer y anótalo con un tipo más
general `Accum<X>` que permite agregar, pero no restablecer, el contador. Esta
anotación asegura que los objetos sean compatibles con el tipo `Accum<X>`.

```motoko
import Buffer "mo:base/Buffer";

type Accum<X> = { add : X -> Nat };

class Counter<X>(init : Buffer.Buffer<X>) : Accum<X> {
  var buffer = init.clone();
  public func add(x : X) : Nat { buffer.add(x); buffer.size() };
  public func reset() { buffer := init.clone() };
};
```

#### Sintaxis completa

Las clases se definen mediante la palabra clave `class`, seguida de:

- Un nombre para el constructor y el tipo que se está definiendo. Por ejemplo,
  `Counter`.

- Argumentos de tipo opcionales. Por ejemplo, omitidos, o `<X>`, o `<X, Y>`.

- Una lista de argumentos. Por ejemplo, `()`, o `(init : Nat)`, etc.

- Una anotación de tipo opcional para los objetos construidos. Por ejemplo,
  omitida, o `Accum<X>`.

- El "cuerpo" de la clase es una definición de objeto, parametrizada por los
  argumentos de tipo y valor, si los hay.

Los componentes del cuerpo marcados como `public` contribuyen al tipo de los
objetos resultantes, y estos tipos se comparan con la anotación opcional, si se
proporciona.

Considera la tarea de recorrer los bits de un número natural
([`Nat`](../base/Nat.md)). Para este ejemplo, podrías definir lo siguiente:

```motoko
class Bits(n : Nat) {
  var state = n;
  public func next() : ?Bool {
    if (state == 0) { return null };
    let prev = state;
    state /= 2;
    ?(state * 2 != prev)
  }
}
```

La definición de clase anterior es equivalente a la definición simultánea de un
sinónimo de tipo estructural y una función de fábrica, ambos llamados `Bits`:

```motoko no-repl
type Bits = {next : () -> ?Bool};
func Bits(n : Nat) : Bits = object {
  // class body
};
```

## Combinación y extensión de objetos

Motoko te permite construir un objeto único a partir de un registro simple y un
bloque de objeto más complicado, al mismo tiempo que proporciona una sintaxis
para construir nuevos objetos a partir de los existentes, agregar nuevos campos
o reemplazar campos existentes. Los registros y objetos _base_ se separan con la
palabra clave `and` y pueden ir seguidos de `with` y campos adicionales (o
sobreescritos) separados por punto y coma. Los registros y campos se encierran
entre llaves, indicando la formación de un registro. Cuando los registros base
tienen campos superpuestos (según sus tipos), se debe proporcionar una
sobreescritura de campo para desambiguar. Los registros base originales nunca se
modifican; en su lugar, se copian sus campos para crear un nuevo objeto, y por
eso nos referimos a esto como una combinación y extensión funcional de objetos.

Aquí tienes algunos ejemplos simples:

1. Combinación de objetos con `and`: La palabra clave `and` combina dos o más
   objetos.

```motoko
let person = { name = "Alice"; };
let employee = { id = 123; department = "Engineering" };

let employedPerson = { person and employee };
// employeePerson now has: name, id, and department
```

2. Extensión de objetos con `with`: La palabra clave `with` te permite agregar
   nuevos campos o sobrescribir los existentes.

```motoko
let person = { name = "Alice" };

let agedPerson = { person with age = 30 };

// agedPersion now has: name and age
```

3. Combinando `and` y `with`: Puedes usar tanto `and` como `with` juntos para
   manipulaciones de objetos más complejas.

```motoko
let person = { name = "Alice" };
let employee = { id = 123; department = "Engineering" };

let employedPersonWithAge = { person and employee with age = 30 };
// employedPersionWithAge now has: name, id, department and age
```

- Al usar `and`, si hay nombres de campo en conflicto en las bases, el conflicto
  debe resolverse utilizando un campo `with`.
- La cláusula `with` se utiliza para desambiguar etiquetas de campo, definir
  nuevos campos, anular campos existentes, agregar nuevos campos `var` o
  redefinir campos `var` existentes para evitar el aliasing.
- Debes anular explícitamente cualquier campo `var` de los objetos base para
  evitar la introducción de alias.

Esta sintaxis proporciona una forma conveniente de crear código modular y
reutilizable en Motoko, permitiendo a los desarrolladores construir objetos
complejos a partir de componentes más simples y extender objetos existentes con
nueva funcionalidad.

Para obtener más detalles, consulta el
[manual de lenguaje](../reference/language-manual#object-combinationextension).

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
