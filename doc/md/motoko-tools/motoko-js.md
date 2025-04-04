---
sidebar_position: 4
---

# Motoko.js

El paquete Motoko.js se puede utilizar para compilar y ejecutar contratos
inteligentes de Motoko en un navegador web o en Node.js.

## Instalación

Para instalar el paquete Motoko.js, utiliza `npm`:

```
npm i --save motoko
```

## Uso

Primero, crea un nuevo proyecto Node.js con los siguientes comandos:

```
mkdir motoko-js-test
cd motoko-js-test
npm init
```

En el archivo `package.json` creado por `npm init`, inserta la siguiente línea:

```
  "type": "module",
```

Luego, crea y abre un archivo `index.js`. En este nuevo archivo, importa el
paquete Motoko.js en tu archivo de código fuente:

```
import mo from 'motoko';
```

Crea un script de Motoko utilizando el sistema de archivos virtual de Node.js:

```
mo.write('Main.mo', `
  actor Main {
    public query func hello() : async Text {
      "Hello, world!"
    };
  };
`)
console.log(mo.run('Main.mo'));
```

Seguidamente, añade una línea final para generar la interfaz Candid
correspondiente al script de Motoko:

```
console.log(mo.candid('Main.mo'));
```

Ejecuta este código con el comando:

```
node index.js
```

La consola devolverá la siguiente salida

```
{
  stdout: '`ys6dh-5cjiq-5dc` : actor {hello : shared query () -> async Text}\n',
  stderr: '',
  result: { error: null }
}
service : {
  hello: () -> (text) query;
}
```

## Referencias

- [Documentación de npm](https://www.npmjs.com/package/motoko)

- [Cargar dependencias desde GitHub](https://github.com/dfinity/node-motoko?tab=readme-ov-file#load-dependencies-from-github)

- [Optimizar para navegadores](https://github.com/dfinity/node-motoko?tab=readme-ov-file#optimize-for-browsers)

- [API de nivel superior](https://github.com/dfinity/node-motoko?tab=readme-ov-file#top-level-api)

- [API de archivos](https://github.com/dfinity/node-motoko?tab=readme-ov-file#file-api)

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
