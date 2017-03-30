module ViewSpecialCases exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, placeholder)
import Html.Events exposing (onInput)
import Dict exposing (Dict)
import ViewHelpers


type alias ViewFn =
    Model -> Html Msg


specialCases : Dict String ViewFn
specialCases =
    Dict.fromList
        [ ( "/", \model -> div [] [ ViewHelpers.renderLatestPosts model ] )
        , ( "/archives"
          , \model ->
                (div []
                    [ input
                        [ onInput UpdateSearchPost
                        , placeholder "Search"
                        , class "searchInput"
                        ]
                        []
                    , ViewHelpers.renderArchives model
                    ]
                )
          )
        ]


getSpecialCase : String -> Maybe ViewFn
getSpecialCase =
    ((flip Dict.get) specialCases)


hasSpecialCase : String -> Bool
hasSpecialCase slug =
    case getSpecialCase slug of
        Just _ ->
            True

        Nothing ->
            False
