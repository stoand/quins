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


%foreign "javascript:lambda: () => console.log(1234)"
consoleLog : PrimIO ()


%foreign "javascript:lambda: (req) => req.url"
getReqUrl : AnyPtr -> PrimIO String

multiHandler : AnyPtr -> AnyPtr -> PrimIO ()
multiHandler request response =
    let prim__url = getReqUrl request in
    let url = fromPrim prim__url in
    
    let res0 = handleReq request response in
    let res1 = putStrLn "asdf" in
    let res0_io = fromPrim res0 in

    let comb = (do
        url_str <- url
        putStrLn $ url_str
        res0_io
        res1) in
            
        toPrim comb

runQuins : (port : Int) -> IO ()
runQuins port = do
    -- startServer port handleReq
    startServer port multiHandler
