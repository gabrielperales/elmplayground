Desde la versión 5, los arrays de JavaScript cuentan con el método *filter* ([`Array.prototype.filter`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter)) que nos permite devolver un nuevo array o colección con sólo los elementos que cumplen la condición que se pasa como argumento a dicho método.

Si por ejemplo tenemos la siguiente colección de elementos en un array : `1, 2, 3, 4, 5, 6, 7, 8, 9 , 10` y aplicamos el método con una función que filtre sólo los elementos pares: `function(element) { return element % 2 === 0; }` nos devolverá un array con los siguientes elementos: `2, 4, 6, 8, 10`.

Veamos el ejemplo con código:

```javascript
// -*- OPTIONS: executable: true, readOnly: false -*-
var collection = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

var filtered_collection = collection.filter(
  function(element){
    return element % 2 === 0;
  }
);

log(filtered_collection);
```

Si ahora, por el contrario queremos filtrar por varios criterios, deberemos realizar un filtro compuesto, de manera que sólo se devuelvan los elementos que cumplan todos los criterios. Esto es, una función a la que llamaremos *multiFilter*, y a la cual se le pasen varias funciones de filtro. De esta forma, si por ejemplo queremos filtrar los elementos que sean pares, y que además sean mayor de un determinado valor, *multiFilter* nos devuelva esos elementos de la colección.

Una primera aproximación para crear esta función *multiFilter* podría ser la siguiente:

```javascript
// -*- OPTIONS: executable: true, readOnly: false -*-
function multiFilter(){
  var filters = [].slice.call(arguments);
  
  return function(element){
    for (var i = 0, len = filters.length; i < len; i++){
      if (!filters[i](element)) return false;
    }
    return true;
  };
}

// filtro para elementos pares
var isEven = function(el){
  return el % 2 === 0;
};

// filtro para elementos mayores que un número
var isGreaterThan = function(number){
  return function(el){
    return el > number;
  };
};

var collection = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

var filtered_collection =
  collection.filter(multiFilter(isEven, isGreaterThan(4)));

log(filtered_collection);
```

Como habéis podido observar, *multiFilter* es un *closure* que nos devuelve una única función de filtro, y que será la que *collection.filter* recibirá como argumento. Esa función se encarga de aplicar cada uno de los filtros que *multiFilter* recibió como argumento, y si para alguna de esos filtro, el elemento no cumple la condición, el elemento será descartado.

En el ejemplo anterior filtramos nuestro array de ejemplo por los criterios de filtrar números pares y filtrar números que sean mayores que 4, y como habéis podido observar funciona correctamente.

Podemos simplificar nuestra función *multiFilter* usando el método *every* ([`Array.prototype.every`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every)) al cual se le pasa una función de condición como las que hemos utilizado para crear filtros, y nos devuelve `true` si todo el array cumple esa condición.

Así pues, nuestra función *multiFilter* quedaría de la siguiente manera:

```javascript
var multiFilter = function(){
  var filters = [].slice.call(arguments);

  return function(element){
    return filters.every(function(filter){
      return filter(element);
    });
  };
};
```

Por último, en las líneas 2, 3 y 4 del siguiente ejemplo, podemos ver esta misma función escrita en JavaScript 2015 / *EcmaScript 6* y que funciona exactamente igual pero utiliza una sintaxis mucho más concisa:

```javascript
// -*- OPTIONS: executable: true, readOnly: false -*-

// versión ES2015 / ES6
const multiFilter = (...filters) => 
  (element) => 
    filters.every((filter) => filter(element));

// filtro para elementos pares
const isEven = (el) => el % 2 === 0;

// filtro para elementos mayores que un número
const isGreaterThan = (number) =>
  (el) => el > number;

const collection = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

const filtered_collection =
  collection.filter(multiFilter(isEven, isGreaterThan(4)));

log(filtered_collection);
```
