// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from 'forge-std/Script.sol';

import { HUniswapV3 } from '../../src/handlers/uniswapv3/HUniswapV3.sol';
import { Tokens } from '../utils/Tokens.sol';

contract DeployHUniswapV3 is Script {
  function run() public {
    Tokens tokens = new Tokens();
    
    address wNativeToken = tokens.getWrappedNativeToken();
    address swapRouter = getSwapRouter();

    vm.startBroadcast();
    
    // new HUniswapV3(wNativeToken, swapRouter);
    new HUniswapV3();

    vm.stopBroadcast();
  }

  function getSwapRouter() public view returns (address addr) {
    if (
      block.chainid == 1 || // Ethereum
      block.chainid == 5 || // Goerli
      block.chainid == 10 || // Optimism
      block.chainid == 69 || // Optimism Kovan
      block.chainid == 137 || // Polygon
      block.chainid == 42161 || // Arbitrum One
      block.chainid == 80001 || // Polygon Mumbai
      block.chainid == 421611 // Arbitrum Rinkeby
    ) {
      addr = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    } else {
			revert('Unsupported chain');
		}
	}
}