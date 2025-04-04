---
sidebar_position: 6
---

# Identificación del llamador (caller)

Las funciones compartidas (shared functions) de Motoko admiten una forma
sencilla de identificación del llamador que te permite inspeccionar el
**principal** de ICP asociado con el llamador de una función. Los principales
son un valor que identifica a un usuario o canister único.

Puedes utilizar el principal asociado con el llamador de una función para
implementar una forma básica de control de acceso en tu programa.

## Uso de la identificación del llamador

En Motoko, la palabra clave `shared` se utiliza para declarar una función
compartida. La función compartida también puede declarar un parámetro opcional
de tipo `{caller: Principal}`.

Para ilustrar cómo acceder al llamador de una función compartida, considera el
siguiente ejemplo:

```motoko
shared(msg) func inc() : async () {
  // ... msg.caller ...
}
```

En este ejemplo, la función compartida `inc()` especifica un parámetro `msg`, un
registro, y `msg.caller` accede al campo principal de `msg`.

Las llamadas a la función `inc()` no cambian. En cada sitio de llamada, el
principal del llamador es proporcionado por el sistema, no por el usuario. El
principal no puede ser falsificado o suplantado por un usuario malintencionado.

Para acceder al llamador de un constructor de una clase de actor, se utiliza la
misma sintaxis en la declaración de la clase de actor. Por ejemplo:

```motoko
shared(msg) persistent actor class Counter(init : Nat) {
  // ... msg.caller ...
}
```

## Agregando control de acceso

Para extender este ejemplo, supongamos que deseas restringir el actor `Counter`
para que solo pueda ser modificado por el instalador del `Counter`. Para hacer
esto, puedes registrar el principal que instaló el actor vinculándolo a una
variable `owner`. Luego puedes verificar que el llamador de cada método sea
igual a `owner` de la siguiente manera:

```motoko file=../examples/Counters-caller.mo

```

En este ejemplo, la expresión `assert (owner == msg.caller)` hace que las
funciones `inc()` y `bump()` se detengan si la llamada no está autorizada,
evitando cualquier modificación de la variable `count`, mientras que la función
`read()` permite cualquier llamador.

El argumento de `shared` es solo un patrón. Puedes reescribir lo anterior
utilizando coincidencia de patrones:

```motoko file=../examples/Counters-caller-pat.mo

```

:::note

Las declaraciones de actores simples no te permiten acceder a su instalador. Si
necesitas acceder al instalador de un actor, reescribe la declaración del actor
como una clase de actor sin argumentos.

:::

## Registro de principals

Los principals admiten igualdad, ordenación y hash, por lo que puedes almacenar
eficientemente principals en contenedores para funciones como mantener una lista
de permitidos o denegados. Hay más operaciones disponibles en la biblioteca base
[principal](../base/Principal.md).

El tipo de datos `Principal` en Motoko es tanto compartible como estable, lo que
significa que puedes comparar `Principal` directamente para la igualdad.

A continuación se muestra un ejemplo de cómo puedes grabar principals en un
conjunto.

```motoko file=../examples/RecordPrincipals.mo

```

```motoko
import Principal "mo:base/Principal";
import OrderedSet "mo:base/OrderedSet";
import Error "mo:base/Error";

persistent actor {

    // Create set to store principals
    transient var principalSet = Set.Make(Principal.compare);

    var principals : OrderedSet.Set<Principal> = principalSet.empty();

    // Check if principal is recorded
    public shared query(msg) func isRecorded() : async Bool {
        let caller = msg.caller;
        principleSet.contains(principals, caller);
    };

    // Record a new principal
    public shared(msg) func recordPrincipal() : async () {
        let caller = msg.caller;
        if (Principal.isAnonymous(caller)) {
            throw Error.reject("Anonymous principal not allowed");
        };

        principals := principalSet.put(principals, caller)
    };
};
```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
