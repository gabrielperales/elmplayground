port module Title exposing (..)

import Types


port newTitle : String -> Cmd msg


setTitle : String -> Cmd Types.Msg
setTitle title =
    newTitle title
