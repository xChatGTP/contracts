// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { console } from 'forge-std/console.sol';

import '../libs/LibCache.sol';
import '../libs/LibStack.sol';

/// @notice A cache structure composed by a bytes32 array
contract Storage {
    using LibCache for mapping(bytes32 => bytes32);
    using LibStack for bytes32[];

    bytes32[] public stack;
    mapping(bytes32 => bytes32) public cache;

    // keccak256 hash of 'msg.sender'
    // prettier-ignore
    bytes32 public constant MSG_SENDER_KEY = 0xb2f2618cecbbb6e7468cc0f2aa43858ad8d153e0280b22285e28e853bb9d453a;

    modifier isStackEmpty() {
        require(stack.length == 0, 'Stack not empty');
        _;
    }

    modifier isInitialized() {
        require(_getSender() != address(0), 'Sender is not initialized');
        _;
    }

    modifier isNotInitialized() {
        require(_getSender() == address(0), 'Sender is initialized');
        _;
    }

    function _setSender(address _overrideSender) internal isNotInitialized {
        console.log('Setting sender to', _overrideSender);
        if (_overrideSender != address(0)) {
            cache.setAddress(MSG_SENDER_KEY, _overrideSender);
        } else {
            cache.setAddress(MSG_SENDER_KEY, msg.sender);
        }
    }

    function _resetSender() internal {
        cache.setAddress(MSG_SENDER_KEY, address(0));
    }

    function _getSender() internal view returns (address) {
        return cache.getAddress(MSG_SENDER_KEY);
    }
}