---
sidebar_position: 2
---

# Referencia del compilador

El compilador de Motoko (`moc`) es la herramienta principal para compilar
programas de Motoko en módulos ejecutables de WebAssembly (Wasm). El compilador
se ejecuta en segundo plano cuando construyes proyectos utilizando el
[IC SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install).
Si invocas el compilador directamente en la línea de comandos, puedes presionar
CTRL-C para salir.

Esta sección proporciona información de referencia sobre los comandos del
compilador.

## moc

Utiliza el compilador de Motoko (`moc`) para compilar programas de Motoko en
módulos ejecutables de WebAssembly (Wasm).

### Uso básico

```bash
moc [option] [file ...]
```

### Opciones

Puedes usar las siguientes opciones con el comando `moc`.

| Opción                                    | Descripción                                                                                                                                                                                                              |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `--ai-errors`                             | Emite mensajes de error adaptados para IA.                                                                                                                                                                               |
| `--actor-idl <idl-path>`                  | Especifica una ruta a los archivos IDL (Candid) del actor.                                                                                                                                                               |
| `--actor-alias <alias> <principal>`       | Especifica un alias de importación para el actor.                                                                                                                                                                        |
| `--args <file>`                           | Lee argumentos adicionales separados por nuevas líneas desde `<file>`.                                                                                                                                                   |
| `--args0 <file>`                          | Lee argumentos adicionales separados por `NUL` desde `<file>`.                                                                                                                                                           |
| `-c`                                      | Compila a WebAssembly.                                                                                                                                                                                                   |
| `--check`                                 | Realiza solo la verificación de tipos.                                                                                                                                                                                   |
| `--compacting-gc`                         | Usa el recolector de basura compactador (no compatible con la persistencia ortogonal mejorada).                                                                                                                          |
| `--copying-gc`                            | Usa el recolector de basura copiador (predeterminado con persistencia clásica, no compatible con la persistencia ortogonal mejorada).                                                                                    |
| `--debug`                                 | Respeta las expresiones de depuración en el código fuente (predeterminado).                                                                                                                                              |
| `--enhanced-orthogonal-persistence`       | Usa persistencia ortogonal mejorada (experimental): Actualizaciones escalables y rápidas utilizando una memoria principal persistente de 64 bits.                                                                        |
| `--error-detail <n>`                      | Establece el nivel de detalle de los mensajes de error para errores de sintaxis, n en \[0..3\] (predeterminado 2).                                                                                                       |
| `--experimental-stable-memory <n>`        | Selecciona el soporte para la biblioteca obsoleta `ExperimentalStableMemory.mo` (n < 0: error, n = 0: advertencia, n > 0: permitir) (predeterminado 0).                                                                  |
| `-fno-shared-code`                        | No comparte código de utilidad de bajo nivel: mayor tamaño de código pero menor consumo de ciclos (predeterminado).                                                                                                      |
| `--generational-gc`                       | Usa el recolector de basura generacional (no compatible con la persistencia ortogonal mejorada).                                                                                                                         |
| `-fshared-code`                           | Comparte código de utilidad de bajo nivel: menor tamaño de código pero mayor consumo de ciclos.                                                                                                                          |
| `-help`,`--help`                          | Muestra información de uso.                                                                                                                                                                                              |
| `--hide-warnings`                         | Oculta las advertencias del compilador.                                                                                                                                                                                  |
| `-Werror`                                 | Trata las advertencias como errores.                                                                                                                                                                                     |
| `--incremental-gc`                        | Usa el recolector de basura incremental (predeterminado de la persistencia ortogonal mejorada, también disponible para la persistencia clásica).                                                                         |
| `--idl`                                   | Compila el binario y emite la especificación IDL (Candid) en un archivo `.did`.                                                                                                                                          |
| `-i`                                      | Ejecuta el compilador en un bucle interactivo de lectura-evaluación-impresión (REPL) para evaluar la ejecución del programa (implica -r).                                                                                |
| `--map`                                   | Genera un mapa de fuentes JavaScript.                                                                                                                                                                                    |
| `--max-stable-pages <n>`                  | Establece el número máximo de páginas disponibles para la biblioteca `ExperimentStableMemory.mo` (predeterminado 65536).                                                                                                 |
| `-no-system-api`                          | Desactiva las importaciones de la API del sistema.                                                                                                                                                                       |
| `-no-timer`                               | Desactiva las importaciones de la API del temporizador y oculta las primitivas del temporizador.                                                                                                                         |
| `-o <file>`                               | Especifica el archivo de salida.                                                                                                                                                                                         |
| `-p <n>`                                  | Establece la profundidad de impresión.                                                                                                                                                                                   |
| `--package <package-name> <package-path>` | Especifica un par `<package-name>` `<package-path>`, separados por un espacio.                                                                                                                                           |
| `--public-metadata <name>`                | Emite la sección personalizada ICP `<name>` (`candid:args` o `candid:service` o `motoko:stable-types` o `motoko:compiler`) como `public` (predeterminado es `private`).                                                  |
| `--omit-metadata <name>`                  | Omite la sección personalizada ICP `<name>` (`candid:args` o `candid:service` o `motoko:stable-types` o `motoko:compiler`).                                                                                              |
| `--print-deps`                            | Imprime las dependencias para un archivo fuente dado.                                                                                                                                                                    |
| `-r`                                      | Interpreta programas.                                                                                                                                                                                                    |
| `--release`                               | Ignora las expresiones de depuración en el código fuente.                                                                                                                                                                |
| `--stable-regions`                        | Fuerza la inicialización temprana de los metadatos de regiones estables (para fines de prueba); consume entre 386KiB o 8MiB de memoria estable física adicional, dependiendo del uso actual de ExperimentalStableMemory. |
| `--stable-types`                          | Compila el binario y emite la firma de tipos estables en un archivo `.most`.                                                                                                                                             |
| `--stable-compatible <pre> <post>`        | Prueba la compatibilidad de actualización entre las firmas de tipos estables `<pre>` y `<post>`.                                                                                                                         |
| `--rts-stack-pages <n>`                   | Establece el número máximo de páginas disponibles para la pila del sistema en tiempo de ejecución (solo compatible con la persistencia clásica, predeterminado 32).                                                      |
| `--trap-on-call-error`                    | Entra en trampa, no lanza un [`Error`](../base/Error.md), cuando una llamada IC falla debido a que la cola de destino está llena o se cruza el umbral de congelación.                                                    |
|                                           | Emula el comportamiento de las versiones de moc < 0.8.0.                                                                                                                                                                 |
| `-t`                                      | Activa el seguimiento en el intérprete.                                                                                                                                                                                  |
| `-v`                                      | Genera salida detallada.                                                                                                                                                                                                 |
| `--version`                               | Muestra información de la versión.                                                                                                                                                                                       |
| `-wasi-system-api`                        | Usa la API del sistema WASI (`wasmtime`).                                                                                                                                                                                |

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
