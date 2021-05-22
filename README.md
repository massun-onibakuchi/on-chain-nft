# On-chain-NFT

 - On-chain NFT, inspired by Uniswap V3 NFT.
   - NFT's Image is saved on-chain in SVG format.
 - Wrapping FT to NFT.
   - Depositing some FT mints a NFT. Burning a NFT returns the deposited NFT.
 - NFT for everyone.
   -  Any user can mint a NFT in turn depositing a certain amount of ERC20 token.

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

## Test

`yarn test`
