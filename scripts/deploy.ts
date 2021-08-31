import hre, { ethers } from 'hardhat'
import { NFTManager, NFTDescriptor, ERC20Mock } from '../typechain'

const overrides = { gasLimit: 9500000 }

const main = async () => {
    console.log('\n\n 📡 Deploying...\n')
    const [wallet] = await ethers.getSigners()

    const name = 'Lido on-chain NFT'
    const symbol = 'Lido-NFT'

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
    const nftManager = (await NFTManagerFactory.deploy(name, symbol, token.address, overrides)) as NFTManager

    const depositAmount = ethers.utils.parseEther('100')

    await token.mint(wallet.address, depositAmount)
    await token.connect(wallet).approve(nftManager.address, depositAmount)
    await nftManager.connect(wallet).mint()

    console.log('wallet.address :>> ', wallet.address)
    console.log('nftManager.address :>> ', nftManager.address)
    console.log('nftDescriptorLibrary.address :>> ', nftDescriptorLibrary.address)
    console.log('token.address :>> ', token.address)

    // await hre.run('verify:verify', {
    //     address: nftManager.address,
    //     constructorArguments: [name, symbol, token.address],
    // })
    // await hre.run('verify:verify', {
    //     address: token.address,
    //     constructorArguments: [],
    // })
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
