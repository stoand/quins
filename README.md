# Quins -- Idris2 Fullstack Framework

## To see Quins running in a real functional app:

* [Install Idris2](https://github.com/idris-lang/Idris2)
* [Install NodeJS](https://nodejs.org/en/download/)
* `npm i -g nodemon`


* `cd ./examples/forum/`
* `./dev.sh`
* Open `http://localhost:5000`

## To Run Frontend Tests

Same as above, except: `./dev.sh test-frontend`
and do not open browser

## What are "Quins"?

`Quins`, or quintuplets, are tuples with five items in a list that together form a database
of queryable data.

The five items of a quintuplet item:

* `E` - element (similar to an SQL table item id) 
* `A` - attribute (like the names of rows)
* `V` - value
* `TX` - transaction
* `A/R` - add or remove

See also: [A Datomic Database](https://docs.datomic.com/cloud/time/filters.html#example-database)

## Detailed Project Reference

The rendered spec:

* [Install Artifact](https://github.com/vitiral/artifact/releases)
* `art serve`
* [http://localhost:5373](http://localhost:5373)

The spec source documents: Check the `./design/` folder
