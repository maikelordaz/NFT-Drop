const hre = require("hardhat");

async function main() {
  
  await hre.run('compile');
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  
  const TheLittleTraveler = await hre.ethers.getContractFactory("TheLittleTraveler");
  const thelittletraveler_contract = await TheLittleTraveler.deploy();
  await thelittletraveler_contract.deployed();
  console.log("TheLittleTraveler deployed to:", thelittletraveler_contract.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
