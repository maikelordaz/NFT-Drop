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
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//LIBRARIES IMPORTS

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//CONTRACT 

contract TheLittleTraveler is ERC721, ERC721URIStorage, AccessControl {
    
    using Strings for uint256;
    using Counters for Counters.Counter;

//VARIABLES

    Counters.Counter private _nftId;
    uint public maxSuply = 10;
    bool public paused = true;
    string [] internal _URIs;
    address public collaborator;
    
    //ROLES
        bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
        
    //FEES
        uint public mintFee = 0.01 ether;

    //MINT
        uint minted = 0;
        uint maxMint = 10;

//MAPPINGS
    mapping (address => uint) ownerTokenCount;

//FUNCTIONS

    constructor() ERC721("The Little Traveler", "TLT") {

        _setupRole(ADMIN_ROLE, msg.sender);
        _URIs = ["QmXgRgBGBrbWgrt4NtNHYa8D7y6EWmgPe9jqv1si8aHUB6",
                 "QmRny92uQhNxwUMaWXqvLQkzy4BXJVDcRVGZSH6nf9BgMz",
                 "QmbvuE9aa1cM1CiKwWCtvpGbUz3kvU5xtEszvVVZFqUSWv",
                 "QmUxhY9S5JeM8dWv3htzaTNq11XJJqTVPp1Mowhc8ArUP9",
                 "QmSBmBXhbvAmGZpCsq8CyMLBLS6tzg9Ph9VJhNGDnZVPXj",
                 "QmRuoq5zvwcHAw2tLvGMTfWujhaNQDgZxqY1Amkakpvxdx",
                 "QmPhxoJi14YaVmMaHHtUyBGX5zFEYiKUMcAXJiGAS9PT8K",
                 "QmaHZxnhWzfMvNL7nbeHt2gpc4VaoNVPAeRAaeibiFscSK",
                 "QmW9ytaZHKjfSgPMhs2CHXFMsTQu7W7pu2XYBTgodyq2eX",
                 "QmfS4eo2atBz6Xyz8Rs61X54g1izADSWys2GV5X82akYTZ"];

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
    * @dev this function is to check how many tokens are left
    */
    function NFTLeft() 
        public 
        view 
        returns (uint256) {

            uint256 tokenLeft = maxSuply-minted;
            return tokenLeft;
    }
    /**
    * @dev this function is for the minting the tokens. 
    */
    function mint() 
        public  
        payable {

            require
                (msg.value == mintFee,
                "You have to pay 0.01 ethers");
            require
                (!paused, "The contract is paused!");
            require
                (minted < maxMint,
                "There are no more tokens to mint");
            uint256 tokenId = _nftId.current();
            _nftId.increment();
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, _URIs[tokenId]);
            minted++;
    }
    /**
    * @dev This are four functions related to set the URI of the Token.
    */    
    function tokenURI(uint256 tokenId)
        public
        view
        override (ERC721, ERC721URIStorage)
        returns (string memory) {

           return super.tokenURI(tokenId);
    }

    function _baseURI() 
        internal 
        view 
        virtual 
        override 
        returns (string memory) {

            return "ipfs://";
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
    * @dev the next function are used only for the test of the contract
    */
    function isAdmin(address account) public virtual view returns(bool) {
        return hasRole(ADMIN_ROLE, account);
    }
    /**
    * @dev last but not least a function to overcome the override of inheritaded contracts
    */    
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl)
    returns (bool) {
        return super.supportsInterface(interfaceId);
    } 
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }   
}
