import { waffle, ethers } from 'hardhat'
import fs from 'fs'
import { Fixture } from 'ethereum-waffle'
import { expect, use } from 'chai'
import { NFTDescriptor, NFTDescriptorTest, ERC20Mock } from '../typechain'

const toWei = ethers.utils.parseEther
use(require('chai-bignumber')())

const overrides = { gasLimit: 9500000 }
const amount = toWei('100')

describe('NFTDescriptor', async function () {
    const provider = waffle.provider
    const wallets = provider.getWallets()
    const [wallet, other] = wallets

    let token: ERC20Mock
    let nftDescriptor: NFTDescriptorTest
    let loadFixture: ReturnType<typeof waffle.createFixtureLoader>

    const nftDescriptorFixture: Fixture<{
        token: ERC20Mock
        nftDescriptor: NFTDescriptorTest
    }> = async () => {
        const nftDescriptorLibraryFactory = await ethers.getContractFactory('NFTDescriptor')
        const nftDescriptorLibrary = (await nftDescriptorLibraryFactory.deploy()) as NFTDescriptor

        const [ERC20MockFactory, NFTDescriptorTestFactory] = await Promise.all([
            ethers.getContractFactory('ERC20Mock'),
            ethers.getContractFactory('NFTDescriptorTest', {
                libraries: {
                    NFTDescriptor: nftDescriptorLibrary.address,
                },
            }),
        ])
        const token = (await ERC20MockFactory.deploy()) as ERC20Mock
        const nftDescriptor = (await NFTDescriptorTestFactory.deploy(overrides)) as NFTDescriptorTest

        return { token, nftDescriptor }
    }

    before('create fixture loader', async () => {
        loadFixture = waffle.createFixtureLoader(wallets)
    })

    beforeEach('load fixture', async function () {
        ;({ token, nftDescriptor } = await loadFixture(nftDescriptorFixture))

        await token.mint(wallet.address, amount)
        await token.mint(other.address, amount)
    })

    function extractJSONFromURI(uri: string): { name: string; description: string; image: string } {
        const encodedJSON = uri.substr('data:application/json;base64,'.length)
        const decodedJSON = Buffer.from(encodedJSON, 'base64').toString('utf8')
        return JSON.parse(decodedJSON)
    }
    it('constructURIParams', async function () {
        const params = {
            tokenId: 10,
            blockNumber: 12345,
            stakeAmount: 10000,
            uTokenAddress: token.address,
            uTokenSymbol: await token.symbol(),
        }
        const expectedTokenUri = {
            name: 'ERC20Mock-NFT',
            description:
                'This NFT represents a liquidity in stETH pool The owner of this NFT can remove the liquidity.\n',
        }
        const json = extractJSONFromURI(await nftDescriptor.constructTokenURI(params))
        console.log('json.image :>> ', json.image)

        const base64Str = json.image.replace('data:image/svg+xml;base64,', '')
        await fs.promises.writeFile('images/nft-descriptor.svg', base64Str, { encoding: 'base64' })

        expect(json.description).to.equal(expectedTokenUri.description)
        expect(json.name).to.equal(expectedTokenUri.name)
    })
})
