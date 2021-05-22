# on-chain-NFT

 - On-chain NFT, inspired by Uniswap V3 NFT.
   - NFT's Image is saved on-chain in SVG format.
 - Converting FT to NFT.
   - Depositing some FT mints a NFT. Burning a NFT returns the deposited FT.
   - Add a collectible element to FT. More UMAMI flavor.
 - NFT for everyone.
   -  Any user can mint a NFT in turn depositing a certain amount of ERC20 token.

### Sample NFT image
 - Depositing some FT (such as stETH) mints a NFT, which automatically generates unique image in SVG format.
 - NFT represents a liquidity in stETH pool, or a owner of FT.
 - Burning a NFT returns the deposited stETH.
 - NFT is transferable.

![Sample NFT image](images/sample-nft-image.svg)

## Setup
To install dependencies,run  
`yarn`

## Compile

`yarn build`

## Test

`yarn test`

Also,This generates a image in SVG format in `images` folder