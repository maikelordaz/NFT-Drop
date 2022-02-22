// SPDX-License-Identifier: unlicensed
/**
* @title TheTraveler NFT drop
* @author Maikel Ordaz
* @notice This is a NFT drop, under the ERC721 standard
*/

pragma solidity ^0.8.4;

//CONTRACTS IMPORTS 

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

//LIBRARIES IMPORTS

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

//CONTRACT 

contract TheLittleTraveler is 
                            ERC721Enumerable, 
                            Pausable, 
                            AccessControl,
                            ERC721URIStorage {
    
    using Counters for Counters.Counter;

//VARIABLES

    bytes32 public constant minter = keccak256("minter");
    bytes32 public constant whitelisted = keccak256("whitelisted");
    Counters.Counter private _nftId;
    uint whitelistMintFee = 0.005 ether;
    uint mintFee = 0.01 ether;
    enum Status {whitelist, minters}
    Status public mintingStatus;
   
//MODIFIERS

    modifier actualStatus(Status _mintingStatus) {
        
        require(mintingStatus == _mintingStatus);
        _;

    }

//EVENTS

    event mintPaused(string);
    event mintUnPaused(string);
    event normalMint (string);
    event mintFinished (string);

//CONSTRUCTOR

    constructor() ERC721("theLittleTraveler", "TLT") {

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(minter, msg.sender);

    }

//FUNCTIONS
    
    /** 
    * @dev this functions are related to pause or unpause the drop and minting process.
      Only the admin can call this functions.
      The admin has to unpause the minting process to start.
    */

    function pause() 
        public 
        onlyRole(DEFAULT_ADMIN_ROLE) {
            
            _pause();
            emit mintPaused("The mint is paused.");
            console.log("The mint is still paused");

    }

    function unpause() 
        public 
        onlyRole(DEFAULT_ADMIN_ROLE) {
            
            _unpause();
            mintingStatus = Status.whitelist;
            emit mintUnPaused("The whitelist has started.");            
            console.log("If you are from the whitelist, you can mint now!");

    }

    /// @dev this functions allow the addresses from the whitelist to mint.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable) {

        super._beforeTokenTransfer(from, to, tokenId);

    }
    
    function whitelistmint(address to) 
        public 
        whenNotPaused
        onlyRole(whitelisted)
        actualStatus(Status.whitelist)
        payable {

        require(msg.value == whitelistMintFee);
        uint256 tokenId = _nftId.current();
        for(uint i = 0; i < 4; i++) {

            _nftId.increment();
            _safeMint(to, tokenId);

        }

        mintingStatus = Status.minters;
        emit normalMint("The mint is paused.");            
        console.log("The whitelist has finished, from now on, everyone can mint!");

    }

    /**
    * @dev this functions are related to he minting process.
      Only the minters can call this functions.
      The contract has to be unpaused. 
    */
  
    function mint(address to) 
        public 
        whenNotPaused
        onlyRole(minter)
        payable {

        require(msg.value == mintFee);
        uint256 tokenId = _nftId.current();
        for(uint j = 4; j < 10; j++) {

            _nftId.increment();
            _safeMint(to, tokenId);

        }

        emit mintFinished("The mint has finished.");            
        console.log("Every token has been minted");

    }

    /// @dev This function is to set the URI of the Token.

    function tokenURI(uint256 tokenId)
        public
        view
        override (ERC721, ERC721URIStorage)
        returns (string memory) {

            return super.tokenURI(tokenId);

    }

    /// @dev This function is to burn the NFT delete the Token´s Id and the Token´s URI.

    function _burn(uint256 tokenId) 
        internal 
        override(ERC721, ERC721URIStorage) {
        
            super._burn(tokenId);

    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    
}
