#!/bin/bash

nodemon -e idr,ipkg -x 'rm build -rf; idris2 --build hello-idris-js.ipkg'
