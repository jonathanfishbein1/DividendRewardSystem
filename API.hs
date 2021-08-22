{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}

{-# OPTIONS_GHC -w #-}

module API where

import           Data.GraphQL
import           Data.GraphQL.Bootstrap
import           Scalars

{-----------------------------------------------------------------------------
* rewards

-- result :: Object RewardsSchema; throws a GraphQL exception on errors
result <- runQuery RewardsQuery
  { _id = ...
  }

-- result :: GraphQLResult (Object RewardsSchema)
result <- runQuerySafe RewardsQuery
  { _id = ...
  }
-----------------------------------------------------------------------------}
data RewardsQuery = RewardsQuery { _id :: StakePoolID }
  deriving (Show)

type RewardsSchema =
  [schema|
  {
    rewards: List Maybe {
      address: StakeAddress,
      amount: Text,
      earnedIn: {
        number: Int,
      },
    },
    delegations: Maybe List Maybe {
      transaction: Maybe {
        outputs: List Maybe {
          address: Text,
          value: Text,
        },
      },
    },
  }
|]

instance GraphQLQuery RewardsQuery where
  type ResultSchema RewardsQuery = RewardsSchema

  getQueryName _ = "rewards"

  getQueryText _ =
    [query|
    query rewards($id: StakePoolID!) {
      rewards: rewards(where: {_and: [{stakePool: {id: {_eq: $id}}}, {earnedIn: {number: {_in: [262, 263, 264]}}}]}) {
        address
        amount
        earnedIn {
          number
        }
      }
      delegations: delegations(where: {stakePool: {id: {_eq: $id}}}) {
        transaction {
          outputs {
            address
            value
          }
        }
      }
    }
  |]

  getArgs query = object ["id" .= _id (query :: RewardsQuery)]

