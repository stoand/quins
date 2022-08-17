#!/bin/bash

cd ../../ && nodemon -e idr,ipkg -x \
    'idris2 --install quins-backend.ipkg; \
     idris2 --install quins-frontend.ipkg && \
     cd examples/forum/ && \
     idris2 --build quins-forum-backend.ipkg && \
     idris2 --build quins-forum-frontend.ipkg && \
     cp static/ build/exec/ -r && \
     node ./build/exec/quins-forum-backend.js'
