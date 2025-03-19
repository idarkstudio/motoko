---
sidebar_position: 4
---

# Verificación de compatibilidad en actualizaciones

Al actualizar un canister, es importante verificar que la actualización pueda
proceder sin:

- Introducir un cambio incompatible en las declaraciones estables.
- Romper clientes debido a un cambio en la interfaz Candid.

`dfx` verifica estas propiedades estáticamente antes de intentar la
actualización. Además, con la
[persistencia ortogonal mejorada](orthogonal-persistence/enhanced.md), Motoko
rechaza cambios incompatibles en las declaraciones estables.

## Ejemplo de actualización

El siguiente es un ejemplo simple de cómo declarar un contador con estado:

```motoko no-repl file=../examples/count-v0.mo

```

Importante, en este ejemplo, cuando el contador se actualiza, se pierde su
estado. Esto se debe a que las variables del actor son, por defecto,
`transient`, lo que significa que se reinicializan en una actualización. El
actor anterior es equivalente a usar la declaración `transient`:

```motoko no-repl file=../examples/count-v0transient.mo

```

Para solucionar esto, puedes declarar una variable `stable` que se mantenga en
las actualizaciones:

```motoko no-repl file=../examples/count-v1stable.mo

```

Para hacer que `stable` sea el valor predeterminado para todas las declaraciones
y `transient` opcional, puedes agregar la palabra clave `persistent` antes de la
declaración del actor.

```motoko no-repl file=../examples/count-v1.mo

```

Si la variable `state` no se declarara como `stable`, ya sea explícitamente o
aplicando `persistent` a la palabra clave `actor`, `state` se reiniciaría desde
`0` en la actualización.

## Evolucionando las declaraciones estables

Cambiar el contador de `Nat` a `Int` es un cambio compatible en las
declaraciones estables. El valor del contador se conserva durante la
actualización.

```motoko no-repl file=../examples/count-v2.mo

```

## Firmas de tipos estables

Una firma de tipo estable describe el contenido estable de un actor de Motoko.
Puedes pensar en esto como la interfaz interna del actor que presenta a sus
futuras actualizaciones.

Por ejemplo, los tipos estables de `v1`:

```motoko no-repl file=../examples/count-v1.most

```

Una actualización de los tipos estables de `v1` a `v2` consume un
[`Nat`](../base/Int.md) como un [`Int`](../base/Nat.md), lo cual es válido
porque `Nat <: Int`, es decir, `Nat` es un subtipo de `Int`.

```motoko no-repl file=../examples/count-v2.most

```

## Evolucionando la interfaz Candid

En esta extensión de la interfaz, los clientes antiguos siguen satisfechos,
mientras que los nuevos obtienen características adicionales como la función
`decrement` y la consulta `read` en este ejemplo.

```motoko no-repl file=../examples/count-v3.mo

```

## Evolución de la interfaz dual

Una actualización es segura siempre que tanto la interfaz Candid como las firmas
de tipos estables sigan siendo compatibles:

- Cada variable estable debe ser declarada de nuevo, eliminada o redeclarada
  como un supertipo de su tipo anterior.
- La interfaz Candid evoluciona a un subtipo.

Considera las siguientes cuatro versiones del ejemplo del contador:

Versión `v0` con la interfaz Candid `v0.did` y la interfaz de tipo estable
`v0.most`:

```candid file=../examples/count-v0.did

```

```motoko no-repl file=../examples/count-v0.most

```

Versión `v1` con la interfaz Candid `v1.did` y la interfaz de tipo estable
`v1.most`,

```candid file=../examples/count-v1.did

```

```motoko no-repl file=../examples/count-v1.most

```

Versión `v2` con la interfaz Candid `v2.did` y la interfaz de tipo estable
`v2.most`,

```candid file=../examples/count-v2.did

```

```motoko no-repl file=../examples/count-v2.most

```

Versión `v3` con la interfaz Candid `v3.did` y la interfaz de tipo estable
`v3.most`:

```candid file=../examples/count-v3.did

```

```motoko no-repl file=../examples/count-v3.most

```

## Actualización incompatible

Echemos un vistazo a otro ejemplo donde el tipo del contador se cambia
nuevamente, esta vez de [`Int`](../base/Int.md) a [`Float`](../base/Float.md):

```motoko no-repl file=../examples/count-v4.mo

```

Esta versión no es compatible ni con las declaraciones de tipos estables, ni con
la interfaz Candid.

- Dado que `Int </: Float`, es decir, `Int` no es un subtipo de `Float`, el tipo
  anterior de `state`, `Int`, no es compatible con el nuevo tipo, `Float`. Esto
  significa que el valor antiguo de `state`, un entero, no puede usarse para
  inicializar el nuevo campo `state`, que ahora requiere un flotante.
- El cambio en el tipo de retorno de `read` tampoco es seguro. Si el cambio
  fuera aceptado, los clientes existentes del método `read`, que aún esperan
  recibir enteros, de repente comenzarían a recibir flotantes incompatibles.

Con la [persistencia ortogonal mejorada](orthogonal-persistence/enhanced.md),
Motoko rechaza activamente cualquier actualización que requiera cambios de
estado incompatibles en cuanto a tipos.

Esto es para garantizar que el estado estable siempre se mantenga seguro.

```
Error from Canister ...: Canister called `ic0.trap` with message: RTS error: Memory-incompatible program upgrade.
```

Además de la verificación en tiempo de ejecución de Motoko, `dfx` muestra un
mensaje de advertencia para estos cambios incompatibles, incluido el cambio
incompatible en Candid.

Motoko tolera los cambios en la interfaz Candid, ya que es más probable que
estos sean cambios intencionales y disruptivos.

:::danger Las versiones de Motoko que utilizan
[persistencia ortogonal clásica](orthogonal-persistence/classical.md) eliminarán
el estado y reinicializarán el contador con `0.0`, si se ignora la advertencia
de `dfx`.

Por esta razón, los usuarios siempre deben prestar atención a las advertencias
de compatibilidad emitidas por `dfx`. :::

## Migración explícita

### Migración explícita utilizando varias actualizaciones

Siempre existe una ruta de migración para cambiar la estructura del estado
estable, incluso si un cambio de tipo directo no es compatible.

Para este propósito, una migración instruida por el usuario se puede realizar en
tres pasos:

1. Introducir nuevas variables de los tipos deseados, manteniendo las
   declaraciones antiguas.
2. Escribir lógica para copiar el estado de las variables antiguas a las nuevas
   durante la actualización.

   Si bien el intento anterior de cambiar el estado de [`Int`](../base/Int.md) a
   [`Nat`](../base/Float.md) no era válido, ahora puedes realizar el cambio
   deseado de la siguiente manera:

   ```motoko no-repl file=../examples/count-v5.mo

   ```

Para mantener también la interfaz Candid, se ha agregado `readFloat`, mientras
que el antiguo `read` se retira manteniendo su declaración y generando una
trampa internamente.

3. Elimina las declaraciones antiguas una vez que todos los datos hayan sido
   migrados:

   ```motoko no-repl file=../examples/count-v6.mo

   ```

Alternativamente, el tipo de `state` puede cambiarse a `Any`, lo que implica
también que esta variable ya no se utiliza.

### Migración explícita utilizando una función de migración

El enfoque anterior de usar varias actualizaciones para migrar datos es tedioso
y poco claro, mezclando código de producción con código de migración.

Para facilitar la migración de datos, Motoko ahora admite la migración explícita
utilizando una función de migración de datos separada. El código para la función
de migración es autónomo y puede colocarse en su propio archivo.

La función de migración toma un registro de campos estables como entrada y
produce un registro de campos estables como salida.

Los campos de entrada extienden o anulan los tipos de cualquier campo estable en
la firma estable del actor. Los campos de salida deben declararse en la firma
estable del actor y tener tipos que puedan ser consumidos por la declaración
correspondiente en la firma estable.

- Todos los valores para los campos de entrada deben estar presentes y ser de
  tipo compatible en el actor antiguo; de lo contrario, la actualización falla
  (trap) y se revierte.
- Los campos generados por la función de migración determinan los valores de las
  variables estables correspondientes en el nuevo actor.
- Todas las demás variables estables del actor, es decir, aquellas que no son
  consumidas ni producidas por la función de migración, se inicializan de la
  manera habitual, ya sea por transferencia desde el actor actualizado, si están
  declaradas en ese actor, o, si están recién declaradas, ejecutando la
  expresión de inicialización en la declaración del campo.
- La función de migración solo se ejecuta durante una actualización y se ignora
  en una instalación nueva del actor en un canister vacío.

La función de migración, cuando es necesaria, se declara utilizando una
expresión entre paréntesis inmediatamente antes de la declaración del actor o
clase de actor, por ejemplo:

```motoko no-repl file=../examples/count-v7.mo

```

La sintaxis emplea las nuevas expresiones entre paréntesis de Motoko para
modificar el comportamiento de la actualización. Otras expresiones entre
paréntesis de forma similar, pero con diferentes nombres de campos y tipos, se
utilizan para modificar otros aspectos de la ejecución de Motoko.

Puedes leer esto como una directiva para aplicar la función de `migration`
indicada justo antes de la actualización.

El uso de una función de migración ofrece otra ventaja: te permite reutilizar el
nombre de un campo existente, incluso cuando su tipo ha cambiado:

```motoko no-repl file=../examples/count-v8.mo

```

Aquí, hemos colocado el código de migración en una biblioteca separada:

```motoko no-repl file=../examples/Migration.mo

```

La función de migración puede ser selectiva y solo consumir o producir un
subconjunto de las variables estables antiguas y nuevas. Otras variables
estables se pueden declarar como de costumbre.

Por ejemplo, aquí, con la misma función de migración, también declaramos una
nueva variable estable, `lastModified`, que registra la hora de la última
actualización, sin tener que mencionar ese campo en la función de migración.

```motoko no-repl file=../examples/count-v9.mo

```

La firma estable de un actor con una función de migración ahora consiste en dos
firmas estables ordinarias, la pre-firma (antes de la actualización) y la
post-firma (después de la actualización).

Por ejemplo, esta es la firma combinada del ejemplo anterior:

```motoko no-repl file=../examples/count-v9.most

```

La segunda firma está determinada únicamente por las declaraciones de variables
estables del actor. La primera firma contiene las declaraciones de campos de
entrada de la función de migración, junto con cualquier variable estable
declarada con un nombre distinto en el actor.

Para garantizar la compatibilidad, al realizar una actualización, la firma
(posterior) del código antiguo debe ser compatible con la firma (anterior) del
nuevo código.

La función de migración se puede eliminar o ajustar en la próxima actualización.

## Herramientas de actualización

`dfx` incorpora una verificación de actualización. Para este propósito, utiliza
el compilador de Motoko (`moc`) que admite:

- `moc --stable-types …​`: Emite tipos estables a un archivo `.most`.

- `moc --stable-compatible <pre> <post>`: Verifica la compatibilidad de
  actualización entre dos archivos `.most`.

Motoko incrusta archivos `.did` y `.most` como secciones personalizadas de Wasm
para su uso por `dfx` u otras herramientas.

Para actualizar, por ejemplo, de `cur.wasm` a `nxt.wasm`, `dfx` verifica que
tanto la interfaz Candid como las variables estables sean compatibles:

```
didc check nxt.did cur.did  // nxt <: cur
moc --stable-compatible cur.most nxt.most  // cur <<: nxt
```

Usando las versiones anteriores, la actualización de `v3` a `v4` falla en esta
verificación:

```
> moc --stable-compatible v3.most v4.most
(unknown location): Compatibility error [M0170], stable variable state of previous type
  var Int
cannot be consumed at new type
  var Float
```

Con la [persistencia ortogonal mejorada](orthogonal-persistence/enhanced.md),
los errores de compatibilidad de las variables estables siempre se detectan en
el sistema de tiempo de ejecución y, si fallan, la actualización se revierte de
manera segura.

:::danger Sin embargo, con la
[persistencia ortogonal clásica](orthogonal-persistence/classical.md), un
intento de actualización de `v2.wasm` a `v3.wasm` es impredecible y puede
provocar una pérdida parcial o total de datos si se ignora la advertencia de
`dfx`. :::

## Agregar campos a registros

Un ejemplo común y real de una actualización incompatible se puede encontrar
[en el foro](https://forum.dfinity.org/t/questions-about-data-structures-and-migrations/822/12?u=claudio/).

En ese ejemplo, un usuario intentaba agregar un campo al registro de carga útil
de un arreglo, actualizando desde la interfaz de tipo estable:

```motoko no-repl file=../examples/Card-v0.mo

```

para _incompatible_ interfaz de tipo estable:

```motoko no-repl file=../examples/Card-v1.mo

```

### Problema

Al intentar esta actualización, `dfx` emite la siguiente advertencia:

```
Stable interface compatibility check issued an ERROR for canister ...
Upgrade will either FAIL or LOSE some stable variable data.

(unknown location): Compatibility error [M0170], stable variable map of previous type
  var [(Nat32, Card)]
cannot be consumed at new type
  var [(Nat32, Card__1)]

Do you want to proceed? yes/No
```

Se recomienda no continuar, ya que perderás el estado en versiones anteriores de
Motoko que utilizan
[persistencia ortogonal clásica](orthogonal-persistence/classical.md). La
actualización con
[persistencia ortogonal mejorada](orthogonal-persistence/enhanced.md) fallará
(trap) y se revertirá, manteniendo el estado anterior.

Agregar un nuevo campo de registro al tipo de una variable estable existente no
está soportado. La razón es simple: La actualización necesitaría proporcionar
valores para el nuevo campo de la nada. En este ejemplo, la actualización
necesitaría inventar algún valor para el campo `description` de cada `card`
existente en `map`. Además, permitir agregar campos opcionales también es un
problema, ya que un registro puede ser compartido desde varias variables con
diferentes tipos estáticos, algunas de las cuales ya declaran el campo agregado
o agregan un campo opcional con el mismo nombre pero con un tipo potencialmente
diferente (y/o una semántica diferente).

Para resolver este problema, se necesita alguna forma de
[migración explícita de datos](#explicit-migration).

Presentamos dos soluciones, la primera utilizando una secuencia de
actualizaciones simples, y una segunda solución recomendada, que utiliza una
sola actualización con una función de migración.

### Solución 1 utilizando dos actualizaciones simples

1. Debes mantener la variable antigua `map` con el mismo tipo estructural. Sin
   embargo, puedes cambiar el nombre del alias de tipo (`Card` a `OldCard`).
2. Puedes introducir una nueva variable `newMap` y copiar el estado antiguo al
   nuevo, inicializando el nuevo campo según sea necesario.
3. Luego, actualiza a esta nueva versión.

```motoko no-repl file=../examples/Card-v1a.mo

```

4. **Después** de haber actualizado con éxito a esta nueva versión, podemos
   actualizar una vez más a una versión que elimine el antiguo `map`.

```motoko no-repl file=../examples/Card-v1b.mo

```

`dfx` emitirá una advertencia de que `map` será eliminado.

Asegúrate de haber migrado previamente el estado antiguo a `newMap` antes de
aplicar esta versión final reducida.

```
Stable interface compatibility check issued a WARNING for canister ...
(unknown location): warning [M0169], stable variable map of previous type
  var [(Nat32, OldCard)]
 will be discarded. This may cause data loss. Are you sure?
```

### Solución 2 utilizando una función de migración y una sola actualización

En lugar de la solución anterior de dos pasos, podemos actualizar en un solo
paso utilizando una función de migración.

1. Define un módulo de migración y una función que transforme la variable
   estable antigua, en su tipo actual, en la nueva variable estable en su nuevo
   tipo.

```motoko no-repl file=../examples/CardMigration.mo

```

2. Especifica la función de migración como la expresión de migración de tu
   declaración de actor:

```motoko no-repl file=../examples/Card-v1c.mo

```

**Después** de haber actualizado con éxito a esta nueva versión, también podemos
actualizar una vez más a una versión que elimine el código de migración.

```motoko no-repl file=../examples/Card-v1d.mo

```

Sin embargo, eliminar o ajustar el código de migración también se puede posponer
hasta la próxima actualización adecuada que solucione errores o amplíe la
funcionalidad.

Ten en cuenta que con esta solución, no es necesario cambiar el nombre de `map`
a `newMap` y el código de migración está aislado del código principal.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
