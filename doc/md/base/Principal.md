# Principal

Módulo para interactuar con Principals (usuarios y canisters).

Los Principals se utilizan para identificar entidades que pueden interactuar con
Internet Computer. Estas entidades pueden ser usuarios o canisters.

Ejemplo de representación textual de Principals:

`un4fu-tqaaa-aaaab-qadjq-cai`

En Motoko, hay un tipo primitivo de Principal llamado `Principal`. Como ejemplo
de dónde podrías ver Principals, puedes acceder al Principal del llamador de tu
función compartida.

```motoko no-repl
shared(msg) func foo() {
  let caller : Principal = msg.caller;
};
```

Luego, puedes usar este módulo para trabajar con el `Principal`.

Importa desde la biblioteca base para usar este módulo.

```motoko name=import
import Principal "mo:base/Principal";
```

## Tipo `Principal`

```motoko no-repl
type Principal = Prim.Types.Principal
```

## Función `fromActor`

```motoko no-repl
func fromActor(a : actor {  }) : Principal
```

Obtiene el identificador `Principal` de un actor.

Ejemplo:

```motoko include=import no-repl
actor MyCanister {
  func getPrincipal() : Principal {
    let principal = Principal.fromActor(MyCanister);
  }
}
```

## Función `toLedgerAccount`

```motoko no-repl
func toLedgerAccount(principal : Principal, subAccount : ?Blob) : Blob
```

Calcula el identificador de cuenta Ledger de un principal. Opcionalmente,
especifica una subcuenta.

Ejemplo:

```motoko include=import
let principal = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let subAccount : Blob = "\4A\8D\3F\2B\6E\01\C8\7D\9E\03\B4\56\7C\F8\9A\01\D2\34\56\78\9A\BC\DE\F0\12\34\56\78\9A\BC\DE\F0";
let account = Principal.toLedgerAccount(principal, ?subAccount); // => \8C\5C\20\C6\15\3F\7F\51\E2\0D\0F\0F\B5\08\51\5B\47\65\63\A9\62\B4\A9\91\5F\4F\02\70\8A\ED\4F\82
```

## Función `toBlob`

```motoko no-repl
func toBlob(p : Principal) : Blob
```

Convierte un `Principal` a su representación `Blob` (bytes).

Ejemplo:

```motoko include=import
let principal = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let blob = Principal.toBlob(principal); // => \00\00\00\00\00\30\00\D3\01\01
```

## Función `fromBlob`

```motoko no-repl
func fromBlob(b : Blob) : Principal
```

Convierte una representación `Blob` (bytes) de un `Principal` a un valor
`Principal`.

Ejemplo:

```motoko include=import
let blob = "\00\00\00\00\00\30\00\D3\01\01" : Blob;
let principal = Principal.fromBlob(blob);
Principal.toText(principal) // => "un4fu-tqaaa-aaaab-qadjq-cai"
```

## Función `toText`

```motoko no-repl
func toText(p : Principal) : Text
```

Convierte un `Principal` a su representación `Text`.

Ejemplo:

```motoko include=import
let principal = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
Principal.toText(principal) // => "un4fu-tqaaa-aaaab-qadjq-cai"
```

## Función `fromText`

```motoko no-repl
func fromText(t : Text) : Principal
```

Convierte una representación `Text` de un `Principal` a un valor `Principal`.

Ejemplo:

```motoko include=import
let principal = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
Principal.toText(principal) // => "un4fu-tqaaa-aaaab-qadjq-cai"
```

## Función `isAnonymous`

```motoko no-repl
func isAnonymous(p : Principal) : Bool
```

Comprueba si el principal dado representa a un usuario anónimo.

Ejemplo:

```motoko include=import
let principal = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
Principal.isAnonymous(principal) // => false
```

## Función `isController`

```motoko no-repl
func isController(p : Principal) : Bool
```

Comprueba si el principal dado puede controlar este canister.

Ejemplo:

```motoko include=import
let principal = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
Principal.isController(principal) // => false
```

## Función `hash`

```motoko no-repl
func hash(principal : Principal) : Hash.Hash
```

Aplica una función hash al principal dado mediante el hash de su representación
`Blob`.

Ejemplo:

```motoko include=import
let principal = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
Principal.hash(principal) // => 2_742_573_646
```

## Función `compare`

```motoko no-repl
func compare(principal1 : Principal, principal2 : Principal) : {#less; #equal; #greater}
```

Función de comparación de propósito general para `Principal`. Devuelve el
`Order` (ya sea `#less`, `#equal` o `#greater`) al comparar `principal1` con
`principal2`.

Ejemplo:

```motoko include=import
let principal1 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let principal2 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
Principal.compare(principal1, principal2) // => #equal
```

## Función `equal`

```motoko no-repl
func equal(principal1 : Principal, principal2 : Principal) : Bool
```

Función de igualdad para tipos de Principal. Esto es equivalente a
`principal1 == principal2`.

Ejemplo:

```motoko include=import
let principal1 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let principal2 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
ignore Principal.equal(principal1, principal2);
principal1 == principal2 // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `==` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `==` como un
valor de función en este momento.

Ejemplo:

```motoko include=import
import Buffer "mo:base/Buffer";

let buffer1 = Buffer.Buffer<Principal>(3);
let buffer2 = Buffer.Buffer<Principal>(3);
Buffer.equal(buffer1, buffer2, Principal.equal) // => true
```

## Función `notEqual`

```motoko no-repl
func notEqual(principal1 : Principal, principal2 : Principal) : Bool
```

Función de desigualdad para tipos de Principal. Esto es equivalente a
`principal1 != principal2`.

Ejemplo:

```motoko include=import
let principal1 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let principal2 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
ignore Principal.notEqual(principal1, principal2);
principal1 != principal2 // => false
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `!=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `!=` como un
valor de función en este momento.

## Función `less`

```motoko no-repl
func less(principal1 : Principal, principal2 : Principal) : Bool
```

Función "menor que" para tipos de Principal. Esto es equivalente a
`principal1 < principal2`.

Ejemplo:

```motoko include=import
let principal1 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let principal2 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
ignore Principal.less(principal1, principal2);
principal1 < principal2 // => false
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `<` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<` como un valor
de función en este momento.

## Función `lessOrEqual`

```motoko no-repl
func lessOrEqual(principal1 : Principal, principal2 : Principal) : Bool
```

Función "menor o igual que" para tipos de Principal. Esto es equivalente a
`principal1 <= principal2`.

Ejemplo:

```motoko include=import
let principal1 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let principal2 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
ignore Principal.lessOrEqual(principal1, principal2);
principal1 <= principal2 // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `<=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `<=` como un
valor de función en este momento.

## Función `greater`

```motoko no-repl
func greater(principal1 : Principal, principal2 : Principal) : Bool
```

Función "mayor que" para tipos de Principal. Esto es equivalente a
`principal1 > principal2`.

Ejemplo:

```motoko include=import
let principal1 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let principal2 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
ignore Principal.greater(principal1, principal2);
principal1 > principal2 // => false
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `>` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>` como un valor
de función en este momento.

## Función `greaterOrEqual`

```motoko no-repl
func greaterOrEqual(principal1 : Principal, principal2 : Principal) : Bool
```

Función "mayor o igual que" para tipos de Principal. Esto es equivalente a
`principal1 >= principal2`.

Ejemplo:

```motoko include=import
let principal1 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
let principal2 = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
ignore Principal.greaterOrEqual(principal1, principal2);
principal1 >= principal2 // => true
```

Nota: La razón por la que esta función está definida en esta biblioteca (además
del operador `>=` existente) es para que puedas usarla como un valor de función
para pasar a una función de orden superior. No es posible usar `>=` como un
valor de función en este momento.
