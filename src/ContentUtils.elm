module ContentUtils exposing (..)

import Types exposing (Model, Author, Content, ContentType(..))
import List
import Date exposing (Month(..))
import Date.Extra exposing (fromCalendarDate)
import String
import RemoteData
import Regex exposing (replace, regex, HowMany(..))


allContent : Model -> List Content
allContent model =
    model.pages ++ model.posts


notFoundContent : Content
notFoundContent =
    { title = "Couldn't find content"
    , contentType = Page
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Author "Jack" "..."
    , markdown = RemoteData.NotAsked
    }


getSlug : String -> String
getSlug =
    let
        removeAccentuated : String -> String
        removeAccentuated input =
            input
                |> replace All (regex "[.,\\/#!$%\\^&\\*\\+;:{}<=>?|@\\-_`~()[]]") (always "")
                |> replace All (regex "[àáâãäå]") (always "a")
                |> replace All (regex "[èéêë]") (always "e")
                |> replace All (regex "[ìíîï]") (always "i")
                |> replace All (regex "[òóôõö]") (always "o")
                |> replace All (regex "[ùúûü]") (always "u")
                |> replace All (regex "[ýÿ]") (always "y")
                |> replace All (regex "ñ") (always "n")
                |> replace All (regex "ç") (always "c")
    in
        String.toLower >> removeAccentuated >> String.words >> String.join "-"


findBySlug : List Content -> String -> Content
findBySlug contentList slug =
    contentList
        |> List.filter (\piece -> "/" ++ (getSlug piece.title) == slug)
        |> List.head
        |> Maybe.withDefault notFoundContent


filterByContentType : List Content -> ContentType -> List Content
filterByContentType contentList contentType =
    List.filter (\c -> c.contentType == contentType) contentList


filterByTitle : List Content -> Maybe String -> List Content
filterByTitle contentList title =
    case title of
        Just title ->
            List.filter (\c -> String.contains (String.toLower title) (String.toLower c.title))
                contentList

        Nothing ->
            sortByDate contentList


findPosts : List Content -> List Content
findPosts contentList =
    filterByContentType contentList Post


latest : List Content -> Content
latest =
    sortByDate >> List.head >> Maybe.withDefault notFoundContent


sortByDate : List Content -> List Content
sortByDate =
    List.sortWith (flip contentByDateComparison)


contentByDateComparison : Content -> Content -> Order
contentByDateComparison a b =
    Date.Extra.compare a.publishedDate b.publishedDate
