#!/bin/bash

nodemon -e idr,ipkg -x \
    'idris2 --build quins-forum-frontend.ipkg && \
     cp static/ build/exec/ -r && \
     node ./build/exec/quins-forum-backend.js'
