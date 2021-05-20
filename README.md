# Badger Sett PoolTogether

Badger Sett and PoolTogether Integration.

PoolTogether is Prize Savings Protocol Ethereum smart contracts.  
For an overview of the concepts and API please see the [documentation](https://docs.pooltogether.com/)

## Concept

The poolTogether protocol has several pre-built yield source integrations sush as Compound. Now, PoolTogether offers a no-loss lottery where DAI, USDC and UNI are deposited into the Compound.

Badger Sett

-   Badger deposited into the pool is to be wrapped into bBadger

[Badger Finance Doc](https://badger-finance.gitbook.io/badger-finance/)

## Setup

To install dependencies,run  
`yarn`

You will needs to enviroment variables to run the tests.
Create a `.env` file in the root directory of your project.

```
ETHERSCAN_API_KEY=
ALCHEMY_API_KEY=
```

You will get the first one from [Etherscan](https://etherscan.io/).
You will get the second one from [Alchemy](https://dashboard.alchemyapi.io/).

## Compile

`yarn build`

## Format

`yarn format`

## Test

`yarn test`
