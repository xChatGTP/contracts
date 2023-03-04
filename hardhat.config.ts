import "@typechain/hardhat"
import "@nomiclabs/hardhat-waffle"
import "@nomiclabs/hardhat-etherscan"
import "@nomiclabs/hardhat-ethers"
import "hardhat-gas-reporter"
import "dotenv/config"
import "solidity-coverage"
import "hardhat-deploy"
import "solidity-coverage"
import { HardhatUserConfig } from "hardhat/types"
import "@nomicfoundation/hardhat-toolbox"

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || "https://eth-goerli"
const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL || "https://polygon-mumbai"
const FUJI_RPC_URL = process.env.FUJI_RPC_URL || "https://avalanche-fuji"

const PRIVATE_KEY = process.env.PRIVATE_KEY || "0xkey"

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "0xkey"

/** @type import('hardhat/config').HardhatUserConfig */
const config: HardhatUserConfig = {
    solidity: {
        compilers: [
            { version: "0.8.0" },
            {
                version: "0.8.9",
            },
        ],
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
        },
        localhost: {
            chainId: 31337,
            url: "http://127.0.0.1:8545/",
        },
        goerli: {
            chainId: 5,
            url: GOERLI_RPC_URL,
            accounts: [PRIVATE_KEY],
        },
        mumbai: {
            chainId: 80001,
            url: MUMBAI_RPC_URL,
            accounts: [PRIVATE_KEY],
        },
        fuji: {
            chainId: 43113,
            url: FUJI_RPC_URL,
            accounts: [PRIVATE_KEY],
        },
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
        player: {
            default: 1,
        },
    },
    // gasReporter: {
    //     enabled: true,
    //     outputFile: "gas-report.txt",
    //     noColors: true,
    //     currency: "USD",
    //     coinmarketcap: COINMARKETCAP_API_KEY,
    // },
    mocha: {
        timeout: 300 * 1000,
    },
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
}

export default config
