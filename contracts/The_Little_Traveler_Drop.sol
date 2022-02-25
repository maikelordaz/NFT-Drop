// SPDX-License-Identifier: unlicensed
/**
* @title TheTraveler NFT drop
* @author Maikel Ordaz
* @notice This is a NFT drop, under the ERC721 standard
*/

pragma solidity ^0.8.4;

//CONTRACTS IMPORTS 

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

//LIBRARIES IMPORTS

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//CONTRACT 

contract TheLittleTraveler is ERC721URIStorage, AccessControl {
    
    using Strings for uint256;
    using Counters for Counters.Counter;

//VARIABLES

    Counters.Counter private _nftId;
    enum Status {whiteListFinished}
    Status public status;
    uint public maxSuply = 10;
    bool public paused = true;
    bool public revealed = false;
    string public uriPrefix = "";
    string public uriSuffix = ".json";
    string public hiddenMetadataUri;

    //ROLES
        bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
        bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
        bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");
        
    //FEES
        uint public whitelistMintFee = 0.005 ether;
        uint public mintFee = 0.01 ether;

    //WHITELIST MINT
        uint mintedByWhiteList = 0;
        uint maxWhiteListMint = 2;

    //NORMAL MINT
        uint minted = 2;
        uint maxMint = 10;

//MAPPINGS
    mapping (address => uint) ownerTokenCount;
    mapping (address => uint) whiteListUser; //To check if the user is from the whitelist.

//EVENTS
    event mintPaused(string);
    event mintUnPaused(string);
    event whiteListOver (string);
    event mintFinished (string);

//MODIFIERS

    modifier actualStatus(Status _status) {

        require(status == _status);
        _;

    }

//FUNCTIONS

    constructor() ERC721("The Little Traveler", "TLT") {

        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(WHITELIST_ROLE, msg.sender);
    }  
    /** 
    * @dev this function is related to pause or unpause the drop.
      Only the admin can call this function.
    * @param _state it gives true or false to the variable paused.
    */ 
    function setPaused(bool _state) 
        public 
        onlyRole(ADMIN_ROLE) {
            
        paused = _state;
    }
    /** 
    * @dev this function is related to the hidden image before the NFT is revealed.
      Only the admin can call this function.
    * @param _state it gives true or false to the variable revealed.
    */
    function setRevealed(bool _state) 
        public 
        onlyRole(ADMIN_ROLE) {

            revealed = _state;
    } 
    /**
    * @dev this function is to grant access to the whitelist to an address.
    * @param whiteListAddress if the address is part of the whiteListUser mapping it has to pay
      0.005 ethers to gain the whitelist role.
    */
    function grantWhiteListRole(address whiteListAddress)
        public 
        payable {

            uint whiteListReserved = whiteListUser[msg.sender];
            require(whiteListUser[whiteListAddress] == whiteListReserved);
            require
                (msg.value == whitelistMintFee,
                "You have to pay 0.005 ethers");        
            _grantRole(WHITELIST_ROLE, whiteListAddress);
    }
    /**
    * @dev this function is to grant the minter role to an address.
    * @param minterAddress The address has to pay 0.01 ethers to gain the minter role.
    */
    function grantMinterRole(address minterAddress)
        public
        onlyRole(ADMIN_ROLE) 
        payable {

            require
                (msg.value == mintFee,
                "You have to pay 0.01 ethers");
            _grantRole(MINTER_ROLE, minterAddress);
    }
    /**
    * @dev this function is for the minting by the whitelist. It makes some checks, first paused
      has to be false, second there has to be token left for the whitelist and third the address
      can not have any token. Only the WHITELIST_ROLE can call it.
    * @param to is an address with the WHITELIST_ROLE
    */
    function whitelistmint(address to) 
        public 
        onlyRole(WHITELIST_ROLE) {

            require
                (!paused, "The contract is paused!");
            require
                (mintedByWhiteList <= maxWhiteListMint,
                "There are no more tokens to mint");
            require
                (ownerTokenCount[to] == 0,
                "You can not mint any more");
            uint256 tokenId = _nftId.current();
            _nftId.increment();
            _safeMint(to, tokenId);            
            mintedByWhiteList++;
            maxSuply--;
            ownerTokenCount[to]++;            
            if (mintedByWhiteList == maxWhiteListMint) {

                status = Status.whiteListFinished;
                emit whiteListOver("The mint for the whitelists is over");
            }
    }
    /**
    * @dev this function is for the minting by the regular users. It makes some checks, first paused
      has to be false, second there has to be token left for the whitelist and third the address
      can not have any token.
    * @param to is an address with the WHITELIST_ROLE
    */
    function mint(address to) 
        public 
        onlyRole(MINTER_ROLE) 
        actualStatus(Status.whiteListFinished) {

            require
                (!paused, "The contract is paused!");
            require
                (minted <= maxMint,
                "There are no more tokens to mint");
            require
                (ownerTokenCount[to] == 0,
                "You can not mint any more");
            uint256 tokenId = _nftId.current();
            _nftId.increment();
            _safeMint(to, tokenId);
            minted++;
            maxSuply--;
            ownerTokenCount[to]++;
            if (minted == maxMint) {

                emit mintFinished("the mint process has finished.");
            }
    }
    /** 
    * @dev this function is to check how many tokens are left
    */
    function NFTLeft() 
        public 
        view 
        returns (uint256) {

            return maxSuply;
    }
    /**
    * @dev This are four functions related to set the URI of the Token as for the hidden image.
    */    
    function setTokenURI(uint tokenId, string memory _tokenURI)
        public {

            tokenId = _nftId.current();
            require
                (_isApprovedOrOwner(_msgSender(), tokenId),
                "ERC721: transfer caller is not the owner nor approved");
            _setTokenURI(tokenId, _tokenURI);
            

    }
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory) {

            tokenId = _nftId.current(); 
            require
                (_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
            if (revealed == false) {
                
                return hiddenMetadataUri;
            }
            string memory currentBaseURI = _baseURI();
            return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), uriSuffix))
            : "";
    }

    function setHiddenMetadataUri(string memory _hiddenMetadataUri) 
        public 
        onlyRole(ADMIN_ROLE) {

            hiddenMetadataUri = _hiddenMetadataUri;
    }

    function setUriPrefix(string memory _uriPrefix) 
        public 
        onlyRole(ADMIN_ROLE) {

            uriPrefix = _uriPrefix;
    }

    function setUriSuffix(string memory _uriSuffix) 
        public 
        onlyRole(ADMIN_ROLE) {

            uriSuffix = _uriSuffix;
    }

    function _baseURI() 
        internal 
        view 
        virtual 
        override 
        returns (string memory) {

            return uriPrefix;
    }

    /**
    *@dev a function to withdraw the payments for the mint.
    */
    function withdraw() 
        public 
        payable 
        onlyRole(ADMIN_ROLE) {
        
            payable(msg.sender).transfer(address(this).balance);        
    }

    /**
    * @dev the next three functions are used only for the test of the contract
    */
    function isAdmin(address account) public virtual view returns(bool) {
        return hasRole(ADMIN_ROLE, account);
    }
    function isWhitelist(address account) public virtual view returns(bool) {
        return hasRole(WHITELIST_ROLE, account);
    }
    function isMinter(address account) public virtual view returns(bool) {            
        return hasRole(MINTER_ROLE, account);
    }
    /**
    * @dev last but not least a function to overcome the override of inheritaded contracts
    */    
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl)
    returns (bool) {
        return super.supportsInterface(interfaceId);
    }    
}
