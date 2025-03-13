---
sidebar_position: 4
---

# Guía de inicio rápido de Motoko

Esta guía de inicio rápido muestra cómo implementar un contrato inteligente
simple de Motoko que dice '¡Hola, mundo!'.

## Requisitos previos

Antes de comenzar, asegúrate de haber configurado tu entorno de desarrollo
siguiendo las instrucciones de la [guía de entorno de desarrollo](./dev-env).

## Crear un nuevo proyecto

Abre una ventana de terminal en tu computadora local, si aún no tienes una
abierta.

Crea un nuevo proyecto y cambia al directorio del proyecto.

Usa `dfx new [nombre_del_proyecto]` para crear un nuevo proyecto:

```
dfx new hello_world
```

Se te pedirá que selecciones el lenguaje que utilizará tu canister de backend:

```
? Select a backend language: ›
❯ Motoko
Rust
TypeScript (Azle)
Python (Kybra)
```

Luego, selecciona un marco de trabajo frontend para tu canister frontend. En
este ejemplo, selecciona:

```
? Select a frontend framework: ›
SvelteKit
React
Vue
Vanilla JS
No JS template
❯ No frontend canister
```

Por último, puedes incluir características adicionales que se agregarán a tu
proyecto:

```
? Add extra features (space to select, enter to confirm) ›
⬚ Internet Identity
⬚ Bitcoin (Regtest)
⬚ Frontend tests
```

## Código del contrato inteligente

Este actor de hello world tiene una única función llamada `greet`. Está marcada
como `query` porque no modifica el estado del actor. La función acepta un nombre
como entrada de tipo [`Text`](../base/Text.md) y devuelve un saludo de tipo
[`Text`](../base/Text.md).

```motoko title="src/hello_backend/main.mo"

actor {
  public query func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };
};
```

## Iniciando el entorno de implementación

Inicia Internet Computer para el desarrollo local o verifica tu conexión a
Internet Computer para la implementación en la red:

- [Implementación local](https://internetcomputer.org/docs/current/developer-docs/getting-started/deploy-and-manage).
- [Implementación en la red principal (Mainnet)](https://internetcomputer.org/docs/current/developer-docs/getting-started/deploy-and-manage).

## Registrar, construir e deployar localmente o en mainnet

Para deployar localmente, utiliza el siguiente comando:

```
dfx deploy
```

Para deployar en mainnet, usa: `--network ic`.

```
dfx deploy --network <network>
```

## Ver tu servicio o aplicación en un navegador, utilizando las URL en la salida del comando `dfx deploy`:

```
...
Committing batch.
Committing batch with 18 operations.
Deployed canisters.
URLs:
Frontend canister via browser
        access_hello_frontend: http://127.0.0.1:4943/?canisterId=cuj6u-c4aaa-aaaaa-qaajq-cai
Backend canister via Candid interface:
        access_hello_backend: http://127.0.0.1:4943/?canisterId=cbopz-duaaa-aaaaa-qaaka-cai&id=ctiya-peaaa-aaaaa-qaaja-cai
```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
