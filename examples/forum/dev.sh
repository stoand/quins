#!/bin/bash

cd ../../ && nodemon -e idr,ipkg -x \
    'rm build -rf; idris2 --install quins-backend.ipkg && \
     cd examples/forum/ && rm build -rf; idris2 --build quins-forum-backend.ipkg && node ./build/exec/quins-forum-backend.js'
