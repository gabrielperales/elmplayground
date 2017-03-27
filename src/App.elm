module MyApp exposing (..)

import Navigation
import Types exposing (Flags, Model, Msg(..))
import View
import OnUrlChange
import RemoteData
import FetchConfig
import ContentUtils


initialModel : Model
initialModel =
    { title = ""
    , subtitle = ""
    , currentContent = ContentUtils.notFoundContent
    , searchPost = Nothing
    , posts = []
    , pages = []
    , location = Nothing
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    { initialModel | location = Just location } ! [ FetchConfig.fetch ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked slug ->
            model ! [ Navigation.newUrl slug ]

        FetchedContent response ->
            let
                currentContent =
                    model.currentContent

                newCurrent =
                    { currentContent | markdown = response }
            in
                { model | currentContent = newCurrent } ! []

        UrlChange location ->
            OnUrlChange.update location.pathname { model | location = Just location }

        UpdateSearchPost title ->
            { model | searchPost = Just title } ! []

        FetchedConfig response ->
            case response of
                RemoteData.Success { title, subtitle, pages, posts } ->
                    let
                        updatedModel =
                            { model | title = title, subtitle = subtitle, pages = pages, posts = posts }
                    in
                        case updatedModel.location of
                            Just location ->
                                update (UrlChange location) updatedModel

                            _ ->
                                updatedModel ! []

                _ ->
                    model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = View.render
        , update = update
        , subscriptions = subscriptions
        }
