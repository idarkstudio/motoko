---
sidebar_position: 3
---

# Servidor de desarrollo de Motoko

El servidor de desarrollo de Motoko, o `mo-dev` en resumen, es una herramienta
de línea de comandos que ofrece un servidor de desarrollo con recarga en vivo
para Motoko.

## Instalación

### Requisitos previos

- [Node.js](https://nodejs.org/es/) ≥ 16:

Puedes instalar `mo-dev` con `npm`:

```sh
npm i -g mo-dev
```

:::info

Standalone `mo-dev` binaries are also available as
[GitHub releases](https://github.com/dfinity/motoko-dev-server/releases).

:::

## Uso

Especifica el directorio de trabajo de tu proyecto Motoko, el cual debe contener
un archivo `dfx.json`:

```sh
mo-dev --cwd path/to/dfx_project
```

Luego, ejecuta el servidor de desarrollo para un canister específico:

```sh
mo-dev --canister foo --deploy
```

Puedes desplegar todos los canisters dentro de un archivo `dfx.json` con la
bandera `--deploy`. Los canisters se desplegarán cuando se cambie un archivo
Motoko:

```sh
mo-dev --deploy
```

Tanbién puedes pasar un argumento de instalación a `dfx deploy`:

```sh
mo-dev --deploy --argument '()'
```

[Ver el uso completo de `mo-dev`](https://github.com/dfinity/motoko-dev-server/).

### Testing

`mo-dev` soporta la ejecución de pruebas unitarias (`*.test.mo`). Las pruebas se
ejecutarán cuando se cambie un archivo Motoko:

```sh
mo-dev --test
```

`mo-dev` también incluye un comando `mo-test`, que se puede utilizar para
ejecutar pruebas unitarias dentro de flujos de trabajo de CI.

Para ejecutar todas las pruebas unitarias de Motoko (`*.test.mo`), utiliza el
siguiente comando:

```sh
mo-test
```

También puedes ejecutar todas las pruebas unitarias de Motoko utilizando un
tiempo de ejecución WASI de forma predeterminada. Esto tiene un mejor
rendimiento y requiere instalar [Wasmtime](https://wasmtime.dev/) en tu sistema:

```sh
mo-test --testmode wasi
```

Para configurar el tiempo de ejecución de una prueba unitaria individual,
incluye el siguiente comentario dentro de tu archivo de prueba (`*.test.mo`):

```motoko no-repl
// @testmode wasi
```

[Ver el uso completo de `mo-test`](https://github.com/dfinity/motoko-dev-server/?tab=readme-ov-file#mo-test).

## Ejemplos

El proyecto
[Vite + React + Motoko](https://github.com/rvanasa/vite-react-motoko#readme)
muestra cómo integrar `mo-dev` en una dapp de pila completa.

[![Abrir en Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/rvanasa/vite-react-motoko)

## Notas importantes

`mo-dev` está en una etapa temprana de desarrollo. No dudes en informar un
error, hacer una pregunta o solicitar una función en la página de
[problemas de GitHub](https://github.com/dfinity/motoko-dev-server/issues) del
proyecto.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
