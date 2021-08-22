{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Main where

import qualified Data.Aeson
import qualified Data.ByteString.Lazy
import qualified Data.Either
import qualified Data.Functor
import qualified Data.List
import qualified Data.Time.Clock
import qualified GHC.Generics
import qualified Prelude
import qualified Data.GraphQL
import qualified Data.GraphQL.Monad
import qualified API
import           Control.Monad.IO.Class (MonadIO(..))

newtype EarnedIn = EarnedIn { number :: Prelude.Integer }

app :: (Data.GraphQL.Monad.MonadGraphQLQuery m, MonadIO m) => m ()
app = do
  result <- Data.GraphQL.Monad.runQuery API.RewardsQuery { _id = "" }
  Control.Monad.IO.Class.liftIO Prelude.$ Prelude.print result

main :: Prelude.IO ()
main = do
  let graphQLSettings =
        Data.GraphQL.Monad.defaultGraphQLSettings { Data.GraphQL.Monad.url =
                                                      "https://graphql-api.mainnet.dandelion.link"
                                                  }
  Data.GraphQL.runGraphQLQueryT graphQLSettings app
  Prelude.return ()
