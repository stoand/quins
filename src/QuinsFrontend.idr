module QuinsFrontend

%foreign "javascript:lambda: (val) => document.querySelector('#quins-app-root').innerHTML = val"
prim__setRootHtml : String -> PrimIO ()

setRootHtml : String -> IO ()
setRootHtml html = fromPrim $ prim__setRootHtml html

SpawnQuintuplet : Type
SpawnQuintuplet = (el : String) -> (attr : String) -> (value : String) -> (trans : String) -> (add : Bool) -> IO ()

spawnQuintuplet : SpawnQuintuplet 
spawnQuintuplet _ _ _ _ _ = putStrLn "spawn quintuplet"

%foreign "javascript:lambda: (spawnQuintuplet) => window.spawnQuintuplet = spawnQuintuplet"
prim__spawnQuintupletBind : SpawnQuintuplet -> PrimIO ()

spawnQuintupletBind : HasIO io => SpawnQuintuplet -> io ()
spawnQuintupletBind spawnQuintuplet = primIO $ prim__spawnQuintupletBind spawnQuintuplet 


dom : String
dom = """

<link rel='stylesheet' href='styles.css'>

<div>asdf</div>

<form onsubmit='window.spawnQuintuplet(`el0`)(`attr0`)(`value0`)(`trans0`)(true)(); return false'>

<input value='post title'>
<input value='post body'>

<button type='submit'>Create Forum Post</button>

</form>
"""

public export
runFrontend : IO ()
runFrontend = do
    putStrLn "hello to frontend"
    spawnQuintupletBind spawnQuintuplet
    setRootHtml dom
