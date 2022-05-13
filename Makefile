.PHONY: all test
# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules

# Install the Modules
install :;
	forge install --no-commit foundry-rs/forge-std
	forge install --no-commit rari-capital/solmate

# Update Dependencies
update:; forge update

# Builds
build  :; forge clean && forge build --optimize --optimizer-runs 200

# Test
test :; forge test -vvv

# Lint
lint :; solhint './src/**/*.sol'

