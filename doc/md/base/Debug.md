# Debug

Funciones de utilidad para depurar (debugging).

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Debug "mo:base/Debug";
```

## Función `print`

```motoko no-repl
func print(text : Text)
```

Imprime `text` en la salida.

NOTA: Cuando se ejecuta en una red ICP, toda la salida se escribe en el
[registro del canister](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/maintain/logs)
con la exclusión de cualquier salida producida durante la ejecución de consultas
no replicadas y consultas compuestas. En otros entornos, como el intérprete y
motores wasm independientes, la salida se escribe en la salida estándar.

```motoko include=import
Debug.print "¡Hola Nuevo Mundo!";
Debug.print(debug_show(4)) // A menudo se usa con `debug_show` para convertir valores a Text
```

## Función `trap`

```motoko no-repl
func trap(errorMessage : Text) : None
```

`trap(t)` atrapa la ejecución con un mensaje de diagnóstico proporcionado por el
usuario.

El llamador de un futuro cuya ejecución llamó a `trap(t)` observará el error
como un valor `Error`, lanzado en `await`, con el código `#canister_error` y el
mensaje `m`. Aquí, `m` es un mensaje `Texto` más descriptivo derivado del
proporcionado `t`. Consulta el ejemplo para más detalles.

NOTA: Otros entornos de ejecución que no pueden manejar errores pueden propagar
el error y terminar la ejecución, con o sin algún mensaje descriptivo.

```motoko
import Debug "mo:base/Debug";
import Error "mo:base/Error";

actor {
  func fail() : async () {
    Debug.trap("mensaje de error proporcionado por el usuario");
  };

  public func foo() : async () {
    try {
      await fail();
    } catch e {
      let code = Error.code(e); // evalúa a #canister_error
      let message = Error.message(e); // contiene el mensaje de error proporcionado por el usuario
    }
  };
}
```
