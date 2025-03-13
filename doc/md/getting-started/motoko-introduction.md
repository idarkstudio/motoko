---
sidebar_position: 1
---

# Conoce Motoko: El lenguaje que está dando forma al futuro de Web3

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />

Motoko es un lenguaje de programación moderno y de propósito general que puedes
usar específicamente para desarrollar ICP canister smart contracts. Aunque está
dirigido principalmente al desarrollo de canisters en ICP, su diseño es lo
suficientemente general como para admitir compilación a otros objetivos en el
futuro.

Motoko está diseñado para ser accesible a programadores con conocimientos
básicos en paradigmas de programación orientada a objetos y/o funcional en
JavaScript u otros lenguajes modernos como Rust, Swift, TypeScript, C# o Java.

```motoko
// A simple Motoko smart contract.

actor Main {
  public query func hello() : async Text {
    "Hello, world!"
  };
};

await Main.hello();
```

Motoko proporciona:

- Un lenguaje de alto nivel para programar aplicaciones que se ejecuten en ICP.

- Un diseño simple que utiliza una sintaxis familiar y fácil de aprender para
  los programadores.

- Un modelo de programación basado en **actores**, optimizado para el manejo
  eficiente de mensajes.

- **Persistencia ortogonal** para un almacenamiento de datos simple, seguro y
  eficiente sin necesidad de una base de datos o memoria secundaria.

- Un intérprete y un compilador que puedes utilizar para probar y compilar el
  código WebAssembly para aplicaciones autónomas.

# ¿Por qué Motoko?

ICP admite programas escritos en diferentes lenguajes. El único requisito es que
el programa debe poder compilarse a código WebAssembly. WebAssembly es un
formato de instrucciones de bajo nivel para máquinas virtuales. Dado que el
código WebAssembly está diseñado para proporcionar instrucciones portátiles de
bajo nivel que permiten desplegar aplicaciones en múltiples plataformas como la
web, es una opción natural para aplicaciones que se ejecuten en ICP. Sin
embargo, la mayoría de los lenguajes de alto nivel que pueden compilarse a
WebAssembly son inseguros o demasiado complejos para los desarrolladores que
buscan entregar aplicaciones seguras sin una curva de aprendizaje prolongada.

Para abordar la necesidad de corrección sin complejidad, DFINITY ha diseñado su
propio lenguaje de programación Motoko. Motoko proporciona una alternativa
simple y expresiva a otros lenguajes de programación y es fácil de aprender
tanto para programadores principiantes como experimentados.

## Motivación y objetivos

Motoko busca ser un lenguaje simple y útil para los smart contracts de ICP,
utilizando una sintaxis familiar que incorpora el modelo de actores. Motoko
ofrece una integración perfecta con las características de ICP y aprovecha al
máximo las funcionalidades presentes y futuras de WebAssembly.

Motoko no es, ni pretende ser, el único lenguaje para implementar canister smart
contracts. Existen kits de desarrollo de canisters para Rust, TypeScript, Python
y próximamente Solidity. El objetivo de ICP es permitir que cualquier lenguaje
pueda producir canister smart contracts compilando el código fuente del canister
a WebAssembly.

Sin embargo, su diseño especializado hace que Motoko sea el lenguaje más fácil y
seguro para programar en ICP.

## Puntos clave de diseño

Motoko ofrece muchas otras características para mejorar la productividad de los
desarrolladores. Ha tomado inspiración de lenguajes como Java, JavaScript, C#,
Swift, Pony, ML y Haskell.

La sintaxis de Motoko debería resultar familiar para los programadores de
JavaScript, pero sin las peculiaridades de JavaScript.

Motoko es un lenguaje concurrente y orientado a actores, con soporte conveniente
para el control de concurrencia utilizando `async/await` y futuros. Su núcleo es
un lenguaje funcional impuro con evaluación por valor, con características
imperativas y orientadas a objetos.

Motoko es fuertemente tipado y ofrece tipos opción, registros, variantes,
genéricos y subtipado. Su sistema de tipos es estructural, lo que significa que
los tipos con nombres diferentes pero definiciones equivalentes son
intercambiables; el subtipado permite usar valores en su tipo preciso, pero
también en cualquier supertipo más general.

- Motoko está orientado a la seguridad.
- La gestión de memoria es automática mediante un recolector de basura.
- Se evitan valores nulos implícitos. Los nulos deben manejarse explícitamente
  mediante tipos opción.
- El sistema de tipos no puede ser evitado usando conversiones inseguras
  (`unsafe`).
- La aritmética utiliza enteros sin límite que no pueden desbordarse o, cuando
  se usan enteros con límite, emplea aritmética verificada que genera errores en
  caso de desbordamiento.
- Todas las conversiones entre tipos no relacionados son explícitas.
- La promoción implícita de un valor a otro tipo solo puede lograrse mediante
  subtipado, una operación de costo cero.
- El soporte de Motoko para la coincidencia de patrones (`pattern matching`)
  concisa y verificada por el compilador fomenta un buen estilo de codificación
  y código auditable.
- No se admite la herencia orientada a objetos, ya que puede ser propensa a
  errores.

Los canisters en Motoko son compilados, no interpretados, produciendo binarios
pequeños con buen rendimiento.

### Soporte nativo para canister smart contracts

Motoko tiene soporte nativo para los canister smart contracts, los cuales se
expresan como un actor de Motoko. Un actor es un objeto autónomo que encapsula
completamente su estado y se comunica con otros actores únicamente mediante
mensajes asíncronos.

### Programación secuencial en estilo directo

En ICP, los canisters pueden comunicarse entre sí enviando mensajes asíncronos.

La programación asíncrona puede ser complicada, por lo que Motoko permite
escribir código asíncrono en un estilo secuencial mucho más simple. Los mensajes
asíncronos son llamadas a funciones que devuelven un futuro, y la construcción
`await` permite suspender la ejecución hasta que un futuro se haya completado.

### Sistema de tipos moderno

Motoko ha sido diseñado para ser intuitivo para quienes están familiarizados con
JavaScript y otros lenguajes populares, pero ofrece características modernas
como tipos estructurales seguros, genéricos, tipos de variantes y verificación
estática de coincidencia de patrones.

### Archivos IDL generados automáticamente

Un actor de Motoko siempre presenta una interfaz tipada a sus clientes,
compuesta por un conjunto de funciones nombradas con argumentos y tipos de
resultados futuros.

El compilador de Motoko y el IC SDK pueden generar esta interfaz en un formato
independiente del lenguaje llamado Candid, para que otros canisters, código
residente en el navegador y aplicaciones móviles que admitan Candid puedan usar
los servicios del actor. El compilador de Motoko puede consumir y producir
archivos Candid, permitiendo que Motoko interactúe sin problemas con canisters
implementados en otros lenguajes de programación, siempre que también admitan
Candid.

### Persistencia ortogonal

ICP persiste la memoria y otra información de estado de un canister a medida que
se ejecuta. Por lo tanto, el estado de un actor de Motoko, incluidas sus
estructuras de datos en memoria, sobrevive indefinidamente. El estado del actor
no necesita ser restaurado ni guardado explícitamente en un almacenamiento
externo.

### Actualizaciones

Motoko proporciona numerosas funciones para ayudarte a aprovechar la
persistencia ortogonal, incluidas características del lenguaje que permiten
conservar los datos de un canister mientras se actualiza su código.

Por ejemplo, Motoko permite declarar ciertas variables como `stable`. Los
valores de las variables `stable` se preservan automáticamente a través de las
actualizaciones del canister.

Una vez actualizado, la nueva interfaz es compatible con la anterior, lo que
significa que los clientes existentes que hagan referencia al canister seguirán
funcionando, pero los nuevos clientes podrán aprovechar sus funcionalidades
mejoradas. Para cambios más complejos, Motoko proporciona una forma segura de
realizar
[migraciones explícitas](../canister-maintenance/compatibility.md#explicit-migration).

## Primeros pasos

Comienza con Motoko [configurando tu entorno de desarrollo](dev-env.md) y
creando un programa simple [¡Hola, mundo!](quickstart.md).
