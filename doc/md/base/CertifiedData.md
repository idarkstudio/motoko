# CertifiedData

Datos certificados.

Internet Computer permite que los contratos inteligentes de canister almacenen
una pequeña cantidad de datos durante el procesamiento del método de
actualización para que, durante el procesamiento de la llamada de consulta, el
canister pueda obtener un certificado sobre esos datos.

Este módulo proporciona una interfaz _de bajo nivel_ a esta API, dirigida a
usuarios avanzados e implementadores de bibliotecas. Consulta la Especificación
Funcional de Internet Computer y la documentación correspondiente para saber
cómo utilizar esto para hacer llamadas de consulta a tu canister a prueba de
manipulaciones.

## Valor `set`

```motoko no-repl
let set : (data : Blob) -> ()
```

Establece los datos certificados.

Debe ser llamado desde un método de actualización, de lo contrario, se
producirán trampas. Debe pasarse un blob de hasta 32 bytes, de lo contrario, se
producirán trampas.

Ejemplo:

```motoko no-repl
import CertifiedData "mo:base/CertifiedData";
import Blob "mo:base/Blob";

// Must be in an update call

let array : [Nat8] = [1, 2, 3];
let blob = Blob.fromArray(array);
CertifiedData.set(blob);
```

Consulta un ejemplo completo sobre cómo utilizar variables certificadas aquí:
https://github.com/dfinity/examples/tree/master/motoko/cert-var

## Valor `getCertificate`

```motoko no-repl
let getCertificate : () -> ?Blob
```

Obtiene un certificado.

Devuelve `null` si no hay un certificado disponible, por ejemplo, al procesar
una llamada de actualización o una llamada entre canisters. Esto devuelve un
valor no nulo solo cuando se procesa una llamada de consulta.

Ejemplo:

```motoko no-repl
import CertifiedData "mo:base/CertifiedData";
// Must be in a query call

CertifiedData.getCertificate();
```

Consulta un ejemplo completo sobre cómo utilizar variables certificadas aquí:
https://github.com/dfinity/examples/tree/master/motoko/cert-var
