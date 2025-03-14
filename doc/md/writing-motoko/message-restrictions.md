---
sidebar_position: 15
---

# Restricciones de mensajería

ICP impone restricciones sobre cuándo y cómo los canisters pueden comunicarse.
Estas restricciones se aplican dinámicamente, pero se previenen estáticamente en
Motoko, eliminando una clase de errores de ejecución dinámica. Dos ejemplos son:

- La instalación de un canister puede ejecutar código, pero no enviar mensajes.

- Un método de consulta (`query`) de un canister no puede enviar mensajes.

Estas restricciones de ICP se reflejan en Motoko como limitaciones en el
contexto del programa en el que pueden aparecer ciertas expresiones. Las
violaciones de estas restricciones se reportan como errores por el verificador
de tipos.

En Motoko, una expresión ocurre en un contexto asíncrono si aparece en el cuerpo
de una expresión `async`, que puede ser el cuerpo de una función compartida
(`shared`) o local, o una expresión independiente. La única excepción son las
funciones `query`, cuyo cuerpo no se considera que abra un contexto asíncrono.

En Motoko, llamar a una función compartida (`shared`) es un error a menos que la
función se llame en un contexto asíncrono. Llamar a una función compartida desde
el constructor de una clase de actor también es un error.

Los constructores `await` y `async` solo están permitidos en un contexto
asíncrono.

Solo es posible lanzar (`throw`) o manejar errores con `try/catch` en un
contexto asíncrono. Esto se debe a que el manejo estructurado de errores solo es
compatible con errores de mensajería y, como la mensajería en sí, está confinado
a contextos asíncronos.

Estas reglas también significan que las funciones locales no pueden llamar
directamente a funciones compartidas o `await` a futuros.

(Las mismas restricciones se aplican a las expresiones `await*` y `async*`).

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
