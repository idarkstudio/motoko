---
sidebar_position: 28
---

# Serialización Candid

Candid es un lenguaje de descripción de interfaces y un formato de serialización
diseñado específicamente para el protocolo de Internet Computer. Es un
componente crucial que permite la comunicación fluida entre diferentes servicios
y contratos inteligentes de canisters en ICP, independientemente de los
lenguajes de programación en los que estén implementados.

En esencia, Candid proporciona una forma independiente del lenguaje para
describir y transmitir datos. Las garantías de tipado fuerte aseguran una
interpretación precisa de los datos en varios servicios y lenguajes. Esta
seguridad de tipos se complementa con un formato binario eficiente para
codificar datos, lo que lo hace ideal para la transmisión en red. En el contexto
de Motoko, Candid está profundamente integrado en el lenguaje. Motoko genera
automáticamente interfaces Candid para contratos inteligentes de canisters y
proporciona funciones integradas como `to_candid` y `from_candid` para facilitar
la serialización y deserialización de datos hacia y desde el formato Candid.

En un ámbito más amplio, Candid sirve como el protocolo de comunicación estándar
entre canisters. Cuando un canister llama a otro, los argumentos se serializan
en Candid, se transmiten y luego se deserializan por el canister receptor. Esta
estandarización permite a los desarrolladores crear frontends en lenguajes como
JavaScript que pueden interactuar fácilmente con canisters backend escritos en
Motoko o Rust.

Es importante destacar que el diseño de Candid permite actualizaciones
compatibles con versiones anteriores de las interfaces de los canisters. Esta
característica facilita la evolución de los servicios a lo largo del tiempo, un
aspecto crítico para aplicaciones de larga duración en Internet Computer.

## Serialización explícita de Candid

Los operadores `to_candid` y `from_candid` de Motoko te permiten trabajar con
datos codificados en Candid.

`to_candid (<exp1>, ..., <expn>)` serializa una secuencia de valores de Motoko
en un `Blob` que contiene una codificación binaria Candid de los datos.

Por ejemplo:

```motoko no-repl
let encoding : Blob = to_candid ("dogs", #are, ['g', 'r', 'e', 'a', 't']);
```

`from_candid <exp>` deserializa un `Blob` que contiene datos Candid de vuelta a
un valor de Motoko.

```motoko no-repl
 let ?(t, v, cs) = from_candid encoding : ?(Text, {#are; #are_not}, [Char]);
```

`from_candid` lanzará una excepción si su argumento es un blob que no contiene
datos Candid válidos. Debido a que la deserialización puede fallar si el valor
codificado no tiene el tipo Candid esperado, `from_candid` devuelve un valor de
tipo opción, con `null` indicando que la codificación está bien formada pero del
tipo Candid incorrecto o algún valor `?v`, donde `v` es el valor decodificado.
`from_candid` solo se puede usar en el contexto de otro código que determine su
tipo de resultado opcional, para lo cual puede ser necesaria una anotación de
tipo.

Por ejemplo, este código que subespecifica el tipo esperado del valor
decodificado es rechazado por el compilador:

```motoko no-repl
let ?(t, v, cs) = from_candid encoding;
```

Los operadores `to_candid` y `from_candid` son palabras clave incorporadas en el
lenguaje y manejan la mayoría de los casos de uso comunes automáticamente. Estos
operadores garantizan la seguridad de tipos y la codificación adecuada de datos
sin requerir que los desarrolladores manejen manualmente las complejidades de la
serialización de Candid.

:::danger

Aunque `to_candid` devolverá una codificación Candid válida de su argumento, en
realidad existen muchas codificaciones Candid diferentes y, por lo tanto, blobs,
para el mismo valor. No hay garantía de que `to_candid` siempre devuelva el
mismo `blob`, dado el mismo argumento. Esto significa que nunca debes usar estos
blobs para comparar valores por igualdad o intentar calcular un hash para un
valor mediante el hash de su codificación Candid. El hash de un valor debe ser
único, pero si lo calculas a partir de una de varias codificaciones Candid, es
posible que no lo sea.

:::

Consulta el manual de lenguaje para obtener más detalles sobre la
[`serialización Candid`](../reference/language-manual#candid_serialization).

## Llamadas dinámicas

La mayoría de los usuarios nunca deberían necesitar usar `to_candid` y
`from_candid`. Un escenario en el que estas operaciones son útiles es cuando se
realizan llamadas dinámicas a métodos de canisters utilizando la función `call`
de la biblioteca base `ExperimentalInternetComputer`.

Aunque la mayoría de los canisters en ICP utilizan Candid, esto no está impuesto
por ICP. A nivel de protocolo, los canisters se comunican en datos binarios
crudos. Candid es simplemente una interpretación común de esos datos que permite
que los canisters escritos en diferentes lenguajes interoperen.

La función `call` toma un principal de canister, el nombre de un método como
texto y un `Blob` binario crudo, y devuelve un futuro que contiene el resultado
de la llamada, también como un `Blob` binario crudo.

Las llamadas dinámicas son particularmente útiles cuando se trabaja con
canisters o servicios que tienen interfaces complejas o no estándar, o cuando se
necesita un control detallado sobre el proceso de llamada. Sin embargo,
requieren un manejo manual de la codificación y decodificación binaria, lo que
es más propenso a errores que usar las abstracciones de alto nivel
proporcionadas por Motoko.

Cuando un servicio utiliza Candid y conoces los tipos del método que deseas
invocar, puedes usar `to_candid` y `from_candid` para manejar el formato
binario.

Típicamente, podrías usar `to_candid` para preparar el argumento de una llamada
y `from_candid` para procesar su resultado.

En este ejemplo, usamos la función `call` importada para hacer una llamada
dinámica en el actor:

```motoko no-repl
import Principal "mo:base/Principal";
import {call} "mo:base/ExperimentalInternetComputer";

persistent actor This {

   public func concat(ts : [Text]) : async Text {
      var r = "";
      for (t in ts.values()) { r #= t };
      r
   };

   public func test() : async Text {
       let arguments = to_candid (["a", "b", "c"]);
       let results = await call(Principal.fromActor(This), "concat", arguments);
       let ?t = from_candid(results) : ?Text;
       t
   }

}
```

Mientras que las llamadas dinámicas ofrecen más flexibilidad, deben ser
utilizadas con prudencia. En la mayoría de los casos, los mecanismos estándar de
llamadas entre canisters y el manejo automático de Candid en Motoko proporcionan
un enfoque más seguro y conveniente para las interacciones entre canisters.

## Recursos

Para obtener más información sobre Candid, consulta la documentación aquí:

- [Candid UI](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/candid).

- [Que es Candid?](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/candid/candid-concepts).

- [Usando Candid](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/candid/candid-howto).

- [Especificacion Candid](https://github.com/dfinity/candid/blob/master/spec/Candid.md).

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
