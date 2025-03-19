# ExperimentalStableMemory

Acceso a nivel de byte a la _memoria estable_ (virtual).

**ADVERTENCIA**: Como su nombre indica, esta biblioteca es **experimental**,
está sujeta a cambios y puede ser reemplazada por alternativas más seguras en
versiones posteriores de Motoko. Úsela bajo su propio riesgo y discreción.

**DEPRECIACIÓN**: El uso de la biblioteca `ExperimentalStableMemory` puede
quedar obsoleto en el futuro. En adelante, los usuarios deben considerar el uso
de la biblioteca `Region.mo` para asignar regiones de memoria _aisladas_ en su
lugar. El uso de regiones dedicadas para diferentes aplicaciones de usuario
garantiza que escribir en una región no afectará el estado de otra región no
relacionada.

Esta es una abstracción ligera sobre la _memoria estable_ de IC y admite la
persistencia de datos binarios sin procesar en las actualizaciones de Motoko. El
uso de este módulo es totalmente compatible con el uso de variables estables de
Motoko, cuyo mecanismo de persistencia también utiliza (realmente) la memoria
estable de IC internamente, pero no interfiere con esta API.

La memoria se asigna, utilizando `grow(pages)`, de forma secuencial y bajo
demanda, en unidades de páginas de 64KiB, comenzando con 0 páginas asignadas.
Las nuevas páginas se inicializan a cero. El crecimiento está limitado por un
límite suave en el recuento de páginas controlado por la bandera de tiempo de
compilación `--max-stable-pages <n>` (el valor predeterminado es 65536, o 4GiB).

Cada operación `load` carga desde la dirección de byte `offset` en formato
little-endian utilizando el ancho de bits natural del tipo en cuestión. La
operación falla si se intenta leer más allá del tamaño actual de la memoria
estable.

Cada operación `store` almacena en la dirección de byte `offset` en formato
little-endian utilizando el ancho de bits natural del tipo en cuestión. La
operación falla si se intenta escribir más allá del tamaño actual de la memoria
estable.

Los valores de texto se pueden manejar utilizando `Text.decodeUtf8` y
`Text.encodeUtf8`, en conjunto con `loadBlob` y `storeBlob`.

La asignación de páginas actual y el contenido de las páginas se conservan en
las actualizaciones.

NB: El tamaño real de la memoria estable de IC (`ic0.stable_size`) puede superar
el tamaño de página informado por la función de Motoko `size()`. Esto (y el
límite de crecimiento) se deben a las variables estables de Motoko. Las
aplicaciones que planean utilizar variables estables de Motoko de manera
limitada o no en absoluto pueden aumentar `--max-stable-pages` según sea
necesario, acercándose al máximo de IC (inicialmente 8GiB, luego 32Gib,
actualmente 64Gib). Todas las aplicaciones deben reservar al menos una página
para los datos de variables estables, incluso cuando no se utilizan variables
estables.

Uso:

```motoko no-repl
import StableMemory "mo:base/ExperimentalStableMemory";
```

## Valor `size`

```motoko no-repl
let size : () -> (pages : Nat64)
```

Tamaño actual de la memoria estable, en páginas. Cada página es de 64KiB (65536
bytes). Inicialmente `0`. Se conserva en las actualizaciones, junto con el
contenido de la memoria estable asignada.

Ejemplo:

```motoko no-repl
let beforeSize = StableMemory.size();
ignore StableMemory.grow(10);
let afterSize = StableMemory.size();
afterSize - beforeSize // => 10
```

## Valor `grow`

```motoko no-repl
let grow : (newPages : Nat64) -> (oldPages : Nat64)
```

Aumenta el `size` actual de la memoria estable en la cantidad de páginas
especificada. Cada página es de 64KiB (65536 bytes). Devuelve el `size` anterior
cuando puede crecer. Devuelve `0xFFFF_FFFF_FFFF_FFFF` si las páginas restantes
son insuficientes. Cada nueva página se inicializa a cero, con el byte 0x00 en
cada desplazamiento. La función `grow` está limitada por un límite suave en el
`size` controlado por la bandera de tiempo de compilación
`--max-stable-pages <n>` (el valor predeterminado es 65536, o 4GiB).

Ejemplo:

```motoko no-repl
import Error "mo:base/Error";

let beforeSize = StableMemory.grow(10);
if (beforeSize == 0xFFFF_FFFF_FFFF_FFFF) {
  throw Error.reject("Sin memoria");
};
let afterSize = StableMemory.size();
afterSize - beforeSize // => 10
```

## Valor `stableVarQuery`

```motoko no-repl
let stableVarQuery : () -> (shared query () -> async { size : Nat64 })
```

Devuelve una consulta que, cuando se llama, devuelve el número de bytes de la
memoria estable (real) de IC que ocuparía persistir sus variables estables
actuales antes de una actualización. Esta función se puede utilizar para
monitorear o limitar el uso de memoria estable real. La consulta calcula la
estimación ejecutando la primera mitad de una actualización, incluido cualquier
método del sistema `preupgrade`. Al igual que cualquier otra consulta, sus
cambios de estado se descartan, por lo que no se produce ninguna actualización
real (u otro cambio de estado). La consulta solo puede ser llamada por el actor
que la contiene y fallará para otros llamadores.

Ejemplo:

```motoko no-repl
actor {
  stable var state = "";
  public func example() : async Text {
    let memoryUsage = StableMemory.stableVarQuery();
    let beforeSize = (await memoryUsage()).size;
    state #= "abcdefghijklmnopqrstuvwxyz";
    let afterSize = (await memoryUsage()).size;
    debug_show (afterSize - beforeSize)
  };
};
```

## Valor `loadNat32`

```motoko no-repl
let loadNat32 : (offset : Nat64) -> Nat32
```

Carga un valor `Nat32` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeNat32(offset, value);
StableMemory.loadNat32(offset) // => 123
```

## Valor `storeNat32`

```motoko no-repl
let storeNat32 : (offset : Nat64, value : Nat32) -> ()
```

Almacena un valor `Nat32` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeNat32(offset, value);
StableMemory.loadNat32(offset) // => 123
```

## Valor `loadNat8`

```motoko no-repl
let loadNat8 : (offset : Nat64) -> Nat8
```

Carga un valor `Nat8` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeNat8(offset, value);
StableMemory.loadNat8(offset) // => 123
```

## Valor `storeNat8`

```motoko no-repl
let storeNat8 : (offset : Nat64, value : Nat8) -> ()
```

Almacena un valor `Nat8` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeNat8(offset, value);
StableMemory.loadNat8(offset) // => 123
```

## Valor `loadNat16`

```motoko no-repl
let loadNat16 : (offset : Nat64) -> Nat16
```

Carga un valor `Nat16` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeNat16(offset, value);
StableMemory.loadNat16(offset) // => 123
```

## Valor `storeNat16`

```motoko no-repl
let storeNat16 : (offset : Nat64, value : Nat16) -> ()
```

Almacena un valor `Nat16` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeNat16(offset, value);
StableMemory.loadNat16(offset) // => 123
```

## Valor `loadNat64`

```motoko no-repl
let loadNat64 : (offset : Nat64) -> Nat64
```

Carga un valor `Nat64` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeNat64(offset, value);
StableMemory.loadNat64(offset) // => 123
```

## Valor `storeNat64`

```motoko no-repl
let storeNat64 : (offset : Nat64, value : Nat64) -> ()
```

Almacena un valor `Nat64` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeNat64(offset, value);
StableMemory.loadNat64(offset) // => 123
```

## Valor `loadInt32`

```motoko no-repl
let loadInt32 : (offset : Nat64) -> Int32
```

Carga un valor `Int32` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeInt32(offset, value);
StableMemory.loadInt32(offset) // => 123
```

## Valor `storeInt32`

```motoko no-repl
let storeInt32 : (offset : Nat64, value : Int32) -> ()
```

Almacena un valor `Int32` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeInt32(offset, value);
StableMemory.loadInt32(offset) // => 123
```

## Valor `loadInt8`

```motoko no-repl
let loadInt8 : (offset : Nat64) -> Int8
```

Carga un valor `Int8` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeInt8(offset, value);
StableMemory.loadInt8(offset) // => 123
```

## Valor `storeInt8`

```motoko no-repl
let storeInt8 : (offset : Nat64, value : Int8) -> ()
```

Almacena un valor `Int8` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeInt8(offset, value);
StableMemory.loadInt8(offset) // => 123
```

## Valor `loadInt16`

```motoko no-repl
let loadInt16 : (offset : Nat64) -> Int16
```

Carga un valor `Int16` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeInt16(offset, value);
StableMemory.loadInt16(offset) // => 123
```

## Valor `storeInt16`

```motoko no-repl
let storeInt16 : (offset : Nat64, value : Int16) -> ()
```

Almacena un valor `Int16` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeInt16(offset, value);
StableMemory.loadInt16(offset) // => 123
```

## Valor `loadInt64`

```motoko no-repl
let loadInt64 : (offset : Nat64) -> Int64
```

Carga un valor `Int64` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeInt64(offset, value);
StableMemory.loadInt64(offset) // => 123
```

## Valor `storeInt64`

```motoko no-repl
let storeInt64 : (offset : Nat64, value : Int64) -> ()
```

Almacena un valor `Int64` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 123;
StableMemory.storeInt64(offset, value);
StableMemory.loadInt64(offset) // => 123
```

## Valor `loadFloat`

```motoko no-repl
let loadFloat : (offset : Nat64) -> Float
```

Carga un valor `Float` desde la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 1.25;
StableMemory.storeFloat(offset, value);
StableMemory.loadFloat(offset) // => 1.25
```

## Valor `storeFloat`

```motoko no-repl
let storeFloat : (offset : Nat64, value : Float) -> ()
```

Almacena un valor `Float` en la memoria estable en el `offset` especificado.
Falla si se produce un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
let offset = 0;
let value = 1.25;
StableMemory.storeFloat(offset, value);
StableMemory.loadFloat(offset) // => 1.25
```

## Valor `loadBlob`

```motoko no-repl
let loadBlob : (offset : Nat64, size : Nat) -> Blob
```

Carga `size` bytes comenzando desde `offset` como un `Blob`. Falla si se produce
un acceso fuera de los límites.

Ejemplo:

```motoko no-repl
import Blob "mo:base/Blob";

let offset = 0;
let value = Blob.fromArray([1, 2, 3]);
let size = value.size();
StableMemory.storeBlob(offset, value);
Blob.toArray(StableMemory.loadBlob(offset, size)) // => [1, 2, 3]
```

## Valor `storeBlob`

```motoko no-repl
let storeBlob : (offset : Nat64, value : Blob) -> ()
```

Escribe los bytes de `blob` a partir de `offset`. Falla si se produce un acceso
fuera de los límites.

Ejemplo:

```motoko no-repl
import Blob "mo:base/Blob";

let offset = 0;
let value = Blob.fromArray([1, 2, 3]);
let size = value.size();
StableMemory.storeBlob(offset, value);
Blob.toArray(StableMemory.loadBlob(offset, size)) // => [1, 2, 3]
```
