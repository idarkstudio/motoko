---
sidebar_position: 18
---

# Subtipificación de objetos

**Subtipo de objetos**: En Motoko, los objetos tienen tipos que pueden
relacionarse mediante subtipo. Los tipos con más campos son menos generales y
son subtipos de tipos con menos campos. Considera los siguientes tipos generales
y subtipos:

- Más general:

```motoko no-repl
{ bump : () -> Nat }
```

- Generalidad media:

```motoko no-repl
{
  inc  : () -> () ;
  read : () -> Nat ;
  bump : () -> Nat ;
}
```

- Menos general:

```motoko no-repl
{
  inc  : () -> () ;
  read : () -> Nat ;
  bump : () -> Nat ;
  write : Nat -> () ;
}
```

Si una función espera recibir un objeto del primer tipo (`{ bump: () → Nat }`),
cualquiera de los tipos dados anteriormente será suficiente, ya que cada uno es
igual o un subtipo del tipo más general.

Sin embargo, si una función espera recibir un objeto del último tipo, el menos
general, los otros dos **no** serán suficientes, ya que a cada uno le falta la
operación `write` necesaria, a la que esta función espera legítimamente tener
acceso.

## Ejemplo

Para ilustrar el papel y el uso de la subtipificación de objetos en Motoko,
considera implementar un contador más simple con un tipo más general que tenga
menos operaciones públicas:

```motoko
object bumpCounter {
  var c = 0;
  public func bump() : Nat {
    c += 1;
    c
  };
};
```

El objeto `bumpCounter` tiene el siguiente tipo de objeto, exponiendo
exactamente una operación, `bump`:

```motoko no-repl
{
  bump : () -> Nat ;
}
```

Este tipo expone la operación más común y una que solo permite cierto
comportamiento. Por ejemplo, el contador solo puede aumentar y nunca disminuir o
establecerse en un valor arbitrario.

En otras partes de un sistema, puedes implementar y usar una versión menos
general con más operaciones:

```motoko no-repl
fullCounter : {
  inc   : () -> () ;
  read  : () -> Nat ;
  bump  : () -> Nat ;
  write : Nat -> () ;
}
```

Considera un contador llamado `fullCounter` con un tipo menos general que
cualquiera de los dados anteriormente. Además de `inc`, `read` y `bump`, también
incluye `write`, que permite al llamador cambiar el valor actual del contador a
uno arbitrario, como volver a `0`.

## Subtipificación estructural

La subtipificación de objetos en Motoko utiliza subtipificación estructural, no
subtipificación nominal.

En la tipificación nominal, la igualdad de dos tipos depende de elegir nombres
de tipos consistentes y globalmente únicos en todos los proyectos y a lo largo
del tiempo.

En Motoko, la igualdad de dos tipos se basa en su estructura, no en sus nombres.
Debido a la tipificación estructural, nombrar un tipo de clase proporciona una
abreviatura conveniente.

Para fines de tipificación, lo único que importa es la estructura del tipo de
objeto correspondiente. Dos clases con nombres diferentes pero definiciones
equivalentes producen objetos compatibles en cuanto a tipo.

Cuando se proporciona la anotación de tipo opcional en una declaración de clase,
se verifica la conformidad. El tipo de objeto debe ser un subtipo de la
anotación. La anotación no afecta el tipo de la clase, incluso si solo describe
un supertipo propio del tipo de objeto.

Las relaciones de subtipificación en Motoko se extienden a todos los tipos, no
solo a los tipos de objetos.

La mayoría de los casos son estándar y siguen la teoría convencional de
lenguajes de programación para la subtipificación _estructural_.

Otros casos notables en Motoko para nuevos programadores incluyen las
interrelaciones entre arreglos, opciones, variantes y tipos numéricos.

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
