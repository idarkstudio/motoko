---
sidebar_position: 25
---

# Capacidad del sistema (`system` capability)

La capacidad del sistema (`system` capability) en Motoko se utiliza para
controlar el acceso a funciones sensibles del sistema y prevenir el uso indebido
de estas funciones. Sirve como un mecanismo de seguridad para garantizar que los
desarrolladores sean explícitamente conscientes cuando están utilizando o
otorgando acceso a operaciones de nivel del sistema con gran poder.

Específicamente, la capacidad del sistema es requerida para llamar a funciones
sensibles como:

1. `ExperimentalCycles.add`: Esta función se utiliza para la gestión de ciclos,
   lo cual es crucial para controlar los recursos computacionales en Internet
   Computer.

2. `Timer.setTimer`: Esta función se utiliza para programar cálculos futuros, lo
   que puede tener un impacto significativo en los recursos y el comportamiento
   del sistema.

La introducción de la capacidad del sistema ayuda a abordar una preocupación de
seguridad en la que, en versiones anteriores de Motoko, las funciones de
bibliotecas de terceros podían hacer llamadas silenciosas a estas funciones
sensibles sin proporcionar ninguna indicación al llamador. Esto podría
potencialmente llevar a comportamientos inesperados o al uso de recursos no
deseado.

Al requerir una declaración explícita y el paso de la capacidad del sistema,
Motoko ahora asegura que los desarrolladores estén completamente conscientes
cuando están utilizando o permitiendo el uso de estas funciones poderosas del
sistema. Esto ayuda a prevenir el uso accidental y hace que las intenciones del
código sean más claras, mejorando tanto la seguridad como la legibilidad del
código.

Es importante destacar que, aunque la capacidad del sistema permite el uso de
estas funciones sensibles, no otorga automáticamente acceso ilimitado a todos
los recursos del sistema. Es un mecanismo a nivel de tipo para controlar y hacer
explícito el uso de funciones específicas del sistema, en lugar de ser un
sistema de permisos completo.

La capacidad del sistema se introdujo en la versión 0.11.0 de Motoko. El cambio
clave es la introducción del parámetro y argumento pseudo-tipo `system`. Por
ejemplo, `ExperimentalCycles.add` ha sido revisada para pasar de tener el tipo
`Nat -> ()` a tener el tipo `<system>Nat -> ()`, reflejando el nuevo requisito
de capacidad del sistema.

Para utilizar capacidades del sistema en tu código, ahora debes declararlas
explícitamente cuando sea necesario, y debes proporcionarlas explícitamente
cuando otorgues permiso a un llamado.

Las funciones que necesitan usar capacidades del sistema deben incluir el
parámetro pseudo-tipo `system`. Es importante destacar que `system`, si se
especifica, debe ser el primer parámetro en declaraciones de funciones o clases.

Por ejemplo:

```motoko no-repl
func splitCycles<system>() {
  let amount = ExperimentalCycles.balance() / 2;
  ExperimentalCycles.add(amount); // generates a warning
}
```

Para suprimir las advertencias sobre el uso implícito de la capacidad del
sistema, también puedes pasar explícitamente la capacidad `system` en los sitios
de llamada:

```motoko no-repl
func splitCycles<system>() {
  let amount = ExperimentalCycles.balance() / 2;
  ExperimentalCycles.add<system>(amount); // accepted without warning
}
```

Las capacidades del sistema están disponibles en contextos específicos, como
dentro de expresiones de actores o cuerpos de clases de actores, funciones
compartidas no consultables, funciones asíncronas, expresiones asíncronas,
funciones locales o clases declaradas con el parámetro pseudo-tipo `system`, y
las funciones del sistema preupgrade y postupgrade.

Sin embargo, no están disponibles en métodos de consulta, métodos de consulta
compuestos o funciones que no declaran su necesidad de la capacidad del sistema.

Para obtener más detalles, consulta el
[manual de lenguaje](../reference/language-manual#type-arguments).

Para obtener detalles sobre la migración de código desde versiones anteriores de
Motoko, consulta esta [guía](../migration-guides/0.11.0-migration-guide).

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
