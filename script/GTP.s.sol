// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from 'forge-std/Script.sol';

import { GTP } from '../src/GTP.sol';

contract DeployAuction is Script {
    GTP internal gtp;

    function run() public {
        vm.startBroadcast();
        gtp = new GTP();
        vm.stopBroadcast();
    }
}