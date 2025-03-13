---
sidebar_position: 12
---

# Llamadas entre canisters

Una de las características más importantes de ICP para los desarrolladores es la
capacidad de llamar a funciones en un canister desde otro canister. Esta
capacidad de hacer llamadas entre canisters, a veces denominada **llamadas
inter-canisters**, te permite reutilizar y compartir funcionalidad en múltiples
dapps.

Por ejemplo, es posible que desees crear una dapp para redes profesionales,
organizar eventos comunitarios o albergar actividades de recaudación de fondos.
Cada una de estas dapps podría tener un componente social que permita a los
usuarios identificar relaciones sociales basadas en algún criterio o interés
compartido, como amigos y familiares o colegas actuales y anteriores.

Para abordar este componente social, podrías crear un solo canister para
almacenar relaciones de usuarios y luego escribir tu aplicación de redes
profesionales, organización comunitaria o recaudación de fondos para importar y
llamar a funciones que están definidas en el canister para conexiones sociales.
Luego, podrías construir aplicaciones adicionales para usar el canister de
conexiones sociales o extender las características proporcionadas por el
canister de conexiones sociales para que sea útil para una comunidad aún más
amplia de otros desarrolladores.

## Uso básico

Una forma sencilla de configurar llamadas entre canisters es a través del
archivo `dfx.json` de tu proyecto.

Por ejemplo, supongamos que deseas construir un canister llamado `foo` que llama
al canister `bar`. Aquí está el archivo `dfx.json`:

```json
{
  "canisters": {
    "foo": {
      "dependencies": ["bar"],
      "type": "motoko",
      "main": "src/Foo.mo"
    },
    "bar": {
      "type": "motoko",
      "main": "src/Bar.mo"
    }
  }
}
```

Observa que `foo` incluye `bar` como una dependencia de canister.

A continuación se muestra un ejemplo de implementación de `foo` (`src/Foo.mo`)
que llama al canister `bar`:

```motoko no-repl
import Bar "canister:bar";

persistent actor Foo {

  public func main() : async Nat {
    let value = await Bar.getValue(); // Call a method on the `bar` canister
    value;
  };

};
```

A continuación se muestra una implementación para `bar` (`src/Bar.mo`):

```motoko
import Debug "mo:base/Debug";

persistent actor Bar {

  public func getValue() : async Nat {
    Debug.print("Hello from the `bar` canister!");
    123;
  };

};
```

Para ejecutar este ejemplo, puedes usar el subcomando `dfx canister call`
(después de implementar los canisters con `dfx deploy`):

```bash
dfx canister call foo main
```

La salida debería parecerse a lo siguiente:

```bash
2025-02-21 15:53:39.567801 UTC: [Canister ajuq4-ruaaa-aaaaa-qaaga-cai] Hello from the `bar` canister!
(123 : nat)
```

Puedes usar también un ID de canister para acceder a un canister previamente
desplegado, como se muestra en esta implementación alternativa de `foo`:

```motoko
persistent actor Foo {
  public func main(canisterId: Text) : async Nat {
    let Bar = actor(canisterId): actor {
      getValue: () -> async Nat; // Define the expected canister interface
    };
    let value = await Bar.getValue(); // Call the canister
    value;
  };

};
```

Luego, usa la siguiente llamada, reemplazando `canister-id` con el ID de un
canister implementado previamente:

```bash
dfx canister call foo main "canister-id"
```

## Uso avanzado

Si el nombre del método o los tipos de entrada son desconocidos en tiempo de
compilación, es posible llamar a métodos arbitrarios de canisters utilizando el
módulo `ExperimentalInternetComputer`.

Aquí tienes un ejemplo que puedes modificar para tu caso de uso específico:

```motoko
import IC "mo:base/ExperimentalInternetComputer";
import Debug "mo:base/Debug";

persistent actor AdvancedCanister1 {

  public func main(canisterId : Principal) : async Nat {
    // Define the method name and input args
    let name = "getValue";
    let args = (123);

    // Call the method
    let encodedArgs = to_candid (args);
    let encodedValue = await IC.call(canisterId, name, encodedArgs);

    // Decode the return value
    let ?value : ?Nat = from_candid encodedValue else Debug.trap("Unexpected return value");
    value;
  };

}
```

```motoko
import Debug "mo:base/Debug";

persistent actor AdvancedCanister2 {

  public func getValue(number: Nat) : async Nat {
     Debug.print("Hello from advanced canister 2!");
     return number * 2;
  };

};
```

En algunas situaciones, puede ser útil hacer referencia a un canister por su ID.
Esto es posible con la siguiente sintaxis de importación:

```motoko
import Canister "ic:7hfb6-caaaa-aaaar-qadga-cai";
```

Si haces esto, verifica que el canister referenciado esté disponible y tenga el
mismo ID de canister en todos los entornos de ejecución previstos (por lo
general, la réplica local y la red principal de ICP).

Además, debe estar disponible un archivo `.did` correspondiente con el nombre
`7hfb6-caaaa-aaaar-qadga-cai.did`, que contenga la interfaz Candid del canister
importado, en la ruta `actor-idl` del compilador `moc`.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
