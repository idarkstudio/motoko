---
sidebar_position: 2
---

# Actores

El modelo de programación de Internet Computer consiste en canisters aislados en
memoria que se comunican mediante el paso de mensajes asíncronos de datos
binarios que codifican valores Candid. Un canister procesa sus mensajes uno a la
vez, evitando condiciones de carrera. Un canister utiliza devoluciones de
llamada (call-backs) para registrar lo que debe hacerse con el resultado de
cualquier mensaje entre canisters que emita.

Motoko proporciona un modelo de programación **basado en actores** a los
desarrolladores para expresar **servicios**, incluidos los de contratos
inteligentes de canisters en ICP. Cada canister se representa como un actor
tipado. El tipo de un actor enumera los mensajes que puede manejar. Cada mensaje
se abstrae como una función asíncrona tipada. Una traducción de tipos de actores
a tipos Candid impone estructura en los datos binarios subyacentes de Internet
Computer. Un actor es similar a un objeto, pero es diferente en que su estado
está completamente aislado, sus interacciones con el mundo son completamente a
través de mensajería asíncrona, y sus mensajes se procesan uno a la vez, incluso
cuando se emiten en paralelo por actores concurrentes.

# Actores

Un actor es similar a un objeto, pero es diferente en que:

- Su estado está completamente aislado.

- Sus interacciones con el mundo se realizan completamente a través de
  mensajería asíncrona.

- Sus mensajes se procesan uno a la vez, incluso cuando se emiten en paralelo
  por actores concurrentes.

Toda comunicación con y entre actores implica el paso de mensajes asíncronos a
través de la red utilizando el protocolo de mensajería de Internet Computer. Los
mensajes de un actor se procesan en secuencia, por lo que las modificaciones de
estado nunca admiten condiciones de carrera, a menos que se permita
explícitamente mediante el uso de expresiones `await`.

Internet Computer garantiza que cada mensaje enviado recibe una respuesta. La
respuesta es éxito con algún valor o un error. Un error puede ser el rechazo
explícito del mensaje por parte del canister receptor, un error debido a una
instrucción ilegal como la división por cero, o un error del sistema debido a
restricciones de distribución o recursos. Por ejemplo, un error del sistema
podría ser la indisponibilidad transitoria o permanente del receptor (ya sea
porque el actor receptor está sobresuscrito o ha sido eliminado).

En Motoko, los actores tienen sintaxis y tipos dedicados:

- La mensajería se maneja mediante las llamadas funciones **compartidas
  (shared)** que devuelven futuros. Las funciones compartidas son accesibles
  para llamadas remotas y tienen restricciones adicionales: sus argumentos y
  valor de retorno deben ser tipos compartidos. Los tipos compartidos son un
  subconjunto de tipos que incluye datos inmutables, referencias a actores y
  referencias a funciones compartidas, pero excluye referencias a funciones
  locales y datos mutables.

- Un futuro, `f`, es un valor del tipo especial `async T` para algún tipo `T`.

- Esperar a que `f` se complete se expresa usando `await f` para obtener un
  valor de tipo `T`. Para evitar introducir estado compartido a través de la
  mensajería, por ejemplo, enviando un objeto o un arreglo mutable, los datos
  que se pueden transmitir a través de funciones compartidas están restringidos
  a tipos compartidos inmutables.

- Todo el estado debe encapsularse dentro del actor o clase de actor. El archivo
  principal del actor debe comenzar con importaciones, seguidas de la definición
  del actor o clase de actor.

## Definiendo un actor

Considera la siguiente declaración de actor:

```motoko file=../examples/counter-actor.mo

```

El actor `Counter` declara un campo y tres funciones públicas y compartidas:

- El campo `count` es mutable, inicializado en cero e implícitamente `private`.

- La función `inc()` incrementa asincrónicamente el contador y devuelve un
  futuro de tipo `async ()` para sincronización.

- La función `read()` lee asincrónicamente el valor del contador y devuelve un
  futuro de tipo `async Nat` que contiene su valor.

- La función `bump()` incrementa y lee asincrónicamente el contador.

Las funciones compartidas, a diferencia de las funciones locales, son accesibles
para llamadas remotas y tienen restricciones adicionales. Sus argumentos y valor
de retorno deben ser de tipo compartido. Los tipos compartidos son un
subconjunto de tipos que incluye datos inmutables, referencias a actores y
referencias a funciones compartidas, pero excluye referencias a funciones
locales y datos mutables. Debido a que toda la interacción con los actores es
asíncrona, las funciones de un actor deben devolver futuros, es decir, tipos de
la forma `async T`, para algún tipo `T`. La única forma de leer o modificar el
estado (`count`) del actor `Counter` es a través de sus funciones compartidas.

Un valor de tipo `async T` es un futuro. El productor del futuro completa el
futuro cuando devuelve un resultado, ya sea un valor o un error.

A diferencia de los objetos y módulos, los actores solo pueden exponer
funciones, y estas funciones deben ser `shared`. Por esta razón, Motoko te
permite omitir el modificador `shared` en las funciones públicas del actor, lo
que permite una declaración más concisa pero equivalente del actor:

```motoko name=counter file=../examples/counter-actor-sugar.mo

```

Para ahora, el único lugar donde se pueden declarar funciones compartidas es en
el cuerpo de un actor o clase de actor. A pesar de esta restricción, las
funciones compartidas siguen siendo valores de primera clase en Motoko y se
pueden pasar como argumentos o resultados, y almacenarse en estructuras de
datos.

El tipo de una función compartida se especifica utilizando un tipo de función
compartida. Por ejemplo, el valor `inc` tiene el tipo `shared () → async Nat` y
se podría suministrar como una devolución de llamada independiente a algún otro
servicio.

## Tipos de actores

Así como los objetos tienen tipos de objetos, los actores tienen tipos de
actores. El ejemplo de `Counter` anterior tiene el siguiente tipo:

```motoko no-repl
actor {
  inc  : shared () -> async ();
  read : shared () -> async Nat;
  bump : shared () -> async Nat;
}
```

El modificador `shared` es requerido en cada miembro de un actor. Motoko los
omite en la visualización y te permite omitirlos al escribir un tipo de actor.

Por lo tanto, el tipo anterior puede expresarse de manera más concisa como:

```motoko no-repl
actor {
  inc  : () -> async ();
  read : () -> async Nat;
  bump : () -> async Nat;
}
```

Al igual que los tipos de objetos, los tipos de actores admiten subtipos: un
tipo de actor es un subtipo de uno más general que ofrece menos funciones con
tipos más generales.

## Comportamiento asíncrono

Al igual que otros lenguajes de programación modernos, Motoko permite una
sintaxis ergonómica para la comunicación **asíncrona** entre componentes.

En el caso de Motoko, cada componente de comunicación es un actor. Como ejemplo
de uso de actores, considera este programa de tres líneas:

```motoko no-repl
let result1 = service1.computeAnswer(params);
let result2 = service2.computeAnswer(params);
finalStep(await result1, await result2)
```

Este programa se puede resumir en el siguiente comportamiento:

1. El programa realiza dos solicitudes (líneas 1 y 2) a dos servicios distintos,
   cada uno implementado como un actor Motoko o un contrato inteligente de
   canister implementado en otro lenguaje.

2. El programa espera a que cada resultado esté listo (línea 3) utilizando la
   palabra clave `await` en cada valor de resultado.

3. El programa utiliza ambos resultados en el paso final (línea 3) llamando a la
   función `finalStep`.

Los servicios **entrelazan** sus ejecuciones en lugar de esperarse unos a otros,
ya que esto reduce la latencia general. Si intentas reducir la latencia de esta
manera sin soporte especial del lenguaje, dicho entrelazamiento rápidamente
sacrificará la claridad y la simplicidad.

Incluso en casos donde no hay ejecuciones entrelazadas, por ejemplo, si hubiera
solo una llamada arriba, no dos, las abstracciones de programación aún permiten
claridad y simplicidad por la misma razón. Es decir, le indican al compilador
dónde transformar el programa, liberando al programador de tener que
distorsionar la lógica del programa para entrelazar su ejecución con el bucle de
paso de mensajes del sistema subyacente.

En el ejemplo anterior, el programa usa `await` en la línea 3 para expresar ese
comportamiento de entrelazado de una manera simple.

En otros lenguajes de programación que carecen de estas abstracciones, los
desarrolladores no solo llamarían a estas dos funciones directamente, sino que
emplearían patrones de programación muy avanzados, posiblemente registrando
"funciones de devolución de llamada" proporcionadas por el desarrollador dentro
de "manejadores de eventos" proporcionados por el sistema. Cada devolución de
llamada manejaría un evento asíncrono que surge cuando una respuesta está lista.
Este tipo de programación a nivel de sistemas es potente, pero muy propenso a
errores, ya que descompone un flujo de datos de alto nivel en eventos de sistema
de bajo nivel que se comunican a través de un estado compartido.

## Trampas y puntos de confirmación

un error es un fallo en tiempo de ejecución no recuperable causado por errores
como división por cero, indexación de arreglos fuera de límites, desbordamiento
numérico, agotamiento de ciclos o fallo de aserción.

Una llamada a una función compartida que se ejecuta sin ejecutar una expresión
`await` nunca se suspende y se ejecuta atómicamente. Una función compartida que
no contiene ninguna expresión `await` es sintácticamente atómica.

### Puntos de confirmación

Una función compartida atómica cuya ejecución genera un error no tiene ningún
efecto visible en el estado del actor que la contiene o en su entorno: cualquier
cambio de estado se revierte y cualquier mensaje que haya enviado se revoca. De
hecho, todos los cambios de estado y envíos de mensajes son tentativos durante
la ejecución: solo se confirman después de alcanzar un punto de confirmación
exitoso.

Los puntos en los que los cambios de estado tentativos y los envíos de mensajes
se confirman irrevocablemente son:

- Salida implícita de una función compartida al producir un resultado.

- Salida explícita mediante expresiones `return` o `throw`.

- Expresiones `await` explícitas.

### Errores (traps)

Un error solo revocará los cambios realizados desde el último punto de
confirmación. En particular, en una función no atómica que realiza múltiples
`await`, un error solo revocará los cambios intentados desde el último `await`:
todos los efectos anteriores se habrán confirmado y no se pueden deshacer.

Considera el siguiente actor con estado `Atomicidad`:

```motoko no-repl file=../examples/atomicity.mo

```

Llamar a la función compartida `atomic()` fallará con un error, ya que la última
instrucción causa una trampa. Sin embargo, la trampa deja la variable mutable
`s` con el valor `0`, no `1`, y la variable `pinged` con el valor `false`, no
`true`. Esto se debe a que la trampa ocurre antes de que el método `atomic` haya
ejecutado un `await`, o haya salido con un resultado. Aunque `atomic` llama a
`ping()`, `ping()` se encola hasta el próximo punto de confirmación.

Llamar a la función compartida `nonAtomic()` también fallará con un error debido
a una trampa. En esta función, la trampa deja la variable `s` con el valor `3`,
no `0`, y la variable `pinged` con el valor `true`, no `false`. Esto se debe a
que cada `await` confirma sus efectos secundarios anteriores, incluyendo el
envío de mensajes. Aunque `f` está completo en el segundo `await`, este `await`
también obliga a confirmar el estado, suspende la ejecución y permite el
procesamiento intercalado de otros mensajes a este actor.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
