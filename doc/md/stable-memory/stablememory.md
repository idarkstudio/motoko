---
sidebar_position: 2
---

# Memoria estable

La biblioteca [`Region`](stable-regions.md) se puede utilizar para interactuar
con la memoria estable en ICP.

La biblioteca proporciona acceso de bajo nivel a la memoria estable de Internet
Computer.

:::danger La biblioteca `ExperimentalStableMemory` ha quedado obsoleta.

Las nuevas aplicaciones deben usar la biblioteca `Region`: ofrece un aislamiento
adicional entre diferentes bibliotecas que utilizan memoria estable. :::

## Paquetes de Mops para memoria estable

- [`memory-buffer`](https://mops.one/memory-buffer): Implementación de búfer
  persistente.

- [`memory-hashtable`](https://mops.one/memory-hashtable): Una biblioteca para
  almacenar, actualizar, eliminar y recuperar un solo valor de blob por clave.

- [`StableTrie`](https://mops.one/stable-trie): Una estructura de datos de mapa
  clave-valor que tiene sus datos principales viviendo permanentemente en
  memoria estable utilizando Regions.

## Ejemplos

- [motoko-bucket](https://github.com/PrimLabs/Bucket): Una biblioteca de base de
  datos clave-valor que utiliza memoria estable.

- [motoko-cdn](https://github.com/gabrielnic/motoko-cdn): Una solución de
  almacenamiento de escalado automático.

- [motoko-dht](https://github.com/enzoh/motoko-dht): Un ejemplo de tabla hash
  distribuida.

- [motoko-document-db](https://github.com/DepartureLabsIC/motoko-document-db):
  Un ejemplo de base de datos de documentos.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
