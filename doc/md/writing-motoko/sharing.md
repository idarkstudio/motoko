---
sidebar_position: 23
---

# Compartiendo datos y comportamiento

En Motoko, el estado mutable siempre es privado para un actor. Sin embargo, dos
actores pueden compartir datos a través de mensajes, y esos mensajes pueden
hacer referencia a actores, incluyéndose a sí mismos y entre sí. Además, los
mensajes pueden hacer referencia a funciones individuales, si esas funciones son
`shared`.

A través de estos mecanismos, dos actores pueden coordinar su comportamiento
mediante el paso de mensajes asíncronos.

## Patrón publicador-suscriptor con actores

Los ejemplos en esta sección ilustran cómo los actores comparten sus funciones,
centrándose en variaciones del
[patrón publicador-suscriptor](https://es.wikipedia.org/wiki/Publicador-suscriptor).
En el patrón publicador-suscriptor, un actor **publicador** mantiene una lista
de actores **suscriptores** a los que notificar cuando ocurre algo notable en el
estado del publicador. Por ejemplo, si el actor publicador publica un nuevo
artículo, los actores suscriptores son notificados de que hay un nuevo artículo
disponible.

El siguiente ejemplo utiliza dos actores en Motoko para construir variaciones de
la relación publicador-suscriptor.

Para ver el código completo de un proyecto funcional que utiliza este patrón,
consulta el ejemplo
[pubsub](https://github.com/dfinity/examples/tree/master/motoko/pubsub) en el
[repositorio de ejemplos](https://github.com/dfinity/examples).

### Actor suscriptor

El siguiente tipo de actor `Subscriber` proporciona una posible interfaz para
que el actor suscriptor exponga y el actor publicador pueda llamar:

```motoko name=tsub
type Subscriber = actor {
  notify : () -> ()
};
```

- El `Publisher` utiliza este tipo para definir una estructura de datos para
  almacenar sus suscriptores como datos.

- Cada actor `Subscriber` expone una función de actualización `notify` como se
  describe en la firma del tipo de actor `Subscriber` anterior.

Ten en cuenta que la subtipificación permite que el actor `Subscriber` incluya
métodos adicionales que no están listados en esta definición de tipo.

Para simplificar, supongamos que la función `notify` acepta datos relevantes de
notificación y devuelve algún mensaje de estado nuevo sobre el suscriptor al
publicador. Por ejemplo, el suscriptor podría devolver un cambio en sus
configuraciones de suscripción basado en los datos de notificación.

### Actor publicador

El lado del publicador del código almacena un arreglo de suscriptores. Para
simplificar, supongamos que cada suscriptor solo se suscribe una vez utilizando
una función `subscribe`:

```motoko no-repl
import Array "mo:base/Array";

persistent actor Publisher {

  var subs : [Subscriber] = [];

  public func subscribe(sub : Subscriber) {
    subs := Array.append<Subscriber>(subs, [sub]);
  };

  public func publish() {
    for (sub in subs.values()) {
      sub.notify();
    };
  };
}
```

Más tarde, cuando algún agente externo no especificado invoca la función
`publish`, todos los suscriptores reciben el mensaje `notify` tal como se define
en el tipo `Subscriber` mencionado anteriormente.

### Métodos del suscriptor

En el caso más simple, el actor suscriptor tiene los siguientes métodos:

- Suscribirse a las notificaciones del publicador utilizando el método `init`.

- Recibir notificaciones como uno de los actores suscritos, como se especifica
  en la función `notify` del tipo `Subscriber` mencionado anteriormente.

- Permitir consultas al estado acumulado, que en este código de ejemplo es
  simplemente un método `get` para obtener el número de notificaciones recibidas
  y almacenadas en la variable `count`.

El siguiente código ilustra la implementación de estos métodos:

```motoko no-repl
persistent actor Subscriber {

  var count : Nat = 0;

  public func init() {
    Publisher.subscribe(Subscriber);
  };

  public func notify() {
    count += 1;
  };

  public func get() : async Nat {
    count
  };
}
```

El actor asume, pero no exige, que su función `init` solo se llama una vez. En
la función `init`, el actor `Subscriber` pasa una referencia a sí mismo de tipo
`actor { notify : () -> () };`.

Si se llama más de una vez, el actor se suscribirá múltiples veces y recibirá
múltiples notificaciones duplicadas del publicador. Esta fragilidad es
consecuencia del diseño básico del patrón publicador-suscriptor mostrado
anteriormente. Un actor publicador más avanzado podría verificar la existencia
de suscriptores duplicados e ignorarlos.

## Compartiendo funciones entre actores

En Motoko, una función `shared` de un actor puede enviarse en un mensaje a otro
actor y luego ser llamada por ese actor o por otro actor.

El código mostrado anteriormente se ha simplificado con fines ilustrativos. La
versión completa ofrece características adicionales a la relación
publicador-suscriptor y utiliza funciones compartidas para hacer esta relación
más flexible.

Por ejemplo, la función de notificación siempre se designa como `notify`. Un
diseño más flexible solo fijaría el tipo de `notify` y permitiría al suscriptor
elegir cualquiera de sus funciones `shared`.

Consulta el
[ejemplo completo](https://github.com/dfinity/examples/tree/master/motoko/pub-sub)
para más detalles.

En particular, supongamos que el suscriptor quiere evitar quedar atado a un
esquema de nombres específico para su interfaz. Lo que realmente importa es que
el publicador pueda llamar a alguna función que el suscriptor elija.

### La palabra clave `shared`

Para permitir esta flexibilidad, un actor necesita compartir una única función
que permita la invocación remota desde otro actor, no simplemente una referencia
a sí mismo.

La capacidad de compartir una función requiere que esta esté pre-designada como
`shared`, y el sistema de tipos exige que estas funciones sigan ciertas reglas
en torno a los tipos de datos que aceptan como argumentos y devuelven como
resultado. En particular, los datos que se pueden transmitir a través de
funciones compartidas deben tener un tipo compartido que consista en datos
planos inmutables, referencias a actores o referencias a funciones compartidas.
Las funciones locales, los objetos con métodos y los arreglos mutables están
excluidos.

Motoko te permite omitir esta palabra clave para los métodos públicos de un
actor, ya que, implícitamente, cualquier función pública de un actor debe ser
`shared`, ya sea que esté marcada explícitamente o no.

Utilizando el tipo de función `shared`, podemos extender el ejemplo anterior
para que sea más flexible. Por ejemplo:

```motoko
type SubscribeMessage = { callback : shared () -> (); };
```

Este tipo difiere del original en que describe un tipo de registro de mensaje
con un único campo llamado `callback`. El tipo original mostrado anteriormente
describe un tipo de actor con un único método llamado `notify`:

```motoko
type Subscriber = actor { notify : () -> () };
```

Notablemente, la palabra clave `actor` significa que este último tipo no es un
registro ordinario con campos, sino más bien un actor con al menos un método,
que debe llamarse `notify`.

Al utilizar el tipo `SubscribeMessage` en su lugar, el actor `Subscriber` puede
elegir otro nombre para su método `notify`:

```motoko no-repl
persistent actor Subscriber {

  var count : Nat = 0;

  public func init() {
    Publisher.subscribe({callback = incr;});
  };

  public func incr() {
    count += 1;
  };

  public query func get(): async Nat {
    count
  };
}
```

En comparación con la versión original, las únicas líneas que cambian son
aquellas que renombran `notify` a `incr` y forman la nueva carga útil del
mensaje `subscribe` utilizando la expresión `{callback = incr}`.

Del mismo modo, podemos actualizar el publicador para tener una interfaz
coincidente:

```motoko no-repl
import Array "mo:base/Array";

persistent actor Publisher {

  var subs : [SubscribeMessage] = [];

  public func subscribe(sub : SubscribeMessage) {
    subs := Array.append<SubscribeMessage>(subs, [sub]);
  };

  public func publish() {
    for (sub in subs.values()) {
      sub.callback();
    };
  };
}
```

<img src="https://github.com/user-attachments/assets/844ca364-4d71-42b3-aaec-4a6c3509ee2e" alt="Logo" width="150" height="150" />
