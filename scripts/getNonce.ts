import { ethers, network } from "hardhat"

async function main() {
    const { deployer } = await ethers.getNamedSigners()

    const nonce = await deployer.getTransactionCount()

    console.log("nonce:", nonce)
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
