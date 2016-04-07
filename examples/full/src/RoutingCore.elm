module RoutingCore (..) where

import Hop.Navigate --exposing (navigateTo, setQuery, addQuery)
import Hop.Types exposing (LocationConfig, HistoryKind(Path,Hash))

locationConfig : LocationConfig
locationConfig = Path

navigateTo =
  Hop.Navigate.navigateTo locationConfig

setQuery =
  Hop.Navigate.setQuery locationConfig

addQuery =
  Hop.Navigate.addQuery locationConfig