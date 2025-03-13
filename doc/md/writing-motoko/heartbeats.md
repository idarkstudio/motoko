---
sidebar_position: 10
---

# Heartbeats

Los canisters de ICP pueden optar por recibir mensajes regulares de heartbeat
exponiendo una función específica `canister_heartbeat` (consulta
[heartbeat](https://smartcontracts.org/docs/interface-spec/index.html#heartbeat)).

En Motoko, un actor puede recibir mensajes de heartbeat declarando una función
`system`, llamada `heartbeat`, sin argumentos y que devuelve un futuro de tipo
unitario (`async ()`).

## Usando heartbeats

Un ejemplo simple y artificial es una alarma recurrente, que se envía un mensaje
a sí misma cada `n`-ésimo heartbeat:

```motoko no-repl file=../examples/Alarm.mo

```

La función `heartbeat` se llama en cada heartbeat de la subred de ICP
programando una llamada asíncrona a la función `heartbeat`. Debido a su tipo de
retorno `async`, una función de heartbeat puede enviar más mensajes y esperar
resultados. El resultado de una llamada de heartbeat, incluyendo cualquier
trampa o error lanzado, se ignora. El cambio de contexto implícito inherente a
llamar a cada función asíncrona de Motoko significa que el momento en que se
ejecuta el cuerpo de `heartbeat` puede ser posterior al momento en que el
heartbeat fue emitido por la subred.

Como una función `async`, la función `heartbeat` de `Alarm` es libre de llamar a
otras funciones asíncronas, así como a funciones compartidas de otros canisters.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
