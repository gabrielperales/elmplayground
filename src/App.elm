module MyApp exposing (..)

import Navigation
import Types exposing (Flags, Model, Msg(..))
import View
import OnUrlChange
import GithubApi
import RemoteData
import FetchConfig
import ContentUtils


initialModel : Model
initialModel =
    { currentContent = ContentUtils.notFoundContent
    , contributors = RemoteData.NotAsked
    , searchPost = Nothing
    , posts = []
    , watchMePosts = []
    , pages = []
    , location = Nothing
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    { initialModel | location = Just location }
        ! [ GithubApi.fetchContributors flags.github_token
          , FetchConfig.fetch
          ]


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

        FetchedContributors response ->
            { model | contributors = response } ! []

        UrlChange location ->
            OnUrlChange.update location.pathname model

        UpdateSearchPost title ->
            { model | searchPost = Just title } ! []

        FetchedConfig response ->
            case response of
                RemoteData.Success config ->
                    let
                        updatedModel =
                            { model | pages = config.pages, posts = config.posts, watchMePosts = config.watchMePosts }
                    in
                        case updatedModel.location of
                            Just loc ->
                                update (UrlChange loc) updatedModel

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
