---
sidebar_position: 27
---

# Escribiendo código incompleto

En medio de la escritura de un programa, es posible que desees ejecutar una
versión incompleta o una versión donde una o más rutas de ejecución estén
ausentes o simplemente sean inválidas.

Para acomodar estas situaciones, Motoko proporciona las funciones `xxx`, `nyi` y
`unreachable` de la biblioteca base `Prelude`, explicadas a continuación. Cada
una es un envoltorio simple alrededor de un mecanismo de
[traps más general](../getting-started/basic-concepts.md#errores-traps).

## Agujeros a corto plazo

Asumiendo que se ha importado el preludio de la siguiente manera:

```motoko no-repl
import P "mo:base/Prelude";
```

Puedes completar cualquier expresión faltante con lo siguiente:

```motoko no-repl
P.xxx()
```

La expresión `xxx()` tiene tipo `None`, que es un subtipo de cualquier otro
tipo. Esto significa que la expresión puede llenar cualquier brecha a corto
plazo en tu código. `xxx()` generará un error cuando se ejecute.

## Agujeros a largo plazo

Por convención, los agujeros a largo plazo pueden considerarse características
"aún no implementadas" (`nyi`), y marcarse como tal con una función similar del
módulo Prelude:

```motoko no-repl
P.nyi()
```

Como `xxx()`, `nyi()` tiene tipo `None`, por lo tanto cualquier otro tipo, y
generará un error al ejecutarse.

## Código inalcanzable

A veces se te pedirá que proporciones código que sabes que nunca se ejecutará,
debido a la lógica del programa anterior.

Para documentar código inalcanzable, puedes usar la función `unreachable` del
preludio:

```motoko no-repl
P.unreachable()
```

Como `unreachable()` tiene tipo `None` y, por lo tanto, cualquier otro tipo,
generará una trampa en la ejecución (¡inesperada!).

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
