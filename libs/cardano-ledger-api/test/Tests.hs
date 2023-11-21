{-# LANGUAGE TypeApplications #-}

module Main where

import Cardano.Ledger.Conway (Conway)
import qualified Test.Cardano.Ledger.Api.State.Imp.QuerySpec as ImpQuery (spec)
import qualified Test.Cardano.Ledger.Api.State.QuerySpec as StateQuery (spec)
import qualified Test.Cardano.Ledger.Api.Tx.Body as TxBody (spec)
import qualified Test.Cardano.Ledger.Api.Tx.Out as TxOut (spec)
import Test.Cardano.Ledger.Conway.ImpTest (withImpState)

import Test.Cardano.Ledger.Common

-- ====================================================================================

apiSpec :: Spec
apiSpec =
  describe "cardano-ledger-api" $ do
    describe "Tx" $ do
      TxOut.spec
      TxBody.spec
    describe "State" $ do
      StateQuery.spec
    describe "Imp" $ withImpState @Conway $ do
      ImpQuery.spec @Conway

main :: IO ()
main = ledgerTestMain apiSpec
