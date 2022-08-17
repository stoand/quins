module ForumFrontend

import public QuinsFrontend

-- %foreign "javascript:lambda: () => { return typeof document != 'undefined' }"
%foreign "javascript:lambda: () => { return typeof require != undefined && require('process').argv[2]; }"
prim__isTestMode : () -> PrimIO String

isTestMode : IO String
isTestMode = fromPrim $ prim__isTestMode ()

main : IO ()
main = do
    test_mode <- isTestMode
    putStrLn (if test_mode == "test-frontend" then "yes-test-mode" else "no-test-mode")
