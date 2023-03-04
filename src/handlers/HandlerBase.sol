// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import { SafeERC20, IERC20 } from 'oz/token/ERC20/utils/SafeERC20.sol';

import { Config } from '../misc/Config.sol';
import { LibStack } from '../libs/LibStack.sol';
import { Storage } from '../misc/Storage.sol';
import { ISwapRouter } from './uniswapv3/ISwapRouter.sol';

abstract contract HandlerBase is Storage, Config {
    using SafeERC20 for IERC20;
    using LibStack for bytes32[];

    /// @dev Place NATIVE_TOKEN_ADDRESS as the first variable
    ///      for delegate call storage loading.
    address public NATIVE_TOKEN_ADDRESS; // = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    /// @dev Placeholder for delegatecall
    ISwapRouter public ROUTER; // = ISwapRouter(address(0));

    function postProcess() external payable virtual {
        revert('Invalid post process');
        /* Implementation template
        bytes4 sig = stack.getSig();
        if (sig == bytes4(keccak256(bytes('handlerFunction_1()')))) {
            // Do something
        } else if (sig == bytes4(keccak256(bytes('handlerFunction_2()')))) {
            bytes32 temp = stack.get();
            // Do something
        } else revert('Invalid post process');
        */
    }

    function _updateToken(address token) internal {
        stack.setAddress(token);
        // Ignore token type to fit old handlers
        // stack.setHandlerType(uint256(HandlerType.Token));
    }

    function _updatePostProcess(bytes32[] memory params) internal {
        for (uint256 i = params.length; i > 0; i--) {
            stack.set(params[i - 1]);
        }
        stack.set(msg.sig);
        stack.setHandlerType(HandlerType.Custom);
    }

    function getContractName() public pure virtual returns (string memory);

    function _revertMsg(string memory functionName, string memory reason)
        internal
        pure
    {
        revert(
            string(
                abi.encodePacked(
                    getContractName(),
                    '_',
                    functionName,
                    ': ',
                    reason
                )
            )
        );
    }

    function _revertMsg(string memory functionName) internal pure {
        _revertMsg(functionName, 'Unspecified');
    }

    function _requireMsg(
        bool condition,
        string memory functionName,
        string memory reason
    ) internal pure {
        if (!condition) _revertMsg(functionName, reason);
    }

    function _uint2String(uint256 n) internal pure returns (string memory) {
        if (n == 0) {
            return '0';
        } else {
            uint256 len = 0;
            for (uint256 temp = n; temp > 0; temp /= 10) {
                len++;
            }
            bytes memory str = new bytes(len);
            for (uint256 i = len; i > 0; i--) {
                str[i - 1] = bytes1(uint8(48 + (n % 10)));
                n /= 10;
            }
            return string(str);
        }
    }

    function _getBalance(address token, uint256 amount)
        internal
        view
        returns (uint256)
    {
        if (amount != type(uint256).max) {
            return amount;
        }

        // ETH case
        if (token == address(0) || token == NATIVE_TOKEN_ADDRESS) {
            return address(this).balance;
        }
        // ERC20 token case
        return IERC20(token).balanceOf(address(this));
    }

    function _tokenApprove(
        address token,
        address spender,
        uint256 amount
    ) internal {
        IERC20(token).safeApprove(spender, amount);
    }

    function _tokenApproveZero(address token, address spender) internal {
        IERC20(token).safeApprove(spender, 1); // 1 for warm load
    }

    function _isNotNativeToken(address token) internal view returns (bool) {
        return (token != address(0) && token != NATIVE_TOKEN_ADDRESS);
    }
}