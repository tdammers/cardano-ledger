module Main where

import System.IO (
  BufferMode (LineBuffering),
  hSetBuffering,
  hSetEncoding,
  stdout,
  utf8,
 )
import Test.Cardano.Data.MapExtrasSpec (mapExtrasSpec)
import qualified Test.Cardano.Data.OSet.StrictSpec as SOSet
import Test.Hspec
import Test.Hspec.Runner

conf :: Config
conf =
  defaultConfig
    { configTimes = True
    , configColorMode = ColorAlways
    }

spec :: Spec
spec =
  describe "cardano-data" $ do
    describe "MapExtras" mapExtrasSpec
    describe "OSet.Strict" SOSet.spec

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  hSetEncoding stdout utf8
  hspecWith conf spec
