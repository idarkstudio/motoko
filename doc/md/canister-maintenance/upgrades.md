---
sidebar_position: 3
---

# Variables estables y métodos de actualización

Una característica clave de Motoko es su capacidad para persistir
automáticamente el estado del programa sin instrucciones explícitas del usuario,
lo que se conoce como **persistencia ortogonal**. Esto no solo cubre la
persistencia entre transacciones, sino que también incluye actualizaciones de
canisters. Para este propósito, Motoko cuenta con un compilador y un sistema de
tiempo de ejecución personalizados que gestionan las actualizaciones de manera
sofisticada, de modo que una nueva versión del programa pueda retomar el estado
dejado por una versión anterior. Como resultado, la persistencia de datos en
Motoko no solo es simple, sino que también previene la corrupción o pérdida de
datos, al mismo tiempo que es eficiente. No se requiere una base de datos, una
API de memoria estable o estructuras de datos estables para retener el estado
entre actualizaciones. En su lugar, una simple palabra clave `stable` es
suficiente para declarar una estructura de datos de forma arbitraria como
persistente, incluso si la estructura utiliza compartición, tiene una
complejidad profunda o contiene ciclos.

Esto es sustancialmente diferente a otros lenguajes compatibles con IC, que
utilizan implementaciones de lenguajes estándar que no están diseñadas con la
persistencia ortogonal en mente: reorganizan estructuras de memoria de manera no
controlada durante la recompilación o en tiempo de ejecución. Como alternativa,
en otros lenguajes, los programadores deben usar explícitamente memoria estable
o estructuras de datos estables especiales para rescatar sus datos entre
actualizaciones. A diferencia de Motoko, este enfoque no solo es engorroso, sino
también inseguro e ineficiente. En comparación con el uso de estructuras de
datos estables, la persistencia ortogonal de Motoko permite un modelado de datos
más natural y un acceso a datos significativamente más rápido, lo que finalmente
resulta en programas más eficientes.

## Declaración de variables estables

En un actor, puedes configurar qué parte del programa se considera persistente,
es decir, que sobrevive a las actualizaciones, y qué parte es efímera, es decir,
que se restablece en las actualizaciones.

Más precisamente, cada declaración de variable `let` o `var` en un actor puede
especificar si la variable es `stable` o `transient`. Si no proporcionas un
modificador, la variable se considera `transient` por defecto.

La semántica de los modificadores es la siguiente:

- `stable` significa que todos los valores directa o indirectamente accesibles
  desde esa variable estable del actor se consideran persistentes y se retienen
  automáticamente entre actualizaciones. Esta es la opción principal para la
  mayor parte del estado del programa.
- `transient` significa que la variable se reinicializa en la actualización, de
  modo que los valores referenciados por esta variable transitoria pueden
  descartarse, a menos que los valores sean transitivamente accesibles a través
  de otras variables que sean estables. `transient` solo se usa para estados
  temporales o referencias a tipos de alto orden, como referencias a funciones
  locales, consulta [tipos estables](#stable-types).

:::note

Las versiones anteriores de Motoko (hasta la versión 0.13.4) usaban la palabra
clave `flexible` en lugar de `transient`. Ambas palabras clave se aceptan
indistintamente, pero la palabra clave heredada `flexible` puede quedar obsoleta
en el futuro.

:::note

El siguiente es un ejemplo simple de cómo declarar un contador estable que puede
ser actualizado mientras se preserva el valor del contador:

```motoko file=../examples/StableCounter.mo

```

A partir de Motoko v0.13.5, si prefijas la palabra clave `actor` con la palabra
clave `persistent`, entonces todas las declaraciones `let` y `var` del actor o
clase de actor se declaran implícitamente como `stable`. Solo las variables
`transient` necesitarán una declaración explícita de `transient`. El uso de un
actor `persistent` puede ayudar a evitar la pérdida de datos no deseada. Es la
sintaxis de declaración recomendada para actores y clases de actores. La
declaración no `persistent` se proporciona para garantizar la compatibilidad con
versiones anteriores.

Desde Motoko v0.13.5, la forma recomendada de declarar `StableCounter` es:

```motoko file=../examples/PersistentCounter.mo

```

:::note

Solo puedes usar el modificador `stable`, `transient` (o el legado `flexible`)
en las declaraciones `let` y `var` que son **campos de actores**. No puedes usar
estos modificadores en ningún otro lugar de tu programa.

:::

Cuando compilas y despliegas un canister por primera vez, todas las variables
transitorias y estables en el actor se inicializan en secuencia. Cuando
despliegas un canister en modo `upgrade`, todas las variables estables que
existían en la versión anterior del actor se pre-inicializan con sus valores
antiguos. Después de que las variables estables se inicializan con sus valores
anteriores, las variables transitorias restantes y las nuevas variables estables
se inicializan en secuencia.

:::danger No olvides declarar las variables como `stable` si deben sobrevivir a
las actualizaciones del canister, ya que el valor predeterminado es `transient`
si no se declara ningún modificador. Una precaución simple es declarar todo el
actor o clase de actor como `persistent`. :::

## Modos de persistencia

Motoko actualmente cuenta con dos implementaciones para la persistencia
ortogonal, consulta [modos de persistencia](orthogonal-persistence/modes.md).

## Tipos estables

Debido a que el compilador debe asegurarse de que las variables estables sean
compatibles con y significativas en el programa de reemplazo después de una
actualización, cada variable `stable` debe tener un tipo estable. Un tipo es
estable si el tipo obtenido al ignorar cualquier modificador `var` dentro de él
es compartido.

La única diferencia entre los tipos estables y los tipos compartidos es el
soporte de los primeros para la mutación. Al igual que los tipos compartidos,
los tipos estables están restringidos a datos de primer orden, excluyendo
funciones locales y estructuras construidas a partir de funciones locales (como
instancias de clases). Esta exclusión de funciones es necesaria porque el
significado de un valor de función, que consiste en datos y código, no puede
preservarse fácilmente a través de una actualización. El significado de los
datos simples, mutables o no, sí puede preservarse.

:::note

En general, las clases no son estables porque pueden contener funciones locales.
Sin embargo, un registro simple de datos estables es un caso especial de tipos
de objetos que son estables. Además, las referencias a actores y funciones
compartidas también son estables, lo que te permite preservar sus valores entre
actualizaciones. Por ejemplo, puedes preservar el registro de estado de un
conjunto de actores o devoluciones de llamada de funciones compartidas suscritas
a un servicio.

:::

## Conversión de tipos no estables a tipos estables

Para las variables que no tienen un tipo estable, existen dos opciones para
hacerlas estables:

1. Usar un módulo `stable` para el tipo, como:

- [StableBuffer](https://github.com/canscale/StableBuffer)
- [StableHashMap](https://github.com/canscale/StableHashMap)
- [StableRBTree](https://github.com/canscale/StableRBTree)

:::note A diferencia de las estructuras de datos estables en el Rust CDK, estos
módulos no usan memoria estable, sino que dependen de la persistencia ortogonal.
El adjetivo "estable" solo denota un tipo estable en Motoko. :::

2. Extraer el estado en un tipo estable y envolverlo en el tipo no estable.

Por ejemplo, el tipo estable `TemperatureSeries` cubre los datos persistentes,
mientras que el tipo no estable `Weather` lo envuelve con métodos adicionales
(tipos de funciones locales).

```motoko no-repl file=../examples/WeatherActor.mo

```

3. **Desaconsejado y no recomendado**:
   [Ganchos de pre y post actualización](#preupgrade-and-postupgrade-system-methods)
   permiten copiar tipos no estables a tipos estables durante las
   actualizaciones. Este enfoque es propenso a errores y no escala para grandes
   cantidades de datos. **Según las mejores prácticas, el uso de estos métodos
   debe evitarse si es posible.** Conceptualemente, tampoco se alinea bien con
   la idea de persistencia ortogonal.

## Firmas de tipos estables

La colección de declaraciones de variables estables en un actor puede resumirse
en una firma estable.

La representación textual de la firma estable de un actor se asemeja a las
internas de un tipo de actor en Motoko:

```motoko no-repl
actor {
  stable x : Nat;
  stable var y : Int;
  stable z : [var Nat];
};
```

Especifica los nombres, tipos y mutabilidad de los campos estables del actor,
posiblemente precedidos por declaraciones de tipos relevantes de Motoko.

:::tip

Puedes emitir la firma estable del actor principal o de la clase de actor a un
archivo `.most` usando la opción del compilador `moc` `--stable-types`. Nunca
deberías necesitar escribir tu propio archivo `.most`.

:::

Una firma estable `<stab-sig1>` es compatible en estabilidad con la firma
`<stab-sig2>`, si para cada campo estable `<id> : T` en `<stab-sig1>` se cumple
una de las siguientes condiciones:

- `<stab-sig2>` no contiene un campo estable `<id>`.
- `<stab-sig>` tiene un campo estable coincidente `<id> : U` con `T <: U`.

Ten en cuenta que `<stab-sig2>` puede contener campos adicionales o abandonar
campos de `<stab-sig1>`. La mutabilidad puede ser diferente para campos
coincidentes.

`<stab-sig1>` es la firma de una versión anterior, mientras que `<stab-sig2>` es
la firma de una versión más nueva.

La condición de subtipificación en los campos estables asegura que el valor
final de algún campo pueda consumirse como el valor inicial de ese campo en el
código actualizado.

:::tip

Puedes verificar la compatibilidad en estabilidad de dos archivos `.most` que
contienen firmas estables, utilizando la opción del compilador `moc`
`--stable-compatible file1.most file2.most`.

:::

## Seguridad en las actualizaciones

Al actualizar un canister, es importante verificar que la actualización pueda
proceder sin:

- Introducir un cambio incompatible en las declaraciones estables.
- Romper clientes debido a un cambio en la interfaz Candid.

Con [persistencia ortogonal mejorada](orthogonal-persistence/enhanced.md),
Motoko rechaza cambios incompatibles en las declaraciones estables durante un
intento de actualización. Además, `dfx` verifica las dos condiciones antes de
intentar la actualización y advierte a los usuarios en consecuencia.

Una actualización de canister en Motoko es segura siempre que:

- La interfaz Candid del canister evolucione a un subtipo de Candid.
- La firma estable de Motoko del canister evolucione a una compatible en
  estabilidad.

:::danger Con
[persistencia ortogonal clásica](orthogonal-persistence/classical.md), la
actualización aún puede fallar debido a restricciones de recursos. Esto es
problemático, ya que el canister no puede ser actualizado. Por lo tanto, se
recomienda encarecidamente probar la escalabilidad de las actualizaciones. La
persistencia ortogonal mejorada abandonará este problema. :::

:::tip

Puedes verificar la subtipificación válida de Candid entre dos servicios
descritos en archivos `.did` utilizando la herramienta
[`didc`](https://github.com/dfinity/candid) con el argumento
`check file1.did file2.did`.

:::

## Actualización de un actor o canister desplegado

Después de haber desplegado un actor de Motoko con las variables `stable`
apropiadas, puedes usar el comando `dfx deploy` para actualizar una versión ya
desplegada. Para obtener información sobre cómo actualizar un canister
desplegado, consulta
[actualizar un contrato inteligente de canister](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/maintain/upgrade).

`dfx deploy` verifica que la interfaz sea compatible, y si no lo es, muestra
este mensaje y pregunta si deseas continuar:

```
You are making a BREAKING change. Other canisters or frontend clients relying on your canister may stop working.
```

Además, Motoko con persistencia ortogonal mejorada implementa una protección
adicional en el sistema de tiempo de ejecución para garantizar que los datos
estables sean compatibles, evitando cualquier corrupción o mala interpretación
de los datos. Además, `dfx` también advierte sobre la eliminación de variables
estables.

## Migración de datos

A menudo, la representación de los datos cambia con una nueva versión del
programa. Para la persistencia ortogonal, es importante que el lenguaje permita
una migración flexible de datos a la nueva versión.

Motoko admite dos tipos de migraciones de datos: migración implícita y migración
explícita.

### Migración implícita

Esto se admite automáticamente cuando la nueva versión del programa es
compatible en estabilidad con la versión anterior. El sistema de tiempo de
ejecución de Motoko maneja automáticamente la migración durante la
actualización.

Más precisamente, los siguientes cambios pueden migrarse implícitamente:

- Agregar o eliminar campos de actores.
- Cambiar la mutabilidad de un campo de actor.
- Eliminar campos de registros.
- Agregar campos de variantes.
- Cambiar `Nat` a `Int`.
- Contravarianza de parámetros de funciones compartidas y covarianza de tipos de
  retorno.
- Cualquier cambio permitido por la regla de subtipificación de Motoko.

### Migración explícita

Patrones de migración más complejos que requieren transformaciones de datos no
triviales son posibles, pero requieren codificación adicional y cuidado por
parte del usuario.

Una forma de reemplazar algunas variables estables por un nuevo conjunto con
tipos diferentes es usar una secuencia de actualizaciones para transformar el
estado según se desee:

Para este propósito, se sigue un enfoque de tres pasos:

1. Introducir nuevas variables de los tipos deseados, manteniendo las
   declaraciones antiguas.
2. Escribir lógica para copiar el estado de las variables antiguas a las nuevas
   durante la actualización.
3. Eliminar las declaraciones antiguas una vez que todos los datos se hayan
   migrado.

Una solución más limpia y mantenible es declarar una expresión de migración
explícita que se utilice para transformar un subconjunto de variables estables
existentes en un subconjunto de variables estables de reemplazo.

Ambos caminos de migración de datos son compatibles con verificaciones estáticas
y dinámicas que evitan la pérdida o corrupción de datos. Por supuesto, un
usuario aún puede perder datos debido a errores de codificación, por lo que debe
proceder con cuidado.

Para obtener más información, consulta el
[ejemplo de migración explícita](compatibility.md#explicit-migration) y el
material de referencia sobre
[expresiones de migración](../../reference/language-manual#migration-expressions).

## Características heredadas

Los siguientes aspectos se conservan por razones históricas y compatibilidad
hacia atrás:

### Métodos del sistema pre-upgrade y post-upgrade

:::danger El uso de los métodos del sistema pre-upgrade y post-upgrade está
desaconsejado. Es propenso a errores y puede dejar un canister inutilizable. En
particular, si un método `preupgrade` falla (trap) y no se puede evitar que
falle por otros medios, entonces tu canister puede quedar en un estado en el que
ya no se puede actualizar. Según las mejores prácticas, se debe evitar el uso de
estos métodos si es posible. :::

Motoko admite ganchos de actualización definidos por el usuario que se ejecutan
inmediatamente antes y después de una actualización. Estos ganchos de
actualización permiten activar lógica adicional durante la actualización. Estos
ganchos se declaran como funciones `system` con nombres especiales, `preupgrade`
y `postupgrade`. Ambas funciones deben tener el tipo `: () → ()`.

:::danger Si `preupgrade` genera un error (trap), alcanza el límite de
instrucciones o alcanza otro límite de computación de IC, la actualización ya no
puede tener éxito y el canister se queda atascado con la versión existente. :::

:::tip `postupgrade` no es necesario, ya que se puede lograr el mismo efecto
introduciendo expresiones de inicialización en el actor, por ejemplo,
expresiones `let` no estables o declaraciones de expresiones. :::

### Memoria estable y regiones estables

La memoria estable se introdujo en IC para permitir actualizaciones en lenguajes
que no implementan la persistencia ortogonal de la memoria principal. Este es el
caso de la persistencia clásica de Motoko, así como de otros lenguajes además de
Motoko.

La memoria estable y las regiones estables aún pueden usarse en combinación con
la persistencia ortogonal, aunque hay poca necesidad práctica de esto con la
persistencia ortogonal mejorada y la futura gran capacidad de memoria principal
en IC.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
