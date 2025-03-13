---
sidebar_position: 3
---

# Clases de actores

Las clases de actores te permiten crear redes de actores de manera programática.
Las clases de actores deben definirse en un archivo fuente separado. Para
ilustrar cómo definir e importar clases de actores, el siguiente ejemplo
implementa un mapa distribuido de claves de tipo [`Nat`](../base/Nat.md) a
valores de tipo [`Text`](../base/Text.md). Proporciona funciones simples de
inserción y búsqueda, `put(k, v)` y `get(k)`, para trabajar con estas claves y
valores.

## Definiendo una clase de actor

Para distribuir los datos en este ejemplo, el conjunto de claves se divide en
`n` recipientes. Por ahora, simplemente fijamos `n = 8`. El recipiente, `i`, de
una clave, `k`, se determina por el resto de `k` dividido por `n`, es decir,
`i = k % n`. El recipiente `i`-ésimo (`i` en `[0..n)`) recibe un actor dedicado
para almacenar valores de texto asignados a las claves en ese recipiente.

El actor responsable del recipiente `i` se obtiene como una instancia de la
clase de actor `Bucket(i)`, definida en el archivo de ejemplo `Buckets.mo`, de
la siguiente manera:

`Buckets.mo`:

```motoko no-repl name=Buckets file=../examples/Buckets.mo

```

Un recipiente almacena el mapeo actual de claves a valores en una variable
mutable `map` que contiene un árbol Rojo-Negro imperativo, `map`, que
inicialmente está vacío.

En `get(k)`, el actor del recipiente simplemente devuelve cualquier valor
almacenado en `k`, devolviendo `map.get(k)`.

En `put(k, v)`, el actor del recipiente actualiza el `map` actual para mapear
`k` a `v` llamando a `map.put(k, v)`.

Ambas funciones utilizan los parámetros de clase `n` e `i` para verificar que la
clave sea apropiada para el recipiente mediante la afirmación `((k % n) == i)`.

Los clientes del mapa pueden comunicarse con un actor coordinador `Map`,
implementado de la siguiente manera:

```motoko no-repl include=Buckets file=../examples/Map.mo

```

Como ilustra este ejemplo, el código de `Map` importa la clase de actor `Bucket`
como el módulo `Buckets`.

El actor mantiene un arreglo de `n` recipientes asignados, con todas las
entradas inicialmente en `null`. Las entradas se llenan con actores `Bucket`
según sea necesario.

En `get(k, v)`, el actor `Map`:

- Usa el resto de la clave `k` dividido por `n` para determinar el índice `i`
  del recipiente responsable de esa clave.

- Devuelve `null` si el recipiente `i`-ésimo no existe, o

- Delega a ese recipiente llamando a `bucket.get(k, v)` si existe.

En `put(k, v)`, el actor `Map`:

- Usa el resto de la clave `k` dividido por `n` para determinar el índice `i`
  del recipiente responsable de esa clave.

- Instala el recipiente `i` si el recipiente no existe mediante una llamada
  asíncrona al constructor, `Buckets.Bucket(i)`, y, después de esperar el
  resultado, lo registra en el arreglo `buckets`.

- Delega la inserción a ese recipiente llamando a `bucket.put(k, v)`.

Si bien este ejemplo establece el número de recipientes en `8`, puedes
generalizar el ejemplo convirtiendo el actor `Map` en una clase de actor,
agregando un parámetro `(n : Nat)` y omitiendo la declaración `let n = 8;`.

Por ejemplo:

```motoko no-repl
actor class Map(n : Nat) {

  type Key = Nat
  ...
}
```

Los clientes de la clase de actor `Map` ahora son libres de determinar el número
máximo de recipientes en la red pasando un argumento en la construcción.

:::note

En ICP, las llamadas a un constructor de clase deben estar provistas de ciclos
para pagar la creación de un principal. Consulta
[ExperimentalCycles](../base/ExperimentalCycles.md) para obtener instrucciones
sobre cómo agregar ciclos a una llamada utilizando la función imperativa
`ExperimentalCycles.add<system>(cycles)`.

:::

## Configuración y gestión de instancias de clases de actores

En ICP, el constructor principal de una clase de actor importada siempre crea un
nuevo principal e instala una nueva instancia de la clase como el código para
ese principal.

Para proporcionar un mayor control sobre la instalación de clases de actores,
Motoko dota a cada clase de actor importada de un constructor secundario
adicional. Este constructor toma un argumento adicional que especifica el modo
de instalación deseado. El constructor solo está disponible a través de una
sintaxis especial que resalta su funcionalidad `system`.

Utilizando esta sintaxis, es posible especificar la configuración inicial del
canister (como un arreglo de controladores), instalar, actualizar y reinstalar
manualmente canisters, exponiendo todas las facilidades de nivel inferior de
Internet Computer.

Consulta
[gestión de clases de actores](../reference/language-manual#actor-class-management)
para obtener más detalles.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
