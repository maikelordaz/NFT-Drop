const hre = require("hardhat");

async function main() {

  await hre.run('compile');

  
  const NFT_drop = await hre.ethers.getContractFactory("NFT_drop");
  const nftDropContract = await NFT_drop.deploy("The traveler, NFT Drop");

  await nftDropContract.deployed();

  console.log("NFT_drop deployed to:", nftDropContract.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });