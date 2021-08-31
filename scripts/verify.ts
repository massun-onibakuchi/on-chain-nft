import hre, { ethers } from 'hardhat'

const main = async () => {
    const name = 'Lido on-chain NFT'
    const symbol = 'Lido-NFT'

    // ERC20Mock
    await hre.run('verify:verify', {
        address: '0x61d86669eE2bf63d63C19D392920da4665063Af8',
        constructorArguments: [],
    })

    // NFTDescriptor
    await hre.run('verify:verify', {
        address: '0xb2005b5F5690a6bd29f2cCaE0826d8aeCECc7F60',
    })

    // NFTManager
    await hre.run('verify:verify', {
        address: '0x42295aA81E811474A7B13450D2f6b563F2F54874',
        constructorArguments: [name, symbol, '0x61d86669eE2bf63d63C19D392920da4665063Af8'],
        libraries: {
            NFTDescriptor: '0xb2005b5F5690a6bd29f2cCaE0826d8aeCECc7F60',
        },
    })
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
