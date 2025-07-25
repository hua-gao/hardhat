require("@nomicfoundation/hardhat-toolbox");
require('hardhat-deploy');
require('@openzeppelin/hardhat-upgrades');
require("dotenv").config();

const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const PRIVATE_KEY_1 = process.env.PRIVATE_KEY_1;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: SEPOLIA_RPC_URL,
      accounts: [PRIVATE_KEY, PRIVATE_KEY_1],
      chainId: 11155111
    }
  },
  namedAccounts: {
    deployer: 0,
    user1: 0,
    user2: 0
  },
  etherscan: {
    apiKey: {
      sepolia: ETHERSCAN_API_KEY
    }
  },
  sourcify: {
    enabled: true
  },
  paths: {
    sources: "./contracts",
    ignore: ["**/CrossChain/**"],
  },
};
