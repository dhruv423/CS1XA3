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
    { name : String, password : String, passwordC : String, error : String }


type Msg = NewUser String -- Name text field changed
    | NewPassword String -- Password text field changed
    | NewPasswordC String -- Confirm Password field
    | GotRegisterResponse (Result Http.Error String) -- Http Post Response Received
    | RegisterButton -- Register Button Pressed


init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = ""
      , password = ""
      , passwordC = ""
      , error = ""
      }
    , Cmd.none
    )

-- View
view : Model -> Html Msg
view model = div []
    [ node "link" [ href "SiteFiles/vendor/fontawesome-free/css/all.min.css", rel "stylesheet", type_ "text/css" ]
        []
    , node "link" [ href "SiteFiles/vendor/datatables/dataTables.bootstrap4.css", rel "stylesheet" ]
        []
    , node "link" [ href "SiteFiles/css/sb-admin.css", rel "stylesheet" ]
        []
    , nav [ class "navbar navbar-expand navbar-dark bg-dark static-top" ]
        [ a [ class "navbar-brand mr-1", href "index.html" ]
            [ text "FinTrack" ]
        , ul [ class "navbar-nav ml-auto ml-md-0" ]
            [ li [ class "nav-item no-arrow" ]
                [ a [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "nav-link", attribute "data-toggle" "", href "#", attribute "role" "button" ]
                    [ i [ class "fas fa-user-circle fa-fw" ]
                        [ ]
                    ]
                ]
            ]
        ]
    , div [ id "wrapper" ]
        [ ul [ class "sidebar navbar-nav" ]
            [ li [ class "nav-item active" ]
                [ a [ class "nav-link", href "index.html" ]
                    [ i [ class "fas fa-fw fa-tachometer-alt" ]
                        []
                    , span []
                        [ text " Dashboard" ]
                    ]
                ]
            , li [ class "nav-item dropdown" ]
                [ a [ class "nav-link", href "index.html" ]
                    [ i [ class "fas fa-fw fa-folder" ]
                        []
                    , span []
                        [ text " Pages" ]
                    ]
                ]
            , li [ class "nav-item" ]
                [ a [ class "nav-link", href "charts.html" ]
                    [ i [ class "fas fa-fw fa-chart-area" ]
                        []
                    , span []
                        [ text " Charts" ]
                    ]
                ]
            , li [ class "nav-item" ]
                [ a [ class "nav-link", href "tables.html" ]
                    [ i [ class "fas fa-fw fa-table" ]
                        []
                    , span []
                        [ text " Tables" ]
                    ]
                ]
            ]
        , div [ id "content-wrapper" ]
            [ div [ class "container-fluid" ]
                [ ol [ class "breadcrumb" ]
                    [ li [ class "breadcrumb-item" ]
                        [ a [ href "#" ]
                            [ text "Dashboard" ]
                        ]
                    , li [ class "breadcrumb-item active" ]
                        [ text "Overview" ]
                    ]
                , div [ class "card mb-3" ]
                    [ div [ class "card-header" ]
                        [ i [ class "fas fa-chart-area" ]
                            []
                        , text " Area Chart Example"
                        ]
                    , div [ class "card-body" ]
                        [ canvas [ attribute "height" "30", id "myAreaChart", attribute "width" "100%" ]
                            []
                        ]
                    , div [ class "card-footer small text-muted" ]
                        [ text "Updated yesterday at 11:59 PM" ]
                    ]
                , div [ class "card mb-3" ]
                    [ div [ class "card-header" ]
                        [ i [ class "fas fa-table" ]
                            []
                        , text " Data Table Example"
                        ]
                    , div [ class "card-body" ]
                        [ canvas [ attribute "height" "30", id "myAreaChart", attribute "width" "100%" ]
                            []
                        ]                    
                    , div [ class "card-footer small text-muted" ]
                        [ text "Updated yesterday at 11:59 PM" ]
                    ]
                ]
            , text "      "
            , footer [ class "sticky-footer" ]
                [ div [ class "container my-auto" ]
                    [ div [ class "copyright text-center my-auto" ]
                        [ span []
                            [ text "Copyright © FinTrack 2019" ]
                        ]
                    ]
                ]
            ]
        , text "  "
        ]
    , text "  "
    , div [ attribute "aria-hidden" "true", attribute "aria-labelledby" "exampleModalLabel", class "modal fade", id "logoutModal", attribute "role" "dialog", attribute "tabindex" "-1" ]
        [ div [ class "modal-dialog", attribute "role" "document" ]
            [ div [ class "modal-content" ]
                [ div [ class "modal-header" ]
                    [ h5 [ class "modal-title", id "exampleModalLabel" ]
                        [ text "Ready to Leave?" ]
                    , button [ attribute "aria-label" "Close", class "close", attribute "data-dismiss" "modal", type_ "button" ]
                        [ span [ attribute "aria-hidden" "true" ]
                            [ text "×" ]
                        ]
                    ]
                , div [ class "modal-body" ]
                    [ text "Select \"Logout\" below if you are ready to end your current session." ]
                , div [ class "modal-footer" ]
                    [ button [ class "btn btn-secondary", attribute "data-dismiss" "modal", type_ "button" ]
                        [ text "Cancel" ]
                    , a [ class "btn btn-primary", href "login.html" ]
                        [ text "Logout" ]
                    ]
                ]
            ]
        ]
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUser name ->
            ( { model | name = name }, Cmd.none )

        NewPassword password ->
            ( { model | password = password }, Cmd.none )
        
        NewPasswordC password ->
            ( { model | passwordC = password }, Cmd.none )

        RegisterButton ->
            if model.password == model.passwordC && model.password /= "" then
                    ( model, loginPost model )
            else if model.name == "" then
                    ( { model | error = "Please enter in an Username" }, Cmd.none)
            else if model.password == "" then
                    ( { model | error = "Please enter in a Password" }, Cmd.none)
            else
                    ( { model | error = "Passwords don't Match" }, Cmd.none)

        GotRegisterResponse result ->
            case result of
                Ok "RegisterFailed" ->
                    ( { model | error = "Failed to Register" }, Cmd.none )

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
        { url = rootUrl ++ "userauth/adduser/"
        , body = Http.jsonBody <| passwordEncoder model
        , expect = Http.expectString GotRegisterResponse
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


















