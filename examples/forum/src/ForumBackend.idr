module ForumBackend

import public QuinsBackend

PORT : Int
PORT = 5000

main : IO ()
main = do
    putStr $ "starting forum server on http://localhost:" ++ show PORT
    runQuins PORT
