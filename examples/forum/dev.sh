#!/bin/bash
idris2 --install ../../quins.ipkg
nodemon -e idr,ipkg -x 'rm build -rf; idris2 --build quins-forum.ipkg'
