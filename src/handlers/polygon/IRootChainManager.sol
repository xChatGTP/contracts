// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface IRootChainManager {
    function depositEtherFor(address user) external payable;
    function depositFor(
        address user,
        address rootToken,
        bytes calldata depositData
    ) external;
}