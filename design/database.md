# SPC-database
partof: REQ-purpose
###

The data layer of this project takes inspiration from the following sources:

* [Datomic](https://docs.datomic.com/cloud/time/filters.html#example-database)

the query interface

* [Differential Dataflow](https://timelydataflow.github.io/differential-dataflow/introduction.html)

the low-level incremental update engine



## Principles

* Quins are stale and can be culled if a quin with the same element and attribute and a higher transaction number exists.
* The `session` element has a special purpose - it will not be sent to
    the server. When a `session` element changes
