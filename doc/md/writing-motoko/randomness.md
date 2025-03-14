---
sidebar_position: 22
---

# Aleatoriedad (Randomness)

El módulo [`Random`](../base/Random.md) de la biblioteca base de Motoko puede
usarse para generar valores aleatorios dentro de contratos inteligentes en ICP.
La generación de aleatoriedad en ICP es un proceso complejo, ya que ICP utiliza
computación determinista para obtener valores aleatorios criptográficamente
seguros.

A nivel bajo, ICP utiliza una Función Aleatoria Verificable (Verifiable Random
Function, VRF) que es expuesta por el canister de gestión y utilizada por el
módulo `Random` de Motoko. En cada ronda de ejecución, la función de
aleatoriedad se evalúa utilizando el número de la ronda actual como entrada para
producir un nuevo conjunto de bytes aleatorios.

Para utilizar la aleatoriedad, se deben seguir ciertas pautas:

- La fuente de aleatoriedad solo puede obtenerse de forma asíncrona en
  fragmentos de 256 bits, que son `Blobs` de 32 bytes.

- Las apuestas deben cerrarse antes de solicitar la fuente de aleatoriedad. Esto
  implica que la misma fuente de aleatoriedad no puede usarse para una nueva
  ronda de apuestas sin perder su garantía criptográfica.

El módulo `Random` incluye una clase llamada `Finite` y un método `*From`. Estos
conllevan el riesgo de arrastrar el estado de una ronda anterior, pero se
proporcionan por razones de rendimiento y conveniencia. Deben usarse con
cuidado.

## Ejemplo del módulo `Random`

Para demostrar el uso de la aleatoriedad, considera el siguiente ejemplo que
baraja un mazo de cartas y luego devuelve las cartas en su orden barajado. El
código está anotado con información adicional:

```motoko file=../examples/CardShuffle.mo

```

Ver este ejemplo en [Motoko Playground](https://play.motoko.org/?tag=2675232834)
o en
[GitHub](https://github.com/crusso/card-shuffle/blob/main/src/cards_backend/main.mo).

:::tip La solución anterior utiliza directamente el conjunto finito de 256 bits
aleatorios devuelto por el canister de gestión. La clase `Random.Finite` utiliza
este suministro finito de bits para generar como máximo 256 lanzamientos de
moneda, devolviendo `null` cuando no es posible hacer más lanzamientos.

Cuando se agota su suministro actual de bits, el código solicita de forma
asíncrona otro conjunto de 256 bits para continuar la mezcla. Un enfoque más
eficiente y igualmente robusto sería utilizar el primer conjunto de 256 bits
como semilla para un generador de números pseudoaleatorios secuencial, generando
una secuencia infinita y perezosa de bits, y luego completar la mezcla con una
sola ronda de comunicación.

:::

## Llamando al método `raw_rand` del canister de gestión

Alternativamente, puedes utilizar la aleatoriedad llamando al endpoint
`raw_rand` del canister de gestión:

```motoko file=../examples/RawRand.mo

```

## Recursos

- [Aletoriedad onchain](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/advanced-features/randomness)

- [Documentacion de la libreria base `Random`](../base/Random.md)

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
