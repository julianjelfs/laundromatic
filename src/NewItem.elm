module NewItem exposing (..)

import Html as H exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit, preventDefaultOn)
import Json.Decode as D
import Ports


type alias Model =
    { name : String
    , intervalInDays : Int
    , lastWashed : Int
    , error : Maybe String
    }


type Msg
    = UpdateName String
    | UpdateInterval String
    | UpdateLastWashed String
    | Submit
    | AddNewError String
    | Cancel


init : Model
init =
    { name = "", intervalInDays = 0, lastWashed = 0, error = Nothing }


update : Msg -> Model -> ( Model, Cmd Msg, Bool )
update msg model =
    case msg of
        UpdateName name ->
            ( { model | name = name }, Cmd.none, False )

        UpdateInterval interval ->
            ( { model | intervalInDays = String.toInt interval |> Maybe.withDefault 0 }, Cmd.none, False )

        UpdateLastWashed last ->
            ( { model | lastWashed = String.toInt last |> Maybe.withDefault 0 }, Cmd.none, False )

        Submit ->
            ( model, Ports.addNewItem ( model.name, model.intervalInDays, model.lastWashed ), False )

        AddNewError err ->
            ( { model | error = Just err }, Cmd.none, False )

        Cancel ->
            ( model, Cmd.none, True )


view : Model -> Html Msg
view model =
    div [ class "new-modal" ]
        [ div
            [ class "add-new-form" ]
            [ H.form [ onSubmit Submit ]
                [ p []
                    [ label [] [ text "Name of item" ]
                    , input
                        [ onInput UpdateName
                        , placeholder "Name of item"
                        , autofocus True
                        , required True
                        , value model.name
                        ]
                        []
                    ]
                , p []
                    [ label [] [ text "Wash frequency (days)" ]
                    , input
                        [ onInput UpdateInterval
                        , placeholder "Wash frequency in days"
                        , type_ "number"
                        , required True
                        , value <| String.fromInt model.intervalInDays
                        ]
                        []
                    ]
                , p []
                    [ label [] [ text "Days since last wash" ]
                    , input
                        [ onInput UpdateLastWashed
                        , placeholder "How many days ago was this last washed?"
                        , type_ "number"
                        , required True
                        , value <| String.fromInt model.lastWashed
                        ]
                        []
                    ]
                , button [ class "submit", type_ "submit" ] [ text "Add new item" ]
                , button [ class "cancel", preventDefaultOn "click" (D.succeed ( Cancel, True )) ] [ text "Cancel" ]
                , case model.error of
                    Nothing ->
                        text ""

                    Just err ->
                        p [ class "error" ] [ text err ]
                ]
            ]
        ]


subscriptions : Sub Msg
subscriptions =
    Ports.addNewError AddNewError
