# Error

Valores de error e inspección.

El tipo `Error` es el argumento de `throw`, parámetro de `catch`. El tipo
`Error` es opaco.

## Tipo `Error`

```motoko no-repl
type Error = Prim.Types.Error
```

Valor de error resultante de las computaciones `async`

## Tipo `ErrorCode`

```motoko no-repl
type ErrorCode = Prim.ErrorCode
```

Código de error para clasificar diferentes tipos de errores de usuario y del
sistema:

```motoko
type ErrorCode = {
  // Error fatal.
  #system_fatal;
  // Error transitorio.
  #system_transient;
  // Respuesta desconocida debido a un plazo perdido.
  #system_unknown;
  // Destino no válido.
  #destination_invalid;
  // Rechazo explícito por parte del código del canister.
  #canister_reject;
  // Canister atrapado.
  #canister_error;
  // Código de error futuro (con código numérico no reconocido).
  #future : Nat32;
  // Error al emitir una llamada entre canisters
  // (indicando que la cola de destino está llena o se ha cruzado el umbral de congelación).
  #call_error : { err_code :  Nat32 }
};
```

## Valor `reject`

```motoko no-repl
let reject : (message : Text) -> Error
```

Crea un error a partir del mensaje con el código `#canister_reject`.

Ejemplo:

```motoko
import Error "mo:base/Error";

Error.reject("Error de ejemplo") // se puede usar como argumento de throw
```

## Valor `code`

```motoko no-repl
let code : (error : Error) -> ErrorCode
```

Devuelve el código de un error.

Ejemplo:

```motoko
import Error "mo:base/Error";

let error = Error.reject("Error de ejemplo");
Error.code(error) // #canister_reject
```

## Valor `message`

```motoko no-repl
let message : (error : Error) -> Text
```

Devuelve el mensaje de un error.

Ejemplo:

```motoko
import Error "mo:base/Error";
import Debug "mo:base/Debug";

let error = Error.reject("Error de ejemplo");
Error.message(error) // "Error de ejemplo"
```
