module FetchConfig exposing (..)

import Types exposing (..)
import Http
import RemoteData
import Json.Decode as Decode exposing (Decoder, andThen, field, at, string)
import Dict exposing (Dict)
import Date exposing (Date)


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
    (field "authors" decodeConfigAuthors
        |> andThen
            (\authors ->
                Decode.map2
                    Config
                    (field "posts" <| Decode.list <| decodeContent Post authors)
                    (field "pages" <| Decode.list <| decodeContent Page authors)
            )
    )


decodeDate : Decoder Date
decodeDate =
    string
        |> andThen
            (\str ->
                case (Date.fromString str) of
                    Ok date ->
                        Decode.succeed date

                    Err error ->
                        Decode.fail error
            )


decodeContent : ContentType -> Dict String Author -> Decoder Content
decodeContent contentType authors =
    Decode.map8 Content
        (field "slug" string)
        (field "name" string)
        (field "title" string)
        (field "publishedDate" decodeDate)
        (field "author"
            (string
                |> Decode.andThen
                    (\name ->
                        case Dict.get name authors of
                            Just x ->
                                Decode.succeed x

                            Nothing ->
                                Decode.fail "Author not found"
                    )
            )
        )
        (Decode.succeed RemoteData.NotAsked)
        (Decode.succeed contentType)
        (field "intro" string)


decodeConfigAuthor : Decoder Author
decodeConfigAuthor =
    Decode.map2 Author
        (field "name" string)
        (field "avatar" string)


decodeConfigAuthors : Decoder (Dict String Author)
decodeConfigAuthors =
    Decode.dict decodeConfigAuthor
