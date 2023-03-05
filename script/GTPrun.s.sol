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
				GTP gtp = GTP(payable(0x721cBaa56e20B90bB4510Aa2019De18ae79596d1));

        // 0x57f1c63497aee0be305b8852b354cec793da43bb is aUSDC (just for test)
        gtp.setSiblingChain(1387, 1387, 'Moonbase', 0x4B4D11d583e24dbC3A84979bE1b421B362F5c51c);
				// gtp.setSiblingChain(80001, 80001, 'Polygon', 0x721cBaa56e20B90bB4510Aa2019De18ae79596d1);

        // IERC20(wNativeToken).approve(address(gtp), type(uint256).max);
        // IERC20(0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa).approve(
				// 	address(gtp),
				// 	type(uint256).max
				// );

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
				datas[2] = hex'00000000000138810000A8699c3C9283D3e44854697Cd22D3Faa240Cfb032889';

				// gas
				gtp.batchExec{ value: 0.5 ether }(tos, configs, datas);
						vm.stopBroadcast();
    }
}