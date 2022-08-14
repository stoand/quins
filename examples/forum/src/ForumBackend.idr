module ForumBackend

import public QuinsBackend

PORT : Int
PORT = 5000

main : IO ()
main = runQuins PORT
