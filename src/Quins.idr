module Main

import public PrimIO

%foreign "javascript:lambda: (x) => x(22)"
prim__ok : (Double -> Double) -> PrimIO Double

ok : Double -> IO Double
ok d = primIO $ prim__ok (\x => x + 2)


%foreign "javascript:lambda: () => document.body.innerText = 'asdf'"
prim__setBodyText : PrimIO ()

setBodyText : IO ()
setBodyText = primIO $ prim__setBodyText

%foreign "javascript:lambda: x => window.x = x"
prim_setGlobalX : Double -> PrimIO ()

setGlobalX : Double -> IO ()
setGlobalX x = primIO $ prim_setGlobalX x

%foreign "javascript:lambda: () => window.x"
prim_getGlobalX : () -> PrimIO Double

getGlobalX : IO Double
getGlobalX = primIO $ prim_getGlobalX ()

runQuins : IO ()
runQuins = do

    setGlobalX 11

    x <- getGlobalX
    
    printLn $ "global X = " ++ show x
    
    setBodyText
