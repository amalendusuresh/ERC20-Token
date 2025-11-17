require("@nomicfoundation/hardhat-toolbox");
require("hardhat-ignition"); // ✅ Load the plugin

module.exports = {
  solidity: "0.8.20",
  networks: {
    hardhat: {}, // Local development
    // Add testnet/mainnet if needed
  },
  namedAccounts: {
    deployer: 0, // First account from Hardhat signers
  },
};
