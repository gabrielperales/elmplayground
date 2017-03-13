module ContentUtils exposing (..)

import Types exposing (Content, ContentType(..))
import List
import Pages
import Date.Extra
import Posts
import String


allContent : List Content
allContent =
    Pages.pages ++ Posts.posts


findBySlug : List Content -> String -> Maybe Content
findBySlug allContent slug =
    allContent
        |> List.filter (\piece -> piece.slug == slug)
        |> List.head


filterByContentType : ContentType -> List Content -> List Content
filterByContentType contentType content =
    List.filter (\c -> c.contentType == contentType) content


filterByTitle : List Content -> Maybe String -> List Content
filterByTitle contentList title =
    case title of
        Just title ->
            List.filter (\c -> String.contains (String.toLower title) (String.toLower c.title))
                contentList

        Nothing ->
            postsInOrder contentList


findPosts : List Content -> List Content
findPosts =
    filterByContentType Post


latest : List Content -> Content
latest contentList =
    postsInOrder contentList
        |> List.head
        |> Maybe.withDefault Pages.notFoundContent


postsInOrder : List Content -> List Content
postsInOrder =
    List.sortWith (flip contentByDateComparison)


watchMeElmPosts : List Content
watchMeElmPosts =
    List.sortWith (flip contentByDateComparison) Posts.watchMeElmPosts


contentByDateComparison : Content -> Content -> Order
contentByDateComparison a b =
    Date.Extra.compare a.publishedDate b.publishedDate
