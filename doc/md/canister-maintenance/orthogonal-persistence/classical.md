---
sidebar_position: 3
---

# Persistencia ortogonal clásica

La persistencia ortogonal clásica es la implementación antigua de la
persistencia ortogonal de Motoko. Actualmente sigue siendo la opción
predeterminada, ya que la persistencia ortogonal mejorada está en fase de
pruebas beta.

En una actualización, el mecanismo de persistencia ortogonal clásica serializa
todos los datos estables a la memoria estable y luego los deserializa de vuelta
a la memoria principal. Esto tiene varias desventajas:

- Como máximo, se pueden persistir 2 GiB de datos del heap a través de
  actualizaciones. Esto se debe a una restricción de implementación. Ten en
  cuenta que, en la práctica, la cantidad de datos estables admitidos puede ser
  mucho menor.
- Los objetos compartidos inmutables en el heap pueden duplicarse, lo que lleva
  a una posible explosión de estado en las actualizaciones.
- Las estructuras profundamente anidadas pueden provocar un desbordamiento de la
  pila de llamadas.
- La serialización y deserialización es costosa y puede alcanzar los límites de
  instrucciones de IC.
- No hay una verificación de compatibilidad estable integrada en el sistema de
  tiempo de ejecución. Si los usuarios ignoran la advertencia de actualización
  de `dfx`, los datos pueden perderse o la actualización puede fallar.

:::danger Todos estos problemas pueden llevar a un canister atascado que ya no
puede ser actualizado. Por lo tanto, es absolutamente necesario probar
exhaustivamente cuántos datos puede manejar una actualización de tu aplicación y
luego limitar de manera conservadora los datos retenidos por ese canister.
Además, es bueno tener una posibilidad de respaldo para rescatar datos incluso
si las actualizaciones fallan, por ejemplo, mediante llamadas de consulta de
datos con privilegios de controlador. :::

Estos problemas se resuelven con la
[persistencia ortogonal mejorada](enhanced.md).
