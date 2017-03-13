module Types exposing (..)

import Date exposing (Date)
import RemoteData exposing (WebData)
import Navigation
import Dict exposing (Dict)


type alias Model =
    { currentContent : Content
    , contributors : WebData (List GithubContributor)
    , searchPost : Maybe String
    , config : WebData Config
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


type alias ContentConfig =
    { title : String
    , name : String
    , slug : String
    , publishedDate : String
    , author : String
    }


type alias Config =
    { pages : List ContentConfig
    , posts : List ContentConfig
    , authors : Dict String Author
    }


type Msg
    = UrlChange Navigation.Location
    | FetchedContent (WebData String)
    | LinkClicked String
    | FetchedContributors (WebData (List GithubContributor))
    | UpdateSearchPost String
    | FetchedConfig (WebData Config)
