// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { IERC20 } from 'oz/token/ERC20/IERC20.sol';
import { Script } from 'forge-std/Script.sol';

import { GTP } from '../src/GTP.sol';
import { Tokens } from './utils/Tokens.sol';
import { DeployHUniswapV3 } from '../script/handlers/HUniswapV3.s.sol';

contract DeployGTP is Script {
    function run() public {
        Tokens tokens = new Tokens();
        // DeployHUniswapV3 dhuniv3 = new DeployHUniswapV3();
    
        address wNativeToken = tokens.getWrappedNativeToken();
        // address swapRouter = dhuniv3.getSwapRouter();
        string memory nativeTokenSymbol = tokens.getAxelarNativeTokenSymbol();

        vm.startBroadcast();
        new GTP(
            tokens.getAxelarGateway(), // gateway
            tokens.getAxelarGasService(), // gasReceiver
            nativeTokenSymbol, // native token symbol
            wNativeToken // native token
            // swapRouter // uniswap v3 router
        );
        vm.stopBroadcast();

        vm.startBroadcast();
    }
}