module Main

import public PrimIO

-- Lower level HTTP

RawReqHandler : Type
RawReqHandler = AnyPtr -> AnyPtr -> ()

handleReqJs : String
handleReqJs = "javascript:lambda:(req, res) => {" ++
    "res.end('55555');" ++
    "" ++
    "}"

%foreign handleReqJs
prim__handleReq : RawReqHandler

startServerJs : String
startServerJs = "javascript:lambda:(port, reqHandler) => {" ++
        "let http = require('http');" ++
        "let server = http.createServer((req,res) => reqHandler(req)(res));" ++
        "server.listen(port);" ++
    "}"
    

%foreign startServerJs
prim__startServer : Int -> RawReqHandler -> PrimIO ()

startServer : Int -> RawReqHandler -> IO ()
startServer port setup_fn = primIO $ prim__startServer port setup_fn

runQuins : (port : Int) -> IO ()
runQuins port = do
    startServer port prim__handleReq
