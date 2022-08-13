module Main

import public PrimIO
import public Data.String
import public Data.List1

-- Lower level HTTP

HTML_INDEX : String
HTML_INDEX = "<html><head><title>Quins App</title><script src='/frontend.js'></script></head>" ++
    "<body><div id='quins-app-root'></div></body></html>"

FRONTEND_PATH : String
FRONTEND_PATH = "./frontend.js"


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
startServerJs = "javascript:lambda:(port, requestHandler) => {" ++
        "let http = require('http');" ++
        -- NOTE: there is an extra empty pair of parathesis
        "let server = http.createServer((req,res) => requestHandler(req)(res)());" ++
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


%foreign "javascript:lambda: (path) => { console.log(__dirname, path);  try { return require('fs').readFileSync(path, 'utf8') } catch(_err) { return 'file not found'; } }"
prim__nodeReadFile : String -> PrimIO String

nodeReadFile : String -> IO String
nodeReadFile path = fromPrim $ prim__nodeReadFile path

route : AnyPtr -> List String -> IO ()
route res ["", ""] = endRes res HTML_INDEX
route res ["", "frontend.js"] = do
    contents <- nodeReadFile FRONTEND_PATH
    endRes res contents
route res _ = endRes res "nothing"

requestHandler : AnyPtr -> AnyPtr -> IO ()
requestHandler request response = do
    url <- getReqUrl request
    putStrLn url
    route response $ forget (Data.String.split (== '/') url)
    
prim__requestHandler : AnyPtr -> AnyPtr -> PrimIO ()
prim__requestHandler req res = toPrim $ requestHandler req res

runQuins : (port : Int) -> IO ()
runQuins port = do
    startServer port prim__requestHandler
