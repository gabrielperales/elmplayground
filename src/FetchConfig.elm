module FetchConfig exposing (..)

import Types exposing (..)
import Http
import RemoteData
import Json.Decode as Decode exposing (Decoder, field, string)
import Dict exposing (Dict)


fetch : Cmd Msg
fetch =
    request
        |> Http.toTask
        |> RemoteData.asCmd
        |> Cmd.map FetchedConfig


request : Http.Request Config
request =
    Http.request
        { method = "GET"
        , headers = []
        , url = "/config.json"
        , body = Http.emptyBody
        , expect = Http.expectJson configDecoder
        , timeout = Nothing
        , withCredentials = False
        }


configDecoder : Decoder Config
configDecoder =
    Decode.map3 Config
        (field "posts" (Decode.list decodeContent))
        (field "pages" (Decode.list decodeContent))
        (field "authors" decodeConfigAuthors)


decodeContent : Decoder ContentConfig
decodeContent =
    Decode.map5 ContentConfig
        (field "slug" string)
        (field "name" string)
        (field "title" string)
        (field "publishedDate" string)
        (field "author" string)


decodeConfigAuthor : Decoder Author
decodeConfigAuthor =
    Decode.map2 Author
        (field "name" string)
        (field "avatar" string)


decodeConfigAuthors : Decoder (Dict String Author)
decodeConfigAuthors =
    Decode.dict decodeConfigAuthor
