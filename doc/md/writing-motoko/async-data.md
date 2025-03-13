---
sidebar_position: 5
---

# Datos asíncronos

En ICP, la comunicación entre canisters es asíncrona. Enviar un mensaje junto
con una devolución de llamada (callback) desde un canister a otro programa una
solicitud en el receptor. La finalización de la solicitud activa la devolución
de llamada al remitente, permitiendo que el remitente procese el resultado.

En Motoko, enviar un mensaje asíncrono de ICP se abstrae como una llamada a una
función compartida que devuelve un resultado asíncrono. Al igual que varios
otros lenguajes, Motoko ofrece `async` y `await` para facilitar la programación
con funciones y cálculos asíncronos.

En Motoko, ejecutar una expresión asíncrona, ya sea una llamada a una función
compartida o simplemente una expresión local `async`, produce un futuro, un
objeto de tipo `async T`, para algún tipo de resultado `T`. En lugar de bloquear
al llamante hasta que la llamada haya regresado, el mensaje se pone en cola en
el destinatario y el futuro que representa esa solicitud pendiente se devuelve
inmediatamente al llamante. El futuro es un marcador de posición para el
resultado eventual de la solicitud que el llamante puede consultar más tarde.

Cada operación que resulta en un futuro (es decir, envíos a otros
`actor`s/canisters o autoenvíos con `async` o mediante llamadas a funciones)
puede ir precedida de un _paréntesis_ de la forma
`(base with attr₁ = v₁; attr₂ = v₂; …)` donde `base` es un registro opcional que
contiene (por ejemplo, valores predeterminados) atributos. Los atributos
aceptados actualmente son `cycles : Nat`, que especifica la cantidad de ciclos
que se enviarán junto con el mensaje, y `timeout : Nat32` para modificar el
plazo y restringir el período de tiempo durante el cual el receptor puede
responder.

La sintaxis `await` sincroniza un futuro y suspende el cálculo hasta que el
futuro se complete por su productor.

Entre la emisión de la solicitud y la decisión de esperar el resultado, el
llamante es libre de hacer otro trabajo. Una vez que el destinatario ha
procesado la solicitud, el futuro se completa y su resultado se pone a
disposición del llamante. Si el llamante está esperando el futuro, su ejecución
puede reanudarse con el resultado; de lo contrario, el resultado simplemente se
almacena en el futuro para su uso posterior.

La combinación de las construcciones `async`/`await` simplifica la programación
asíncrona al permitir que los `await` se incrusten dentro de código secuencial
ordinario, sin requerir un manejo complicado de devoluciones de llamada
asíncronas.

## Funciones asíncronas

Aquí hay un programa de ejemplo que utiliza funciones asíncronas:

```motoko file=../examples/counter-actor.mo

```

El actor `Counter` declara un campo y tres funciones públicas compartidas:

- El campo `count` es mutable, inicializado a cero e implícitamente `private`.

- La función `inc()` incrementa asincrónicamente el contador y devuelve un
  futuro de tipo `async ()` para sincronización.

- La función `read()` lee asincrónicamente el valor del contador y devuelve un
  futuro de tipo `async Nat` que contiene su valor.

- La función `bump()` incrementa y lee asincrónicamente el contador.

La única forma de leer o modificar el estado (`count`) del actor `Counter` es a
través de sus funciones compartidas.

## Usando `await` para consumir futuros asíncronos

El llamador de una función compartida típicamente recibe un futuro, un valor de
tipo `async T` para algún T.

Lo único que el llamador puede hacer con este futuro es esperar a que sea
completado por el productor, desecharlo o almacenarlo para su uso posterior.

Para acceder al resultado de un valor `async`, el receptor del futuro utiliza
una expresión `await`.

Por ejemplo, para usar el resultado de `Counter.read()` anterior, podemos
primero asignar el futuro a un identificador `a`, y luego `await a` para
recuperar el [`Nat`](../base/Nat.md) subyacente, `n`:

```motoko no-repl
let a : async Nat = Counter.read();
let n : Nat = await a;
```

La primera línea recibe inmediatamente un futuro del valor del contador, pero no
espera por él y, por lo tanto, no puede usarlo como un número natural todavía.

La segunda línea `await` este futuro y extrae el resultado, un número natural.
Esta línea puede suspender la ejecución hasta que el futuro se haya completado.

Normalmente, se combinan los dos pasos en uno y simplemente se espera una
llamada asíncrona directamente:

```motoko no-repl
let n : Nat = await Counter.read();
```

A diferencia de una llamada a una función local, que bloquea al llamante hasta
que el llamado haya devuelto un resultado, una llamada a una función compartida
devuelve inmediatamente un futuro, `f`, sin bloquear. En lugar de bloquear, una
llamada posterior a `await f` suspende el cálculo actual hasta que `f` esté
completo. Una vez que el futuro se completa (por el productor), la ejecución de
`await p` se reanuda con su resultado. Si el resultado es un valor, `await f`
devuelve ese valor. De lo contrario, el resultado es algún error, y `await f`
propaga el error al consumidor de `await f`.

Esperar un futuro por segunda vez simplemente produce el mismo resultado,
incluyendo volver a lanzar cualquier error almacenado en el futuro. La
suspensión ocurre incluso si el futuro ya está completo; esto asegura que los
cambios de estado y los envíos de mensajes antes de cada `await` se confirmen.

## Usando paréntesis para modificar las modalidades de envío de mensajes

En los ejemplos anteriores, todos los mensajes enviados al actor `Counter` no
transmiten ciclos y nunca expiran cuando se espera su resultado. Ambos aspectos
se pueden configurar agregando sintácticamente un paréntesis y modificando así
los atributos dinámicos del envío del mensaje.

Para agregar ciclos al envío, se escribiría

```motoko no-repl
let a = (with cycles = 42_000_000) Counter.bump();
```

De manera similar, se puede especificar un tiempo de espera explícito para
aplicar al esperar el resultado del mensaje. Esto es útil en aplicaciones que
prefieren un esfuerzo máximo sobre la entrega garantizada de mensajes de
respuesta:

```motoko no-repl
let a = (with timeout = 25) Counter.bump();
```

Se pueden definir valores predeterminados personalizados para estos atributos en
un registro que se utiliza como la expresión base de un paréntesis:

```motoko no-repl
let boundedWait = { timeout = 25 };
let a = (boundedWait with cycles = 42_000_000) Counter.bump();
```

:::danger

Una función que no realiza `await` en su cuerpo tiene la garantía de ejecutarse
de manera atómica. En particular, el entorno no puede cambiar el estado del
actor mientras la función se está ejecutando. Sin embargo, si una función
realiza un `await`, la atomicidad ya no está garantizada. Entre la suspensión y
la reanudación alrededor del `await`, el estado del actor que la contiene puede
cambiar debido al procesamiento concurrente de otros mensajes entrantes del
actor. Es responsabilidad del programador protegerse contra cambios de estado no
sincronizados. Sin embargo, un programador puede confiar en que cualquier cambio
de estado antes del `await` se confirmará.

:::

Por ejemplo, la implementación de `bump()` anterior tiene la garantía de
incrementar y leer el valor de `count` en un solo paso atómico. La siguiente
implementación alternativa no tiene la misma semántica y permite que otro
cliente del actor interfiera con su operación.

```motoko no-repl
  public shared func bump() : async Nat {
    await inc();
    await read();
  };
```

Cada `await` suspende la ejecución, permitiendo que un interlocutor cambie el
estado del actor. Por diseño, los `await` explícitos hacen que los posibles
puntos de interferencia sean claros para el lector.

## Paquetes Mops para el flujo de datos asíncronos

- [`maf`](https://mops.one/maf) y [`mal`](https://mops.one/mal): Entregas de
  datos asíncronos.

- [`rxmo`](https://mops.one/rxmo): Una biblioteca para programación reactiva que
  utiliza observables, facilitando la composición de código asíncrono o basado
  en devoluciones de llamada.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
