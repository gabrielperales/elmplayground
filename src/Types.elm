module Types exposing (..)

import Date exposing (Date)
import RemoteData exposing (WebData)
import Navigation


type alias Flags =
    { github_token : String
    }


type alias Model =
    { currentContent : Content
    , contributors : WebData (List GithubContributor)
    , searchPost : Maybe String
    , posts : List Content
    , watchMePosts : List Content
    , pages : List Content
    , location : Maybe Navigation.Location
    }


type alias Author =
    { name : String
    , avatar : String
    }


type alias GithubContributor =
    { name : String, profileUrl : String }


type ContentType
    = Page
    | Post


type alias Content =
    { title : String
    , name : String
    , slug : String
    , publishedDate : Date
    , author : Author
    , markdown : WebData String
    , contentType : ContentType
    , intro : String
    }


type alias Config =
    { pages : List Content
    , watchMePosts : List Content
    , posts : List Content
    }


type Msg
    = UrlChange Navigation.Location
    | FetchedContent (WebData String)
    | LinkClicked String
    | FetchedContributors (WebData (List GithubContributor))
    | UpdateSearchPost String
    | FetchedConfig (WebData Config)
