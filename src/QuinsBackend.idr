module QuinsBackend

import PrimIO
import Data.String
import Data.List1
import MimeList

-- Lower level HTTP

HTML_INDEX : String
HTML_INDEX = "<html><head><title>Quins App</title></head>" ++
    "<body><div id='quins-app-root'></div><script src='quins-forum-frontend.js'></script></body></html>"

RawReqHandler : Type
RawReqHandler = AnyPtr -> AnyPtr -> PrimIO ()

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

endResJs : String
endResJs = "javascript:lambda: (res,code,mime,str) => {" ++
    "res.writeHead(code, {'Content-Type': mime});" ++
    "res.end(str);" ++
    "" ++
    "}"
    
%foreign endResJs
prim__endRes : AnyPtr -> (responseCode : Int) -> (mimeType : String) -> (body : String) -> PrimIO ()

endRes : AnyPtr -> (responseCode : Int) -> (mimeType : String) -> (body : String) -> IO ()
endRes ptr response_code mime_type body = fromPrim $ prim__endRes ptr response_code mime_type body

nodeReadFileJs : String
nodeReadFileJs = "javascript:lambda: (path) => {" ++
    -- NOTE: no sanitizing paths in the format '../../secret' is needed
    -- these urls are sanitized when nodejs parses the request
    "let fullPath = require('path').join(__dirname, path);" ++
    "try { return require('fs').readFileSync(fullPath, 'utf8') } catch(_err) { return 'FILE_NOT_FOUND'; } }"

%foreign nodeReadFileJs
prim__nodeReadFile : String -> PrimIO String

nodeReadFile : String -> IO String
nodeReadFile path = fromPrim $ prim__nodeReadFile path

route : AnyPtr -> String -> IO ()
route res "/" = endRes res 200 "text/html" HTML_INDEX
route res file_path = do
    contents <- nodeReadFile file_path
    if contents == "FILE_NOT_FOUND" then
        endRes res 404 "text/plain" "file not found" else endRes res 200 (mimeForPath file_path) contents

requestHandler : AnyPtr -> AnyPtr -> IO ()
requestHandler request response = do
    url <- getReqUrl request
    route response url
    
prim__requestHandler : AnyPtr -> AnyPtr -> PrimIO ()
prim__requestHandler req res = toPrim $ requestHandler req res


public export
runQuins : (port : Int) -> IO ()
runQuins port = do
    startServer port prim__requestHandler
