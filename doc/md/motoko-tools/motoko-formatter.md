---
sidebar_position: 2
---

# Herramientas de formateo de Motoko

El complemento Motoko Prettier se puede utilizar para formatear y validar
archivos de código fuente de Motoko. Se puede utilizar a través de la
[CLI de Prettier](https://prettier.io/docs/en/cli.html) o a través de VS Code.

Alternativamente, el paquete de Node.js
[`mo-fmt`](https://www.npmjs.com/package/mo-fmt) es una herramienta de formateo
de Motoko independiente.

## Complemento Motoko Prettier

### Instalación

Para instalar el complemento Motoko Prettier, primero descarga e instala
[Node.js](https://nodejs.org/es/download/).

Luego, crea un nuevo proyecto Motoko o navega hasta un directorio de proyecto
existente.
[Aprende más sobre cómo crear un proyecto Motoko](../getting-started/quickstart.md).

Después, ejecuta el siguiente comando en el directorio del proyecto:

```sh
npm install --save-dev prettier prettier-plugin-motoko
```

### Usando la CLI de Prettier

Puedes formatear archivos de Motoko a través de la CLI de Prettier usando el
siguiente comando:

```sh
npx prettier --write --plugin=prettier-plugin-motoko **/*.mo
```

Para validar si tus archivos de Motoko están formateados correctamente, usa el
siguiente comando:

```sh
npx prettier --check --plugin=prettier-plugin-motoko **/*.mo
```

### Usando VS Code

El plugin de Motoko Prettier funciona de forma nativa con la
[extension de Motoko para VS Code](https://marketplace.visualstudio.com/items?itemName=dfinity-foundation.vscode-motoko).

También es compatible con la
[extension Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode).

### Ignorando código

Puedes configurar código para que sea ignorado del formateo o de la validación
usando un comentario `prettier-ignore`:

```motoko no-repl
// prettier-ignore
func ignored<A>(a:A){a};

func formatted<B>(b : B) { b };
```

## `mo-fmt`

### Instalación

Para instalar `mo-fmt`, ejecuta el siguiente comando:

```
npm install mo-fmt
```

Luego, para formatear y validar el formato de los archivos de código de Motoko,
ejecuta los comandos:

```
mo-fmt **/*
mo-fmt -c **/*
```

## Referencias

- [Motoko Prettier plugin GitHub repo](https://github.com/dfinity/prettier-plugin-motoko/)

- [Extension de Motoko para VS Code](https://marketplace.visualstudio.com/items?itemName=dfinity-foundation.vscode-motoko)

- [`mo-fmt`](https://www.npmjs.com/package/mo-fmt)

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
