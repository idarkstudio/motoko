---
sidebar_position: 4
---

# Generando documentación de Motoko

`mo-doc` es una herramienta de línea de comandos para generar documentación para
el código fuente de Motoko. Procesa archivos fuente y genera documentación en
varios formatos.

## Inicio rápido

Descarga `mo-doc` desde la página de la pagina
[GitHub releases](https://github.com/dfinity/motoko/releases) de Motoko o
simplemente utiliza el binario incluido en tu instalación de
[dfx](https://internetcomputer.org/docs/current/developer-docs/setup/install):

```
$(dfx cache show)/mo-doc [options]
```

## Opciones

- `--source <path>`: Especifica el directorio donde buscar archivos fuente de
  Motoko. Por defecto, es `src`.

- `--output <path>`: Especifica el directorio donde se generará la
  documentación. Por defecto, es `docs`.

- `--format <format>`: Especifica el formato generado. Debe ser uno de los
  siguientes:

  - `html`: Genera documentación en formato HTML.
  - `adoc`: Genera documentación en formato AsciiDoc.
  - `plain`: Genera documentación en formato Markdown.

  Por defecto, es `html`.

- `--help`: Muestra información de uso.

## Ejemplos

1. Generar documentación HTML desde el directorio de origen predeterminado
   (`src`) y colocarla en el directorio de salida predeterminado (`docs`):

   ```bash
   mo-doc
   ```

2. Generar documentación AsciiDoc desde un directorio de origen específico:

   ```bash
   mo-doc --format plain --source ./motoko-code
   ```

3. Generar documentación en Markdown en un directorio de salida personalizado:

   ```bash
   mo-doc --format adoc --output ./public
   ```

## Escribiendo comentarios de documentación

`mo-doc` admite documentar tu código de Motoko utilizando comentarios de bloque
especiales (`/** */`) y comentarios de línea (`///`).

Los comentarios de documentación se pueden utilizar para proporcionar
explicaciones para funciones, clases, tipos, módulos, variables y más. Pueden
abarcar varias líneas y pueden contener formato de Markdown enriquecido:

````motoko no-repl
/// Calculate the factorial of a given positive integer.
///
/// Example:
/// ```motoko
/// factorial(0); // => null
/// factorial(3); // => ?6
/// ```
func factorial(n : Nat) : ?Nat {
    // ...
}
````

## Recursos

Echa un vistazo al
[código fuente de la biblioteca base de Motoko](https://github.com/dfinity/motoko-base/tree/master/src)
para obtener ejemplos adicionales y mejores prácticas.

El código fuente de `mo-doc` está disponible en el repositorio de GitHub
[dfinity/motoko](https://github.com/dfinity/motoko/tree/master/src/docs). ¡Se
aceptan contribuciones!

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
