Como sabrás, `Function.prototype.bind` se usa en la mayoría de los casos para evitar `var that = this` o `var self = this` como por ejemplo:

```javascript
function goTo(e){
  e.preventDefault();
  var url = $(this).attr('href');
  window.location.href = url;
}

$('a').on('click', goTo.bind(this));
```

El primer argumento que recibe `bind` será asignado a `this` dentro del contexto de la función que devuelve. 

Una propiedad menos conocida de `bind` es que acepta más de un parámetro. Cada parámetro que adicional será pasado como argumento cuando se invoque la función.

Es decir, si tenemos la función add:

```javascript
var add = function(a, b){
  return a + b;
};
```

ejecutar la siguiente sentencia

```
var add1 = add.bind(null, 1);
```

será equivalente a:

```javascript
var add1 = function(){
  return add.apply(null, [1].concat(arguments));
};
```

Esto quiere decir que podremos realizar aplicaciones parciales de las funciones como en este ejemplo:

```javascript
// -*- OPTIONS: executable: true, readOnly: false -*-
var add = function(a, b){
  return a + b;
};

var add1 = add.bind(null, 1);

log(add1(1)); // imprime 2
log(add1(5)); // imprime 6

var add10 = add.bind(null, 10);

log(add10(1)); // imprime 11
log(add10(20)); // imprime 30

// edita y ejecuta tus propias pruebas :)
```

Interesante, ¿verdad?. 

