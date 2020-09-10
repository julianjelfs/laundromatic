module ListItem exposing (..)

import DeleteIcon as Delete
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Item exposing (Item, timeTillDue)
import Ports
import Time exposing (Posix)


type Confirming
    = NotConfirming
    | ConfirmingDelete
    | ConfirmingWash


type alias Model =
    { busy : Bool
    , confirming : Confirming
    }


type Msg
    = ConfirmDelete
    | ConfirmWash
    | Cancel
    | Delete Item
    | Wash Item


init : Model
init =
    { busy = False
    , confirming = NotConfirming
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ConfirmDelete ->
            ( { model | confirming = ConfirmingDelete }, Cmd.none )

        ConfirmWash ->
            ( { model | confirming = ConfirmingWash }, Cmd.none )

        Cancel ->
            ( { model | confirming = NotConfirming }, Cmd.none )

        Delete item ->
            ( { model | busy = True }, Ports.deleteItem item )

        Wash item ->
            ( { model | busy = True }, Ports.washItem item )


confirmView : Msg -> Html Msg
confirmView onConfirm =
    div
        [ class "item"
        ]
        [ div
            [ class "item__desc -confirm" ]
            [ p [ class "item__title" ] [ text "Are you sure?" ]
            ]
        , button
            [ class "item__action -yes"
            , onClick onConfirm
            ]
            [ text "Yes" ]
        , button
            [ class "item__action -no"
            , onClick Cancel
            ]
            [ text "No" ]
        ]


view : Item -> Posix -> Model -> Html Msg
view item now model =
    case model.confirming of
        ConfirmingDelete ->
            confirmView (Delete item)

        ConfirmingWash ->
            confirmView (Wash item)

        NotConfirming ->
            let
                overdue =
                    isOverdue now item
            in
            div
                [ class "item"
                , classList [ ( "-processing", model.busy ) ]
                ]
                [ div
                    [ class "item__control"
                    , onClick ConfirmDelete
                    ]
                    [ Delete.icon ]
                , div
                    [ class "item__desc" ]
                    [ p [ class "item__title" ]
                        [ span [] [ text <| item.name ]
                        , span [ class "item__interval" ] [ text <| "(" ++ String.fromInt item.intervalInDays ++ " days)" ]
                        ]
                    , p [ class "item_subtitle" ] [ text <| lastWashed now item ]
                    ]
                , button
                    [ class "item__action"
                    , onClick ConfirmWash
                    , classList [ ( "-overdue", overdue ) ]
                    ]
                    [ text <|
                        if overdue then
                            "Overdue"

                        else
                            "Wash"
                    ]
                ]


isOverdue : Posix -> Item -> Bool
isOverdue now item =
    timeTillDue now item < 0


lastWashed : Posix -> Item -> String
lastWashed now item =
    let
        nowInt =
            Time.posixToMillis now
    in
    case item.lastWashed of
        0 ->
            "never washed"

        lw ->
            let
                days =
                    toFloat (nowInt - lw) / 1000 / 60 / 60 / 24

                rounded =
                    toFloat (round (days * 100)) / 100
            in
            "washed " ++ String.fromFloat rounded ++ " days ago"
