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

%foreign "javascript:lambda: (req) => req.url"
prim__getReqUrl : AnyPtr -> PrimIO String

getReqUrl : AnyPtr -> IO String
getReqUrl ptr = fromPrim $ prim__getReqUrl ptr

%foreign "javascript:lambda: (res,str) => res.end(str)"
prim__endRes : AnyPtr -> String -> PrimIO ()

endRes : AnyPtr -> String -> IO ()
endRes ptr str = fromPrim $ prim__endRes ptr str

multiHandler : AnyPtr -> AnyPtr -> IO ()
multiHandler request response = do
    url_str <- getReqUrl request
    putStrLn url_str

    endRes response "bybye"

prim__multiHandler : AnyPtr -> AnyPtr -> PrimIO ()
prim__multiHandler req res = toPrim $ multiHandler req res

runQuins : (port : Int) -> IO ()
runQuins port = do
    -- startServer port handleReq
    startServer port prim__multiHandler
