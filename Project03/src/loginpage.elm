import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Browser.Navigation exposing (load)
import Html.Events as Events
import Http
import Json.Decode as JDecode
import Json.Encode as JEncode
import String


main = Browser.element { init = init
                       , update = update
                       , subscriptions = \_ -> Sub.none
                       , view = view
                       }

rootUrl =
    "http://localhost:8000/"

-- Model 
type alias Model =  
    { name : String, password : String, error : String }


type Msg = NewName String -- Name text field changed
    | NewPassword String -- Password text field changed
    | GotLoginResponse (Result Http.Error String) -- Http Post Response Received
    | LoginButton -- Login Button Pressed


init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = ""
      , password = ""
      , error = ""
      }
    , Cmd.none
    )

-- View
view : Model -> Html Msg
view model = div []
    [ node "link" [ rel "icon", type_ "image/png", href "images/icons/favicon.ico" ]
        []
    , node "link" [ rel "stylesheet", type_ "text/css", href "vendor/bootstrap/css/bootstrap.min.css" ]
        []
    , node "link" [ rel "stylesheet", type_ "text/css", href "fonts/font-awesome-4.7.0/css/font-awesome.min.css" ]
        []
    , node "link" [ rel "stylesheet", type_ "text/css", href "fonts/iconic/css/material-design-iconic-font.min.css" ]
        []
    , node "link" [ rel "stylesheet", type_ "text/css", href "vendor/animate/animate.css" ]
        []
    , node "link" [ rel "stylesheet", type_ "text/css", href "vendor/css-hamburgers/hamburgers.min.css" ]
        []
    , node "link" [ rel "stylesheet", type_ "text/css", href "vendor/animsition/css/animsition.min.css" ]
        []
    , node "link" [ rel "stylesheet", type_ "text/css", href "css/util.css" ]
        []
    , node "link" [ rel "stylesheet", type_ "text/css", href "css/main.css" ]
        []
    , div [ class "limiter" ]
         [ div [ class "container-login100" ]
            [ div [ class "wrap-login100" ]
                 [ div [ class "login100-form validate-form" ]
                     [ span [ class "login100-form-title p-b-26" ]
                        [ text "Welcome" ]
                        , span [ class "login100-form-title p-b-48" ]
                        [ p []
                        [ text model.error ]
                        ]
                        , div [ class "wrap-input100 validate-input" ]
                        [ viewInput "text" "Email" model.name NewName ]
                        
                        , div [ class "wrap-input100 validate-input" ]
                        [ viewInput "password" "Password" model.password NewPassword ]
                        , div [ class "container-login100-form-btn" ]
                        [ div [ class "wrap-login100-form-btn" ]
                        [ div [ class "login100-form-bgbtn" ]
                        []
                        , button [ class "login100-form-btn", Events.onClick LoginButton ]
                        [ text "Login" ]
                        ]
                        ]
                        , div [ class "text-center p-t-115" ]
                        [ span [ class "txt1" ]
                        [ text "Don’t have an account?" ]
                        , a [ class "txt2", href "#" ]
                        [ text " Sign Up" ]
                        ]
                    ]
                ]
            ]
        ]
    ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, Events.onInput toMsg ] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewName name ->
            ( { model | name = name }, Cmd.none )

        NewPassword password ->
            ( { model | password = password }, Cmd.none )

        LoginButton ->
            ( model, loginPost model )

        GotLoginResponse result ->
            case result of
                Ok "LoginFailed" ->
                    ( { model | error = "Failed to Login" }, Cmd.none )

                Ok _ ->
                    ( model, load ("https://google.ca") )

                Err error ->
                    ( handleError model error, Cmd.none )



passwordEncoder : Model -> JEncode.Value
passwordEncoder model =
    JEncode.object
        [ ( "username"
          , JEncode.string model.name
          )
        , ( "password"
          , JEncode.string model.password
          )
        ]



loginPost : Model -> Cmd Msg
loginPost model =
    Http.post
        { url = rootUrl ++ "userauth/loginuser/"
        , body = Http.jsonBody <| passwordEncoder model
        , expect = Http.expectString GotLoginResponse
        }



handleError : Model -> Http.Error -> Model
handleError model error =
    case error of
        Http.BadUrl url ->
            { model | error = "bad url: " ++ url }

        Http.Timeout ->
            { model | error = "timeout" }

        Http.NetworkError ->
            { model | error = "network error" }

        Http.BadStatus i ->
            { model | error = "bad status " ++ String.fromInt i }

        Http.BadBody body ->
            { model | error = "bad body " ++ body }
