module Examples.Advanced.Languages.Update where

import Effects exposing (Effects, Never)
import Debug
import Hop

import Examples.Advanced.Models as Models
import Examples.Advanced.Languages.Actions as Actions

update : Actions.Action -> List Models.Language -> Hop.Payload -> (List Models.Language, Effects Actions.Action)
update action languages routerPayload =
  case Debug.log "action" action of
    Actions.Show id ->
      let
        navAction =
          Hop.navigateTo ("/languages/" ++ id)
      in
        (languages, Effects.map Actions.HopAction navAction)
    Actions.Edit id ->
      let
        navAction =
          Hop.navigateTo ("/languages/" ++ id ++ "/edit")
        in
          (languages, Effects.map Actions.HopAction navAction)
    Actions.Update id prop value ->
      -- need to update the language here
      let udpatedLanguages =
        List.map (updateWithId id prop value) languages
      in
      (udpatedLanguages, Effects.none)
    Actions.AddQuery query ->
      (languages, Effects.map Actions.HopAction (Hop.addQuery query routerPayload.url))
    Actions.SetQuery query ->
      (languages, Effects.map Actions.HopAction (Hop.setQuery query routerPayload.url))
    _ ->
      (languages, Effects.none)

updateWithId id prop value language =
  if id == language.id then
    case prop of
      "name" ->
        {language | name = value}
      _ ->
          language
  else
    language