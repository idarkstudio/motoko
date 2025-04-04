# None

El valor ausente

El tipo `None` representa un tipo sin _ningún_ valor.

A menudo se utiliza para tipificar código que no devuelve el control (por
ejemplo, un bucle infinito) o para designar valores imposibles (por ejemplo, el
tipo `?None` solo contiene `null`).

## Tipo `None`

```motoko no-repl
type None = Prim.Types.None
```

El tipo vacío. Un subtipo de todos los tipos.

## Function `impossible`

```motoko no-repl
func impossible<A>(_ : None) : A
```

Convierte un valor absurdo en un tipo arbitrario.
