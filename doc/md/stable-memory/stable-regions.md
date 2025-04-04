---
sidebar_position: 1
---

# Regiones estables (Stable regions)

La biblioteca `Region` proporciona acceso de bajo nivel a la función de memoria
estable de ICP.

Las regiones estables se introdujeron originalmente con la
[persistencia ortogonal clásica](../canister-maintenance/orthogonal-persistence/classical.md)
para permitir que datos a mayor escala se retuvieran a través de
actualizaciones. Para este propósito, los programadores podían almacenar
explícitamente datos persistentes en la memoria estable, con regiones que
ayudaban a aislar diferentes instancias que usaban la memoria estable.

Esto ha sido reemplazado por la
[persistencia ortogonal mejorada](../canister-maintenance/orthogonal-persistence/enhanced.md).
Sin embargo, las regiones aún se ofrecen por compatibilidad hacia atrás y para
casos de uso específicos donde los desarrolladores prefieren gestionar los datos
explícitamente en una memoria lineal persistente.

## La biblioteca `Region`

La biblioteca [`Region`](../base/Region.md) en el paquete `base` permite al
programador asignar incrementalmente páginas de memoria estable de 64 bits y
usar esas páginas para leer y escribir datos de manera incremental en un formato
binario definido por el usuario.

Se pueden asignar varias páginas a la vez, y cada página contiene 64 KiB. La
asignación puede fallar debido a los límites de recursos impuestos por ICP. Las
páginas se inicializan con ceros.

Aunque el usuario asigna a nivel de páginas de 64 KiB, la implementación
asignará a un nivel más grueso de un bloque, actualmente 128 páginas físicas de
memoria estable.

El sistema de tiempo de ejecución de Motoko garantiza que no haya interferencia
entre la abstracción presentada por la biblioteca `Region` y las variables
estables de un actor, aunque ambas abstracciones finalmente usan las mismas
instalidades subyacentes de memoria estable disponibles para todos los canisters
de ICP. Este soporte del sistema de tiempo de ejecución significa que es seguro
para un programa de Motoko explotar tanto las variables estables como `Region`,
dentro de la misma aplicación.

Además, las `Region`s distintas usan páginas distintas de memoria estable,
asegurando que dos `Region`s distintas no puedan interferir con las
representaciones de datos de la otra durante la operación normal o durante una
actualización.

## Uso de `Regions`

La interfaz de la biblioteca `Region` consta de funciones para consultar y
aumentar el conjunto actual de páginas de memoria estable asignadas, además de
pares coincidentes de operaciones `load` y `store` para la mayoría de los tipos
escalares de tamaño fijo de Motoko.

También están disponibles operaciones más generales como `loadBlob` y
`storeBlob` para leer y escribir blobs binarios y otros tipos que pueden
codificarse como [`Blob`](../base/Blob.md)s de tamaños arbitrarios, utilizando
codificadores y decodificadores proporcionados por Motoko o definidos por el
usuario.

```motoko no-repl
module {

  // A stateful handle to an isolated region of IC stable memory.
  //  `Region` is a stable type and regions can be stored in stable variables.
  type Region = Prim.Types.Region;

  // Allocate a new, isolated `Region` of size 0.
  new : () -> Region;

  // Current size of the region `r` in pages.
  // Each page is 64KiB (65536 bytes).
  // Initially `0`.
  size : (r : Region) -> (pages : Nat64);

  // Grow current `size` of region `r` by `pagecount` pages.
  // Each page is 64KiB (65536 bytes).
  // Returns previous `size` when able to grow.
  // Returns `0xFFFF_FFFF_FFFF_FFFF` if remaining pages of physical stable memory insufficient.
  // Please note that there is no way to shrink the size of a region.
  grow : (r : Region, new_pages : Nat64) -> (oldpages : Nat64);

  // read ("load") a byte from a region, by offset.
  loadNat8 : (r : Region, offset : Nat64) -> Nat8;

  // write ("store") a byte into a region, by offset.
  storeNat8 : (r : Region, offset : Nat64, value: Nat8) -> ();

  // ... and similar for Nat16, Nat32, Nat64,
  // Int8, Int16, Int32 and Int64 ...

  loadFloat : (r : Region, offset : Nat64) -> Float;
  storeFloat : (r : Region, offset : Nat64, value : Float) -> ();

  // Load `size` bytes starting from `offset` in region `r` as a [`Blob`](../base/Blob.md).
  // Traps on out-of-bounds access.
  loadBlob : (r : Region, offset : Nat64, size : Nat) -> Blob;

  // Write all bytes of [`Blob`](../base/Blob.md) to region `r` beginning at `offset`.
  // Traps on out-of-bounds access.
  storeBlob : (r : Region, offset : Nat64, value : Blob) -> ()

}
```

:::danger Una región estable expone una memoria lineal de bajo nivel y es tarea
del programador manipular e interpretar correctamente estos datos. Esto puede
ser propenso a errores al administrar datos en una región estable. Sin embargo,
la seguridad de los objetos de heap de valores nativos de Motoko siempre está
garantizada, independientemente del contenido de la región estable. :::

:::note El costo de acceder a las regiones estables es significativamente mayor
que el uso de la memoria nativa de Motoko, es decir, los valores y objetos
regulares de Motoko. :::

## Ejemplo

Para demostrar la biblioteca `Region`, a continuación se muestra una
implementación simple de un actor de registro que registra mensajes de texto en
un registro escalable y persistente.

El ejemplo ilustra el uso simultáneo de variables estables y memoria estable.
Utiliza una única variable estable, `state`, para realizar un seguimiento de las
dos regiones y su tamaño en bytes, pero almacena el contenido del registro
directamente en la memoria estable.

```motoko no-repl file=../examples/StableMultiLog.mo

```

La función compartida `add(blob)` asigna suficiente memoria estable para
almacenar el blob dado y escribe el contenido del blob, su tamaño y su posición
en las regiones pre-asignadas. Una región está dedicada a almacenar los blobs de
tamaños variables, y la otra está dedicada a almacenar sus metadatos de tamaño
fijo.

La consulta compartida `get(index)` lee en cualquier parte del registro sin
recorrer memoria no relacionada.

`StableLog` asigna y mantiene sus datos de registro potencialmente grandes
directamente en memoria estable y utiliza una cantidad pequeña y fija de
almacenamiento para las variables estables reales. Actualizar `StableLog` a una
nueva implementación no debería consumir muchos ciclos, independientemente del
tamaño actual del registro.

## Paquetes de Mops para regiones estables

- [`memory-region`](https://mops.one/memory-region): Una biblioteca para la
  abstracción sobre el tipo `Region` que admite la reutilización de memoria
  desasignada.

- [`stable-enum`](https://mops.one/stable-enum): Enumeraciones implementadas en
  regiones estables.

- [`stable-buffer`](https://mops.one/stable-buffer): Búferes implementados en
  regiones estables.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
