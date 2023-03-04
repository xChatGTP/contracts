// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

contract Tokens {
	function getWrappedNativeToken() public view returns (address addr) {
		addr = block.chainid == 1 // Ethereum
			? 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
			: block.chainid == 5 // Goerli
			? 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6
			: block.chainid == 10 || block.chainid == 69 // Optimism, Optimism Kovan
			? 0x4200000000000000000000000000000000000006
			: block.chainid == 137 // Polygon
			? 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270
			: block.chainid == 42161 // Arbitrum One
			? 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1
			: block.chainid == 43113 // Avalanche Fuji
			? 0xd00ae08403B9bbb9124bB305C09058E32C39A48c
			: block.chainid == 43114 // Avalanche
			? 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7
			: block.chainid == 80001 // Polygon Mumbai
			? 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889
			: block.chainid == 421611 // Arbitrum Rinkeby
			? 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1
			: address(0);
			
		if (addr == address(0)) revert('Unsupported chain');
	}

	function getAxelarUSDC() public view returns (address addr) {
		addr = block.chainid == 5
			? 0x254d06f33bDc5b8ee05b2ea472107E300226659A
			: block.chainid == 43113
			? 0x57F1c63497AEe0bE305B8852b354CEc793da43bB
			: block.chainid == 80001
			? 0x2c852e740B62308c46DD29B982FBb650D063Bd07
			: address(0);
		
		if (addr == address(0)) revert('Unsupported chain');
	}
}
