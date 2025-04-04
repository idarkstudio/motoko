---
sidebar_position: 1
---

# Ciclos (Cycles)

El uso de los recursos de un canister en ICP se mide y se paga en
[ciclos](https://internetcomputer.org/docs/current/developer-docs/defi/cycles/converting_icp_tokens_into_cycles).

En los programas de Motoko desplegados en ICP, cada actor representa un canister
y tiene un saldo asociado de ciclos. La propiedad de los ciclos puede
transferirse entre actores. Los ciclos se envían y reciben selectivamente a
través de llamadas a funciones compartidas. Un llamador puede elegir transferir
ciclos con una llamada, y un receptor puede elegir aceptar los ciclos que el
llamador pone a disposición. A menos que se indique explícitamente, no se
transfieren ciclos por parte de los llamadores ni se aceptan por parte de los
receptores.

Los receptores pueden aceptar todos, algunos o ninguno de los ciclos
disponibles, hasta un límite determinado por el saldo actual de su actor.
Cualquier ciclo restante se reembolsa al llamador. Si una llamada falla (trap),
todos los ciclos que la acompañan se reembolsan automáticamente al llamador sin
pérdida.

Motoko está adoptando una sintaxis y tipos dedicados para apoyar una
programación más segura con ciclos. Los usuarios ahora pueden adjuntar
`(where cycles = <cantidad>)` como prefijo a los envíos de mensajes y
expresiones asíncronas. Esta nueva sintaxis eventualmente hará obsoleto el uso
de `ExperimentalCycles.add<system>(ciclos)` en los ejemplos que siguen.

Por ahora (y hasta que se deprecie oficialmente), proporcionamos una forma
temporal de gestionar ciclos a través de una API imperativa de bajo nivel
proporcionada por la biblioteca
[ExperimentalCycles](../base/ExperimentalCycles.md) en el paquete `base`.

:::note

Esta biblioteca está sujeta a cambios y es probable que sea reemplazada por un
soporte de más alto nivel para ciclos en versiones posteriores de Motoko.
Consulta [Datos asíncronos](../writing-motoko/async-data.md) para obtener más
información sobre el uso de paréntesis (como adjuntar ciclos) en el envío de
mensajes.

:::

## La biblioteca [`ExperimentalCycles`](../base/ExperimentalCycles.md)

La biblioteca [`ExperimentalCycles`](../base/ExperimentalCycles.md) proporciona
operaciones imperativas para observar el saldo actual de ciclos de un actor,
transferir ciclos y observar reembolsos.

La biblioteca ofrece las siguientes operaciones:

- `func balance() : (amount : Nat)`: Devuelve el saldo actual de ciclos del
  actor como `amount`. La función `balance()` es con estado y puede devolver
  valores diferentes después de llamadas a `accept(n)`, llamar a una función
  después de `add` ciclos, o reanudar desde `await`, lo que refleja un
  reembolso.

- `func available() : (amount : Nat)`: Devuelve la cantidad actualmente
  disponible de ciclos como `amount`. Esta es la cantidad recibida del llamador
  actual, menos la cantidad acumulada `accept`ada hasta ahora por esta llamada.
  Al salir de la función compartida actual o de la expresión `async` mediante
  `return` o `throw`, cualquier cantidad disponible restante se reembolsa
  automáticamente al llamador.

- `func accept<system>(amount : Nat) : (accepted : Nat)`: Transfiere `amount`
  desde `available()` a `balance()`. Devuelve la cantidad realmente transferida,
  que puede ser menor que la solicitada, por ejemplo, si hay menos disponible o
  si se alcanzan los límites de saldo del canister. Requiere la capacidad
  `system`.

- `func add<system>(amount : Nat) : ()`: Indica la cantidad adicional de ciclos
  que se transferirán en la próxima llamada remota, es decir, la evaluación de
  una llamada a una función compartida o una expresión `async`. En el momento de
  la llamada, pero no antes, la cantidad total de unidades `add`ed desde la
  última llamada se deduce de `balance()`. Si este total excede `balance()`, el
  llamador falla (trap), abortando la llamada. Requiere la capacidad `system`.

- `func refunded() : (amount : Nat)`: Informa la `amount` de ciclos reembolsados
  en el último `await` del contexto actual, o cero si aún no ha ocurrido ningún
  `await`. Llamar a `refunded()` es únicamente informativo y no afecta a
  `balance()`. En cambio, los reembolsos se agregan automáticamente al saldo
  actual, ya sea que se use `refunded` para observarlos o no.

:::danger

Dado que los ciclos miden los recursos computacionales gastados, el valor de
`balance()` generalmente disminuye de una llamada a una función compartida a la
siguiente.

El registro implícito de cantidades agregadas, incrementado en cada `add`, se
restablece a cero al entrar en una función compartida, y después de cada llamada
a una función compartida o al reanudar desde un `await`.

:::

### Ejemplo

Para ilustrar, ahora usaremos la biblioteca
[`ExperimentalCycles`](../base/ExperimentalCycles.md) para implementar un
programa simple de alcancía (piggy bank) para ahorrar ciclos.

Nuestra alcancía tiene un propietario implícito, una devolución de llamada
`benefit` y una `capacity` fija, todo proporcionado en el momento de la
construcción. La devolución de llamada se utiliza para transferir cantidades
retiradas.

```motoko name=PiggyBank file=../examples/PiggyBank.mo

```

El propietario de la alcancía se identifica con el llamador implícito del
constructor `PiggyBank()`, utilizando el patrón compartido, `shared(msg)`. El
campo `msg.caller` es un [`Principal`](../base/Principal.md) y se almacena en la
variable privada `owner` para referencia futura. Consulta
[principales e identificación del llamador](../writing-motoko/caller-id.md) para
obtener más explicación sobre esta sintaxis.

La alcancía está inicialmente vacía, con `savings` (ahorros) actuales en cero.

Solo las llamadas del `owner` pueden:

- Consultar los `savings` actuales de la alcancía (función `getSavings()`), o

- Retirar cantidades de los ahorros (función `withdraw(amount)`).

La restricción sobre el llamador se aplica mediante las declaraciones
`assert (msg.caller == owner)`, cuyo fallo hace que la función que la contiene
falle (trap) sin revelar el saldo ni mover ningún ciclo.

Cualquier llamador puede `depositar` una cantidad de ciclos, siempre que los
ahorros no excedan la `capacity`, rompiendo la alcancía. Debido a que la función
de depósito solo acepta una porción de la cantidad disponible, un llamador cuyo
depósito exceda el límite recibirá un reembolso implícito de cualquier ciclo no
aceptado. Los reembolsos son automáticos y están garantizados por la
infraestructura de ICP.

Dado que la transferencia de ciclos es unidireccional del llamador al receptor,
recuperar ciclos requiere el uso de una devolución de llamada explícita
utilizando la función `benefit`, que se toma como argumento en el constructor.
Aquí, `benefit` es llamada por la función `withdraw`, pero solo después de
autenticar al llamador como `owner`. Invocar `benefit` en `withdraw` invierte la
relación llamador/receptor, permitiendo que los ciclos fluyan en sentido
contrario.

Ten en cuenta que el propietario de `PiggyBank` podría proporcionar una
devolución de llamada que recompense a un beneficiario distinto de `owner`.

Aquí se muestra cómo una propietaria, `Alice`, podría usar una instancia de
`PiggyBank`:

```motoko include=PiggyBank file=../examples/Alice.mo

```

`Alice` importa la clase de actor `PiggyBank` como una biblioteca para poder
crear un nuevo actor `PiggyBank` bajo demanda.

La mayor parte de la acción ocurre en la función `test()` de `Alice`:

- Alice dedica `10_000_000_000_000` de sus propios ciclos para operar la
  alcancía llamando a `Cycles.add(10_000_000_000_000)` justo antes de crear una
  nueva instancia, `porky`, de `PiggyBank`, pasando la devolución de llamada
  `Alice.credit` y la capacidad (`1_000_000_000`). Al pasar `Alice.credit`, se
  nombra a `Alice` como la beneficiaria de los retiros. Los `10_000_000_000_000`
  ciclos, menos una pequeña tarifa de instalación, se acreditan en el saldo de
  `porky` sin ninguna acción adicional por parte del código de inicialización
  del programa. Puedes pensar en esto como una alcancía eléctrica que consume
  sus propios recursos a medida que se usa. Dado que la construcción de un
  `PiggyBank` es asíncrona, `Alice` necesita `await` el resultado.

- Después de crear `porky`, primero verifica que `porky.getSavings()` sea cero
  usando un `assert`.

- `Alice` dedica `1_000_000` de sus ciclos (`Cycles.add<system>(1_000_000)`)
  para transferir a `porky` con la próxima llamada a `porky.deposit()`. Los
  ciclos solo se consumen del saldo de Alice si la llamada a `porky.deposit()`
  tiene éxito.

- `Alice` ahora retira la mitad de la cantidad, `500_000`, y verifica que los
  ahorros de `porky` se hayan reducido a la mitad. `Alice` eventualmente recibe
  los ciclos a través de una devolución de llamada a `Alice.credit()`, iniciada
  en `porky.withdraw()`. Ten en cuenta que los ciclos recibidos son precisamente
  los ciclos `add`ed en `porky.withdraw()`, antes de invocar su devolución de
  llamada `benefit`, `Alice.credit`.

- `Alice` retira otros `500_000` ciclos para agotar sus ahorros.

- `Alice` intenta depositar `2_000_000_000` ciclos en `porky`, pero esto excede
  la capacidad de `porky` a la mitad, por lo que `porky` acepta `1_000_000_000`
  y reembolsa los `1_000_000_000` restantes a `Alice`. `Alice` verifica la
  cantidad reembolsada (`Cycles.refunded()`), que se ha restaurado
  automáticamente a su saldo. También verifica los ahorros ajustados de `porky`.

- La función `credit()` de `Alice` simplemente acepta todos los ciclos
  disponibles llamando a `Cycles.accept<system>(available)`, verificando la
  cantidad realmente `aceptada` con un `assert`.

:::note

Para este ejemplo, Alice está utilizando los ciclos que ya tiene disponibles.

:::

:::danger

Debido a que `porky` consume ciclos en su operación, es posible que `porky`
gaste parte o incluso todos los ahorros de ciclos de Alice antes de que ella
tenga la oportunidad de recuperarlos.

:::

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
