module Main

import public PrimIO

ReqHandler : Type
ReqHandler = AnyPtr -> AnyPtr -> PrimIO ()

handleReqJs : String
handleReqJs = "(req, res) => {" ++
    "res.end(55555)" ++
    "" ++
    "}"

%foreign handleReqJs
prim__handleReq : ReqHandler

handleReq : AnyPtr -> AnyPtr -> IO ()
handleReq request response = primIO $ prim__handleReq request response

startServerJs : String
startServerJs = "javascript:lambda:(port, reqHandler) => {" ++
        "let http = require('http');" ++
        "let server = http.createServer(reqHandler);" ++
        "server.listen(port);" ++
    "}" 

%foreign startServerJs
prim__startServer : Int -> ReqHandler -> PrimIO ()

startServer : Int -> ReqHandler -> IO ()
startServer port setup_fn = primIO $ prim__startServer port setup_fn

runQuins : IO ()
runQuins = do
    startServer 5000 ?todo_handler
