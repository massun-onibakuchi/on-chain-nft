import { waffle, ethers } from 'hardhat'
import { Fixture } from 'ethereum-waffle'
import { expect, use } from 'chai'
import { NFTManager, NFTDescriptor, ERC20Mock, NFTDescriptorTest } from '../typechain'
import { BigNumber } from '@ethersproject/bignumber'

const toWei = ethers.utils.parseEther
use(require('chai-bignumber')())

const overrides = { gasLimit: 9500000 }
const amount = toWei('100') // must be greater than STAKE_AMOUNT

describe('NFTManager', async function () {
    const provider = waffle.provider
    const wallets = provider.getWallets()
    const [wallet, other] = wallets

    const name = 'On-chain NFT'
    const symbol = 'ON-CHAIN-NFT'
    let token: ERC20Mock
    let nftManager: NFTManager
    let nftDescriptor: NFTDescriptorTest
    let loadFixture: ReturnType<typeof waffle.createFixtureLoader>

    const nftFixture: Fixture<{
        token: ERC20Mock
        nftManager: NFTManager
        nftDescriptor: NFTDescriptorTest
    }> = async () => {
        const nftDescriptorLibraryFactory = await ethers.getContractFactory('NFTDescriptor')
        const nftDescriptorLibrary = (await nftDescriptorLibraryFactory.deploy()) as NFTDescriptor

        const [ERC20MockFactory, NFTManagerFactory, NFTDescriptorTestFactory] = await Promise.all([
            ethers.getContractFactory('ERC20Mock'),
            ethers.getContractFactory('NFTManager', {
                libraries: {
                    NFTDescriptor: nftDescriptorLibrary.address,
                },
            }),
            ethers.getContractFactory('NFTDescriptorTest', {
                libraries: {
                    NFTDescriptor: nftDescriptorLibrary.address,
                },
            }),
        ])
        const token = (await ERC20MockFactory.deploy()) as ERC20Mock
        const nftManager = (await NFTManagerFactory.deploy(name, symbol, token.address, overrides)) as NFTManager
        const nftDescriptor = (await NFTDescriptorTestFactory.deploy(overrides)) as NFTDescriptorTest

        return { token, nftManager, nftDescriptor }
    }

    before('create fixture loader', async () => {
        loadFixture = waffle.createFixtureLoader(wallets)
    })

    beforeEach('load fixture', async function () {
        ;({ token, nftManager, nftDescriptor } = await loadFixture(nftFixture))

        await token.mint(wallet.address, amount)
        await token.mint(other.address, amount)
    })

    it('get name,symbol,baseURI, uToken address', async function () {
        expect(await nftManager.name()).to.equal(name)
        expect(await nftManager.symbol()).to.equal(symbol)
        expect(await nftManager.baseURI()).to.equal('')
        expect(await nftManager.uToken()).to.eq(token.address)
    })

    it('mint', async function () {
        const STAKE_AMOUNT = await nftManager.STAKE_AMOUNT()

        expect(await nftManager.totalSupply()).to.eq(0)
        expect(await nftManager.balanceOf(wallet.address)).to.eq(0)
        await token.connect(wallet).approve(nftManager.address, amount)
        await nftManager.connect(wallet).mint()

        // NFT
        expect(await nftManager.totalSupply()).to.eq(1)
        expect(await nftManager.stakedBlockNumber(0)).not.to.equal(0)
        expect(await nftManager.balanceOf(wallet.address)).to.eq(BigNumber.from(1))
        expect(await nftManager.ownerOf(0)).to.eq(wallet.address)

        // token
        expect(await token.balanceOf(nftManager.address)).to.eq(STAKE_AMOUNT)
        expect(await token.balanceOf(wallet.address)).to.eq(amount.sub(STAKE_AMOUNT))
    })

    it('burn', async function () {
        await token.connect(wallet).approve(nftManager.address, amount)
        await nftManager.connect(wallet).mint()

        await nftManager.connect(wallet).burn(0)

        expect(await nftManager.balanceOf(wallet.address)).to.eq(0)
        expect(await nftManager.totalSupply()).to.eq(0)
        expect(await nftManager.stakedBlockNumber(0)).equal(0)

        expect(await token.balanceOf(nftManager.address)).to.eq(0)
        expect(await token.balanceOf(wallet.address)).to.eq(amount)
    })

    it('tokenURI', async function () {
        await token.connect(wallet).approve(nftManager.address, amount)
        await nftManager.connect(wallet).mint()

        const blockNumer = await nftManager.stakedBlockNumber(0)
        const params = {
            tokenId: 0,
            blockNumber: blockNumer.toString(),
            stakeAmount: (await nftManager.STAKE_AMOUNT()).toString(),
            uTokenAddress: token.address,
            uTokenSymbol: await token.symbol(),
        }
        expect(await nftManager.tokenURI(params.tokenId)).to.eq(await nftDescriptor.constructTokenURI(params))
    })

    it('transferFrom', async function () {
        await token.connect(wallet).approve(nftManager.address, amount)
        await nftManager.connect(wallet).mint()
        await nftManager.connect(wallet).transferFrom(wallet.address, other.address, 0)
        expect(await nftManager.ownerOf(0)).to.equal(other.address)
    })
})
