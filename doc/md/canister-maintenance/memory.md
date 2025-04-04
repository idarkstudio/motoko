---
sidebar_position: 5
---

# Diagnósticos de memoria

## Hook de memoria baja (Low memory hook)

El IC permite implementar un hook de memoria baja, que es un disparador de
advertencia cuando la memoria principal se está volviendo escasa.

Para este propósito, un actor o instancia de clase de actor en Motoko puede
implementar la función del sistema `lowmemory()`. Esta función del sistema se
programa cuando el espacio libre de memoria principal del canister ha caído por
debajo del umbral definido `wasm_memory_threshold`, que es parte de la
configuración del canister. En Motoko, `lowmemory()` implementa el hook
`canister_on_low_wasm_memory` definido en la especificación de IC.

Ejemplo de uso del hook de memoria baja:

```
actor {
    system func lowmemory() : async* () {
        Debug.print("Low memory!");
    }
}
```

Las siguientes propiedades se aplican al hook de memoria baja:

- La ejecución de `lowmemory` ocurre con cierto retraso, ya que se programa como
  un mensaje asíncrono separado que se ejecuta después del mensaje en el que se
  cruzó el umbral.
- Una vez ejecutado, `lowmemory` solo se activa nuevamente cuando el espacio
  libre de memoria principal primero excede y luego cae por debajo del umbral.
- Los errores no manejados o las fallas (traps) en `lowmemory` se ignoran. Las
  fallas solo revierten los cambios realizados en `lowmemory`.
- Debido a su tipo de retorno `async*`, la función `lowmemory` puede enviar más
  mensajes y `await` resultados.
