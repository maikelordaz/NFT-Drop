// SPDX-License-Identifier: MIT
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
    uint mintFee = 0.01 ether;
   

//MAPPINGS


//EVENTS


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

    }

    function unpause() 
        public 
        onlyRole(DEFAULT_ADMIN_ROLE) {
            
            _unpause();

    }

    /**
    * @dev this functions are related to he minting process.
      Only the minters can call this functions.
      The contract has to be unpaused. 
     */

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable) {

        super._beforeTokenTransfer(from, to, tokenId);

    }

    function mint(address to) 
        public 
        whenNotPaused
        onlyRole(minter)
        payable {

        require(msg.value == mintFee);
        uint256 tokenId = _nftId.current();
        for(uint i = 0; i < 10; i++) {

            _nftId.increment();
            _safeMint(to, tokenId);

        }

    }

    function tokenURI(uint256 tokenId)
        public
        view
        override (ERC721, ERC721URIStorage)
        returns (string memory)
    {
            return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId) 
        internal 
        override(ERC721, ERC721URIStorage) {
        
            super._burn(tokenId);

    }

   
}