// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from 'forge-std/Script.sol';

import { HUniswapV2 } from '../../src/handlers/uniswapv2/HUniswapV2.sol';
import { Tokens } from '../utils/Tokens.sol';

contract DeployHUniswapV2 is Script {
  function run() public {
    Tokens tokens = new Tokens();
    
    address v2SwapRouter = getV2SwapRouter();

    vm.startBroadcast();
    
    new HUniswapV2(v2SwapRouter);

    vm.stopBroadcast();
  }

  function getV2SwapRouter() public view returns (address addr) {
    addr = block.chainid == 1287
      ? 0x8a1932D6E26433F3037bd6c3A40C816222a6Ccd4
      : block.chainid == 80001
      ? address(0)
      : address(0);
    
    if (addr == address(0)) {
			revert('Unsupported chain');
		}
	}
}