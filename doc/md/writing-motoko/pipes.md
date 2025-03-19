---
sidebar_position: 20
---

# Canalización de valores en expresiones

A veces puede resultar difícil leer expresiones profundamente anidadas que
involucran varias aplicaciones de funciones.

```motoko file=../examples/Unpiped.mo#L1-L8

```

Esta expresión toma el rango de números `0`..`10`, lo convierte en una lista,
filtra la lista para obtener los múltiplos de tres y luego devuelve un registro
que contiene el resultado.

Para hacer estas expresiones más legibles, puedes usar el operador de
canalización de Motoko `<exp1> |> <exp2>`. El operador evalúa el primer
argumento `<exp1>` y te permite referirte a su valor en `<exp2>` utilizando la
expresión especial de marcador de posición `_`.

Usando esto, puedes escribir la expresión anterior de la siguiente manera:

```motoko file=../examples/Piped.mo#L1-L8

```

Ahora, el orden textual de las operaciones corresponde a la explicación
anterior. La expresión de canalización `<exp1> |> <exp2>` es solo azúcar
sintáctica para el siguiente bloque de enlace `<exp1>` a un identificador
reservado de marcador de posición, `p`, antes de devolver `<exp2>`:

```bnf
do { let p = <exp1>; <exp2> }
```

La identificación de marcador de posición, de otro modo inaccesible, solo puede
ser referenciada por la expresión de marcador de posición `_`. Se permiten
múltiples referencias a `_` y se refieren al mismo valor dentro de la misma
operación de canalización.

Ten en cuenta que usar `_` como una expresión fuera de una operación de
canalización, donde no está definido, es un error.

Por ejemplo, el siguiente ejemplo produce el error de tiempo de compilación
"error de tipo [M0057], variable no vinculada \_":

```motoko no-repl
let x = _;
```

Internamente, el compilador utiliza el identificador reservado `_` como el
nombre para el marcador de posición llamado `p` anteriormente, por lo que este
`let` simplemente hace referencia a una variable no definida.

Consulta la
[página del manual de lenguaje sobre canalizaciones](../reference/language-manual#pipe-operators-and-placeholder-expressions)
para obtener más detalles.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
