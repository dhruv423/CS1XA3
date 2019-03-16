import Browser
import Html exposing (..)
import String
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Http





-- MAIN


main =
 Browser.element
     { init = init
     , update = update
     , subscriptions = subscriptions
     , view = view
     }



-- MODEL


type alias Model =
  { name : String
  , password : String
  , response : String
  }


init : () -> (Model, Cmd Msg)
init _ =
  (Model "" "" "", Cmd.none)


type Msg
  = Name String
  | Password String
  | ResponsePost (Result Http.Error String)
  | Match

post : Model -> Cmd Msg
post model =
  Http.post
    { url = "https://mac1xa3.ca/e/bhavsd1/lab7/"
    , body = Http.stringBody "application/x-www-form-urlencoded" ("name=" ++ model.name ++ "&password=" ++ model.password)
    , expect = Http.expectString ResponsePost
    }



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Name name ->
      ({ model | name = name }, Cmd.none)

    Password password ->
      ({ model | password = password }, Cmd.none)

    Match ->
      (model, post model)

    ResponsePost result ->
            case result of
                Ok val -> ( { model | response = val }, Cmd.none )
                Err error -> ( handleError model error, Cmd.none )


handleError model error =
    case error of
        Http.BadUrl url ->
            { model | response = "bad url: " ++ url }
        Http.Timeout ->
            { model | response = "timeout" }
        Http.NetworkError ->
            { model | response = "network error" }
        Http.BadStatus i ->
            { model | response = "bad status " ++ String.fromInt i }
        Http.BadBody body ->
            { model | response = "bad body " ++ body }




subscriptions : Model -> Sub Msg
subscriptions _ =
                Sub.none

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ viewInput "text" "Name" model.name Name
    , viewInput "password" "Password" model.password Password
    , div [] [ text model.response ]
    , button [onClick Match] [ text "POST"]
    ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []
