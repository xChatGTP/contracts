// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { IERC20 } from 'oz/token/ERC20/IERC20.sol';
import { Script } from 'forge-std/Script.sol';

import { GTP } from '../src/GTP.sol';
import { Tokens } from './utils/Tokens.sol';
import { DeployHUniswapV3 } from '../script/handlers/HUniswapV3.s.sol';

contract DeployGTPrun is Script {
    function run() public {
        Tokens tokens = new Tokens();

        address wNativeToken = tokens.getWrappedNativeToken();

        vm.startBroadcast();
				GTP gtp = GTP(payable(0x236A80A4cCf06e8EE6d869B318447d10983D7c03)); // 0x721cBaa56e20B90bB4510Aa2019De18ae79596d1

        // 0x57f1c63497aee0be305b8852b354cec793da43bb is aUSDC (just for test)
        gtp.setSiblingChain(1287, 1287, 'Moonbeam', 0x8c5dD4Ed3521dAc9b4f3c668F6D8d5684df07CF4);
				// gtp.setSiblingChain(80001, 80001, 'Polygon', 0x721cBaa56e20B90bB4510Aa2019De18ae79596d1);

        IERC20(wNativeToken).approve(address(gtp), type(uint256).max);
        IERC20(0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa).approve(
					address(gtp),
					type(uint256).max
				);

				address[] memory tos = new address[](3);
				bytes32[] memory configs = new bytes32[](3);
				bytes[] memory datas = new bytes[](3);

				tos[0] = address(0xf0Ec636d1Ab91CD2D7c683713bffd74d8fbBFfAf);
				configs[0] = 0x0000000000000000000000000000000000000000000000000000000000000000;

				datas[0] = hex'd0797f84000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000001000000000000000000000000A6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000009184e72a000';

				tos[1] = address(0x71766C5B91D00e303A345124f4EBf542595c7749);
				configs[1] = 0x0001000000000000000000000000000000000000000000000000000000000000;
				datas[1] = hex'e473efd3000000000000000000000000A6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa0000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000009184e72a00000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000';

				tos[2] = address(0);
				configs[2] = 0x0100000000000000000100ffffffffffffffffffffffffffffffffffffffffff;
				datas[2] = hex'0000000000013881000005079c3C9283D3e44854697Cd22D3Faa240Cfb032889';

				// gas
				gtp.batchExec{ value: 0.5 ether }(tos, configs, datas);
						vm.stopBroadcast();
    }
}