const eth = {
	WRAPPED_NATIVE_TOKEN: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
}

const optimism = {
	WRAPPED_NATIVE_TOKEN: '0x4200000000000000000000000000000000000006',
}

const polygon = {
	WRAPPED_NATIVE_TOKEN: '0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270',
}

const avalanche = {
	WRAPPED_NATIVE_TOKEN: '0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7',
}

module.exports =
	network.name == 'eth'
    ? eth
    : network.name == 'optimism'
    ? optimism
    : network.name == 'polygon'
    ? polygon
    : network.name == 'avalanche'
    ? avalanche
    : console.log('Unsupported network name') & process.exit(0);

module.exports.skip = async () => true;