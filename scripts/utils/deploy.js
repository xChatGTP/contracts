const addresses = require('./addresses.js');

// Get the contract from in-memory deployment or on-chain address
async function get(contractName) {
  return await getAlias(contractName, contractName);
}

async function getAlias(contractName, alias) {
  const [deployer] = await ethers.getSigners();

  // Get the address
  var contractAddress;
  if (network.name == 'hardhat') {
    // In-memory deployment uses in-memory deployed contracts in deployments
    contractAddress = (await deployments.get(alias)).address;
    if (!contractAddress) {
      console.log('Fail to get the name from deployments ' + alias) &
        process.exit(0);
    }
  } else {
    // Use the deployed contracts defined in addresses.js
    contractAddress = addresses[alias];
    if (!contractAddress) {
      console.log(
        'Fail to get the name from deploy/utils/addresses.js ' + alias
      ) & process.exit(0);
    }
  }

  // Get the contract
  const contract = await ethers.getContractAt(
    contractName,
    contractAddress,
    deployer
  );
  console.log(alias + ': ' + contractAddress + ' (get)');

  return contract;
}

// Deploy the contract if hasn't been deployed yet
async function deploy(contractName, ...args) {
  return await deployAlias(contractName, contractName, ...args);
}

async function deployAlias(contractName, alias, ...args) {
  const { deploy } = deployments;
  const [deployer] = await ethers.getSigners();
  const contractAddress = addresses[alias];

  // hardhat node will reuse in-memory deployment so it's fine to execute deploy
  // Other networks don't redeploy if exists
  if (network.name != 'hardhat' && contractAddress) {
    console.log(alias + ': ' + contractAddress + ' (get)');
    return;
  }

  // Deploy the contract
  const contract = await deploy(alias, {
    from: deployer.address,
    contract: contractName,
    args: [...args],
    log: true,
  });

  return contract;
}