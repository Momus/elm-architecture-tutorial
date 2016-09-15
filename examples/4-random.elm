module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Random


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieOne : Int
    , dieTwo : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1 1, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFace ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.pair (Random.int 1 6) (Random.int 1 6)
                |> Random.generate NewFace
            )

        NewFace newFace ->
            ( Model (fst newFace) (snd newFace)
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text (toString model.dieOne)
            , text "    "
            , text (toString model.dieTwo)
            ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
