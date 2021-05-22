# on-chain-NFT

 - On-chain NFT, inspired by Uniswap V3 NFT.
   - NFT's Image is saved on-chain in SVG format.
 - Converting FT to NFT.
   - Depositing some FT mints a NFT. Burning a NFT returns the deposited FT.
   - Add a collectible element to FT. More UMAMI flavor.
 - NFT for everyone.
   -  Any user can mint a NFT in turn depositing a certain amount of ERC20 token.

### Concept
Lido is a decentralized infrastructure for issuing stETH tokens that you can use while staking ETH.

 - Encourage the use of stETH and wstETH
 - Depositing some FT (such as wstETH) mints a NFT, which automatically generates unique image in SVG format.
 - NFT represents a liquidity in stETH pool, or a owner of FT.
 - NFT is transferable.
  
[Lido Finance](https://lido.fi)

[Lido Finance Doc](https://docs.lido.fi/)

[Lido Finance Github](https://github.com/lidofinance/lido-dao)

Sample Image

<img src="images/sample-nft-image.svg" alt="Sample NFT image" width="50%" height="50%"><img src="images/sample-nft-image2.svg" alt="Sample NFT image" width="50%" height="50%"><img src="images/sample-nft-image3.svg" alt="Sample NFT image" width="50%" height="50%"><img src="images/sample-nft-image7.svg" alt="Sample NFT image" width="50%" height="50%"><img src="images/sample-nft-image4.svg" alt="Sample NFT image" width="50%" height="50%"><img src="images/sample-nft-image5.svg" alt="Sample NFT image" width="50%" height="50%">

## Setup
To install dependencies,run  
`yarn`

## Compile

`yarn build`

## Test

`yarn test`

Also,This generates a image in SVG format in `images` folder