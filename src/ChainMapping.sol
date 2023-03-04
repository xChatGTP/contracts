// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import { Ownable } from 'oz/access/Ownable.sol';

contract ChainMapping is Ownable {
	struct Chain {
		// uint256 chainNumber; // our internal chain id
		uint256 chainId; // official chain id
		string chainName;
		address gtp; // GTP contract deployed on this chain
	}

	// Mapping from our internal chain id to official chain
	mapping (uint256 => Chain) public chains;

	function setChain(
		uint256 chainNumber,
		uint256 chainId,
		string memory chainName,
		address _gtp
	) external onlyOwner {
		chains[chainNumber] = Chain(chainId, chainName, _gtp);
	}
}