# Timer

Temporizadores para tareas únicas o periódicas. Aplicable como parte del
mecanismo predeterminado. Si se invoca `moc` con `-no-timer`, la importación
fallará. Además, si se pasa `--trap-on-call-error`, una cola de envío de
canister congestionada puede evitar que las expiraciones del temporizador se
ejecuten en tiempo de ejecución. También puede desactivar el temporizador
global.

La resolución de los temporizadores es similar a la velocidad de bloqueo, por lo
que las duraciones deben elegirse por encima de eso. Para despertares frecuentes
de canister, considere usar el mecanismo de
[heartbeat](https://internetcomputer.org/docs/current/motoko/main/writing-motoko/heartbeats);
sin embargo, cuando sea posible, los canisters deben preferir los
temporizadores.

La funcionalidad descrita a continuación solo está habilitada cuando el actor no
la anula al declarar una `system func timer` explícita.

Los temporizadores _no_ se persisten en las actualizaciones. Una estrategia
posible para restablecer los temporizadores después de una actualización es usar
variables estables en el gancho `post_upgrade` y destilar la información del
temporizador necesaria desde allí.

Se desaconseja encarecidamente el uso de temporizadores para la seguridad (por
ejemplo, control de acceso). Asegúrese de informarse sobre la seguridad de dapp
de última generación. Si debe usar temporizadores para controles de seguridad,
asegúrese de considerar problemas de reentrancia, así como la desaparición de
temporizadores en actualizaciones y reinstalaciones.

Para obtener más información sobre el uso de temporizadores en el IC, consulte
[la documentación](https://internetcomputer.org/docs/current/developer-docs/backend/periodic-tasks#timers-library-limitations).

## Tipo `Duration`

```motoko no-repl
type Duration = {#seconds : Nat; #nanoseconds : Nat}
```

## Tipo `TimerId`

```motoko no-repl
type TimerId = Nat
```

## Función `setTimer`

```motoko no-repl
func setTimer(d : Duration, job : () -> async ()) : TimerId
```

Instala un temporizador único que, al expirar después de la duración dada `d`,
ejecuta el futuro `job()`.

```motoko no-repl
let now = Time.now();
let thirtyMinutes = 1_000_000_000 * 60 * 30;
func alarmUser() : async () {
  // ...
};
appt.reminder = setTimer(#nanoseconds (Int.abs(appt.when - now - thirtyMinutes)), alarmUser);
```

## Función `recurringTimer`

```motoko no-repl
func recurringTimer(d : Duration, job : () -> async ()) : TimerId
```

Instala un temporizador recurrente que, al expirar después de la duración dada
`d`, ejecuta el futuro `job()` y se vuelve a insertar para otra expiración.

Nota: Una duración de 0 solo expirará una vez.

```motoko no-repl
func checkAndWaterPlants() : async () {
  // ...
};
let daily = recurringTimer(#seconds (24 * 60 * 60), checkAndWaterPlants);
```

## Function `cancelTimer`

```motoko no-repl
func cancelTimer(_ : TimerId) : ()
```

Cancela un temporizador aún activo con `(id : TimerId)`. Para temporizadores
vencidos y `id`s no reconocidos, no sucede nada.

```motoko no-repl
func deleteAppointment(appointment : Appointment) {
  cancelTimer (appointment.reminder);
  // ...
};
```
