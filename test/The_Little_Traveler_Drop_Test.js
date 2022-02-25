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
    let minter_role;
    let address1;
    let address2;
    let address3;
    const whitelistMintFee = 0.005;
    const price = 0.01;
   
//BEFORE EACH TEST THE CONTRACT IS DEPLOYED
    beforeEach(async function () {
    
        TheLittleTraveler = await ethers.getContractFactory("TheLittleTraveler");
        [admin_role, whitelist_role, minter_role, address1, address2, address3] = 
            await ethers.getSigners();
        thelittletraveler_contract = await TheLittleTraveler.deploy();

});
    
    it("Should launch the constructor", async function () {
        /*The owner of the contract is set as admin and whitelist on the constructor of the 
        contract, this expects verify that this is true, also check  that the same address is 
        not a minter, and that other address is not an admin. If any of the true or false argument
        is changed by the opposite the test must fail.
        */
     expect(await thelittletraveler_contract.isAdmin(admin_role.address)).to.be.equal(true);
     expect(await thelittletraveler_contract.isWhitelist(admin_role.address)).to.be.equal(true);
     expect(await thelittletraveler_contract.isAdmin(whitelist_role.address)).to.be.equal(false);
     expect(await thelittletraveler_contract.isAdmin(minter_role.address)).to.be.equal(false);            
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
        
    xit("Should add an address to the whitelist by paying 0.005 ethers", async function () {

     
        
   
    });

    xit("Should give an address the minter role by paying 0.01 ethers", async function () {
   
        //await thelittletraveler_contract.grantWhiteListRole(address1);

        //expect(thelittletraveler_contract.connect(address1).
           

    });

    xit("Should allow the whitelist to mint", async function () {

     await thelittletraveler_contract.setPaused(false);
     (await thelittletraveler_contract.ownerTokenCount).to.be.equal(0);
     //expect(await thelittletraveler_contract._safeMint(admin_role, 1));
     expect(await thelittletraveler_contract.mintedByWhiteList).to.be.equal(1);
     expect(await thelittletraveler_contract.NFTLeft()).to.be.equal(9);
     expect(await thelittletraveler_contract.ownerTokenCount).to.be.equal(1);
   
    });

    xit("Should allow the normal users to mint", async function () {
   
    });

    it("Should check how many tokens are left", async function () {
     /* It check the initial state of the NFT lefts*/
     expect(await thelittletraveler_contract.NFTLeft()).to.be.equal(10);    
    });

    xit("Token URI generation", async function () {
        const uriPrefix = "ipfs://__COLLECTION_CID__/";
        const uriSuffix = ".json";
        const hiddenMetadataUri = "ipfs://_hidden_";
        const tokenId = 1;
    
        await thelittletraveler_contract.setRevealed(true);
        expect(await thelittletraveler_contract.tokenURI(1)).
        to.equal(hiddenMetadataUri);
    
        // Reveal collection
        await thelittletraveler_contract.setUriPrefix(uriPrefix);
        
    
        expect(await thelittletraveler_contract.tokenURI(1)).
        to.equal(`${uriPrefix}1${uriSuffix}`);
      });


});

