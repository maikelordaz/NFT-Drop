const { expect } = require("chai");
const { ethers, web3 } = require("hardhat");
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { Contract } = require("ethers");
const { utils } = require("web3");


//START OF TEST
describe("The_Little_Traveler_Drop", function () {

    let TheLittleTraveler;
    let thelittletraveler_contract;
    let admin_role;    
    let Alice;
    let Bob;
   
//BEFORE EACH TEST THE CONTRACT IS DEPLOYED
    beforeEach(async function () {
    
        TheLittleTraveler = await ethers.getContractFactory("TheLittleTraveler");
        [admin_role, Alice, Bob] = await ethers.getSigners();
      

});
    it("Should deploy the contract", async function () {
     thelittletraveler_contract = await TheLittleTraveler.deploy();
     await thelittletraveler_contract.deployed();            
    });
    
    it("Should check the initial state of the contract", async function () {
       
     expect(await thelittletraveler_contract.isAdmin(admin_role.address)).
        to.be.equal(true);
     expect(await thelittletraveler_contract.isAdmin(Alice.address)).
        to.be.equal(false);            
    });

    it("Should pause the contract", async function () {

     expect(await thelittletraveler_contract.paused()).to.be.equal(true);
     await thelittletraveler_contract.setPaused(false);
     expect(await thelittletraveler_contract.paused()).to.be.equal(false);
     await thelittletraveler_contract.setPaused(true);
     expect(await thelittletraveler_contract.paused()).to.be.equal(true);
    });   

    it("Should check how many tokens are left", async function () {

        expect(await thelittletraveler_contract.NFTLeft()).to.be.equal(10);    
    }); 

    it("Should failed to mint if the user does not pay", async function () {

        await thelittletraveler_contract.setPaused(false);
        await expect(thelittletraveler_contract.connect(Bob).
            mint({value: ethers.utils.parseEther("0.001")})).to.be.
            revertedWith("You have to pay 0.01 ethers");          
    });

    it("Should failed to mint if the contract is paused", async function () {

        await thelittletraveler_contract.setPaused(true);
        await expect(thelittletraveler_contract.connect(Bob).
            mint({value: ethers.utils.parseEther("0.01")})).to.be.
            revertedWith("The contract is paused!");          
    });

    it("Should to mint", async function () {

        await thelittletraveler_contract.setPaused(false);
        await thelittletraveler_contract.connect(Alice).
            mint({value: ethers.utils.parseEther("0.01")});
        expect(await thelittletraveler_contract.NFTLeft()).to.be.equal(9);   
    });

    it("Should fail to mint if there are no more tokens", async function () {

        await thelittletraveler_contract.setPaused(false);
        for (let i=0; i <9; i++) {
        await thelittletraveler_contract.connect(Alice).
            mint({value: ethers.utils.parseEther("0.01")});
        }  
        expect(await thelittletraveler_contract.NFTLeft()).to.be.equal(0);  
        await expect(thelittletraveler_contract.connect(Bob).
            mint({value: ethers.utils.parseEther("0.01")})).to.be.
            revertedWith("There are no more tokens to mint"); 
    });

    it("Should allow the admin to withdraw", async function () {

        await thelittletraveler_contract.withdraw();
      
    });


});

