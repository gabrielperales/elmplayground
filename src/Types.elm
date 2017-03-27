module Types exposing (..)

import Date exposing (Date)
import RemoteData exposing (WebData)
import Navigation


type alias Flags =
    { github_token : String
    }


type alias Model =
    { title : String
    , subtitle : String
    , currentContent : Content
    , searchPost : Maybe String
    , posts : List Content
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
    , publishedDate : Date
    , author : Author
    , markdown : WebData String
    , contentType : ContentType
    }


type alias Config =
    { title : String
    , subtitle : String
    , pages : List Content
    , posts : List Content
    }


type Msg
    = UrlChange Navigation.Location
    | FetchedContent (WebData String)
    | LinkClicked String
    | UpdateSearchPost String
    | FetchedConfig (WebData Config)
