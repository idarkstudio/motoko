---
sidebar_position: 26
---

# Timers

En ICP, los canisters pueden establecer timers (timeres) recurrentes que
ejecutan un fragmento de código después de un período de tiempo o intervalo
regular. Los tiempos en Motoko se implementan utilizando el módulo
[`Timer.mo`](../base/Timer.md) y devuelven un `TimerId`. Los `TimerId` son
únicos para cada instancia de timer. Un canister puede contener varios timers.

## Ejemplo

Un ejemplo simple es un recordatorio periódico que registra un mensaje de año
nuevo:

```motoko no-repl file=../examples/Reminder.mo

```

El mecanismo subyacente es un
[timer global del canister](https://internetcomputer.org/docs/current/references/ic-interface-spec#timer)
que, por defecto, emite devoluciones de llamada apropiadas desde una cola de
prioridad mantenida por el tiempo de ejecución de Motoko.

El mecanismo del timer se puede desactivar por completo pasando la bandera
`-no-timer` a `moc`.

## Acceso de bajo nivel

Cuando se desea acceder a un nivel más bajo del timer global del canister, un
actor puede optar por recibir mensajes de expiración del timer declarando una
función `system` llamada `timer`. La función toma un argumento que se utiliza
para restablecer el timer global y devuelve un futuro de tipo unit `async ()`.

Si se declara el método del sistema `timer`, el módulo de la biblioteca base
[`Timer.mo`](../base/Timer.md) puede no funcionar correctamente y no debe
utilizarse.

El siguiente ejemplo de una devolución de llamada de expiración del timer global
se llama inmediatamente después de que el canister se inicia, es decir, después
de la instalación, y periódicamente cada veinte segundos a partir de entonces:

```motoko no-repl
system func timer(setGlobalTimer : Nat64 -> ()) : async () {
  let next = Nat64.fromIntWrap(Time.now()) + 20_000_000_000;
  setGlobalTimer(next); // absolute time in nanoseconds
  print("Tick!");
}
```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
