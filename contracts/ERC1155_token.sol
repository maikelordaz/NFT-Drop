// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.4;

//CONTRACT IMPORTS
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//CONTRACT

contract IAN is 
            ERC1155,    
            Ownable {

//VARIABLES

    uint public suply = 50;

//FUNCTIONS

    constructor() ERC1155("") {}

    function setURI(string memory newuri) 
        public 
        onlyOwner {

            _setURI(newuri);

    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner {

            require(amount <= suply, "Not enough tokens");
            _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner {

            _mintBatch(to, ids, amounts, data);
            
    }
}