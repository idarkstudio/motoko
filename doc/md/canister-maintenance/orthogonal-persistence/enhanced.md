---
sidebar_position: 2
---

# Persistencia ortogonal mejorada

La persistencia ortogonal mejorada implementa la visión de una persistencia
ortogonal eficiente y escalable en Motoko que combina:

- **Heap estable**: Persistiendo la memoria principal del programa a través de
  actualizaciones de canisters.
- **Heap de 64 bits**: Extendiendo la memoria principal a 64 bits para una
  persistencia a gran escala.

Como resultado, el uso de almacenamiento secundario (memoria estable explícita,
estructuras de datos estables dedicadas, abstracciones de almacenamiento tipo
DB) ya no será necesario: los desarrolladores de Motoko pueden trabajar
directamente en sus estructuras de programación orientadas a objetos normales
que se persisten y retienen automáticamente a través de cambios de versión del
programa.

### Activación

La persistencia ortogonal mejorada se ofrece actualmente para **pruebas beta** a
través de la bandera del compilador `--enhanced-orthogonal-persistence`.

Para activar la persistencia ortogonal mejorada en `dfx`, se debe especificar el
siguiente argumento de línea de comandos en `dfx.json`:

```
...
    "type" : "motoko"
    ...
    "args" : "--enhanced-orthogonal-persistence"
...
```

:::tip A pesar del uso de la persistencia ortogonal mejorada, se recomienda
encarecidamente probar exhaustivamente las actualizaciones de tu aplicación.
Además, se aconseja tener una posibilidad de respaldo para rescatar datos
incluso cuando las actualizaciones fallen, por ejemplo, mediante llamadas de
consulta de datos con privilegios de controlador. :::

[La persistencia ortogonal clásica](classical.md) con memoria principal de 32
bits y estabilización Candid sigue siendo actualmente el modo predeterminado.
Consulta [modos de persistencia ortogonal](modes.md) para una comparación.

## Diseño

En comparación con la persistencia ortogonal existente en Motoko, este diseño
ofrece:

- **Rendimiento**: Las nuevas versiones del programa se reanudan directamente
  desde la memoria principal existente y tienen acceso a los datos compatibles
  con la memoria.
- **Escalabilidad**: El mecanismo de actualización escala con heaps más grandes
  y, en contraste con la serialización, no alcanza los límites de instrucciones
  de IC.

En comparación con el uso explícito de la memoria estable, este diseño mejora:

- **Simplicidad**: Los desarrolladores no necesitan lidiar con la memoria
  estable explícita.
- **Rendimiento**: No es necesario copiar hacia y desde la memoria estable
  separada.

La persistencia ortogonal mejorada se basa en las siguientes propiedades
principales:

- Extensión de IC para retener la memoria principal en las actualizaciones.
- Soporte de memoria principal de 64 bits en IC.
- Un diseño de memoria a largo plazo que es invariante a las nuevas versiones
  compiladas del programa.
- Una verificación rápida de compatibilidad de memoria que se realiza en cada
  actualización de canister.
- Recolección de basura incremental utilizando un heap particionado.

### Verificación de compatibilidad

Las actualizaciones solo se permiten si la nueva versión del programa es
compatible con la versión anterior, de modo que el sistema de tiempo de
ejecución garantice una estructura de memoria compatible.

Los cambios compatibles para tipos inmutables son en gran medida análogos a la
relación de subtipos permitida en Motoko, con cierta flexibilidad para los
campos de actores, es decir:

- Agregar o eliminar campos de actores.
- Cambiar la mutabilidad de los campos de actores (`let` a `var` y viceversa).
- Eliminar campos de objetos.
- Agregar campos de variantes.
- Cambiar `Nat` a `Int`.
- Soporte de contravarianza de parámetros de funciones compartidas y covarianza
  de tipos de retorno.
- Cualquier otro cambio según la regla de subtipificación de Motoko.

El sistema de tiempo de ejecución verifica la compatibilidad de migración
durante la actualización y, si no se cumple, revierte la actualización. Esta
verificación de compatibilidad sirve como una medida de seguridad adicional
además de la advertencia de `dfx`, que puede ser ignorada por los usuarios.

Cualquier cambio más complejo se puede realizar con instrucciones programáticas,
consulta [migración explícita](../upgrades.md#explicit-migration).

### Ruta de migración

Al migrar desde la estabilización basada en serialización antigua al nuevo heap
persistente, los datos antiguos se deserializan una última vez desde la memoria
estable y luego se colocan en el nuevo diseño de heap persistente. Una vez que
se opera en el heap persistente, el sistema debe evitar intentos de retroceder a
la antigua persistencia basada en serialización.

#### Estabilización basada en copia de grafos

Suponiendo que el diseño de memoria persistente necesite cambiarse en el futuro,
el sistema de tiempo de ejecución admite la serialización y deserialización
hacia y desde la memoria estable en un formato de datos definido utilizando
estabilización basada en copia de grafos. Datos arbitrariamente grandes pueden
serializarse y deserializarse más allá del límite de instrucciones y conjunto de
trabajo de las actualizaciones. La serialización y deserialización de grandes
cantidades de datos se divide en múltiples mensajes, ejecutándose antes y/o
después de la actualización de IC para migrar heaps grandes. Otros mensajes se
bloquearán durante este proceso y solo el propietario del canister o los
controladores del canister tienen permitido iniciar este proceso.

Esto solo será necesario en situaciones raras cuando la implementación de Motoko
cambie su diseño de memoria interno. Los usuarios serán instruidos para iniciar
explícitamente esta migración.

#### Uso

La estabilización basada en copia de grafos se puede realizar en tres pasos:

1. Iniciar la estabilización explícita antes de la actualización:

```
dfx canister call CANISTER_ID __motoko_stabilize_before_upgrade "()"
```

2. Ejecuta la actualización:

```
dfx deploy CANISTER_ID
```

3. Completar la desestabilización explícita después de la actualización:

```
dfx canister call CANISTER_ID __motoko_destabilize_after_upgrade "()"
```

Observaciones:

- Cuando se recibe el error de `dfx` "The request timed out." durante la
  estabilización explícita, la actualización o la desestabilización, simplemente
  se puede repetir la llamada hasta que se complete.
- El paso 3 (desestabilización explícita) puede no ser necesario si la operación
  correspondiente cabe en el mensaje de actualización.

### Memoria estable antigua

La memoria estable antigua sigue siendo igualmente accesible como memoria
secundaria (legacy) con el nuevo soporte. Por lo tanto, las regiones estables se
pueden combinar con la persistencia ortogonal.

## Retención de memoria principal en IC

El IC introduce una nueva opción de actualización `wasm_memory_persistence` para
controlar la retención de la memoria principal Wasm del canister.

- `wasm_memory_persistence = opt keep` retiene la memoria principal Wasm y es
  requerida para la persistencia ortogonal mejorada de Motoko. El IC impide usar
  esta opción para canisters con persistencia clásica.
- `wasm_memory_persistence = null` utiliza la persistencia clásica, reemplazando
  la memoria principal. Sin embargo, se implementa una verificación de seguridad
  para evitar que la memoria principal se elimine accidentalmente para la
  persistencia ortogonal mejorada.
- La otra opción `replace` no se recomienda, ya que elimina la memoria principal
  Wasm, incluso para la persistencia ortogonal mejorada, lo que podría provocar
  la pérdida de datos.
