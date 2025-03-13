---
sidebar_position: 3
---

# Entorno de desarrollo

Para desarrollar e implementar contratos inteligentes de canister Motoko,
necesitarás un entorno de desarrollo que contenga el compilador Motoko y la
biblioteca base. Se recomienda utilizar el
[IC SDK](https://github.com/dfinity/sdk#readme), que incluye Motoko, junto con
`dfx`, una herramienta de línea de comandos utilizada para crear, compilar e
implementar canisters en ICP.

Los entornos de desarrollo vienen en varios tipos y formatos, lo que hace que el
desarrollo sea flexible y accesible.

## Entornos en la nube

[Gitpod](https://www.gitpod.io/) y
[GitHub Codespaces](https://github.com/features/codespaces) son entornos de
desarrollo basados en el navegador que se pueden utilizar para construir, probar
y ejecutar contratos inteligentes de Motoko.

Aquí tienes algunos proyectos de inicio para el desarrollo de canisters de
Motoko en línea:

- [ICP Hello World Motoko](https://github.com/dfinity/icp-hello-world-motoko#readme)
- [Vite + React + Motoko](https://github.com/rvanasa/vite-react-motoko#readme)

Obtén más información sobre
[Gitpod](https://internetcomputer.org/docs/current/developer-docs/developer-tools/ide/gitpod)
y
[GitHub Codespaces](https://internetcomputer.org/docs/current/developer-docs/developer-tools/ide/codespaces)
para el desarrollo de Motoko.

## Entornos de contenedores

Los desarrolladores pueden querer configurar un entorno en contenedor para el
desarrollo de Motoko y otras actividades relacionadas con ICP. Los entornos de
contenedores son especialmente útiles para sistemas basados en Windows, ya que
`dfx` no es compatible de forma nativa en Windows.

Obtén más información sobre
[contenedores de desarrollo](https://internetcomputer.org/docs/current/developer-docs/developer-tools/ide/dev-containers)
y
[contenedores Docker](https://internetcomputer.org/docs/current/developer-docs/developer-tools/ide/dev-containers#using-docker-directly)
para el desarrollo de Motoko.

## Motoko playground

[Motoko playground](https://play.motoko.org/) es un entorno de desarrollo basado
en el navegador que permite la implementación y prueba temporal de contratos
inteligentes de canister. El Motoko playgroud también se puede utilizar a través
del comando `dfx deploy --playground` en la CLI.

Los canisters implementados en el Motoko playgroud utilizan recursos prestados
de un grupo de canisters y están limitados a una duración de implementación de
20 minutos. Por lo tanto, no se recomienda el uso del playground para el
desarrollo a largo plazo.

Obtén más información sobre el
[Motoko playgroud](https://internetcomputer.org/docs/current/developer-docs/developer-tools/ide/playground).

## Entorno de desarrollo local

Antes de comenzar a desarrollar en Motoko, verifica lo siguiente:

- [x] Tienes una conexión a internet y acceso a una terminal de shell en tu
      computadora local macOS o Linux.

- [x] Tienes una ventana de interfaz de línea de comandos (CLI) abierta. Esta
      ventana también se conoce como ventana de "terminal".

- [x] Has descargado e instalado el paquete IC SDK como se describe en la página
      de
      [instalación del IC SDK](https://internetcomputer.org/docs/current/developer-docs/getting-started/install).

- [x] Tienes un editor de código instalado. El
      [IDE de VS Code](https://code.visualstudio.com/download) (con la
      [extensión de Motoko](https://marketplace.visualstudio.com/items?itemName=dfinity-foundation.vscode-motoko))
      es una opción popular.

- [x] Has descargado e instalado [git](https://git-scm.com/downloads).

- [x] Asegúrate de que todos los paquetes y herramientas mencionados
      anteriormente estén actualizados a las últimas versiones.

## Versión de Motoko

La siguiente tabla detalla qué versión de Motoko se incluyó con cada versión
principal del IC SDK.

| IC SDK version | Motoko version |
| -------------- | -------------- |
| 0.20.0         | 0.11.1         |
| 0.19.0         | 0.11.1         |
| 0.18.0         | 0.11.0         |
| 0.17.0         | 0.10.4         |
| 0.16.0         | 0.10.4         |
| 0.15.0         | 0.9.7          |
| 0.14.0         | 0.8.7          |
| 0.13.0         | 0.7.6          |
| 0.12.0         | 0.7.3          |
| 0.11.0         | 0.6.29         |
| 0.10.0         | 0.6.26         |
| 0.9.0          | 0.6.20         |
| 0.8.0          | 0.6.5          |
| 0.7.0          | 0.6.1          |

Puedes averiguar qué versión de Motoko se incluyó con una versión del IC SDK a
través del siguiente archivo:

```
https://github.com/dfinity/sdk/blob/<VERSION>/nix/sources.json#L144
```

Reemplaza `<VERSION>` con la versión de lanzamiento de IC SDK, como `0.14.2`.

## Entorno de desarrollo personalizado

### Especificar una versión personalizada del compilador

Para especificar una versión personalizada del compilador Motoko que se
utilizará con `dfx`, puedes usar el administrador de paquetes `mops` o `vessel`.

Para `mops`, utiliza el siguiente comando para descargar una versión diferente
del compilador Motoko (`moc`):

```
mops toolchain use moc 0.10.3
```

Para `vessel`, configura la siguiente variable de entorno:

```
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy
```

## Especificar una versión personalizada de la biblioteca base

Para especificar una versión personalizada de la biblioteca base de Motoko que
se utilizará con `dfx`, puedes usar el administrador de paquetes `mops` con el
siguiente comando:

```
mops add base@<VERSION>
```

Por ejemplo, para usar la versión `0.9.0` de la biblioteca base, utiliza el
siguiente comando:

```
mops add base@0.9.0
```

### Especificar una versión personalizada de `dfx`

Para especificar una versión personalizada de `dfx`, puedes usar la herramienta
[`dfxvm`](https://internetcomputer.org/docs/current/developer-docs/developer-tools/cli-tools/dfxvm/docs/cli-reference/dfxvm/dfxvm-default).
Para establecer una versión predeterminada de `dfx` que se utilizará en tu
proyecto, ejecuta el siguiente comando:

```
$ dfxvm default 0.7.2
...
info: installed dfx 0.7.2
info: set default version to dfx 0.7.2
```

### Pasar flags a `moc` en `dfx.json`

Puedes pasar flags directamente a `moc` agregando un campo `args` en la
descripción del canister Motoko en el archivo `dfx.json` de tu proyecto:

Aquí tienes un ejemplo de configuración de canister `dfx.json` que utiliza
`args`:

```json
...
  "canisters": {
    "hello": {
      "type": "motoko",
      "main": "src/hello/main.mo",
      "args": "-v --incremental-gc"
    },
  }
...
```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
