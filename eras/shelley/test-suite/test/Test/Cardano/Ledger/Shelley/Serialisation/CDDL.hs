{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module Test.Cardano.Ledger.Shelley.Serialisation.CDDL
  ( tests,
  )
where

import Cardano.Ledger.Address
  ( Addr,
    RewardAcnt,
  )
import Cardano.Ledger.Crypto (StandardCrypto)
import Cardano.Ledger.Keys (KeyRole (Staking))
import Cardano.Ledger.Keys.Bootstrap (BootstrapWitness)
import Cardano.Ledger.Shelley (Shelley)
import Cardano.Ledger.Shelley.API
  ( Credential,
    DCert,
    MultiSig,
    ProposedPPUpdates,
    ShelleyTx,
    Update,
  )
import Cardano.Ledger.Shelley.Metadata (ShelleyTxAuxData)
import Cardano.Ledger.Shelley.PParams (ShelleyPParamsUpdate)
import Cardano.Ledger.Shelley.TxBody
  ( ShelleyTxBody,
    ShelleyTxOut,
    StakePoolRelay,
  )
import Cardano.Ledger.TxIn (TxIn)
import Cardano.Protocol.TPraos.BHeader (BHBody, BHeader)
import Cardano.Protocol.TPraos.OCert (OCert)
import qualified Data.ByteString.Lazy as BSL
import Paths_cardano_ledger_shelley_test
import Test.Cardano.Ledger.Shelley.LaxBlock (LaxBlock)
import Test.Cardano.Ledger.Shelley.Serialisation.CDDLUtils
  ( cddlAnnotatorTest,
    cddlGroupTest,
    cddlTest,
  )
import Test.Tasty (TestTree, testGroup, withResource)

tests :: Int -> TestTree
tests n = withResource combinedCDDL (const (pure ())) $ \cddl ->
  testGroup "CDDL roundtrip tests" $
    [ cddlAnnotatorTest @(BHeader StandardCrypto) n "header",
      cddlAnnotatorTest @(BootstrapWitness StandardCrypto) n "bootstrap_witness",
      cddlTest @(BHBody StandardCrypto) n "header_body",
      cddlGroupTest @(OCert StandardCrypto) n "operational_cert",
      cddlTest @(Addr StandardCrypto) n "address",
      cddlTest @(RewardAcnt StandardCrypto) n "reward_account",
      cddlTest @(Credential 'Staking StandardCrypto) n "stake_credential",
      cddlAnnotatorTest @(ShelleyTxBody Shelley) n "transaction_body",
      cddlTest @(ShelleyTxOut Shelley) n "transaction_output",
      cddlTest @StakePoolRelay n "relay",
      cddlTest @(DCert StandardCrypto) n "certificate",
      cddlTest @(TxIn StandardCrypto) n "transaction_input",
      cddlAnnotatorTest @(ShelleyTxAuxData Shelley) n "transaction_metadata",
      cddlAnnotatorTest @(MultiSig Shelley) n "multisig_script",
      cddlTest @(Update Shelley) n "update",
      cddlTest @(ProposedPPUpdates Shelley) n "proposed_protocol_parameter_updates",
      cddlTest @(ShelleyPParamsUpdate Shelley) n "protocol_param_update",
      cddlAnnotatorTest @(ShelleyTx Shelley) n "transaction",
      cddlAnnotatorTest @(LaxBlock (BHeader StandardCrypto) Shelley) n "block"
    ]
      <*> pure cddl

combinedCDDL :: IO BSL.ByteString
combinedCDDL = do
  base <- readDataFile "cddl-files/shelley.cddl"
  crypto <- readDataFile "cddl-files/real/crypto.cddl"
  extras <- readDataFile "cddl-files/mock/extras.cddl"
  -- extras contains the types whose restrictions cannot be expressed in CDDL
  pure $ base <> crypto <> extras

readDataFile :: FilePath -> IO BSL.ByteString
readDataFile name = getDataFileName name >>= BSL.readFile
