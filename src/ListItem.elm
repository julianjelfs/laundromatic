module ListItem exposing (..)

import DeleteIcon as Delete
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Item exposing (Item)
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


view : Item -> Model -> Html Msg
view item model =
    case model.confirming of
        ConfirmingDelete ->
            confirmView (Delete item)

        ConfirmingWash ->
            confirmView (Wash item)

        NotConfirming ->
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
                    , p [ class "item_subtitle" ] [ text <| dueIn item ]
                    ]
                , button
                    [ class "item__action"
                    , onClick ConfirmWash
                    , classList [ ( "-overdue", item.dueInDays < 0 ), ( "-due", item.dueInDays == 0 ) ]
                    ]
                    [ text <|
                        if item.dueInDays == 0 then
                            "Due"

                        else if item.dueInDays < 0 then
                            "Overdue"

                        else
                            "Wash"
                    ]
                ]


dueIn : Item -> String
dueIn item =
    if item.dueInDays == 0 then
        "due today"

    else if item.dueInDays < 0 then
        "overdue by " ++ String.fromInt (negate item.dueInDays) ++ " days"

    else
        "due in " ++ String.fromInt item.dueInDays ++ " days"
