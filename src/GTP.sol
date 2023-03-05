// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import { AxelarExecutable } from 'axelar-gmp/executable/AxelarExecutable.sol';
import { IAxelarGasService } from 'axelar-gmp/interfaces/IAxelarGasService.sol';
import { StringToAddress, AddressToString } from 'axelar-gmp/utils/AddressString.sol';
import { SafeERC20, IERC20 } from 'oz/token/ERC20/utils/SafeERC20.sol';
import { Address } from 'oz/utils/Address.sol';
import { Strings } from 'oz/utils/Strings.sol';
import { console } from 'forge-std/console.sol';

import { Config } from './misc/Config.sol';
import { Storage } from './misc/Storage.sol';
import { LibStack } from './libs/LibStack.sol';
import { LibParam } from './libs/LibParam.sol';
import { ISwapRouter } from './handlers/uniswapv3/ISwapRouter.sol';

contract GTP is Storage, Config {
    using SafeERC20 for IERC20;
    using Address for address;
    using AddressToString for address;
    using LibParam for bytes32;
    using LibStack for bytes32[];
    using Strings for uint256;
    using StringToAddress for string;

    event LogBegin(
        address indexed handler,
        bytes4 indexed selector,
        bytes payload
    );

    event LogEnd(
        address indexed handler,
        bytes4 indexed selector,
        bytes result
    );

    struct SiblingChain {
		// uint256 chainNumber; // our internal chain id
		uint256 chainId; // official chain id
		string chainName;
		address gtp; // GTP contract deployed on this chain
	}

    address private constant NATIVE_TOKEN_ALT = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    address public owner;

	// Mapping from our internal chain id to official chain
	mapping (uint256 => SiblingChain) public siblingChains;

    IAxelarGasService public gasReceiver;

    string private NATIVE_TOKEN_SYMBOL;

    modifier onlyOwner() {
        require(msg.sender == owner, 'Only owner');
        _;
    }

    constructor(
        address _gateway,
        address _gasReceiver,
        string memory _nativeTokenSymbol,
        address _nativeTokenAddress
    ) {
        // gasReceiver = IAxelarGasService(_gasReceiver);
        // wrappedTokenAddress = _nativeTokenAddress;
        NATIVE_TOKEN_SYMBOL = _nativeTokenSymbol;
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    /**
     * @notice Combo execution function. Including three phases: pre-process,
     * exection and post-process.
     * @param tos The handlers of combo.
     * @param configs The configurations of executing cubes.
     * @param datas The combo datas.
     */
    function batchExec(
        address[] calldata tos,
        bytes32[] calldata configs,
        bytes[] memory datas
    ) external payable {
        _preProcess(msg.sender);
        _execs(tos, configs, datas, msg.sender);
        _postProcess();
    }

    /**
     * @notice The execution interface for callback function to be executed.
     * @dev This function can only be called through the handler, which makes
     * the caller become proxy itself.
     */
    function execs(
        address[] calldata tos,
        bytes32[] calldata configs,
        bytes[] memory datas
    ) external payable {
        require(msg.sender == address(this), 'Does not allow external calls');
        _execs(tos, configs, datas, msg.sender);
    }

    /**
     * @notice Executed by Axelar on target chain (from source chain).
     */
    // function _executeWithToken(
    //     string calldata,
    //     string calldata,
    //     bytes calldata payload,
    //     string calldata tokenSymbol,
    //     uint256 amount
    // ) internal override {
    //     address user;
    //     address[] memory tos;
    //     bytes32[] memory configs;
    //     bytes[] memory datas;
        
    //     (user, tos, configs, datas) = abi.decode(payload, (address, address[], bytes32[], bytes[]));
    //     _chainedExecs(user, tos, configs, datas);
    // }

    function _chainedExecs(
        address user,
        address[] memory tos,
        bytes32[] memory configs,
        bytes[] memory datas
    ) internal {
        _preProcess(user);
        _execs(tos, configs, datas, user);
        _postProcess();
    }

    /**
     * @notice The execution phase.
     * @param tos The handlers of combo.
     * @param configs The configurations of executing cubes.
     * @param datas The combo datas.
     */
    function _execs(
        address[] memory tos,
        bytes32[] memory configs,
        bytes[] memory datas,
        address user
    ) internal {
        // bytes32[256] memory localStack;
        bytes32[8] memory localStack;
        uint256 index;
        uint256 counter;

        require(tos.length == datas.length, 'Tos and datas length inconsistent');
        require(tos.length == configs.length, 'Tos and configs length inconsistent');

        for (uint256 i = 0; i < tos.length;) {
            console.log(i);
            address to = tos[i];
            bytes32 config = configs[i];
            bytes memory data = datas[i];

            // Pass the rest of the execution data  to the next chain.
            // Include the bridging execution (index i), which is needed for bridging the token.
            // {
            //     address[] memory _tos = new address[](tos.length - i);
            //     bytes32[] memory _configs = new bytes32[](tos.length - i);
            //     bytes[] memory _datas = new bytes[](tos.length - i);

            //     // skip the i-th tx since it (must) indicates bridging
            //     for (uint256 j = i + 1;  j < tos.length;) {
            //         _tos[tos.length - j] = tos[j];
            //         _configs[tos.length - j] = configs[j];
            //         _datas[tos.length - j] = datas[j];
            //         unchecked {
            //             ++j;
            //         }
            //     }

            //     _execsTransferChain(
            //         _tos,
            //         _configs,
            //         _datas,
            //         user,
            //         chainNum,
            //         nextChainNum
            //     );
            // }

            // Check if the data contains dynamic parameter
            if (!config.isStatic()) {
                // If so, trim the exectution data base on the configuration and stack content
                _trim(data, config, localStack, index);
            }
            // Emit the execution log before call
            bytes4 selector = _getSelector(data);
            emit LogBegin(to, selector, data);

            // Check if the output will be referenced afterwards
            bytes memory result = _exec(to, data, counter);
            counter++;

            // Emit the execution log after call
            emit LogEnd(to, selector, result);

            if (config.isReferenced()) {
                // If so, parse the output and place it into local stack
                uint256 num = config.getReturnNum();
                uint256 newIndex = _parse(localStack, result, index);
                require(
                    newIndex == index + num,
                    'Return num and parsed return num not matched'
                );
                index = newIndex;
            }

            // Setup the process to be triggered in the post-process phase
            _setPostProcess(to);

            unchecked {
                ++i;
            }
        }
    }

    // function _execsTransferChain(
    //     address[] memory tos,
    //     bytes32[] memory configs,
    //     bytes[] memory datas,
    //     address user,
    //     uint256 curChainNum,
    //     uint256 nextChainNum
    // ) internal {
    //     require(tos.length > 1, 'Invalid length in chain transfer');
    //     bytes memory payload = abi.encode(user, tos, configs, datas);

    //     SiblingChain memory nextChain = siblingChains[nextChainNum];
    //     string memory dstChain = nextChain.chainName; // e.g. 'ethereum-2'
    //     string memory dstContractAddr = Strings.toHexString(uint256(uint160(nextChain.gtp)), 20);
    //     uint256 amount = 0.025 ether;

    //     // AVAX (Avalanche)
    //     // ETH (Ethereum)
    //     // FTM (Fantom)
    //     // GLMR (Moonbeam)
    //     // MATIC (Polygon)

    //     // address tokenAddress = gateway.tokenAddresses(symbol);

    //     // Pay gas
    //     gasReceiver.payNativeGasForContractCallWithToken{value: msg.value}(
    //         address(this), // sender
    //         dstChain,
    //         dstContractAddr,
    //         payload,
    //         NATIVE_TOKEN_SYMBOL,
    //         amount,
    //         msg.sender
    //     );

    //     // Initiate GMP
    //     gateway.callContractWithToken(dstChain, dstContractAddr, payload, NATIVE_TOKEN_SYMBOL, amount);
    // }

    /**
     * @notice Trimming the execution data.
     * @param data The execution data.
     * @param config The configuration.
     * @param localStack The stack the be referenced.
     * @param index Current element count of localStack.
     */
    function _trim(
        bytes memory data,
        bytes32 config,
        bytes32[8] memory localStack, // bytes32[256] memory localStack,
        uint256 index
    ) internal pure {
        // Fetch the parameter configuration from config
        (uint256[] memory refs, uint256[] memory params) = config.getParams();
        // Trim the data with the reference and parameters
        for (uint256 i = 0; i < refs.length;) {
            require(refs[i] < index, 'Reference to out of localStack');
            bytes32 ref = localStack[refs[i]];
            uint256 offset = params[i];
            uint256 base = PERCENTAGE_BASE;
            assembly {
                let loc := add(add(data, 0x20), offset)
                let m := mload(loc)
                // Adjust the value by multiplier if a dynamic parameter is not zero
                if iszero(iszero(m)) {
                    // Assert no overflow first
                    let p := mul(m, ref)
                    if iszero(eq(div(p, m), ref)) {
                        revert(0, 0)
                    } // require(p / m == ref)
                    ref := div(p, base)
                }
                mstore(loc, ref)
            }
            unchecked {
                i++;
            }
        }
    }

    /**
     * @notice Parse the return data to the local stack.
     * @param localStack The local stack to place the return values.
     * @param ret The return data.
     * @param index The current tail.
     */
    function _parse(
        bytes32[8] memory localStack, // bytes32[256] memory localStack,
        bytes memory ret,
        uint256 index
    ) internal pure returns (uint256 newIndex) {
        uint256 len = ret.length;
        // The return value should be multiple of 32-bytes to be parsed.
        require(len % 32 == 0, 'illegal length for _parse');
        // Estimate the tail after the process.
        newIndex = index + len / 32;
        require(newIndex <= 256, 'stack overflow');
        assembly {
            let offset := shl(5, index)
            // Store the data into localStack
            for {
                let i := 0
            } lt(i, len) {
                i := add(i, 0x20)
            } {
                mstore(
                    add(localStack, add(i, offset)),
                    mload(add(add(ret, i), 0x20))
                )
            }
        }
    }

    /**
     * @notice The execution of a single action.
     * @param to_ The handler of cube.
     * @param data_ The cube execution data.
     * @param counter_ The current counter of the cube.
     */
    function _exec(
        address to_,
        bytes memory data_,
        uint256 counter_
    ) internal returns (bytes memory result) {
        bool success;
        assembly {
            success := delegatecall(
                sub(gas(), 5000),
                to_,
                add(data_, 0x20),
                mload(data_),
                0,
                0
            )
            let size := returndatasize()

            result := mload(0x40)
            mstore(
                0x40,
                add(result, and(add(add(size, 0x20), 0x1f), not(0x1f)))
            )
            mstore(result, size)
            returndatacopy(add(result, 0x20), 0, size)
        }

        if (!success) {
            if (result.length < 68) revert('_exec');
            assembly {
                result := add(result, 0x04)
            }

            if (counter_ == type(uint256).max) {
                revert(abi.decode(result, (string))); // Don't prepend counter
            } else {
                revert(
                    string(
                        abi.encodePacked(
                            counter_.toString(),
                            '_',
                            abi.decode(result, (string))
                        )
                    )
                );
            }
        }
    }

    /**
     * @notice Setup the post-process.
     * @param to_ The handler of post-process.
     */
    function _setPostProcess(address to_) internal {
        // If the stack length equals 0, just skip
        // If the top is a custom post-process, replace it with the handler
        // address.
        if (stack.length == 0) {
            return;
        } else if (
            stack.peek() == bytes32(bytes12(uint96(HandlerType.Custom))) &&
            bytes4(stack.peek(1)) != 0x00000000
        ) {
            stack.pop();
            stack.setAddress(to_);
            stack.setHandlerType(HandlerType.Custom);
        }
    }

    /// @notice The pre-process phase.
    function _preProcess(address _overrideSender)
        internal
        virtual
        isStackEmpty
    {
        // Set the sender
        _setSender(_overrideSender);
    }

    /// @notice The post-process phase.
    function _postProcess() internal {
        // Handler type will be parsed at the beginning. Will send the token back to
        // user if the handler type is 'Token'. Will get the handler address and
        // execute the customized post-process if handler type is 'Custom'.
        while (stack.length > 0) {
            bytes32 top = stack.get();
            // Get handler type
            HandlerType handlerType = HandlerType(uint96(bytes12(top)));
            if (handlerType == HandlerType.Token) {
                address addr = address(uint160(uint256(top)));
                uint256 tokenAmount = IERC20(addr).balanceOf(address(this));
                if (tokenAmount > 0)
                    IERC20(addr).safeTransfer(msg.sender, tokenAmount);
            } else if (handlerType == HandlerType.Custom) {
                address addr = stack.getAddress();
                _exec(
                    addr,
                    abi.encodeWithSelector(POSTPROCESS_SIG),
                    type(uint256).max
                );
            } else {
                revert('Invalid handler type');
            }
        }

        // Balance should also be returned to user
        uint256 amount = address(this).balance;
        if (amount > 0) payable(msg.sender).transfer(amount);
        // Reset cached datas
        _resetSender();
    }

    /// @notice Get payload function selector.
    function _getSelector(bytes memory payload)
        internal
        pure
        returns (bytes4 selector)
    {
        selector =
            payload[0] |
            (bytes4(payload[1]) >> 8) |
            (bytes4(payload[2]) >> 16) |
            (bytes4(payload[3]) >> 24);
    }

    function setSiblingChain(
		uint256 chainNumber,
		uint256 chainId,
		string memory chainName,
		address _gtp
	) external onlyOwner {
		siblingChains[chainNumber] = SiblingChain(chainId, chainName, _gtp);
	}

    fallback() external payable {}

    receive() external payable {}
}