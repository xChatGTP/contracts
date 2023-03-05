// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { IERC20 } from 'oz/token/ERC20/IERC20.sol';
import { console } from 'forge-std/console.sol';
import 'forge-std/Test.sol';

import { Tokens } from '../script/utils/Tokens.sol';
import { DeployHUniswapV3 } from '../script/handlers/HUniswapV3.s.sol';
import { GTP } from '../src/GTP.sol';
import { HUniswapV3 } from '../src/handlers/uniswapv3/HUniswapV3.sol';
import { HFunds } from '../src/handlers/funds/HFunds.sol';

interface IWrappedNativeToken {
	function deposit() external payable;
	function withdraw(uint256 wad) external;
}

contract GTPTest is Test {
	GTP internal gtp;
	HUniswapV3 internal hUniswapV3;
	HFunds internal hFunds;

	address internal wNativeToken;
	address internal swapRouter;

	function setUp() public {
		Tokens tokens = new Tokens();
		DeployHUniswapV3 dhuniv3 = new DeployHUniswapV3();
    
		wNativeToken = tokens.getWrappedNativeToken();
		swapRouter = dhuniv3.getSwapRouter();

		gtp = new GTP(
				address(1), // gateway
				address(1), // gasReceiver
				'MATIC', // native token symbol
				wNativeToken // native token
				// swapRouter // uniswap v3 router
		);

		IERC20(wNativeToken).approve(address(gtp), type(uint256).max);

		hUniswapV3 = new HUniswapV3(wNativeToken, swapRouter);
		hFunds = new HFunds();

		// Get Wrapped Token
		vm.deal(address(this), 10_000 ether);
		require(address(this).balance >= 10_000 ether, 'Not enough balance');
		IWrappedNativeToken(wNativeToken).deposit{value: 100 ether}();
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
		datas[0] = hex'd0797f840000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000d500B1d8E8eF31E21C99d1Db9A6444d3ADf127000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000de0b6b3a7640000';

		gtp.batchExec{ value: 1 ether }(tos, configs, datas);
	}

	function testSwapNative2Token() public {
		console.log('matic bal (this)', address(this).balance);
		console.log('matic bal (GTP)', address(gtp).balance);
		console.log('usdc bal (this)', IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174).balanceOf(address(this)));
		console.log('usdc bal (GTP)', IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174).balanceOf(address(gtp)));

		address[] memory tos = new address[](2);
		bytes32[] memory configs = new bytes32[](2);
		bytes[] memory datas = new bytes[](2);

		tos[0] = address(hFunds);
		configs[0] = 0x0000000000000000000000000000000000000000000000000000000000000000;
		datas[0] = hex'd0797f840000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000d500B1d8E8eF31E21C99d1Db9A6444d3ADf127000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000de0b6b3a7640000';

		tos[1] = address(hUniswapV3);
		configs[1] = 0x0000000000000000000000000000000000000000000000000000000000000000;
		datas[1] = hex'8aa5b89b0000000000000000000000002791Bca1f2de4661ED88A30C99A7a9449Aa8417400000000000000000000000000000000000000000000000000000000000000640000000000000000000000000000000000000000000000000de0b6b3a764000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000';

		gtp.batchExec{ value: 1 ether }(tos, configs, datas);

		console.log('matic bal (this)', address(this).balance);
		console.log('matic bal (GTP)', address(gtp).balance);
		console.log('usdc bal (this)', IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174).balanceOf(address(this)));
		console.log('usdc bal (GTP)', IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174).balanceOf(address(gtp)));
	}

	fallback() external payable {}
	receive() external payable {}
}