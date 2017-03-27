module View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class, href, target, src)
import RemoteData exposing (WebData, RemoteData(..))
import Markdown
import Types exposing (Msg(..), GithubContributor)
import ViewSpecialCases
import Types exposing (Model, Msg, Content)
import ViewHelpers exposing (linkContent, externalLink)
import ContentUtils exposing (findBySlug, notFoundContent)


render : Model -> Html Msg
render model =
    div [ class "site-container" ]
        [ navigation model
        , header model
        , body model
        , footer model
        ]


header : Model -> Html Msg
header { title, subtitle } =
    Html.header [ class "header" ] [ h1 [] [ text title ], h4 [] [ text subtitle ] ]


active : String -> String -> Html.Attribute Msg
active path slug =
    class
        (if path == slug then
            "active"
         else
            ""
        )


navigation : Model -> Html Msg
navigation model =
    let
        path =
            model.location
                |> Maybe.map .pathname
                |> Maybe.withDefault "/"
    in
        nav [ class "navigation" ]
            [ li [ active "/" path ] [ linkContent "Home" <| findBySlug model.pages "/" ]
            , li [ active "/archives" path ] [ linkContent "Archives" <| findBySlug model.pages "/archives" ]
            , li [ active "/about" path ] [ linkContent "About" <| findBySlug model.pages "/about" ]
            , li [ class "hireme", active "/hire-me" path ] [ linkContent "Hire me" <| findBySlug model.pages "/hire-me" ]
            ]


body : Model -> Html Msg
body model =
    section [ class "body" ]
        [ mainBody model, subContent ]


subContent : Html Msg
subContent =
    div [ class "subContent" ]
        [ p [] [ text "" ] ]


mainBody : Model -> Html Msg
mainBody model =
    div [ class "mainBody" ]
        [ h1 [] [ text model.currentContent.title ]
        , renderMeta model.currentContent
        , renderContent model
        ]


renderMeta : Content -> Html Msg
renderMeta content =
    case content.contentType of
        Types.Page ->
            div [] []

        Types.Post ->
            div [ class "content-meta" ]
                [ p []
                    [ text
                        ("Published on " ++ ViewHelpers.formatDate content.publishedDate ++ " by " ++ content.author.name ++ ".")
                    ]
                ]


convertMarkdownToHtml : WebData String -> Html Msg
convertMarkdownToHtml markdown =
    case markdown of
        Success data ->
            Markdown.toHtml [ class "markdown-content" ] data

        Failure e ->
            text "There was an error"

        _ ->
            text "Loading"


renderContent : Model -> Html Msg
renderContent model =
    case ViewSpecialCases.getSpecialCase model.currentContent.title of
        Just fn ->
            article [ class "fn-content" ] [ (fn model) ]

        Nothing ->
            renderMarkdown model.currentContent.markdown


renderMarkdown : WebData String -> Html Msg
renderMarkdown markdown =
    article [ class "markdown-content" ] [ convertMarkdownToHtml markdown ]


footer : Model -> Html Msg
footer model =
    Html.footer [ class "footer" ]
        [ text "Blog forked from "
        , a [ target "_blank", href "https://github.com/jackfranklin/elmplayground" ] [ text "elmplayground" ]
        , text ". Some batteries were added by "
        , linkContent "me" <| findBySlug model.pages "/about"
        ]
