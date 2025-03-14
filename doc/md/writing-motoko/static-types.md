---
sidebar_position: 24
---

# Tipos estáticos

Al igual que otros lenguajes de programación modernos, Motoko permite que cada
variable contenga el valor de una función, un objeto o un dato primitivo como
una cadena, una palabra o un entero. También existen otros
[tipos de valores](../getting-started/basic-concepts.md#valores), como
registros, tuplas y datos etiquetados llamados variantes.

Motoko utiliza la propiedad formal de seguridad de tipos, también conocida como
solidez de tipos. Cada variable en un programa de Motoko tiene un tipo asociado,
y este tipo se conoce estáticamente antes de que el programa se ejecute. Cada
uso de cada variable es verificado por el compilador para evitar errores de tipo
en tiempo de ejecución, incluyendo errores de referencia `null`, acceso inválido
a campos y similares. En este sentido, los tipos de Motoko proporcionan una
forma de documentación confiable y **verificada por el compilador** en el código
fuente del programa.

Para ejecutarse, Motoko se compila estáticamente a WebAssembly, un formato
binario portátil que se abstrae limpiamente sobre el hardware moderno,
permitiendo así su ejecución en Internet y en ICP.

Esto a menudo se resume con la frase
["los programas bien tipados de Motoko no fallan"](../getting-started/basic-concepts.md#sonoridad-de-tipos),
lo que significa que las únicas operaciones que se realizarán sobre los datos
son aquellas permitidas por su tipo estático.

Las pruebas dinámicas pueden verificar propiedades que están más allá del
alcance del sistema de tipos de Motoko. El sistema de tipos de Motoko no es
intencionalmente avanzado. Más bien, el sistema de tipos de Motoko integra
conceptos estándar de sistemas de tipos modernos, pero bien entendidos, para
proporcionar un lenguaje accesible, expresivo y seguro para programar
aplicaciones distribuidas de propósito general.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
