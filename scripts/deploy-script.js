
const hre = require("hardhat");

async function main() {
  
  // await hre.run('compile');

  
  const TheLittleTraveler = await hre.ethers.getContractFactory("TheLittleTraveler");
  const thelittletraveler_contract = await TheLittleTraveler.deploy("The little traveler NFT!");

  await thelittletraveler_contract.deployed();

  console.log("TheLittleTraveler deployed to:", thelittletraveler_contract.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
