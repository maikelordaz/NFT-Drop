require("dotenv").config();

require("@nomiclabs/hardhat-waffle");
require("@openzeppelin/test-helpers/configure");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("@nomiclabs/hardhat-etherscan");
require('hardhat-deploy');

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {

    rinkeby: {
      url: process.env.NETWORK_RINKEBY_URL || '',
      accounts: process.env.NETWORK_RINKEBY_PRIVATE_KEY !== undefined 
      ? [process.env.NETWORK_RINKEBY_PRIVATE_KEY] : [],
    },  
},
etherscan: {
  apiKey: {
    rinkeby: process.env.ETHERSCAN_API_KEY
  }
}
}


