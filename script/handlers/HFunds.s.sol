// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Script } from 'forge-std/Script.sol';

import { HFunds } from '../../src/handlers/funds/HFunds.sol';

contract DeployHFunds is Script {
  function run() public {
    vm.startBroadcast();
    
    new HFunds();

    vm.stopBroadcast();
  }
}