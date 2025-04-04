---
sidebar_position: 4
---

# Argumentos

Los argumentos se pueden pasar a una función de un actor para que la función los
use como entrada. Los argumentos pueden ser
[valores primitivos](../getting-started/basic-concepts#valores-primitivos), como
[`Int`](../base/Int.md), [`Nat`](../base/Nat.md), [`Bool`](../base/Bool.md) o
[`Text`](../base/Text.md), o pueden ser valores no primitivos como tuplas,
arreglos u objetos. Para mostrar un ejemplo básico de cómo un actor puede
aceptar un argumento, esta página utilizará un actor de Motoko de ejemplo que
acepta múltiples argumentos de texto.

## Argumento de texto único

Primero, define un argumento que tenga una función `location` y el argumento
`name` con un argumento `city`:

```motoko
persistent actor {
  public func location(city : Text) : async Text {
    return "Hello, " # city # "!";
  };
};
```

Una vez que tu canister esté
[deployado](https://internetcomputer.org/docs/current/developer-docs/getting-started/deploy-and-manage),
puedes llamar al método `location` en el programa y pasar tu argumento `city` de
tipo [`Text`](../base/Text.md) ejecutando el siguiente comando:

```
dfx canister call location_hello_backend location "San Francisco"
```

## Pasando múltiples argumentos

Es posible que desees intentar modificar el código fuente para devolver
resultados diferentes. Por ejemplo, es posible que desees modificar la función
`location` para devolver varios nombres de ciudades.

Modifica la función `location` con dos nuevas funciones:

```motoko
persistent actor {

  public func location(cities : [Text]) : async Text {
    return "Hello, from " # (debug_show cities) # "!";
  };

  public func location_pretty(cities : [Text]) : async Text {
    var str = "Hello from ";
    for (city in cities.values()) {
        str := str # city # ", ";
    };
    return str # "bon voyage!";
  }
};

```

Puede que notes que [`Text`](../base/Text.md) en este ejemplo de código está
encerrado entre corchetes cuadrados (`[ ]`). Por sí mismo,
[`Text`](../base/Text.md) representa una secuencia (codificada en UTF-8) de
caracteres Unicode. Al colocar corchetes cuadrados alrededor de un tipo, se
describe un **arreglo (array)** de ese tipo. En este contexto, por lo tanto,
`[Text]` indica un arreglo de valores de texto, lo que permite que el programa
acepte múltiples valores de texto como un arreglo.

Para obtener información sobre las funciones que realizan operaciones en
arreglos, consulta la descripción del [módulo Array](../base/Array.md) en la
biblioteca base de Motoko o la **referencia del lenguaje de programación
Motoko**. Para otro ejemplo centrado en el uso de arreglos, consulta el proyecto
de
[ordenación rápida (quick sort)](https://github.com/dfinity/examples/tree/master/motoko/quicksort)
en el repositorio de [ejemplos](https://github.com/dfinity/examples/).

Llama al método `location` en el programa y pasa tu argumento `city` utilizando
la sintaxis de descripción de la interfaz Candid ejecutando el siguiente
comando:

```
dfx canister call favorite_cities location '(vec {"San Francisco";"Paris";"Rome"})'
```

El comando utiliza la sintaxis de descripción de la interfaz Candid
`(vec { val1; val2; val3; })` para devolver un vector de valores. Para obtener
más información sobre el lenguaje de descripción de la interfaz Candid, consulta
la guía del lenguaje
[Candid](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/candid/candid-concepts).

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
