Cuando alguien que viene de Java, C# u otros lenguajes orientados a objetos, una de las mayores dificultades que encuentra al empezar con Javascript es entender el funcionamiento de la referencia *this* en los diferentes contextos, puesto que en la mayoría de lenguajes *this* siempre hace referencia al objeto actual, y esto en Javascript no es siempre así.

En Javascript (**ES5**) la única forma de crear un contexto es mediante la creación de una función. Todas las variables creadas entro de esa función serán visibles para toda la función. Es decir, mientras que en otros lenguajes el ámbito de las variables es a nivel de bloque, en Javascript, el ámbito es a nivel de función. Veamos unos ejemplos para entenderlo mejor:

```javascript

```

En lenguajes como Java es muy común ver códigos como el del ejemplo de arriba, donde declaramos e inicializamos una variable en un bucle for. Con esto esperaríamos que esa variable sólo sea visible dentro de ese bloque for, y que más tarde esa variable no exista. Pero en Javascript esto no es así, si no que todas las variables definidas dentro de una función sufren un efecto llamado [**hoisting**](http://www.w3schools.com/js/js_hoisting.asp) y el intérprete las declara al comienzo de la función asignándoles el valor `undefinded` - lo cual parece contradictorio - pero así lo hace. 

De esta forma el ejemplo anterior sería equivalente a este código:

```javascript

```

Ahora que sabemos cómo funcionan los contextos de las variables en Javascript, podemos ver que ocurre con *this* y cómo es que a veces podemos perder la referencia al objeto actual.


##### Ejecución como función

Es la forma general de ejecutar una función en javascript. Tan sólo debemos poner el nombre de la función y añadir `()` para invocarla. Si la función tiene parámetros éstos deben ser incluidos dentro de los paréntesis.

```javascript
function saludar(name){
  alert('Hola ' + name);
}

saludar('Gabriel'); // ejecutamos la función con el parámetro 'Gabriel'
```


##### Ejecución como método

```javascript
var gabriel = {
 name: 'Gabriel',
 saludar: function(){
   alert('Hola ' + this.name);
 }
};

gabriel.saludar(); // ejecuta la función como método del objeto gabriel.
```

Podemos comprobar que al ejecutar `gabriel.saludar()` se ejecuta el método y que en ese caso `this` hace referencia al objeto gabriel y por eso `this.name` es 'Gabriel'. En cambio, podemos ejecutar la función saludar de esta manera:

```javascript
var gabriel = {
  name: 'Gabriel',
  saludar: function(){
    alert('Hola '+this.name);
  }
};

var saludar = gabriel.saludar; // asignamos la función contenida en el método gabriel.saludar a la variable saludar

saludar(); // en este caso la función no se ejecuta como método, si no como función
```

En este caso, el alert mostrará sólo 'Hola'.

##### Ejecución con *call*

```javascript
var gabriel = {
  name: 'Gabriel',
  saludar: function(){
    alert('Hola '+this.name);
  }
};

var rocio = {
  name: 'Rocío'
};

gabriel.saludar.call(rocio); // muestra 'Hola Rocío' en un alert
```

##### Ejecución con *apply*

```javascript

```
