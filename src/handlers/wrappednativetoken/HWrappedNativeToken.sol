// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import 'oz/token/ERC20/utils/SafeERC20.sol';
import '../HandlerBase.sol';
import './IWrappedNativeToken.sol';

contract HWrappedNativeToken is HandlerBase {
    function getContractName() public pure override returns (string memory) {
        return 'HWrappedNativeToken';
    }

    function deposit(uint256 value) external payable {
        try
            IWrappedNativeToken(NATIVE_TOKEN_ADDRESS).deposit{value: value}()
        {} catch Error(string memory reason) {
            _revertMsg('deposit', reason);
        } catch {
            _revertMsg('deposit');
        }
        _updateToken(NATIVE_TOKEN_ADDRESS);
    }

    function withdraw(uint256 wad) external payable {
        try
            IWrappedNativeToken(NATIVE_TOKEN_ADDRESS).withdraw(wad)
        {} catch Error(string memory reason) {
            _revertMsg('withdraw', reason);
        } catch {
            _revertMsg('withdraw');
        }
    }
}