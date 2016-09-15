module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events as Events exposing (..)
import Http
import Json.Decode as Json
import Task
import VirtualDom exposing (Node(..))


main =
    Html.program
        { init = init "cats"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    }


topics : List String
topics =
    [ "cats"
    , "dogs"
    , "transportation"
    , "nature"
    , "music"
    ]


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model topic "waiting.gif"
    , getRandomGif topic
    )



-- UPDATE


type Msg
    = MorePlease
    | NewTopic String
    | FetchSucceed String
    | FetchFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        NewTopic newTopic ->
            ( { model | topic = newTopic }, getRandomGif newTopic )

        FetchSucceed newUrl ->
            ( Model model.topic newUrl, Cmd.none )

        FetchFail _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ Html.Attributes.class "container" ]
        [ h3 [] [ text "Chose a gif!" ]
        , Html.br [] []
        , topicDropDown
        , br [] []
        , img [ src model.gifUrl ] []
        , br [] []
        , button [ onClick MorePlease ] [ text "More Please!" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "//api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string



-- VIEW Funcions


topicDropDown : Html.Html Msg
topicDropDown =
    Html.select [ onChange NewTopic ] (dropDownItems topics)


dropDownItems : List String -> List (Html a)
dropDownItems choices =
    let
        createEntry item =
            Html.option [ Html.Attributes.value item ]
                [ Html.text item ]
    in
        List.map createEntry choices


{-| from https://github.com/elm-lang/html/issues/23
   I don't really understand how it works, but it does.
-}
onChange : (String -> msg) -> Attribute msg
onChange handler =
    Events.on "change"
        <| Json.map handler
        <| Json.at [ "target", "value" ] Json.string
