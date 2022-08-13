module Main

import public PrimIO

-- Lower level HTTP

RawReqHandler : Type
RawReqHandler = AnyPtr -> AnyPtr -> PrimIO ()

handleReqJs : String
handleReqJs = "javascript:lambda:(req, res) => {" ++
    "res.end('55555');" ++
    "" ++
    "}"

%foreign handleReqJs
prim__handleReq : RawReqHandler

%foreign "javascript:lambda: (a,b) => {console.log(234) }"
prim__print : AnyPtr -> AnyPtr -> PrimIO ()

handleReq : RawReqHandler
handleReq req res = do
    prim__handleReq req res

startServerJs : String
startServerJs = "javascript:lambda:(port, reqHandler) => {" ++
        "let http = require('http');" ++
        -- NOTE: there is an extra empty pair of parathesis
        "let server = http.createServer((req,res) => reqHandler(req)(res)());" ++
        "server.listen(port);" ++
    "}"



%foreign startServerJs
prim__startServer : Int -> RawReqHandler -> PrimIO ()

startServer : HasIO io => Int -> RawReqHandler -> io ()
startServer port setup_fn = primIO $ prim__startServer port setup_fn

runQuins : (port : Int) -> IO ()
runQuins port = do
    startServer port handleReq
