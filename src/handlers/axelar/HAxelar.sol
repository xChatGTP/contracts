// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import { AxelarExecutable } from 'axelar-gmp/executable/AxelarExecutable.sol';
import { IAxelarGateway } from 'axelar-gmp/interfaces/IAxelarGateway.sol';
import { IAxelarGasService } from 'axelar-gmp/interfaces/IAxelarGasService.sol';
import { SafeERC20, IERC20 } from 'oz/token/ERC20/utils/SafeERC20.sol';

import '../HandlerBase.sol';
import '../../libs/BytesLib.sol';

// contract HAxelar is HandlerBase, AxelarExecutable {
// 		using SafeERC20 for IERC20;
//     using BytesLib for bytes;

// 		IAxelarGasService public immutable gasService;

// 		constructor(
// 			address _gateway,
// 			address _gasReceiver
// 		) AxelarExecutable(_gateway) {
// 				gasService = IAxelarGasService(_gasReceiver);
// 		}

// 		function getContractName() public pure override returns (string memory) {
//         return 'HAxelar';
//     }

// 		function bridge(
//         string memory destinationChain,
//         string memory destinationAddress,
//         address[] calldata destinationAddresses,
//         string memory symbol,
//         uint256 amount
//     ) external payable {
//         address tokenAddress = gateway.tokenAddresses(symbol);
//         IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
//         IERC20(tokenAddress).approve(address(gateway), amount);
//         bytes memory payload = abi.encode(destinationAddresses);
//         if (msg.value > 0) {
//             gasService.payNativeGasForContractCallWithToken{ value: msg.value }(
//                 address(this),
//                 destinationChain,
//                 destinationAddress,
//                 payload,
//                 symbol,
//                 amount,
//                 msg.sender
//             );
//         }
//         gateway.callContractWithToken(destinationChain, destinationAddress, payload, symbol, amount);
//     }
// }
