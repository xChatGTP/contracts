import { ethers, network } from "hardhat"
import {
    FUJI_AXELAR_CHAIN_NAME,
    FUJI_TEST_EXECUTE_CONTRACT_ADDRESS,
    FUJI_WAVAX_CONTRACT_ADDRESS,
    GOERLI_AXELAR_CHAIN_NAME,
    GOERLI_TEST_EXECUTE_CONTRACT_ADDRESS,
    GOERLI_WETH_CONTRACT_ADDRESS,
    MUMBAI_AXELAR_CHAIN_NAME,
    MUMBAI_TEST_EXECUTE_CONTRACT_ADDRESS,
    MUMBAI_WMATIC_CONTRACT_ADDRESS,
} from "../constants"
import {
    IERC20,
    IERC20__factory,
    TestExecute,
    TestExecute__factory,
} from "../typechain-types"

const WAVAX_AMOUNT = ethers.utils.parseEther("0.001")
const AXELAR_RELAYER_FEE = ethers.utils.parseEther("0.007")

async function main() {
    const { deployer } = await ethers.getNamedSigners()

    const TestExecuteContract = TestExecute__factory.connect(
        FUJI_TEST_EXECUTE_CONTRACT_ADDRESS,
        deployer
    )

    const WAVAXContract = IERC20__factory.connect(
        FUJI_WAVAX_CONTRACT_ADDRESS,
        deployer
    )

    const needToApprove = true

    if (needToApprove) {
        const approveTx = await WAVAXContract.approve(
            FUJI_TEST_EXECUTE_CONTRACT_ADDRESS,
            WAVAX_AMOUNT,
            {
                // gasLimit: 3_000_000,
                // gasPrice: 30_000_000_000,
                // nonce: 741,
            }
        )
        console.log("approveTx:", approveTx.hash)

        await approveTx.wait(1)

        console.log("Successfully approved!")
    }

    console.log("Attempting try execute...")

    const tryExecuteTx = await TestExecuteContract.tryExecute(
        MUMBAI_AXELAR_CHAIN_NAME,
        MUMBAI_TEST_EXECUTE_CONTRACT_ADDRESS,
        "Hello there!",
        "WAVAX",
        WAVAX_AMOUNT,
        {
            // nonce: await deployer.getTransactionCount(),
            // gasLimit: 30000000,
            // gasPrice: 2000000000,
            value: AXELAR_RELAYER_FEE,
        }
    )

    console.log("tx hash:", tryExecuteTx.hash)

    await tryExecuteTx.wait(2)

    console.log("Successful tryExecute!")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
