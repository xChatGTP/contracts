// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from 'forge-std/Script.sol';

import { GTP } from '../src/GTP.sol';
import { Tokens } from './utils/Tokens.sol';

contract DeployGTP is Script {
    function run() public {
        Tokens tokens = new Tokens();
    
        address wNativeToken = tokens.getWrappedNativeToken();

        vm.startBroadcast();
        new GTP(
            address(1), // gateway
            address(1), // gasReceiver
            'MATIC', // native token symbol
            wNativeToken // native token
        );
        vm.stopBroadcast();
    }
}