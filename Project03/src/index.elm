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
    { pageL : Page, error : String, userInfo: UserInfo  }

type Page = Dashboard
    | ExpenseTracker
    | LoanTracker

type Msg = Show Page
     | LogOut
     | GetResponse (Result Http.Error String)
     | UserInfoResponse (Result Http.Error UserInfo)

init : () -> ( Model, Cmd Msg )
init _ =
    ( { pageL = Dashboard
      , error = ""
      , userInfo  = { income = 0, expense = 0, expenseType = "Works from Elm", loanAmount = 0, loanPeriod = 0, loanInterest = 0}
      }
    , getAuth
    )

type alias UserInfo = {
        income : Float, 
        expense : Float, 
        expenseType : String,
        loanAmount : Float, 
        loanPeriod : Float, 
        loanInterest : Float
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Show page ->
            ( { model | pageL = page }, Cmd.none )
        
        LogOut ->
            (model, doLogOut)

        UserInfoResponse result ->
            case result of 
                 Ok recievedInfo -> 
                    ({ model | userInfo = recievedInfo }, Cmd.none )

                 Err error -> 
                    ( handleError model error , Cmd.none )

        GetResponse result ->
            case result of
                Ok "NotAuth" ->
                    ( { model | error = "Not Authenticated" }, load "loginpage.html")
                
                Ok "LoggedOut" ->
                    ( { model | error = "Logged Out"}, load "loginpage.html")

                Ok "IsAuth" ->
                    ( model, getUserInfo )
                
                Ok _ ->
                    ( model, getUserInfo )

                Err error ->
                    ( handleError model error, Cmd.none )




infoJsonD : JDecode.Decoder UserInfo  
infoJsonD = 
    JDecode.map6 UserInfo  
        (JDecode.field "income" JDecode.float)
        (JDecode.field "expense" JDecode.float)
        (JDecode.field "expensetype" JDecode.string)
        (JDecode.field "loanamount" JDecode.float)
        (JDecode.field "loanperiod" JDecode.float)
        (JDecode.field "loaninterest" JDecode.float)

getUserInfo : Cmd Msg
getUserInfo =
    Http.get 
        { url = rootUrl ++ "userauth/getuserinfo/"
        , expect = Http.expectJson UserInfoResponse infoJsonD
        }

getAuth : Cmd Msg
getAuth =
    Http.get
        { url = rootUrl ++ "userauth/isauth/"
        , expect = Http.expectString GetResponse
        }

doLogOut : Cmd Msg
doLogOut =
    Http.get
        { url = rootUrl ++ "userauth/logoutuser/"
        , expect = Http.expectString GetResponse
        }

handleError : Model -> Http.Error -> Model
handleError model error =
    case error of
        Http.BadUrl url ->
            { model | error = "Bad URL: " ++ url }

        Http.Timeout ->
            { model | error = "Timeout" }

        Http.NetworkError ->
            { model | error = "Network Error" }

        Http.BadStatus i ->
            { model | error = "Bad Status " ++ String.fromInt i }

        Http.BadBody body ->
            { model | error = "Bad Body " ++ body }


dashboardView : Model -> Html msg 
dashboardView model = div [] 
    [ ol [ class "breadcrumb" ]
    [ li [ class "breadcrumb-item" ]
                        [ a [ ]
                            [ text "Dashboard" ]
                        ]
                    , li [ class "breadcrumb-item active" ]
                        [ text "Works" ]
                    ]
    ]


loantrackerView : Model -> Html msg 
loantrackerView model = div [] 
    [ ol [ class "breadcrumb" ]
    [ li [ class "breadcrumb-item" ]
                        [ a [ ]
                            [ text "Loan Tracker" ]
                        ]
                    , li [ class "breadcrumb-item active" ]
                        [ text "Works" ]
                    ]
                    , div []
                    [ div [ class "card-header" ]
                        [ i [ class "fas fa-chart-area" ]
                            []
                        , text " Area Chart Example"
                        ]
                    ]
    ]

expensetrackerView : Model -> Html msg 
expensetrackerView model = div [] 
    [ ol [ class "breadcrumb" ]
    [ li [ class "breadcrumb-item" ]
                        [ a [ ]
                            [ text "Expense Tracker" ]
                        ]
                    , li [ class "breadcrumb-item active" ]
                        [ text "Works" ]
    ]
                    , div [ class "card mb-3" ]
                    [ div [ class "card-header" ]
                        [ i [ class "fas fa-chart-area" ]
                            []
                        , text " Area Chart Example"
                        ]
                    ]
    
    ]
    


view : Model -> Html Msg
view model = div []
    [ node "link" [ href "SiteFiles/vendor/fontawesome-free/css/all.min.css", rel "stylesheet", type_ "text/css" ]
        []
    , node "link" [ href "SiteFiles/vendor/datatables/dataTables.bootstrap4.css", rel "stylesheet" ]
        []
    , node "link" [ href "SiteFiles/css/sb-admin.css", rel "stylesheet" ]
        []
    , nav [ class "navbar navbar-expand navbar-dark bg-dark static-top" ]
        [ a [ class "navbar-brand mr-1", href "" ]
            [ text "FinTrack" ]
        , ul [ class "navbar-nav ml-auto ml-md-0" ]
            [ li [ class "nav-item no-arrow" ]
                [ a [ attribute "aria-expanded" "false", class "nav-link ",  attribute "role" "button", Events.onClick LogOut]
                    [ text "Log Out"]
                    
                ]
            ]
        ]
    , div [ id "wrapper" ]
        [ ul [ class "sidebar navbar-nav" ]
            [ li [ class "nav-item " ]
                [ a [ class "nav-link", Events.onClick (Show Dashboard) ]
                    [ i [ class "fas fa-fw fa-tachometer-alt"]
                        []
                    , span []
                        [ text " Dashboard" ]
                    ]
                ]
            , li [ class "nav-item dropdown" ]
                [ a [ class "nav-link", Events.onClick (Show ExpenseTracker) ]
                    [ i [ class "fas fa-fw fa-folder" ]
                        []
                    , span []
                        [ text " Expense Tracker" ]
                    ]
                ]
            , li [ class "nav-item" ]
                [ a [ class "nav-link" , Events.onClick (Show LoanTracker) ]
                    [ i [ class "fas fa-fw fa-chart-area" ]
                        []
                    , span []
                        [ text " Loan Tracker" ]
                    ]
                ]
            ]
        , div [ id "content-wrapper" ]
            [ div [ class "container-fluid" ]
                [ 
                    case model.pageL of 
                        Dashboard      -> dashboardView model 
                        LoanTracker    -> loantrackerView model 
                        ExpenseTracker -> expensetrackerView model
                        
                ]
            , text "      "
            , footer [ class "sticky-footer" ]
                [ div [ class "container my-auto" ]
                    [ div [ class "copyright text-center my-auto" ]
                        [ span []
                            [ text (model.userInfo.expenseType) ]
                        ]
                    ]
                ]
            ]
        , text "  "
        ]
    , text "  "
    ]




