---
sidebar_position: 11
---

# Enteros y números

Motoko ofrece una variedad de tipos para representar enteros y números
naturales, con la suite habitual de operadores aritméticos (`+`, `-`, `*`, `/`,
etc.) y operadores de comparación (`==`, `!=`, `<`, `>`, `<=`, `>=`).

Los tipos [`Int`](../base/Int.md) y [`Nat`](../base/Nat.md) son no acotados, lo
que significa que sus valores pueden crecer hasta un tamaño arbitrario, limitado
solo por la memoria.

El tipo [`Nat`](../base/Nat.md) es un subtipo de [`Int`](../base/Int.md), por lo
que siempre puedes proporcionar un valor de tipo [`Nat`](../base/Nat.md) donde
se espera un [`Int`](../base/Int.md), pero no viceversa.

Motoko también proporciona enteros y naturales acotados, o de tamaño fijo,
utilizando un sufijo para indicar el tamaño del tipo en bits.

Por lo tanto, [`Int8`](../base/Int8.md), [`Int16`](../base/Int16.md),
[`Int32`](../base/Int32.md) y [`Int64`](../base/Int64.md) son tipos de enteros
de 8, 16, 32 y 64 bits, mientras que [`Nat8`](../base/Nat8.md),
[`Nat16`](../base/Nat16.md), [`Nat32`](../base/Nat32.md) y
[`Nat64`](../base/Nat64.md) son tipos de naturales de 8, 16, 32 y 64 bits.

Una operación aritmética sobre un valor de un tipo de tamaño fijo generará una
trampa si su resultado excede los límites del tipo de tamaño fijo, ya sea por
desbordamiento o subdesbordamiento. Por ejemplo, `255 : Nat8 + 3` genera una
trampa, porque 258 es demasiado grande para un [`Nat8`](../base/Nat8.md).

Las versiones envolventes (wrapping) y no tramposas de las operaciones
aritméticas habituales, que realizan aritmética modular, están disponibles
agregando un `%` como sufijo al operador habitual. Por ejemplo,
`255 : Nat8 +% 3` se evalúa como `2`.

El tipo de una constante entera o natural está determinado por el contexto
textual de la constante, predeterminando a [`Int`](../base/Int.md) para
constantes negativas y [`Nat`](../base/Nat.md) para constantes positivas. De lo
contrario, el tipo de una constante se puede indicar utilizando una anotación de
tipo, por ejemplo `0 : Nat8`.

Se puede forzar que una constante no negativa se interprete como un
[`Int`](../base/Int.md) utilizando un signo explícito, por ejemplo `+1` es el
[`Int`](../base/Int.md) uno.

Por conveniencia, las actualizaciones en el lugar de una variable o elemento de
un arreglo se pueden escribir utilizando un operador de asignación compuesta,
combinando una operación aritmética con el operador de asignación `:=`. Por
ejemplo, `x += 1` es una abreviatura de `x := x + 1` y combina la suma `+` con
la asignación.

Motoko no proporciona conversiones implícitas entre tipos numéricos. En su
lugar, se deben usar funciones de la biblioteca base como `Nat8.toNat` y
`Nat8.fromNat` para realizar conversiones explícitas.

Para ilustrar el trabajo con números, aquí hay un programa de calculadora de
ejemplo que crea un solo actor con varias funciones de punto de entrada públicas
para realizar operaciones aritméticas básicas utilizando enteros.

## Usando enteros

```motoko file=../examples/Calc.mo

```

Puedes notar que este código de ejemplo utiliza tipos de datos enteros
([`Int`](../base/Int.md)), lo que te permite usar números positivos o negativos.
Si deseas restringir las funciones en este código de calculadora para usar solo
números positivos, podrías cambiar el tipo de datos para permitir solo datos
naturales ([`Nat`](../base/Nat.md)).

Este programa admite las siguientes llamadas a funciones:

- La llamada a la función `add` acepta entrada y realiza una suma.

- La llamada a la función `sub` acepta entrada y realiza una resta.

- La llamada a la función `mul` acepta entrada y realiza una multiplicación.

- La llamada a la función `div` acepta entrada y realiza una división. También
  incluye código para evitar que el programa intente dividir por cero.

- La función `clearall` borra el valor de `cell` almacenado como resultado de
  operaciones anteriores, restableciendo el valor de `cell` a cero.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
