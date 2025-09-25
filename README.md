# API Selector de cursos

Una API de Rails para prestar un servicio de selección de cursos ofertados.

------------------------------------------------------------------------

## Features

-   Filtrar cursos por el criterio de la más próxima edición (`closest`), el de fecha más lejana al actual (`latest`), el de escuela (`school-XYZ`) y el de tipo indicado (`type-XYZ`).\
-   Incluye tests en Rspec para garantizar estabilidad del servicio.

------------------------------------------------------------------------

## Instalación

``` bash
git clone https://github.com/Getu11/OEIChallenge.git
cd OEIChallenge
bundle install
```

Arrancar el server de Rails:

``` bash
bin/rails server
```

------------------------------------------------------------------------

## Script de Bash

El ejemplo incluido en el repositorio incluye un `test-case1.sh` (con el puerto cambiado a 3000 y un cambio de sintaxis que podría arreglar el script para quienes usan ZSH)\
y el script de Bash original: `test-case1-original.sh`.\
\
Para ejecutarlo, hay que tener el server de Rails iniciado.
``` bash
./test-case1.sh
Test 1 : [  OK  ]
Test 2 : [  OK  ]
Test 3 : [  OK  ]
Test 4 : [  OK  ]
```
------------------------------------------------------------------------

## Testing

Ejecutar tests:
``` bash
bundle exec rspec --format documentation
```

Debería salir lo siguiente:
``` bash
Course Selection API
  criteria: closest
    selects the edition with the earliest future date
  criteria: latest
    selects the edition with the furthest future date
  criteria: type-name
    filters courses by given type
  criteria: school-name
    filters courses by school
  ...
```
