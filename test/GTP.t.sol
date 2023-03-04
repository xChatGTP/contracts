// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { console } from 'forge-std/console.sol';

import { Tokens } from '../script/utils/Tokens.sol';
import { DeployHUniswapV3 } from '../script/handlers/HUniswapV3.s.sol';
import { GTP } from '../src/GTP.sol';
import { HUniswapV3 } from '../src/handlers/uniswapv3/HUniswapV3.sol';
import { HFunds } from '../src/handlers/funds/HFunds.sol';

contract GTPTest {
	GTP internal gtp;
	HUniswapV3 internal hUniswapV3;
	HFunds internal hFunds;

	function setUp() public {
		Tokens tokens = new Tokens();
		DeployHUniswapV3 dhuniv3 = new DeployHUniswapV3();
    
		address wNativeToken = tokens.getWrappedNativeToken();
		address swapRouter = dhuniv3.getSwapRouter();

		gtp = new GTP(
				address(1), // gateway
				address(1), // gasReceiver
				'MATIC', // native token symbol
				wNativeToken // native token
		);

		hUniswapV3 = new HUniswapV3(
				wNativeToken,
				swapRouter
		);

		hFunds = new HFunds();
	}

	function testEmpty() public {
		address[] memory tos = new address[](0);
		bytes32[] memory configs = new bytes32[](0);
		bytes[] memory datas = new bytes[](0);

		gtp.batchExec(tos, configs, datas);
	}

	function testInvalidLength() public {
		address[] memory tos = new address[](1);
		bytes32[] memory configs = new bytes32[](0);
		bytes[] memory datas = new bytes[](0);

		tos[0] = address(hFunds);

		console.log(tos[0]);
		gtp.batchExec(tos, configs, datas);
	}

	function testInject() public {
		address[] memory tos = new address[](1);
		bytes32[] memory configs = new bytes32[](1);
		bytes[] memory datas = new bytes[](1);

		tos[0] = address(hFunds);
		configs[0] = 0x0000000000000000000000000000000000000000000000000000000000000000;
		// datas[0] = hex'd0797f840000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000d500B1d8E8eF31E21C99d1Db9A6444d3ADf127000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000de0b6b3a7640000';
		datas[0] = hex'd0797f840000000000000000000000000d500B1d8E8eF31E21C99d1Db9A6444d3ADf12700000000000000000000000000000000000000000000000000de0b6b3a7640000';
		// console.logBytes(
		// 	abi.encode(address(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270), 1_000_000_000)
		// );
		// console.logBytes(
		// 	abi.encodeWithSignature('inject(address[],uint256[])', address(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270), 1_000_000_000)
		// );
		gtp.batchExec(tos, configs, datas);
	} //0xe4ca0c9ea113b23b823953edf5552e8423c25f70
}