#!/bin/bash

cd ../../ && nodemon -e idr,ipkg -x \
    'rm build -rf; idris2 --install quins.ipkg && \
     cd examples/forum/ && rm build -rf; idris2 --build quins-forum.ipkg'
