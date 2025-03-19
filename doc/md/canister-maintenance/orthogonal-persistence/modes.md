---
sidebar_position: 1
---

# Modos de persistencia

Motoko cuenta con dos implementaciones para la persistencia ortogonal:

- [Persistencia ortogonal mejorada](enhanced.md), actualmente en etapa beta,
  proporciona actualizaciones muy rápidas, escalando de forma independiente del
  tamaño del montón. Esto se logra al retener toda la memoria principal de Wasm
  en una actualización y simplemente realizar una verificación de seguridad de
  actualización basada en tipos. Al utilizar un espacio de direcciones de 64
  bits, está diseñado para escalar más allá de 4 GiB y en el futuro, ofrecer la
  misma capacidad que la memoria estable.

- [Persistencia ortogonal clásica](classical.md) es la antigua implementación de
  la persistencia ortogonal que será reemplazada por la persistencia ortogonal
  mejorada. En una actualización, el sistema de tiempo de ejecución primero
  serializa los datos persistentes en la memoria estable y luego los deserializa
  nuevamente en la memoria principal. Si bien esto es ineficiente y no
  escalable, presenta problemas en datos inmutables compartidos (lo que
  potencialmente conduce a una explosión de estado), estructuras profundas
  (desbordamiento de la pila de llamadas) y montones más grandes (la
  implementación limita los datos estables a un máximo de 2 GiB).
