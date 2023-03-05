// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from 'forge-std/Script.sol';

import { GTP } from '../src/GTP.sol';
import { Tokens } from './utils/Tokens.sol';
import { DeployHUniswapV3 } from '../script/handlers/HUniswapV3.s.sol';

contract DeployGTP is Script {
    function run() public {
        Tokens tokens = new Tokens();
        DeployHUniswapV3 dhuniv3 = new DeployHUniswapV3();
    
        address wNativeToken = tokens.getWrappedNativeToken();
        // address swapRouter = dhuniv3.getSwapRouter();

        vm.startBroadcast();
        new GTP(
            address(1), // gateway
            address(1), // gasReceiver
            'MATIC', // native token symbol
            wNativeToken // native token
            // swapRouter // uniswap v3 router
        );
        vm.stopBroadcast();
    }
}