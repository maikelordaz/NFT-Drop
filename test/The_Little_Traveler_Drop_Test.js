const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { Contract } = require("ethers");


//START OF TEST
describe("The_Little_Traveler_Drop", function () {

    let TheLittleTraveler;
    let thelittletraveler_contract;
    let admin_role;
    let whitelist_role;
    let collaborator;
    let address1;
    let address2;
    let address3;
    const whitelistMintFee = 0.005;
    const price = 0.01;
    let cid = ["cid1, cid2, cid3"];
   
//BEFORE EACH TEST THE CONTRACT IS DEPLOYED
    beforeEach(async function () {
    
        TheLittleTraveler = await ethers.getContractFactory("TheLittleTraveler");
        [admin_role, whitelist_role, collaborator, address1, address2, address3] = 
            await ethers.getSigners();
      

});
    it("Should deploy the contract", async function () {
     thelittletraveler_contract = await TheLittleTraveler.deploy(cid);
     await thelittletraveler_contract.deployed();            
    });
    
    it("Should the initial state of the owner", async function () {
        /*The owner of the contract is set as admin and whitelist on the constructor of the 
        contract, this expects verify that this is true, also check  that the same address is 
        not a minter, and that other address is not an admin. If any of the true or false argument
        is changed by the opposite the test must fail.
        */
     expect(await thelittletraveler_contract.isAdmin(admin_role.address)).to.be.equal(true);
     expect(await thelittletraveler_contract.isWhitelist(admin_role.address)).to.be.equal(true);
     expect(await thelittletraveler_contract.isAdmin(whitelist_role.address)).to.be.equal(false);
     expect(await thelittletraveler_contract.isAdmin(collaborator.address)).to.be.equal(false);            
    });

    it("Should pause the contract", async function () {
       /*The function should pause the contract, the initial state of the variable is true, and 
       here we can test the change of the variable paused by activate the setPaused function. By 
       changing any of the true or false arguments by the opposite, the test should fail. Only the 
       admin can call this function, to check if another account can do it there is the last command 
       line, if it is uncomment the test should fail.
        */
     expect(await thelittletraveler_contract.paused()).to.be.equal(true);
     await thelittletraveler_contract.setPaused(false);
     expect(await thelittletraveler_contract.paused()).to.be.equal(false);
     await thelittletraveler_contract.setPaused(true);
     expect(await thelittletraveler_contract.paused()).to.be.equal(true);
     //await thelittletraveler_contract.connect(minter_role.address).setPaused(false);
    });

    it("Should change the state of the hidden image and reveal it", async function () {
       /*The function should change the state of the revealed variable, which is realated to the 
       hidden image before the minting. The initial state of the variable is false, and here we can 
       test the change of the variable by activate the setRevealed function. By changing any of the 
       true or false arguments by the opposite, the test should fail. Only the admin can call this
       function, to check if another account can do it there is the last command line, if it is 
       uncomment the test should fail.
        */
       expect(await thelittletraveler_contract.revealed()).to.be.equal(false);
       await thelittletraveler_contract.setRevealed(true);
       expect(await thelittletraveler_contract.revealed()).to.be.equal(true);
       await thelittletraveler_contract.setRevealed(false);
       expect(await thelittletraveler_contract.revealed()).to.be.equal(false);
       //await thelittletraveler_contract.connect(minter_role.address).setRevealed(true);  
    });

    it("Should check how many tokens are left", async function () {
        /* It check the initial state of the NFT lefts*/
        expect(await thelittletraveler_contract.NFTLeft()).to.be.equal(10);    
    });

    it("Should allow the whitelist to mint", async function () {

     await thelittletraveler_contract.setPaused(false);
     await thelittletraveler_contract.whitelistmint();
     expect(await thelittletraveler_contract.ownerOf(0)).to.equal(admin_role.address);        
      
    });  

    it("Should allow the normal users to mint", async function () {

        await thelittletraveler_contract.setPaused(false);
        await thelittletraveler_contract.setRevealed(true);
        await thelittletraveler_contract.connect(collaborator).grantMinterRole
        ({value: ethers.utils.parseEther("0.01")});
        await thelittletraveler_contract.connect(collaborator).mint();
        expect(await thelittletraveler_contract.ownerOf(1)).to.equal(collaborator.address);   
    });
});

