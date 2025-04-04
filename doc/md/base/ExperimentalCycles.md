# ExperimentalCycles

Gestión de ciclos dentro de actores en Internet Computer (IC).

El uso de Internet Computer se mide y se paga en _ciclos_. Esta biblioteca
proporciona operaciones imperativas para observar ciclos, transferir ciclos y
observar reembolsos de ciclos.

**ADVERTENCIA:** Esta API de bajo nivel es **experimental** y es probable que
cambie o incluso desaparezca. En el futuro, se puede agregar soporte sintáctico
dedicado para manipular ciclos, lo que haría obsoleta esta biblioteca.

**NOTA:** Dado que los ciclos miden los recursos computacionales, el valor de
`balance()` puede cambiar de una llamada a la siguiente.

Ejemplo de uso en IC:

```motoko no-repl
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";

actor {
  public func main() : async() {
    Debug.print("Saldo principal: " # debug_show(Cycles.balance()));
    Cycles.add<system>(15_000_000);
    await operation(); // acepta 10_000_000 ciclos
    Debug.print("Reembolso principal: " # debug_show(Cycles.refunded())); // 5_000_000
    Debug.print("Saldo principal: " # debug_show(Cycles.balance())); // disminuido en aproximadamente 10_000_000
  };

  func operation() : async() {
    Debug.print("Saldo de operación: " # debug_show(Cycles.balance()));
    Debug.print("Disponible de operación: " # debug_show(Cycles.available()));
    let obtained = Cycles.accept<system>(10_000_000);
    Debug.print("Obtenido de operación: " # debug_show(obtained)); // => 10_000_000
    Debug.print("Saldo de operación: " # debug_show(Cycles.balance())); // aumentado en 10_000_000
    Debug.print("Disponible de operación: " # debug_show(Cycles.available())); // disminuido en 10_000_000
  }
}
```

## Function `balance`

```motoko no-repl
func balance() : (amount : Nat)
```

Devuelve el saldo actual de ciclos del actor como `amount`.

Ejemplo de uso en IC:

```motoko no-repl
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";

actor {
  public func main() : async() {
    let balance = Cycles.balance();
    Debug.print("Saldo: " # debug_show(balance));
  }
}
```

## Function `available`

```motoko no-repl
func available() : (amount : Nat)
```

Devuelve el `amount` de ciclos actualmente disponibles. La cantidad disponible
es la cantidad recibida en la llamada actual, menos la cantidad acumulativa
`accept`ada por esta llamada. Al salir de la función compartida actual o de la
expresión asíncrona a través de `return` o `throw`, cualquier cantidad
disponible restante se reembolsa automáticamente al llamador/contexto.

Ejemplo de uso en IC:

```motoko no-repl
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";

actor {
  public func main() : async() {
    let available = Cycles.available();
    Debug.print("Disponible: " # debug_show(available));
  }
}
```

## Function `accept`

```motoko no-repl
func accept(amount : Nat) : (accepted : Nat)
```

Transfiere hasta `amount` desde `available()` a `balance()`. Devuelve la
cantidad transferida realmente, que puede ser menor que la solicitada, por
ejemplo, si hay menos disponible o si se alcanzan los límites de saldo del
canister.

Ejemplo de uso en IC (para mayor simplicidad, solo se transfieren ciclos a sí
mismo):

```motoko no-repl
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";

actor {
  public func main() : async() {
    Cycles.add<system>(15_000_000);
    await operation(); // acepta 10_000_000 ciclos
  };

  func operation() : async() {
    let obtained = Cycles.accept<system>(10_000_000);
    Debug.print("Obtenido: " # debug_show(obtained)); // => 10_000_000
  }
}
```

## Function `add`

```motoko no-repl
func add(amount : Nat) : ()
```

Indica una cantidad adicional `amount` de ciclos que se transferirá en la
próxima llamada, es decir, la evaluación de una llamada a función compartida o
expresión asíncrona. Genera una trampa si el total actual superaría `2 ** 128`
ciclos. En la llamada, pero no antes, la cantidad total de ciclos `add`idos
desde la última llamada se deduce de `balance()`. Si este total supera
`balance()`, el llamador genera una trampa, abortando la llamada.

**Nota**: El registro implícito de las cantidades agregadas se restablece a cero
al entrar en una función compartida y después de cada llamada a función
compartida o reanudación de un await.

Ejemplo de uso en IC (para mayor simplicidad, solo se transfieren ciclos a sí
mismo):

```motoko no-repl
import Cycles "mo:base/ExperimentalCycles";

actor {
  func operation() : async() {
    ignore Cycles.accept<system>(10_000_000);
  };

  public func main() : async() {
    Cycles.add<system>(15_000_000);
    await operation();
  }
}
```

@deprecated This function will be removed in future. Use the parenthetical
syntax on message sends and `async` expressions to attach cycles:
`(with cycles = <amount>) C.send(...)`.

## Function `refunded`

```motoko no-repl
func refunded() : (amount : Nat)
```

Informa sobre la `amount` de ciclos reembolsados en el último `await` del
contexto actual, o cero si aún no se ha producido ningún await. Llamar a
`refunded()` es únicamente informativo y no afecta a `balance()`. En su lugar,
los reembolsos se agregan automáticamente al saldo actual, independientemente de
si se utiliza `refunded` para observarlos.

Ejemplo de uso en IC (para mayor simplicidad, solo se transfieren ciclos a sí
mismo):

```motoko no-repl
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";

actor {
  func operation() : async() {
    ignore Cycles.accept<system>(10_000_000);
  };

  public func main() : async() {
    Cycles.add<system>(15_000_000);
    await operation(); // acepta 10_000_000 ciclos
    Debug.print("Reembolsado: " # debug_show(Cycles.refunded())); // 5_000_000
  }
}
```

## Function `burn`

```motoko no-repl
func burn(amount : Nat) : (burned : Nat)
```

Attempts to burn `amount` of cycles, deducting `burned` from the canister's
cycle balance. The burned cycles are irrevocably lost and not available to any
other principal either.

Example for use on the IC:

```motoko no-repl
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";

actor {
  public func main() : async() {
    let burnt = Cycles.burn<system>(10_000_000);
    Debug.print("Burned: " # debug_show burnt); // 10_000_000
  }
}
```
