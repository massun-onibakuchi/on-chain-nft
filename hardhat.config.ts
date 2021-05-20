import "dotenv/config";
import { task, HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "hardhat-typechain";
import "hardhat-deploy";
import "hardhat-etherscan-abi";
import "hardhat-dependency-compiler";

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const BLOCK_NUMBER = process.env.BLOCK_NUMBER || "12068742";
const PROJECT_ID = process.env.PROJECT_ID;
const MNEMONIC = process.env.MNEMONIC;

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (args, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        console.log(account.address);
    }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const config: HardhatUserConfig = {
    defaultNetwork: "hardhat", //rinkeby
    networks: {
        localhost: {
            url: "http://127.0.0.1:8545",
        },
        hardhat: {
            chainId: 1,
            forking: {
                url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
                blockNumber: parseInt(BLOCK_NUMBER),
                enabled: true,
            },
        },
        ropsten: {
            url: `https://eth-ropsten.alchemyapi.io/v2/O52IVElOb_z9i-QDw4HAtAmoqm8NFvnr`,
            // `https://ropsten.infura.io/v3/${PROJECT_ID}`
            // accounts: [privateKey1, privateKey2]
            accounts: {
                mnemonic: MNEMONIC,
                // path: "m/44'/60'/0'/0/0",
                initialIndex: 0,
                count: 10,
            },
        },
        // https://hardhat.org/config/#hd-wallet-config
    },
    dependencyCompiler: {
        paths: [        ],
    },
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
    },
    solidity: {
        compilers: [
            {
                version: "0.6.12",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
            {
                version: "0.7.6",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
        ],
    },
    paths: {
        sources: "./contracts",
        tests: "./test",
        cache: "./cache",
        artifacts: "./artifacts",
    },
};

export default config;
