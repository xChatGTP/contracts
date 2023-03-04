import { DeployFunction } from "hardhat-deploy/dist/types"
import { HardhatRuntimeEnvironment } from "hardhat/types"
import { verify } from "../utils/verify"
import {
    FUJI_GAS_RECEIVER_CONTRACT_ADDRESS,
    FUJI_GATEWAY_CONTRACT_ADDRESS,
    GOERLI_GAS_RECEIVER_CONTRACT_ADDRESS,
    GOERLI_GATEWAY_CONTRACT_ADDRESS,
    MUMBAI_GAS_RECEIVER_CONTRACT_ADDRESS,
    MUMBAI_GATEWAY_CONTRACT_ADDRESS,
} from "../constants"

const deployTestExecute: DeployFunction = async function (
    hre: HardhatRuntimeEnvironment
) {
    const { deployments, getNamedAccounts, network } = hre
    const { deploy } = deployments
    const { deployer } = await getNamedAccounts()

    console.log("Deploying TestExecute on ", network.name)

    let args: string[] = []

    switch (network.name) {
        case "goerli":
            args = [
                GOERLI_GATEWAY_CONTRACT_ADDRESS,
                GOERLI_GAS_RECEIVER_CONTRACT_ADDRESS,
            ]
            break
        case "mumbai":
            args = [
                MUMBAI_GATEWAY_CONTRACT_ADDRESS,
                MUMBAI_GAS_RECEIVER_CONTRACT_ADDRESS,
            ]
            break
        case "fuji":
            args = [
                FUJI_GATEWAY_CONTRACT_ADDRESS,
                FUJI_GAS_RECEIVER_CONTRACT_ADDRESS,
            ]
            break
    }

    const TestExecuteDeployResponse = await deploy("TestExecute", {
        from: deployer,
        args,
        log: true,
        waitConfirmations: 3,
    })

    console.log("Deployed TestExecute to: ", TestExecuteDeployResponse.address)

    if (network.name === "goerli") {
        await verify(TestExecuteDeployResponse.address, args)
    }
}

export default deployTestExecute
deployTestExecute.tags = ["all", "testExecute"]
