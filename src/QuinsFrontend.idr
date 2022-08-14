module QuinsFrontend

%foreign "javascript:lambda: (val) => document.querySelector('#quins-app-root').innerHTML = val"
prim__setRootHtml : String -> PrimIO ()

setRootHtml : String -> IO ()
setRootHtml html = fromPrim $ prim__setRootHtml html

dom : String
dom = """
<div>asdf</div>

<form>

<input value='post title'>
<input value='post body'>

<button type='submit' value='Create Forum Post'>

</form>
"""

public export
runFrontend : IO ()
runFrontend = do
    putStrLn "hello to frontend"
    setRootHtml dom
