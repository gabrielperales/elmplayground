Han sido ya varias las veces que he tenido que resolver el problema de la sucesión de fibonacci con varios lenguajes. La sucesión de fibonacci es la sucesión `0, 1, 1, 2, 3, 5, 8, 13, 21, 34...`, la cual tiene claramente un carácter recursivo, puesto que cada término de la sucesión se calcula con la suma de los dos anteriores, es decir `fib(n) = fib(n-1) + fib(n-2)`

Una primera aproximación recursiva en javascript podría ser la siguiente:

```javascript
// -*- OPTIONS: executable: true, readOnly:false -*-

var fibonacci = function(n){
  if (n === 0 || n === 1) return n;
  return fibonacci(n-1) + fibonacci(n-2);
};

for(var i = 0; i <= 10; i++) log(fibonacci(i));
// edita y ejecuta tus propias pruebas :)
```

El problema es que hay una explosión exponencial en cuanto al número de llamadas recursivas que se producen y la repetición del cálculo de términos anteriores de la sucesión.

![fibonacci recursive](https://users.soe.ucsc.edu/~fire/dev-2008f-12/labs/lab8-Recursion-vs-Iteration/fib_5.png)

Cómo se muestra en la anterior imagen, para calcular el quinto término de la sucesión (`fib(5)`), `fib(3)` se calcula 2 veces, `fib(2)` se calcula 3 veces y `fib(1)` 5 veces. Obviamente esto no es eficiente. Lo lógico sería que una vez calculado un término, no sea necesario volver a calcularlo. Esto podemos conseguirlo usando una caché para guardar esos resultados. En JavaScript esto es fácil de hacer usando una *closure* para guardar la cache.
El siguiente código mostraría la solución que yo he realizado, dónde sólo se hace una llamada recursiva y sólo se calcula cada término una vez.

```javascript
// -*- OPTIONS: executable: true, readOnly:false -*-
var fibonacci = (function(){
  var f =  [0, 1];
  return function(n){
   return f[n] = f[n] !== undefined ? f[n] : fibonacci(n-1) + f[n-2]
  };
}());

for(var i = 0; i <= 10; i++) log(fibonacci(i));
```

La *closure* se encuentra dentro de una función que se auto ejecuta `(function(){ ... }());` que hace que la función que devuelve,
```javascript
return function(n){
  return f[n] = f[n] || fibonacci(n-1) + f[n-2];
};
```
sea asignada a la variable `fibonacci` y que dentro de la *closure* se tenga acceso a la variable `f` con los resultados previamente calculados.

> **Actualizado** con versión Ecmascript 6 / ES6 / ES2015


```javascript
// -*- OPTIONS: executable: true, readOnly:false -*-
// versión Ecmascript 6 / ES2015
const fibonacci = (() => {
  const f =  [0, 1];
  return (n) => f[n] = f[n] !== undefined ? f[n] : fibonacci(n-1) + f[n-2];
})();

for(var i = 0; i <= 10; i++) log(fibonacci(i));
// edita y ejecuta tus propias pruebas :)
```



