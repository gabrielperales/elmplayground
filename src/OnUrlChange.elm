module OnUrlChange exposing (update)

import Types exposing (Model, Msg, Content)
import FetchContent
import Title
import RemoteData exposing (RemoteData)
import ViewSpecialCases
import ContentUtils


getContentForUrl : Model -> String -> Content
getContentForUrl model =
    ContentUtils.findBySlug <| ContentUtils.allContent model


update : String -> Model -> ( Model, Cmd Msg )
update newUrl model =
    let
        item =
            getContentForUrl model newUrl

        newItem =
            { item | markdown = RemoteData.Loading }

        specialCase =
            ViewSpecialCases.hasSpecialCase newUrl

        commands =
            if specialCase then
                []
            else
                [ FetchContent.fetch newItem, Title.setTitle newItem.title ]
    in
        { model | currentContent = newItem } ! commands
