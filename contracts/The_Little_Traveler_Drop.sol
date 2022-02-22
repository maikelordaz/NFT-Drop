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

    Counters.Counter private _nftId;

    //ROLES
        bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
        bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
        bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");
    
    //FEES
        uint whitelistMintFee = 0.005 ether;
        uint mintFee = 0.01 ether;

    //WHITELIST MINT
        uint mintedByWhiteList = 0;
        uint maxWhiteListMint = 4;

    //NORMAL MINT
        uint minted = 3;
        uint maxMint = 11;

//MAPPINGS

    mapping (address => uint) ownerTokenCount;


//EVENTS

    event mintPaused(string);
    event mintUnPaused(string);
    event normalMint (string);
    event mintFinished (string);

//CONSTRUCTOR

    constructor() ERC721("theLittleTraveler", "TLT") {

        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(WHITELIST_ROLE, msg.sender);

    }

//FUNCTIONS
    
    /** 
    * @dev this functions are related to pause or unpause the drop and minting process.
      Only the admin can call this functions.
      The admin has to unpause the minting process to start.
    */

    function pause() 
        public 
        onlyRole(ADMIN_ROLE) {
            
            _pause();
            emit mintPaused("The mint is paused.");

    }

    function unpause() 
        public 
        onlyRole(ADMIN_ROLE) {
            
            _unpause();
            emit mintUnPaused("The whitelist has started.");

    }

    /// @dev this functions allow the addresses from the whitelist to mint.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable) {

        super._beforeTokenTransfer(from, to, tokenId);

    }
    
    function grantWhiteListRole(address whiteListAddress)
        public
        whenNotPaused
        onlyRole(ADMIN_ROLE) {

            _grantRole(WHITELIST_ROLE, whiteListAddress);

    }

    function whitelistmint(address to) 
        public 
        whenNotPaused
        onlyRole(WHITELIST_ROLE)
        payable {

            require
                (msg.value == whitelistMintFee,
                "You have to pay 0.005 ethers");
            require
                (mintedByWhiteList < maxWhiteListMint,
                "There are no more tokens to mint");
            require
                (ownerTokenCount[to] == 0,
                "You can not mint any more");
            uint256 tokenId = _nftId.current();
            _nftId.increment();
            _safeMint(to, tokenId);
            mintedByWhiteList++;
            ownerTokenCount[to]++;

    }

    /**
    * @dev this functions are related to he minting process.
      Only the minters can call this functions.
      The contract has to be unpaused. 
    */
  
    function grantMinterRole(address whiteListAddress)
        public
        whenNotPaused
        onlyRole(ADMIN_ROLE) {

            _grantRole(MINTER_ROLE, whiteListAddress);

    }

    function mint(address to) 
        public 
        whenNotPaused
        onlyRole(MINTER_ROLE) 
        payable {

            require
                (msg.value == mintFee,
                "You have to pay 0.01 ethers");
            require
                (minted < maxMint,
                "There are no more tokens to mint");
            require
                (ownerTokenCount[to] == 0,
                "You can not mint any more");
            uint256 tokenId = _nftId.current();
            _nftId.increment();
            _safeMint(to, tokenId);
            minted++;
            ownerTokenCount[to]++;

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
        returns (bool) {

        return super.supportsInterface(interfaceId);
    }
    
}
