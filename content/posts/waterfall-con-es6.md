La naturaleza asíncrona de javascript a veces hace que abusemos de los *callbacks* y cuando eso ocurre, se dan casos de lo que se conoce como ***callback hell***.

```javascript
// Ejemplo de callback hell
doAsync1(function () {
  doAsync2(function () {
    doAsync3(function () {
      doAsync4(function () {
    });
  });
});
```
El *callback hell* es subjetivo, por lo que el código muy anidado puede estar bien muchas veces, pero otras veces el código asíncrono se puede volver malo cuando se vuelve complejo controlar el flujo de programa.

Una buena pregunta para ver cómo de *"malo"* (*hell* ) es tu código es: ¿Cuánto me costaría refactorizar mi código si `doAsync2` ocurriese antes que `doAsync1`?
El objetivo no es eliminar niveles de indentación (o tabulación), si no escribir código modular (¡y testabla!) que sea fácil de entender y resistente.


Gracias a que existen librerías como **[Async.js](https://github.com/caolan/async)** podemos solventar el problema. Async añade una capa de funciones que reducen la complejidad evitando la anidación de *callbacks*.

```javascript
const waterfall = (tasks, callback = () => {}) => {
  let cb;
  (cb = (err, ...args) => {
     task = tasks.shift();
     return !err && task
       ? task(...args, cb) : callback(err, ...args);
  }());
};
```

**Fuentes**

- GitHub [Async.js](https://github.com/caolan/async)
- StrongLoop [Managing Node.js Callback Hell with Promises, Generators and Other Approaches](https://strongloop.com/strongblog/node-js-callback-hell-promises-generators/)
- Stack Abuse [Avoiding callback hell in nodejs](http://stackabuse.com/avoiding-callback-hell-in-node-js/)
