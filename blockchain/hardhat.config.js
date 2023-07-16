require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');
require('@nomiclabs/hardhat-ethers');
require('hardhat-contract-sizer');
require("dotenv").config();


const ACCOUNT = process.env.ACCOUNT
const API_KEY = process.env.API_KEY_ETH;

module.exports = {
  defaultNetwork: "localhost",
  solidity: {
    version: '0.8.4',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
    },
  },
  contractSizer: {
    alphaSort: false,
    runOnCompile: false,
    disambiguatePaths: false,
  },

  networks: {
    hardhat: {
      gas: 'auto',
      allowUnlimitedContractSize: true,
    },
    // testnet
    goerli: {
      url: `https://still-twilight-needle.ethereum-goerli.discover.quiknode.pro/3f299d81b648bddc3b5d17f0ea3cd872b158ab27/`,
      accounts: [ACCOUNT],
      gasPrice: 100000000000,
      timeout: 20000,
    },
    //mainnet
    ethereum: {
      url: `https://mainnet.infura.io/v3/${INFURA}`,
      accounts: [ACCOUNT],
      timeout: 20000,
    },
    localhost: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
    }
  },
  etherscan: {
    apiKey: API_KEY,
  }
};

