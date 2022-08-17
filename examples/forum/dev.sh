#!/bin/bash

if [ "$1" = "test-frontend" ]
  then
    RUN_CMD='node ./build/exec/quins-forum-frontend.js test-frontend'
  else
    RUN_CMD='node ./build/exec/quins-forum-backend.js'
fi


cd ../../ && nodemon -e idr,ipkg -x \
    "idris2 --install quins-backend.ipkg; \
     idris2 --install quins-frontend.ipkg && \
     cd examples/forum/ && \
     idris2 --build quins-forum-backend.ipkg && \
     idris2 --build quins-forum-frontend.ipkg && \
     cp static/ build/exec/ -r && \
     ${RUN_CMD}"
