# :balloon: Lambdabuster 
 
Es un sistema de Alquiler y Venta de peliculas por streaming.

## :gear: Requerimientos

:gem: Ruby

## :star2: Como correr

```shell
ruby main.rb
```

## :balloon: Como usar

- Primero insertar la direccion de un archivo JSON con los datos de la aplicacion.

El JSON debe tener el siguiente formato

```
"directors":
    [
        {
            "name": String. Nombre del director,
            "birthday": Date. Fecha de nacimiento del director, en formato ISO 8601,
            "nationality": String. País de nacimiento del director
        },
    ]
"actors":
    [
        {
            "name": String. Nombre del actor,
            "birthday": Date. Fecha de nacimiento del actor, en formato ISO 8601,
            "nationality": String. País de nacimiento del actor
        },
    ]
"movies":
    [
        {
            "name": String. Nombre de la película,
            "runtime": Int. Duración de la película en minutos,
            "categories": [String]. Lista de categorías o géneros de la película,
            "release-date": Date. Fecha de estreno de la película, en formato ISO 8601,
            "directors": [String]. Lista con los nombres de los directores de la película,
            "actors": [String]. Lista con los nombres de los actores de la película,
            "price": Float. Precio de compra de la película,
            "rent_price": Float. Precio de alquiler de la película. Puede ser nulo, en
            cuyo caso la película no estará disponible para alquiler,
            1"premiere": Bool. Indica si la película es un estreno.
            "discount": Int. Valor [0,100] que indica el descuento en % que tendrá una película.
        },
    ]
```

- Usar cualquiera de las siguientes funciones.

    1. Crear nueva orden de alquiler

    2. Crear nueva orden de compra

    3. Mi Usuario

    4. Consultar catálogo

        4.1. Mostrar todas

        4.2. Filtrar

            1. Nombre

            2. Ano

            3. Nombre de director

            4. Nombre de actor

            5. Duracion

            6. Categorias

            7. Precio de compra

            8. Precio de alquiler


            9. Aplicar otro filtro

            10. Buscar

5. Salir
