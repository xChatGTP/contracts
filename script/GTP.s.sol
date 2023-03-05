// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from 'forge-std/Script.sol';

import { GTP } from '../src/GTP.sol';
import { Tokens } from './utils/Tokens.sol';
import { DeployHUniswapV3 } from '../script/handlers/HUniswapV3.s.sol';

contract DeployGTP is Script {
    function run() public {
        // Tokens tokens = new Tokens();
        // // DeployHUniswapV3 dhuniv3 = new DeployHUniswapV3();
    
        // address wNativeToken = tokens.getWrappedNativeToken();
        // // address swapRouter = dhuniv3.getSwapRouter();

        // vm.startBroadcast();
        // new GTP(
        //     address(1), // gateway
        //     address(1), // gasReceiver
        //     'MATIC', // native token symbol
        //     wNativeToken // native token
        //     // swapRouter // uniswap v3 router
        // );
        // vm.stopBroadcast();

        vm.startBroadcast();
        GTP gtp = GTP(payable(0xaF28975A0F4FFd34421697daeF69EE581c824FD4));

        // 0x57f1c63497aee0be305b8852b354cec793da43bb is aUSDC (just for test)
        gtp.setSiblingChain(43113, 43113, 'Avalanche', 0x57F1c63497AEe0bE305B8852b354CEc793da43bB);

        address[] memory tos = new address[](3);
		bytes32[] memory configs = new bytes32[](3);
		bytes[] memory datas = new bytes[](3);

		tos[0] = address(0xf0Ec636d1Ab91CD2D7c683713bffd74d8fbBFfAf);
		configs[0] = 0x0000000000000000000000000000000000000000000000000000000000000000;

		datas[0] = hex'd0797f84000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000001000000000000000000000000A6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000009184e72a000';

		tos[1] = address(0x87A02FCD6e89a0f074209DCAE4017d82c905b492);
		configs[1] = 0x0001000000000000000000000000000000000000000000000000000000000000;
		datas[1] = hex'e473efd3000000000000000000000000A6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa0000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000009184e72a00000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000';

		tos[2] = address(0);
		configs[2] = 0x0100000000000000000100ffffffffffffffffffffffffffffffffffffffffff;
		datas[2] = hex'00000000000138810000A8699c3C9283D3e44854697Cd22D3Faa240Cfb032889';

		gtp.batchExec{ value: 0.1 ether }(tos, configs, datas);
        vm.stopBroadcast();
    }
}