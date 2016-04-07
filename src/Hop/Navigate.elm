module Hop.Navigate (navigateTo, addQuery, setQuery, removeQuery, clearQuery) where

{-| Functions for changing the browser location

@docs navigateTo, addQuery, removeQuery, setQuery, clearQuery
-}

import Effects exposing (Effects, Never)
import History
import Hop.Location as Location
import Hop.Types exposing (..)


{-| Changes the location (hash and query)

  navigateTo will append "#/" if necessary

    update action model =
      case action of
        ...
        NavigateTo path ->
          (model, Effects.map HopAction (navigateTo path))
-}
navigateTo : LocationConfig -> String -> Effects ()
navigateTo config route =
  route
    |> Location.locationFromUser
    |> navigateToLocation config



{-
@private
navigateToLocation
Change the location using a Location record
-}


navigateToLocation : LocationConfig -> Location -> Effects ()
navigateToLocation config location =
  location
    |> Location.locationToFullPath config
    |> History.setPath
    |> Effects.task



-------------------------------------------------------------------------------
-- QUERY


{-| Add query string values (patches any existing values)

    update action model =
      case action of
        ...
        AddQuery query ->
          (model, Effects.map HopAction (Hop.addQuery query model.location))

  To remove a value set the value to ""
-}
addQuery : LocationConfig -> Query -> Location -> Effects ()
addQuery config query currentLocation =
  currentLocation
    |> Location.addQuery query
    |> navigateToLocation config


{-| Set query string values (removes existing values)

    update action model =
      case action of
        ...
        SetQuery query ->
          (model, Effects.map HopAction (Hop.setQuery query model.location))
-}
setQuery : LocationConfig -> Query -> Location -> Effects ()
setQuery config query currentLocation =
  currentLocation
    |> Location.setQuery query
    |> navigateToLocation config


{-| Remove one query string value

    update action model =
      case action of
        ...
        RemoveQuery query ->
          (model, Effects.map HopAction (Hop.removeQuery key model.location))
-}
removeQuery : LocationConfig -> String -> Location -> Effects ()
removeQuery config key currentLocation =
  currentLocation
    |> Location.removeQuery key
    |> navigateToLocation config


{-| Clear all query string values

    update action model =
      case action of
        ...
        ClearQuery ->
          (model, Effects.map HopAction (Hop.clearQuery model.location))
-}
clearQuery : LocationConfig -> Location -> Effects ()
clearQuery config currentLocation =
  currentLocation
    |> Location.clearQuery
    |> navigateToLocation config
