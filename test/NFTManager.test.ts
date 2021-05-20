import { waffle, ethers } from 'hardhat'
import { Fixture } from 'ethereum-waffle'
import { expect, use } from 'chai'
import { NFTManager } from '../typechain/NFTManager'
import { NFTDescriptor } from '../typechain/NFTDescriptor'
import { NFTSVG } from '../typechain/NFTSVG'
import { ERC20Mock } from '../typechain/ERC20Mock'

const toWei = ethers.utils.parseEther
use(require('chai-bignumber')())

const overrides = { gasLimit: 9500000 }
const amount = toWei('100')

describe('BadgerYieldSource', async function () {
    const provider = waffle.provider
    const [wallet, other] = provider.getWallets()

    let erc20: ERC20Mock
    let nftManager: NFTManager
    const nftManagerFixture: Fixture<{
        token: ERC20Mock
        nftManager: NFTManager
    }> = async () => {
        const nftDescriptorLibraryFactory = await ethers.getContractFactory('NFTDescriptor')
        const nftDescriptorLibrary = (await nftDescriptorLibraryFactory.deploy()) as NFTDescriptor

        const [ERC20MockFactory, NFTManagerFactory] = await Promise.all([
            ethers.getContractFactory('ERC20Mock'),
            ethers.getContractFactory('NFTManager', {
                libraries: {
                    NFTDescriptor: nftDescriptorLibrary.address,
                },
            }),
        ])
        const token = (await ERC20MockFactory.deploy()) as ERC20Mock
        const nftManager = (await NFTManagerFactory.deploy(overrides)) as NFTManager

        return { token, nftManager }
    }

    before('create fixture loader', async () => {
        loadFixture = waffle.createFixtureLoader(wallets)
    })

    beforeEach(async function () {
        ;({ nft, factory, tokens, weth9, router } = await loadFixture(nftFixture))

        // ----- initialize -----
        await erc20.mint(wallet.address, amount)
        await erc20.mint(other.address, amount)
    })

    it('get underkying token address', async function () {
        expect(await yieldSource.depositToken()).to.equal(erc20.address)
    })

    it('balanceOfToken', async function () {
        // check
        expect(await badger.balanceOf(wallet.address)).to.eq(amount)
        // supply
        await badger.connect(wallet).approve(yieldSource.address, amount)
        await yieldSource.supplyTokenTo(amount, wallet.address)

        const bBadgerBalance = await yieldSource.balanceOf(wallet.address)
        expect(await sett.balanceOf(yieldSource.address)).eq(bBadgerBalance)
    })

    it('supplyTokenTo', async function () {
        expect(await badger.balanceOf(sett.address)).to.eq(0)
        expect(await badger.balanceOf(wallet.address)).to.eq(amount)

        await badger.connect(wallet).approve(yieldSource.address, amount)
        await yieldSource.supplyTokenTo(amount, wallet.address)

        expect(await badger.balanceOf(sett.address)).to.eq(amount)
        expect(await yieldSource.balanceOfToken(wallet.address)).to.eq(amount)
    })

    it('redeemToken', async function () {
        await badger.connect(wallet).approve(yieldSource.address, amount)
        await yieldSource.supplyTokenTo(amount, wallet.address)

        expect(await badger.balanceOf(wallet.address)).to.eq(toWei('0'))
        await yieldSource.redeemToken(amount)
        expect(await badger.balanceOf(wallet.address)).to.eq(amount)
    })
})
