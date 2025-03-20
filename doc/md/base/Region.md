# Region

Acceso a nivel de byte a regiones de memoria aisladas y estables (virtuales).

Esta es una abstracción moderadamente liviana sobre la memoria estable de IC y
admite la persistencia de regiones de datos binarios en las actualizaciones de
Motoko. El uso de este módulo es totalmente compatible con el uso de variables
estables de Motoko, cuyo mecanismo de persistencia también utiliza memoria
estable de IC (real) internamente, pero no interfiere con esta API. También es
totalmente compatible con los usos existentes de la biblioteca
`ExperimentalStableMemory`, que tiene una interfaz similar, pero solo admite una
region de memoria, sin aislamiento entre diferentes aplicaciones.

El tipo `Region` es estable y se puede utilizar en estructuras de datos
estables.

Se asigna una nueva `Region` vacía utilizando la función `new()`.

Las regiones son objetos con estado y se pueden distinguir por el identificador
numérico devuelto por la función `id(region)`. Cada region posee una secuencia
inicialmente vacía pero ampliable de páginas virtuales de memoria estable de IC.
El tamaño actual, en páginas, de una region se devuelve mediante la función
`size(region)`. El tamaño de una region determina el rango, [ 0, ...,
tamaño(region)\*2^16 ), de desplazamientos de bytes válidos en la region; estos
desplazamientos se utilizan como origen y destino de las operaciones de
`load`/`store` en la region.

La memoria se asigna a una region utilizando la función `grow(region, páginas)`,
de forma secuencial y bajo demanda, en unidades de páginas lógicas de 64KiB,
comenzando con 0 páginas asignadas. Una llamada a `grow` puede tener éxito,
devolviendo el tamaño anterior de la region, o fallar, devolviendo un valor
centinela. Las nuevas páginas se inicializan a cero.

El tamaño de una region solo puede crecer y nunca disminuir. Además, las páginas
de memoria estable asignadas a una region no se recuperarán mediante la
recolección de basura, incluso si el objeto de la region en sí se vuelve
inalcanzable.

El crecimiento está limitado por un límite suave en el recuento de páginas
físicas controlado por la bandera de tiempo de compilación
`--max-stable-pages <n>` (el valor predeterminado es 65536, o 4GiB).

Cada operación de `load` carga desde la dirección de byte relativa `offset` en
la region en formato little-endian utilizando el ancho de bits natural del tipo
en cuestión. La operación se interrumpe si se intenta leer más allá del tamaño
actual de la region.

Cada operación de `store` almacena en la dirección de byte relativa `offset` en
la region en formato little-endian utilizando el ancho de bits natural del tipo
en cuestión. La operación se interrumpe si se intenta escribir más allá del
tamaño actual de la region.

Los valores de texto se pueden manejar utilizando `Text.decodeUtf8` y
`Text.encodeUtf8`, en conjunto con `loadBlob` y `storeBlob`.

La asignación actual de la region y el contenido de la region se conservan en
las actualizaciones.

NB: El tamaño real de la memoria estable de IC (`ic0.stable_size`) puede superar
el tamaño total de página informado al sumar todos los tamaños de las regiones.
Esto (y el límite de crecimiento) se deben a las variables estables de Motoko y
al registro de regiones. Las aplicaciones que planeen utilizar variables
estables de Motoko con moderación o no en absoluto pueden aumentar
`--max-stable-pages` según sea necesario, acercándose al máximo de IC
(inicialmente 8GiB, luego 32GiB, actualmente 64GiB). Todas las aplicaciones
deben reservar al menos una página para los datos de variables estables, incluso
cuando no se utilizan variables estables.

Uso:

```motoko no-repl
import Region "mo:base/Region";
```

## Tipo `Region`

```motoko no-repl
type Region = Prim.Types.Region
```

Un identificador con estado para una region aislada de memoria estable de IC.
`Region` es un tipo estable y las regiones se pueden almacenar en variables
estables.

## Valor `new`

```motoko no-repl
let new : () -> Region
```

Asigna una nueva Region aislada de tamaño 0.

Ejemplo:

```motoko no-repl
let region = Region.new();
assert Region.size(region) == 0;
```

## Valor `id`

```motoko no-repl
let id : Region -> Nat
```

Devuelve un Nat que identifica la region dada. Puede usarse para la igualdad, la
comparación y el hash. NB: Las regiones devueltas por `new()` se numeran a
partir de 16 (las regiones 0..15 están actualmente reservadas para uso interno).
Asigna una nueva Region aislada de tamaño 0.

Ejemplo:

```motoko no-repl
let region = Region.new();
assert Region.id(region) == 16;
```

## Valor `size`

```motoko no-repl
let size : (region : Region) -> (páginas : Nat64)
```

Tamaño actual de `region`, en páginas. Cada página es de 64KiB (65536 bytes).
Inicialmente `0`. Se conserva en las actualizaciones, junto con el contenido de
la memoria estable asignada.

Ejemplo:

```motoko no-repl
let region = Region.new();
let beforeSize = Region.size(region);
ignore Region.grow(region, 10);
let afterSize = Region.size(region);
afterSize - beforeSize // => 10
```

## Valor `grow`

```motoko no-repl
let grow : (region : Region, newPages : Nat64) -> (oldPages : Nat64)
```

Aumenta el `size` actual de `region` en la cantidad de páginas dada. Cada página
es de 64KiB (65536 bytes). Devuelve el `size` anterior cuando puede crecer.
Devuelve `0xFFFF_FFFF_FFFF_FFFF` si las páginas restantes son insuficientes.
Cada nueva página se inicializa a cero, conteniendo el byte 0x00 en cada offset.
La función `grow` está limitada por un límite suave en el `size` controlado por
la bandera de tiempo de compilación `--max-stable-pages <n>` (el valor
predeterminado es 65536, o 4 GiB).

Ejemplo:

```motoko no-repl
import Error "mo:base/Error";

let region = Region.new();
let beforeSize = Region.grow(region, 10);
if (beforeSize == 0xFFFF_FFFF_FFFF_FFFF) {
  throw Error.reject("Out of memory");
};
let afterSize = Region.size(region);
afterSize - beforeSize // => 10
```

## Valor `loadNat8`

```motoko no-repl
let loadNat8 : (region : Region, offset : Nat64) -> Nat8
```

Dentro de `region`, carga un valor `Nat8` desde `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeNat8(region, offset, value);
Region.loadNat8(region, offset) // => 123
```

## Valor `storeNat8`

```motoko no-repl
let storeNat8 : (region : Region, offset : Nat64, value : Nat8) -> ()
```

Dentro de `region`, almacena un valor `Nat8` en `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeNat8(region, offset, value);
Region.loadNat8(region, offset) // => 123
```

## Valor `loadNat16`

```motoko no-repl
let loadNat16 : (region : Region, offset : Nat64) -> Nat16
```

Dentro de `region`, carga un valor `Nat16` desde `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeNat16(region, offset, value);
Region.loadNat16(region, offset) // => 123
```

## Valor `storeNat16`

```motoko no-repl
let storeNat16 : (region : Region, offset : Nat64, value : Nat16) -> ()
```

Dentro de `region`, almacena un valor `Nat16` en `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeNat16(region, offset, value);
Region.loadNat16(region, offset) // => 123
```

## Valor `loadNat32`

```motoko no-repl
let loadNat32 : (region : Region, offset : Nat64) -> Nat32
```

Dentro de `region`, carga un valor `Nat32` desde `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeNat32(region, offset, value);
Region.loadNat32(region, offset) // => 123
```

## Valor `storeNat32`

```motoko no-repl
let storeNat32 : (region : Region, offset : Nat64, value : Nat32) -> ()
```

Dentro de `region`, almacena un valor `Nat32` en `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeNat32(region, offset, value);
Region.loadNat32(region, offset) // => 123
```

## Valor `loadNat64`

```motoko no-repl
let loadNat64 : (region : Region, offset : Nat64) -> Nat64
```

Dentro de `region`, carga un valor `Nat64` desde `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeNat64(region, offset, value);
Region.loadNat64(region, offset) // => 123
```

## Valor `storeNat64`

```motoko no-repl
let storeNat64 : (region : Region, offset : Nat64, value : Nat64) -> ()
```

Dentro de `region`, almacena un valor `Nat64` en `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeNat64(region, offset, value);
Region.loadNat64(region, offset) // => 123
```

## Valor `loadInt8`

```motoko no-repl
let loadInt8 : (region : Region, offset : Nat64) -> Int8
```

Dentro de `region`, carga un valor `Int8` desde `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeInt8(region, offset, value);
Region.loadInt8(region, offset) // => 123
```

## Valor `storeInt8`

```motoko no-repl
let storeInt8 : (region : Region, offset : Nat64, value : Int8) -> ()
```

Dentro de `region`, almacena un valor `Int8` en `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeInt8(region, offset, value);
Region.loadInt8(region, offset) // => 123
```

## Valor `loadInt16`

```motoko no-repl
let loadInt16 : (region : Region, offset : Nat64) -> Int16
```

Dentro de `region`, carga un valor `Int16` desde `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeInt16(region, offset, value);
Region.loadInt16(region, offset) // => 123
```

## Valor `storeInt16`

```motoko no-repl
let storeInt16 : (region : Region, offset : Nat64, value : Int16) -> ()
```

Dentro de `region`, almacena un valor `Int16` en `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeInt16(region, offset, value);
Region.loadInt16(region, offset) // => 123
```

## Valor `loadInt32`

```motoko no-repl
let loadInt32 : (region : Region, offset : Nat64) -> Int32
```

Dentro de `region`, carga un valor `Int32` desde `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeInt32(region, offset, value);
Region.loadInt32(region, offset) // => 123
```

## Valor `storeInt32`

```motoko no-repl
let storeInt32 : (region : Region, offset : Nat64, value : Int32) -> ()
```

Dentro de `region`, almacena un valor `Int32` en `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeInt32(region, offset, value);
Region.loadInt32(region, offset) // => 123
```

## Valor `loadInt64`

```motoko no-repl
let loadInt64 : (region : Region, offset : Nat64) -> Int64
```

Dentro de `region`, carga un valor `Int64` desde `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeInt64(region, offset, value);
Region.loadInt64(region, offset) // => 123
```

## Valor `storeInt64`

```motoko no-repl
let storeInt64 : (region : Region, offset : Nat64, value : Int64) -> ()
```

Dentro de `region`, almacena un valor `Int64` en `offset`. Se interrumpe en caso
de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 123;
Region.storeInt64(region, offset, value);
Region.loadInt64(region, offset) // => 123
```

## Valor `loadFloat`

```motoko no-repl
let loadFloat : (region : Region, offset : Nat64) -> Float
```

Dentro de `region`, carga un valor `Float` desde el `offset` dado. Se interrumpe
en caso de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 1.25;
Region.storeFloat(region, offset, value);
Region.loadFloat(region, offset) // => 1.25
```

## Valor `storeFloat`

```motoko no-repl
let storeFloat : (region : Region, offset : Nat64, value : Float) -> ()
```

Dentro de `region`, almacena el valor de tipo `Float` en la posición `offset`.
Se interrumpe en caso de acceso fuera de límites.

Ejemplo:

```motoko no-repl
let region = Region.new();
let offset = 0;
let value = 1.25;
Region.storeFloat(region, offset, value);
Region.loadFloat(region, offset) // => 1.25
```

## Valor `loadBlob`

```motoko no-repl
let loadBlob : (region : Region, offset : Nat64, size : Nat) -> Blob
```

Dentro de `region`, carga `size` bytes comenzando desde `offset` como un `Blob`.
Se interrumpe en caso de acceso fuera de límites.

Ejemplo:

```motoko no-repl
import Blob "mo:base/Blob";

let region = Region.new();
let offset = 0;
let value = Blob.fromArray([1, 2, 3]);
let size = value.size();
Region.storeBlob(region, offset, value);
Blob.toArray(Region.loadBlob(region, offset, size)) // => [1, 2, 3]
```

## Valor `storeBlob`

```motoko no-repl
let storeBlob : (region : Region, offset : Nat64, value : Blob) -> ()
```

Dentro de `region`, escribe `blob.size()` bytes de `blob` comenzando en
`offset`. Se interrumpe en caso de acceso fuera de límites.

Ejemplo:

```motoko no-repl
import Blob "mo:base/Blob";

let region = Region.new();
let offset = 0;
let value = Blob.fromArray([1, 2, 3]);
let size = value.size();
Region.storeBlob(region, offset, value);
Blob.toArray(Region.loadBlob(region, offset, size)) // => [1, 2, 3]
```
