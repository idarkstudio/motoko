---
sidebar_position: 29
---

# Tipos recursivos

Un tipo recursivo es un tipo que contiene valores del mismo tipo. Los tipos
recursivos te permiten crear estructuras de datos recursivas complejas, como
listas enlazadas o árboles.

Motoko admite listas enlazadas, una estructura de datos que es un ejemplo de un
tipo recursivo.

## Listas recursivas (List)

```motoko no-repl
type List<T> = ?(T, List<T>);
```

En este ejemplo, el tipo genérico `List<T>` se define con un parámetro de tipo.
`List<T>` es una tupla con dos componentes: el primer componente es el parámetro
de tipo `T` y el segundo componente es `List<T>`. El segundo componente es el
tipo recursivo, ya que el tipo genérico `List<T>` contiene un valor de sí mismo
dentro de su propia definición.

`List` es un patrón repetitivo, donde cada componente repetido es una tupla que
contiene un valor de tipo `T` y una referencia a la cola de `List<T>`.

## Funciones recursivas

Una función recursiva se puede utilizar para obtener el último elemento de una
lista dada:

```motoko no-repl
func last<T>(l : List<T>) : ?T {
  switch l {
    case null { null };
    case (?(x, null)) { ?x };
    case (?(_, t)) { last<T>(t) };
  };
};
```

Esta función genérica `last<T>` toma un argumento `l` de tipo `List<T>`, que se
refiere a la cabeza de una lista. Si esta función devuelve el último elemento de
una lista, devuelve un valor opcional `?T`. Si no hay un último elemento,
devolverá `null`. El cuerpo de la función utiliza una declaración `switch` para
determinar si la lista pasada como argumento es una lista vacía, el último
elemento de una lista, o si es la cola de una lista con un próximo valor.

En esta declaración `switch`, la función `last<T>` se utiliza de forma
recursiva, ya que se llama a sí misma con `t` como argumento. La función se
llama nuevamente cada vez que se cumple la declaración del caso, y la función
recibe una cabeza de lista en la que puede hacer una conmutación hasta que se
devuelva el último elemento.

:::info Ten en cuenta que necesitarás usar funciones recursivas para acceder a
todos los datos en un tipo recursivo. :::

## Recursos

- [Recursive types](https://github.com/Web3NL/motoko-book/blob/main/src/advanced-types/recursive-types.md).
