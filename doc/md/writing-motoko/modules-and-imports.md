---
sidebar_position: 16
---

# Módulos e importaciones

El diseño de Motoko busca minimizar los tipos y operaciones integrados. En lugar
de tipos integrados, Motoko proporciona una biblioteca base de módulos para
manejar muchos tipos de operaciones comunes y hacer que el lenguaje se sienta
completo. Esta biblioteca base sigue evolucionando con módulos que admiten
características principales, y las API de la biblioteca base están sujetas a
cambios con el tiempo en diversos grados. Debes tener en cuenta, en particular,
que el tamaño y la cantidad de módulos y funciones incluidos en la biblioteca
base probablemente aumentarán drásticamente. Las actualizaciones de los módulos
de la biblioteca base podrían introducir cambios importantes que requieran que
actualices tus programas para mantener la compatibilidad. Los cambios
importantes se comunican a través de las
[guías de migración de Motoko](../migration-guides/overview.md).

Esta sección proporciona ejemplos de diferentes escenarios para usar las
palabras clave `module` e `import`.

## Importando desde la biblioteca base

Consulta la
[documentación en línea de la biblioteca base de Motoko](../base/index.md).

Puedes encontrar el código fuente de los módulos base de Motoko en el
repositorio de código abierto
[repository](https://github.com/dfinity/motoko-base).

En el repositorio hay instrucciones para generar una copia local de la
documentación actual del paquete base de Motoko.

Para importar desde la biblioteca base, usa la palabra clave `import` seguida de
un nombre de módulo local y una URL donde la declaración `import` pueda
encontrar el módulo. Por ejemplo:

```motoko
import Debug "mo:base/Debug";
Debug.print("hello world");
```

Este ejemplo ilustra cómo importar código Motoko, indicado por el uso del
prefijo `mo:` para identificar el módulo como un módulo Motoko. La declaración
no incluye la extensión de tipo de archivo `.mo`. Luego, se utiliza la ruta de
la biblioteca base `base/` y el nombre del módulo [`Debug`](../base/Debug.md).

También puedes importar selectivamente un subconjunto de valores nombrados de un
módulo utilizando la sintaxis del patrón de objeto:

```motoko
import { map; find; foldLeft = fold } = "mo:base/Array";
```

En este ejemplo, las funciones `map` y `find` se importan sin modificar,
mientras que la función `foldLeft` se renombra a `fold`.

## Importando archivos locales

Otro enfoque común para escribir programas en Motoko implica dividir el código
fuente en diferentes módulos. Por ejemplo, podrías diseñar una aplicación
utilizando el siguiente modelo:

- Un archivo `main.mo` para contener el actor y las funciones que cambian el
  estado.

- Un archivo `types.mo` para todas tus definiciones de tipos personalizados.

- Un archivo `utils.mo` para funciones que realizan trabajo fuera del actor.

En este escenario, podrías colocar los tres archivos en el mismo directorio y
usar una importación local para que las funciones estén disponibles donde se
necesiten.

Por ejemplo, el archivo `main.mo` contiene las siguientes líneas para hacer
referencia a los módulos en el mismo directorio:

```motoko no-repl
import Types "types";
import Utils "utils";
```

Porque estas líneas importan módulos del proyecto local en lugar de la
biblioteca Motoko, estas declaraciones de importación no utilizan el prefijo
`mo:`.

En este ejemplo, tanto los archivos `types.mo` como `utils.mo` están en el mismo
directorio que el archivo `main.mo`. Una vez más, la importación no utiliza el
sufijo de archivo `.mo`.

## Importando desde otro paquete o directorio

También puedes importar módulos de otros paquetes o de directorios distintos al
directorio local.

Por ejemplo, las siguientes líneas importan módulos de un paquete `redraw` que
está definido como una dependencia:

```motoko no-repl
import Render "mo:redraw/Render";
import Mono5x5 "mo:redraw/glyph/Mono5x5";
```

Puedes definir dependencias para un proyecto utilizando un gestor de paquetes o
en el archivo de configuración `dfx.json` del proyecto.

En este ejemplo, el módulo `Render` se encuentra en la ubicación predeterminada
para el código fuente en el paquete `redraw`, y el módulo `Mono5x5` está en un
subdirectorio del paquete `redraw` llamado `glyph`.

## Importando paquetes desde un gestor de paquetes

Para descargar e instalar paquetes de terceros, se puede utilizar un gestor de
paquetes como [Mops](https://mops.one) o
[Vessel](https://github.com/dfinity/vessel).

Para usar cualquiera de estos gestores de paquetes, edita el archivo `dfx.json`
de tu proyecto para especificar una herramienta de paquetes (`packtool`), como:

```json
{
  "defaults": {
    "build": {
      "packtool": "mops sources"
    }
  }
}
```

Para Vessel, utiliza `vessel sources`.

Luego, para descargar un paquete con la herramienta de línea de comandos `mops`,
utiliza un comando como:

```
mops add vector
```

Para Vessel, edita el archivo `vessel.dhall` para incluir los paquetes que tu
proyecto importará.

Luego, importa los paquetes como lo harías con otros paquetes en el archivo
fuente de Motoko:

```motoko no-repl
import Vec "mo:vector";
import Vec "mo:vector/Class";
```

## Importando clases de actores

Aunque las importaciones de módulos se utilizan típicamente para importar
bibliotecas de funciones y valores locales, también pueden usarse para importar
clases de actores. Cuando un archivo importado contiene una clase de actor con
nombre, el cliente del archivo importado ve un módulo que contiene la clase de
actor.

Este módulo tiene dos componentes, ambos nombrados según la clase de actor:

- Una definición de tipo que describe la interfaz de la clase.

- Una función asíncrona que toma los parámetros de la clase como argumentos y
  devuelve de manera asíncrona una nueva instancia de la clase.

Por ejemplo, un actor en Motoko puede importar e instanciar la clase `Counter`
descrita de la siguiente manera:

`Counters.mo`:

```motoko name=Counters file=../examples/Counters.mo

```

`CountToTen.mo`:

```motoko no-repl file=../examples/CountToTen.mo

```

La instalación es asíncrona, por lo que el llamador debe esperar el resultado.

La anotación de tipo `: Counters.Counter` es redundante aquí. Se incluye solo
para ilustrar que el tipo de la clase del actor está disponible cuando se
requiere.

## Importando desde otro contrato inteligente de canister

También puedes importar actores y sus funciones compartidas desde otro canister
utilizando el prefijo `canister:` en lugar del prefijo `mo:`.

:::note

A diferencia de una biblioteca de Motoko, un canister importado puede ser
implementado en cualquier otro lenguaje, como Rust o incluso una versión
diferente de Motoko, que emite interfaces Candid para su canister.

:::

Por ejemplo, podrías tener un proyecto que produce los siguientes tres
canisters:

- BigMap (implementado en Rust).

- Connectd (implementado en Motoko).

- LinkedUp (implementado en Motoko).

Estos tres canisters se declaran en el archivo de configuración `dfx.json` del
proyecto y se compilan ejecutando `dfx build`.

Puedes utilizar las siguientes líneas para importar los canisters `BigMap` y
`Connectd` como actores en el actor Motoko LinkedUp:

```motoko no-repl
import BigMap "canister:BigMap";
import Connectd "canister:connectd";
```

Al importar canisters, es importante tener en cuenta que el tipo para el
canister importado corresponde a un **actor de Motoko** en lugar de un **módulo
de Motoko**. Esta distinción puede afectar cómo se tipan algunas estructuras de
datos.

Para el actor del canister importado, los tipos se derivan del archivo Candid
`project-name.did` del canister, en lugar de derivarse directamente de Motoko.

La traducción del tipo de actor de Motoko al tipo de servicio Candid suele ser
uno a uno, y hay algunos tipos distintos de Motoko que se mapean al mismo tipo
Candid. Por ejemplo, los tipos de Motoko [`Nat32`](../base/Nat32.md) y `Char` se
exportan ambos como el tipo Candid [`Nat32`](../base/Nat32.md), pero
[`Nat32`](../base/Nat32.md) se importa canónicamente como el tipo de Motoko
[`Nat32`](../base/Nat32.md), no como `Char`.

El tipo de una función de canister importada podría diferir del tipo del código
original de Motoko que la implementa. Por ejemplo, si la función de Motoko tenía
el tipo `shared Nat32 -> async Char` en la implementación, su tipo Candid
exportado sería `(nat32) -> (nat32)`, pero el tipo de Motoko importado a partir
de este tipo Candid será en realidad el tipo correcto
`shared Nat32 -> async Nat32`.

## Nombrando módulos importados

Aunque la convención más común es identificar los módulos importados por el
nombre del módulo, como se ilustra en los ejemplos anteriores, no hay un
requisito que te obligue a hacerlo. Por ejemplo, podrías querer usar nombres
diferentes para evitar conflictos de nombres o para simplificar el esquema de
nombres.

El siguiente ejemplo ilustra diferentes nombres que podrías usar al importar el
módulo `List` de la biblioteca base, evitando un choque con otra biblioteca
`List` de un paquete ficticio llamado `collections`:

```motoko no-repl
import List "mo:base/List:";
import Sequence "mo:collections/List";
import L "mo:base/List";
```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
