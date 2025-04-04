---
sidebar_position: 1
---

# Escribiendo código en Motoko

El lenguaje de programación Motoko es un lenguaje nuevo, moderno y seguro en
tipos para desarrolladores que desean construir la próxima generación de
aplicaciones distribuidas en ICP, ya que está específicamente diseñado para
admitir las características únicas de ICP mientras proporciona un entorno de
programación familiar pero robusto. Como un lenguaje nuevo, Motoko está en
constante evolución con soporte para nuevas características y otras mejoras.

El compilador de Motoko, la documentación y otras herramientas son de
[código abierto](https://github.com/dfinity/motoko) y se publican bajo la
licencia Apache 2.0. Las contribuciones son bienvenidas.

## Actores

Un
[contrato inteligente de canister](https://internetcomputer.org/docs/current/developer-docs/getting-started/development-workflow)
se expresa como un [actor](actors-async.md) de Motoko. Un actor es un objeto
autónomo que encapsula completamente su estado y se comunica con otros actores
solo a través de mensajes asíncronos.

Por ejemplo, este código define un actor `Counter` con estado:

```motoko name=counter file=../examples/Counter.mo

```

Su única función pública, `inc()`, puede ser invocada por este y otros actores,
para actualizar y leer el estado actual de su campo privado `value`.

## Mensajes asíncronos

En ICP, los
[canisters pueden comunicarse](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/call/overview)
con otros canisters enviando [mensajes asíncronos](async-data.md). Los mensajes
asíncronos son llamadas a funciones que devuelven un **futuro**, y utilizan una
construcción `await` que te permite suspender la ejecución hasta que un futuro
se haya completado. Esta característica simple evita la creación de un bucle de
devoluciones de llamada asíncronas explícitas en otros lenguajes.

```motoko no-repl file=../examples/factorial.mo#L9-L21

```

## Sistema de tipos moderno

Motoko ha sido diseñado para ser intuitivo para aquellos familiarizados con
JavaScript y otros lenguajes populares, pero ofrece características modernas
como tipos estructurales sólidos, genéricos, tipos variantes y coincidencia de
patrones verificada estáticamente.

```motoko file=../examples/tree.mo

```

## Archivos IDL autogenerados

Un actor de Motoko siempre presenta una interfaz tipada a sus clientes como un
conjunto de funciones nombradas con tipos de argumentos y resultados.

El compilador de Motoko y el SDK de IC pueden emitir esta interfaz en un formato
neutral de lenguaje llamado [Candid](candid-ui.md). Otros canisters, código
residente en el navegador y aplicaciones móviles que admiten Candid pueden usar
los servicios del actor. El compilador de Motoko puede consumir y producir
archivos Candid, lo que permite que Motoko interactúe sin problemas con
canisters implementados en otros lenguajes de programación (siempre que admitan
Candid).

Por ejemplo, el actor `Counter` de Motoko anterior tiene la siguiente interfaz
Candid:

```candid
service Counter : {
  inc : () -> (nat);
}
```

## Persistencia ortogonal

ICP persiste la memoria y otros estados de tu canister mientras se ejecuta. El
estado de un actor Motoko, incluyendo sus estructuras de datos en memoria,
sobrevive indefinidamente. El estado del actor no necesita ser restaurado y
guardado explícitamente en almacenamiento externo.

Por ejemplo, en el siguiente actor `Registry` que asigna IDs secuenciales a
nombres de texto, el estado de la tabla hash se preserva a través de las
llamadas, incluso cuando el estado del actor se replica en muchas máquinas nodos
de ICP y típicamente no reside en memoria:

```motoko file=../examples/Registry.mo

```

## Actualizaciones

Motoko proporciona numerosas características para ayudarte a aprovechar la
persistencia ortogonal, incluida la capacidad de retener los datos de un
canister mientras [actualizas](../canister-maintenance/upgrades.md) el código
del canister.

Por ejemplo, Motoko te permite declarar ciertas variables como `stable`. Estas
variables se conservan automáticamente entre actualizaciones de canisters.

Considera un contador estable:

```motoko file=../examples/StableCounter.mo

```

Puede ser instalado, incrementado _n_ veces y luego actualizado sin
interrupción:

```motoko file=../examples/StableCounterUpgrade.mo

```

El `valor` fue declarado `estable`, lo que significa que el estado actual, _n_,
del servicio se conserva después de la actualización. El conteo continuará desde
_n_, no se reiniciará desde `0`.

La nueva interfaz es compatible con la anterior, lo que permite que los clientes
existentes que hacen referencia al canister sigan funcionando. Los nuevos
clientes podrán aprovechar su funcionalidad actualizada, en este ejemplo la
función adicional `reset`.

Para hacer más conveniente la declaración de variables estables y evitar
declaraciones `estable` faltantes, Motoko te permite agregar el prefijo
`persistent` a todo el actor. En un actor `persistent`, todas las declaraciones
son `estables` de forma predeterminada. Solo las declaraciones marcadas
explícitamente como `transient` se descartarán en la actualización.

```motoko file=../examples/PersistentStableCounter.mo

```

En este ejemplo, `value` ahora es implícitamente estable, mientras que
`invocations` es solo una declaración temporal transitoria que no sobrevivirá a
las actualizaciones: cuenta el número de llamadas a `inc` desde la primera
instalación o la última actualización.

Para escenarios que no se pueden resolver solo con variables estables, Motoko
proporciona ganchos de actualización definidos por el usuario que se ejecutan
inmediatamente antes y después de una actualización, lo que te permite migrar
estados arbitrarios a variables estables.

## Organización del código fuente

Motoko permite separar diferentes partes del código en el archivo `main.mo` en
módulos separados. Esto puede ser útil para dividir grandes piezas de código
fuente en fragmentos más pequeños y manejables.

Un enfoque común es excluir las definiciones de tipos del archivo `main.mo` e
incluirlas en un archivo `Types.mo`.

Otro enfoque es declarar variables estables y métodos públicos en el archivo
`main.mo` y luego separar toda la lógica y los tipos en otros archivos. Este
flujo de trabajo puede ser beneficioso para realizar pruebas unitarias de manera
eficiente.

## Siguientes pasos

Para comenzar a escribir código en Motoko, comienza leyendo la documentación
detallada de algunos de los conceptos descritos anteriormente:

- [Actores](actors-async.md)

- [Clases de actores](actor-classes.md)

- [Datos asíncronos](async-data.md)

- [Identificación llamador](caller-id.md)

El lenguaje de programación Motoko continúa evolucionando con cada versión del
[IC SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install)
y con las actualizaciones continuas del compilador de Motoko. Vuelve
regularmente para probar nuevas características y ver qué ha cambiado.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
