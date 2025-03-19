---
sidebar_position: 25
---

# Igualdad estructural

La igualdad (`==`) — y por extensión la desigualdad (`!=`) — es **estructural**.
Dos valores, `a` y `b`, son iguales, `a == b`, si tienen contenidos iguales,
independientemente de la representación física o la identidad de esos valores en
la memoria.

Por ejemplo, las cadenas `"hello world"` y `"hello " # "world"` son iguales,
aunque es muy probable que estén representadas por objetos diferentes en la
memoria.

La igualdad está definida solo en tipos `shared` o en tipos que no contienen:

- Campos mutables.

- Arreglos mutables.

- Funciones no compartidas.

- Componentes de tipo genérico.

Por ejemplo, podemos comparar arreglos de objetos:

```motoko run
let a = [ { x = 10 }, { x = 20 } ];
let b = [ { x = 10 }, { x = 20 } ];
a == b;
```

Es importante destacar que esto no compara por referencia, sino por valor.

## Subtipificación

La igualdad respeta la subtipificación, por lo que
`{ x = 10 } == { x = 10; y = 20 }` devuelve `true`.

Para acomodar la subtipificación, dos valores de tipos diferentes son iguales si
son iguales en su supertipo común más específico, lo que significa que coinciden
en su estructura común. El compilador emitirá una advertencia en casos donde
esto pueda llevar a comportamientos no deseados sutiles.

Por ejemplo: `{ x = 10 } == { y = 20 }` devolverá `true` porque los dos valores
se comparan en el tipo de registro vacío. Es poco probable que esa sea la
intención, por lo que el compilador emitirá una advertencia en este caso.

```motoko run
{ x = 10 } == { y = 20 };
```

## Tipos genéricos

No es posible declarar que una variable de tipo genérico sea `shared`, por lo
que la igualdad solo se puede usar en tipos no genéricos. Por ejemplo, la
siguiente expresión genera una advertencia:

```motoko run
func eq<A>(a : A, b : A) : Bool = a == b;
```

Comparar estos dos en el tipo `Any` significa que esta comparación siempre
devolverá `true` sin importar sus argumentos, por lo que esto no funciona como
uno podría esperar.

Si te encuentras con esta limitación en tu código, debes aceptar una función de
comparación de tipo `(A, A) -> Bool` como argumento y usarla para comparar los
valores en su lugar.

Veamos un ejemplo de prueba de pertenencia en una lista. Esta primera
implementación **no funciona**:

```motoko run
import List "mo:base/List";

func contains<A>(element : A, list : List.List<A>) : Bool {
  switch list {
    case (?(head, tail))
      element == head or contains(element, tail);
    case null false;
  }
};

assert(not contains(1, ?(0, null)));
```

Esta afirmación generará una advertencia porque el compilador compara el tipo
`A` con `Any`, lo cual siempre es `true`. Mientras la lista tenga al menos un
elemento, esta versión de `contains` siempre devolverá `true`.

Esta segunda implementación muestra cómo aceptar explícitamente la función de
comparación:

```motoko run
import List "mo:base/List";
import Nat "mo:base/Nat";

func contains<A>(eqA : (A, A) -> Bool, element : A, list : List.List<A>) : Bool {
  switch list {
    case (?(head, tail))
      eqA(element, head) or contains(eqA, element, tail);
    case null false;
  }
};

assert(not contains(Nat.equal, 1, ?(0, null)));
```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
