
const hre = require("hardhat");

async function main() {
  
  // await hre.run('compile');

  
  const TheTraveler = await hre.ethers.getContractFactory("TheTraveler");
  const thetraveler_contract = await TheTraveler.deploy("The traveler NFT!");

  await thetraveler_contract.deployed();

  console.log("TheTraveler deployed to:", thetraveler_contract.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
