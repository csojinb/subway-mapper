import String
import List

import Html.App as App
import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes as HA

import Svg exposing (..)
import Svg.Attributes as SA

main = App.beginnerProgram { model = init, update = update, view = view }

-- MODEL

type alias Model = { size : Int, count : Int }

init : Model
init = { size = 100, count = 1 }

-- UPDATE

type Msg = Add | Remove | ChangeSize Int
update msg model =
    case msg of
        Add ->
            { model | count = model.count + 1 }
        Remove ->
            { model | count = max 0 (model.count - 1) }
        ChangeSize newSize ->
            { model | size = newSize }

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ div [] [ Html.text <| padString "Add or remove bullseyes:" 2
                 , button [ onClick Remove ] [ Html.text "-" ]
                 , Html.text <| padString (toString model.count) 2
                 , button [ onClick Add ] [ Html.text "+" ]
                 ]
        , div [] [ Html.text <| padString "Change size:" 2
                 , input [ HA.placeholder "100"
                         , onInput (toIntWithDefault 100 >> ChangeSize)
                         ] []
                 ]
        , div [] [ drawBullseyes model ]
        ]

padString : String -> Int -> String
padString s n = (String.repeat n " ") ++ s ++ (String.repeat n " ")

toIntWithDefault : Int -> String -> Int
toIntWithDefault default s =
    String.toInt s |> Result.toMaybe |> Maybe.withDefault default

drawBullseyes : Model -> Html Msg
drawBullseyes model =
    let
        (size, count) = (model.size, model.count)
        name = "bullseye" ++ (toString size)
        element = g [ SA.id name ] [ bullseye size ]
        place x = use [ SA.x <| toString <| (x - 1) * size
                      , SA.width (toString size)
                      , SA.height (toString size)
                      , SA.xlinkHref <| ref name ] []
    in
        svg [] [ defs [] [ element ]
               , g [] <| List.map place [1..count]
               ]

bullseye : Int -> Svg Msg
bullseye size =
    let
        center = size // 2
        band = size // 10
        ring = bullseyeRing center center
        radius n = n * band
        style = "stroke:black;stroke-width:" ++ (toString <| max 1 (band // 2))
    in
        g [ SA.style style ] <| List.map (ring << radius) [1..4]

bullseyeRing : Int -> Int -> Int -> Svg Msg
bullseyeRing x y r =
    circle [ SA.cx (toString x), SA.cy (toString y), SA.r (toString r)
           , SA.fillOpacity "0.0"] []


ref : String -> String
ref s = "#" ++ s



