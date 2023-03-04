### [🏔EthDenver'23]

# xChatGTP Contracts

-   Before running the `testExecuteScript.ts`, make sure to create `.env` and fill in the values given in `.env.example`

-   Install packages

    ```shell
    yarn install
    ```

-   [Optional] Deploy `TestExecute` contracts on Fuji (Avalanche) and Mumbai (Polygon).

    ```shell
    npx hardhat deploy --network fuji
    npx hardhat deploy --network mumbai
    ```

-   If new contracts were delpoyed in the previous step, be sure to update the contract addresses in `constants.ts` with the newly deployed contracts. Specifically, `FUJI_TEST_EXECUTE_CONTRACT_ADDRESS` and `MUMBAI_TEST_EXECUTE_CONTRACT_ADDRESS` need to be updated.

-   Run the `testExecuteScript.ts` script to see the Axelar GMP in action! This will bridge WAVAX from Fuji to Axelar along with the message "Hello There!". Make sure you have WAVAX to bridge and AVAX to pay for relayer gas fees.

    ```shell
    npx hardhat run scripts/testExecuteScript.ts --network fuji
    ```

-   Track the status on Axelar [here](https://testnet.axelarscan.io/gmp/search?sourceChain=avalanche&destinationChain=polygon)
