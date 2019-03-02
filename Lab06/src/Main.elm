import Browser
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (value, placeholder)
import Html.Events exposing (onInput)


main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  { 
    content1 : String,
    content2 : String
  }

init : Model
init =
  { content1 = ""
  , content2 = ""
  }

type Msg = Change String | Change2 String  

update : Msg -> Model -> Model
update msg model =
  case msg of Change newContent -> { model | content1 = newContent }
              Change2 newContent -> { model | content2 = newContent }


view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "String 1", value model.content1, onInput (Change) ] []
    , input [ placeholder "String 2", value model.content2, onInput (Change2) ] []
    , div [] [ text (model.content1 ++ " : " ++ model.content2) ]
    ]

    