-include .env

.PHONY: all test clean deploy-bsc-verify

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std --no-commit && \
forge install openzeppelin/openzeppelin-contracts --no-commit && \
forge install openzeppelin/openzeppelin-contracts-upgradeable --no-commit && \
forge install transmissions11/solmate --no-commit && \
forge install uniswap/v3-core@0.8 --no-commit && \
forge install uniswap/v3-periphery@0.8 --no-commit && \
forge install axelarnetwork/axelar-gmp-sdk-solidity --no-commit 

# Update Dependencies
update :; forge update

build :; forge build

build-op :; forge build --via-ir --optimize

type :; npx typechain --target ethers-v5 ./abi/*.json --out-dir ./types

type-move-server :; npx typechain --target ethers-v5 ./abi/*.json && cp -r ./types/ethers-contracts/* ../website/src/types/contracts

bind :; forge bind

bind-op :; forge bind --via-ir --optimize

test-anvil :; forge test --via-ir --optimize --rpc-url http://localhost:8545 -vvvv

# Test on Goerli fork
test :; forge test --via-ir --optimize --fork-url ${MUMBAI_RPC_URL} -vvvv

# Test on Goerli fork, watching test contract change
test-watch :; forge test --fork-url ${GOERLI_RPC_URL} -vv --watch ./test/VenusHedger.t.sol 

snapshot :; forge snapshot

slither :; slither ./src 

format :; prettier --write src/**/*.sol && prettier --write src/*.sol

# solhint should be installed globally
lint :; solhint src/**/*.sol && solhint src/*.sol

anvil :; anvil -m 'test test test test test test test test test test test junk'

# deploy with verification # call like `make deploy-goerli contract=Token`
# use the "@" to hide the command from your shell
deploy-goerli :; @forge script script/${contract}.s.sol:Deploy${contract} --via-ir --optimize --rpc-url ${GOERLI_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvv

deploy-mumbai :; @forge script script/${contract}.s.sol:Deploy${contract} --via-ir --optimize --rpc-url ${MUMBAI_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${POLYGONSCAN_API_KEY} -vvvv

deploy-moonbase :; @forge script script/${contract}.s.sol:Deploy${contract} --via-ir --optimize --rpc-url ${MOONBASE_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${MOONSCAN_API_KEY} -vvvv

deploy-handlers-goerli :; @forge script script/handlers/${contract}.s.sol:Deploy${contract} --via-ir --optimize --rpc-url ${GOERLI_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvv

deploy-handlers-mumbai :; @forge script script/handlers/${contract}.s.sol:Deploy${contract} --via-ir --optimize --rpc-url ${MUMBAI_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${POLYGONSCAN_API_KEY} -vvvv

deploy-handlers-moonbase :; @forge script script/handlers/${contract}.s.sol:Deploy${contract} --via-ir --optimize --rpc-url ${MOONBASE_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${MOONSCAN_API_KEY} -vvvv

action-mumbai :; @forge script script/actions/${contract}.s.sol:Action${contract} --via-ir --optimize --rpc-url ${MUMBAI_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast -vvvv
action-moonbase :; @forge script script/actions/${contract}.s.sol:Action${contract} --via-ir --optimize --rpc-url ${MOONBASE_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast -vvvv

# This is the private key of account from the mnemonic from the "make anvil" command
# `make deploy-anvil contract=VenusHedger`
deploy-anvil :; @forge script script/${contract}.s.sol:Deploy${contract} --via-ir --optimize --rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast 

deploy-handlers-anvil :; @forge script script/handlers/${contract}.s.sol:Deploy${contract} --via-ir --optimize --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast 

#
# ABI
#
abis : abi-distribution-ex abi-auction abi-vault

abi-distribution-ex :; forge inspect src/DistributionExecutable.sol:DistributionExecutable abi > abi/DistributionExecutable.json # --via-ir --optimize
