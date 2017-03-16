module ContentUtils exposing (..)

import Types exposing (Model, Author, Content, ContentType(..))
import List
import Date exposing (Month(..))
import Date.Extra exposing (fromCalendarDate)
import String
import RemoteData


allContent : Model -> List Content
allContent model =
    model.pages ++ model.posts ++ model.watchMePosts


notFoundContent : Content
notFoundContent =
    { title = "Couldn't find content"
    , contentType = Page
    , name = "not-found"
    , slug = "notfound"
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Author "Jack" "..."
    , markdown = RemoteData.NotAsked
    , intro = ""
    }


findBySlug : List Content -> String -> Content
findBySlug contentList slug =
    contentList
        |> List.filter (\piece -> piece.slug == slug)
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
