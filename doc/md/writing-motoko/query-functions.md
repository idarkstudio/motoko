---
sidebar_position: 21
---

# Funciones de consulta (Query functions)

En la terminología de ICP, los mensajes de **actualización** (update), también
conocidos como llamadas, pueden alterar el estado del canister cuando se
invocan. Para efectuar un cambio de estado, se requiere un acuerdo entre las
réplicas distribuidas antes de que la red pueda confirmar el cambio y devolver
un resultado. Alcanzar un consenso es un proceso costoso con una latencia
relativamente alta.

Para las partes de las aplicaciones que no requieren las garantías del consenso,
el ICP admite operaciones de consulta más eficientes. Estas pueden leer el
estado de un canister desde una sola réplica, modificar una instantánea durante
su ejecución y devolver un resultado, pero no pueden alterar permanentemente el
estado ni enviar mensajes adicionales.

## Funciones de consulta

Motoko admite la implementación de consultas mediante funciones `query`. La
palabra clave `query` modifica la declaración de una función compartida de un
actor para que se ejecute con semántica de consulta no comprometedora y más
rápida.

Por ejemplo, considera el siguiente actor `Counter` con una función `read`
llamada `peek`:

```motoko file=../examples/CounterWithQuery.mo

```

La función `peek()` podría ser utilizada por un frontend de `Counter` que ofrece
una visualización rápida pero menos confiable del valor actual del contador.

Las funciones de consulta pueden ser llamadas desde funciones que no son de
consulta. Debido a que esas llamadas anidadas requieren consenso, las ganancias
de eficiencia de las llamadas anidadas de consulta serán modestas en el mejor de
los casos.

El modificador `query` se refleja en el tipo de una función de consulta:

```motoko no-repl
  peek : shared query () -> async Nat
```

Como antes, en las declaraciones de `query` y en los tipos de actores, la
palabra clave `shared` se puede omitir.

:::info

Un método query no puede llamar a una función de actor y dará como resultado un
error al compilar el código. Las llamadas a funciones ordinarias están
permitidas.

:::

## Funciones de consulta compuestas (Composite query functions)

Las consultas tienen limitaciones en lo que pueden hacer. En particular, no
pueden enviar mensajes adicionales, incluidas otras consultas.

Para abordar esta limitación, el ICP admite otro tipo de función de consulta
llamada consulta compuesta.

Al igual que las consultas simples, los cambios de estado realizados por una
consulta compuesta son transitorios, aislados y nunca se confirman. Además, las
consultas compuestas no pueden llamar a funciones de actualización, incluidas
aquellas implícitas en expresiones `async`, que requieren llamadas de
actualización en segundo plano.

A diferencia de las consultas simples, las consultas compuestas pueden llamar a
funciones de consulta y a funciones de consulta compuesta en el mismo actor o en
otros actores, pero solo si esos actores residen en la misma subred.

Como un ejemplo artificial, considera generalizar el actor `Counter` anterior a
una clase de contadores. Cada instancia de la clase proporciona una función
adicional de `composite query` para sumar los valores de un arreglo dado de
contadores:

```motoko file=../examples/CounterWithCompositeQuery.mo

```

Declarar `sum` como una `composite query` le permite llamar a las consultas
`peek` de los contadores de sus argumentos.

Si bien los mensajes de actualización pueden llamar a funciones de consulta
simples, no pueden llamar a funciones de consulta compuestas. Esta distinción,
que está dictada por las capacidades actuales de ICP, explica por qué las
funciones de consulta y las funciones de consulta compuestas se consideran tipos
distintos de funciones compartidas.

Tenga en cuenta que el modificador `composite query` se refleja en el tipo de
una función de consulta compuesta:

```motoko no-repl
  sum : shared composite query ([Counter]) -> async Nat
```

Desde que solo una consulta compuesta puede llamar a otra consulta compuesta, es
posible que te preguntes cómo se llama alguna consulta compuesta en absoluto.

Las consultas compuestas se inician fuera de ICP, generalmente por una
aplicación (como un frontend de navegador) que envía un mensaje de ingreso
invocando una consulta compuesta en un actor de backend.

:::danger La semántica de las consultas compuestas de Internet Computer asegura
que los cambios de estado realizados por una consulta compuesta estén aislados
de otras llamadas entre canisters, incluyendo consultas recursivas, al mismo
actor.

En particular, una llamada a una consulta compuesta deshace su estado al salir
de la función, pero tampoco pasa los cambios de estado a las llamadas de
sub-consulta o sub-consulta compuesta. Las llamadas repetidas, que incluyen
llamadas recursivas, tienen una semántica diferente a las llamadas que acumulan
cambios de estado.

En las llamadas secuenciales, los cambios de estado internos de las consultas
anteriores no tienen efecto en las consultas posteriores, ni las consultas
observarán los cambios de estado locales realizados por la consulta compuesta
que las envuelve. Los cambios de estado locales realizados por la consulta
compuesta se conservan a lo largo de las llamadas hasta que finalmente se
deshacen al salir de la consulta compuesta.

Esta semántica puede llevar a un comportamiento sorprendente para los usuarios
acostumbrados a la programación imperativa ordinaria.

Considera este ejemplo que contiene la consulta compuesta `test` que llama a la
consulta `q` y a la consulta compuesta `cq`.

```motoko no-repl file=../examples/CompositeSemantics.mo

```

Cuando `state` es `0`, una llamada a `test` devuelve

```
{s0 = 0; s1 = 0; s2 = 0; s3 = 3_000}
```

Esto se debe a que ninguna de las actualizaciones locales de `state` es visible
para ninguno de los llamadores o llamados.

:::

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
