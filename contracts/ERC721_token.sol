// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.4;

//CONTRACT IMPORTS

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//LIBRARIES IMPORTS

import "@openzeppelin/contracts/utils/Counters.sol";

//CONTRACT

contract TheOne is 
                ERC721, 
                ERC721URIStorage, 
                Ownable {

//VARIABLES

    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    uint public suply = 5;

//MAPINGS

    mapping (address => uint) ownerTokenCount;

//FUNCTIONS

    constructor() ERC721("TheOne", "ONE") {}

    function safeMint(address to, string memory uri) 
        public 
        onlyOwner {
        
            uint256 tokenId = _tokenId.current();
            require(tokenId <= suply, "There are no more tokens");
            require(ownerTokenCount[to] == 0, "You can not mint any more");
            _tokenId.increment();
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, uri);
            ownerTokenCount[to]++;

    }


    function _burn(uint256 tokenId) 
        internal 
        override(ERC721, ERC721URIStorage) {

            super._burn(tokenId);

    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory) {

            return super.tokenURI(tokenId);
            
    }
}