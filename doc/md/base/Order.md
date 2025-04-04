# Order

Orden

## Tipo `Order`

```motoko no-repl
type Order = {#less; #equal; #greater}
```

Un tipo para representar un orden.

## Función `isLess`

```motoko no-repl
func isLess(order : Order) : Bool
```

Verifica si un orden es #less.

## Función `isEqual`

```motoko no-repl
func isEqual(order : Order) : Bool
```

Verifica si un orden es #equal.

## Función `isGreater`

```motoko no-repl
func isGreater(order : Order) : Bool
```

Verifica si un orden es #greater.

## Función `equal`

```motoko no-repl
func equal(o1 : Order, o2 : Order) : Bool
```

Devuelve verdadero solo si `o1` y `o2` tienen el mismo orden.
