// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "hardhat/console.sol";

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';


contract TestExecute is AxelarExecutable {
    IAxelarGasService public immutable gasService;

    event TryExecute_DebugEvent(bytes _payload);
    event TestExecute_PayloadSuccess(string _payload);

    // Set the gateway and gas receiver contract address
    // "The Gateway contract is used by Axelar network to execute cross-chain transactions"
    // "The Gas Receiver is a smart contract that accepts tokens as payment to cover costs of contract execution for general message passing transactions"
    // [Source] https://docs.axelar.dev/learn#gateway-smart-contracts
    constructor(address _gateway, address _gasReceiver) AxelarExecutable(_gateway) {
        gasService = IAxelarGasService(_gasReceiver);
    }

    // Function to be called to start the bridging + messaging
    function tryExecute(
        string memory _destinationChain, // Destination chain (https://docs.axelar.dev/dev/build/contract-addresses/testnet)
        string memory _destinationAddress, // Contract address to be called on the destination chain
        // ***NOTE, the payload can be any time and does not have to be a string***
        // Here, it is a string for the sake of simplicity
        string memory _rawPayload, // Payload to be passed to the function on the destination chain contract
        string memory _symbol, // Symbol of the tokens to be bridged (https://docs.axelar.dev/dev/build/contract-addresses/testnet#assets)
        uint256 _amount // Amount of tokens to bridge
    ) external payable {
        // Prepare the tokens and payload for bridging
        address tokenAddress = gateway.tokenAddresses(_symbol); // Get the contract address for the token

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount); // Transfer the tokens from the sender to this account
        IERC20(tokenAddress).approve(address(gateway), _amount); // Approve the gateway to use the tokens on behalf of this contract
        bytes memory payload = abi.encode(_rawPayload); // Encode the payload so that it can be sent as a message over the bridge
        
        emit TryExecute_DebugEvent(payload);

        // If fee is sent with tx, pay for the gas in this chain
        if (msg.value > 0) {
            // [Source] https://docs.axelar.dev/dev/gas-services/pay-gas#paynativegasforcontractcallwithtoken
            gasService.payNativeGasForContractCallWithToken{value: msg.value}(
                address(this), // The contract that will call "callContractWithToken" => This contract
                // The following arguments must simply match the arguments of "callContractWithToken", which is called below
                _destinationChain,
                _destinationAddress,
                payload,
                _symbol,
                _amount,
                // ***NOTE, there may be a better way to calculate the relayer fees*** 
                msg.sender // This is the refund address for excess gas
            );
        }

        // The actual call to bridge the token and send the message
        // [Source] https://docs.axelar.dev/dev/build/gmp-tokens-with-messages
        gateway.callContractWithToken(
            // The following arguments have been described above
            _destinationChain,
            _destinationAddress,
            payload,
            _symbol,
            _amount
        );
    }

    // "Function that will be triggered by the Axelar network after the callContractWithToken function has been executed"
    // [Source] https://docs.axelar.dev/dev/build/gmp-tokens-with-messages
    function _executeWithToken(
        string calldata, // source chain
        string calldata, // Contract address that initiated the bridging
        bytes calldata _payload, // Encoded payload
        string calldata _tokenSymbol, // Symbol for the bridged token
        uint256 _amount // Amount of tokens bridged
    ) internal override {
        // Decode the payload
        // For the sake of symplicity, in this case the payload was originally a string
        string memory decodedPayload = abi.decode(_payload, (string));
        // address tokenAddress = gateway.tokenAddresses(_tokenSymbol); // Get the contract address for the token
    
        emit TestExecute_PayloadSuccess(decodedPayload);
    }
}