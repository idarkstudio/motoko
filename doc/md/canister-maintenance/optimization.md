---
sidebar_position: 2
---

# Optimización de canisters

El compilador de Motoko produce binarios pequeños con código razonablemente
eficiente, pero no es un compilador altamente optimizado. Es posible optimizar
aún más los binarios de Motoko, tanto en tamaño de código como en uso de ciclos,
utilizando herramientas adicionales como `wasm-opt`.

## Usando `wasm-opt`

`Wasm-opt` es un optimizador general de Wasm que ahora está disponible en dfx,
versiones 0.14.0 y posteriores.

`Wasm-opt` se puede utilizar para habilitar optimizaciones de canisters a través
de una opción de configuración en el archivo `dfx.json` del proyecto, como:

```json
{
  "canisters": {
    "my_canister": {
      "optimize": "cycles"
    }
  }
}
```

### Niveles de optimización para el uso de ciclos

Utilizando la opción `"optimize": "cycles"`, puedes esperar una estimación
aproximada de reducción en el uso de ciclos para los canisters de Motoko de
alrededor del 10%.

La opción `"optimize": "cycles"` es la recomendada por defecto, ya que se
corresponde con el nivel de optimización 3 en el paquete `wasm-opt`.

Los niveles de optimización para el uso de ciclos son los siguientes:

```
O4
O3 (equivalent to “cycles”)
O2
O1
O0 (performs no optimizations)
```

### Niveles de optimización para el tamaño del binario

Para optimizar el tamaño del binario, puedes utilizar la opción
`"optimize": "size"`. Al utilizar la opción de tamaño, los tamaños de los
binarios pueden reducirse aproximadamente en un 16%.

Los niveles de optimización para el tamaño del binario son los siguientes:

```
Oz (equivalent to “size”)
Os
```

Cada optimización preserva las secciones de metadatos específicas de Internet
Computer de cada canister.

:::info Ten en cuenta que en ciertos casos, las optimizaciones pueden aumentar
la complejidad de ciertas funciones en tu módulo Wasm, lo que puede llevar a que
sean rechazadas por la réplica. Si te encuentras con este problema, se
recomienda utilizar un nivel de optimización menos agresivo para no exceder el
límite de complejidad. :::

Puedes encontrar más información sobre la optimización de canisters y sobre las
pruebas de referencia de `wasm-opt` en
[este post del foro](https://forum.dfinity.org/t/canister-optimizer-available-in-dfx-0-14-0/21157).

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
