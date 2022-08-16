# SPC-examples_forum

A case study in what a forum
has in terms of features, as well as 
how the framework most efficiently can be built around this
realistic proof of concept.


## Features

[[.sign_in]]

The user signs in by entering any username.
No email verification is needed.

__Pages:__

### Index

SPAWNS: { session page home:<index body id> <tx0> add }

### Home Page

ON: { session page home:<index body id> <tx0> add }

[[.open_forum]]

SPAWNS:

* { session page home:<index body id> <tx0> remove }
* { session page posts:<index body id> <tx0> add }

### Posts Page

[[.create_post]]

* { user id locally opens page `posts` } 

[[.update_post]]

[[.delete_post]]

[[.display_posts]] -- a form of `Generic List`

[[.rate_post]]

### Comments

[[.create_comment]]

[[.update_comment]]

[[.delete_comment]]

[[.display_comments]] -- a form of `Generic List`

[[.rate_comment]]


### Generic List

Can be sorted by:

* newest to oldest or vice versa
* highest rating / controversial

Initially loads the 10 most fitting to criteria. Has option to load 10 more.
