// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
//req: Implement all functions and events outlined in the ERC-721 token standard
import './interfaces.sol';

import './counter.sol';

import './erc721.sol';

contract MyNFT is ERC721 {
    
    Counter private _tokenIdCounter;
    //allow mint only 100 tokens
    uint256 maxSupply = 100;

    mapping(address => bool) public allowList;
    constructor(address[] memory allowedaddresses) payable{
        for(uint256 i = 0; i < allowedaddresses.length; i++){
            allowList[allowedaddresses[i]] = true;
        }
    } 
    //i read payable means it acepts only native currency
    function mint(uint id) public payable {
       
        uint256 tokenId = _tokenIdCounter.get();
        //req: There should be a maximum of 100 mintable tokens. After 100, the contract should not allow any more minting.
        require(tokenId < maxSupply, "We Sold Out!");
        if(allowList[msg.sender]==false)
            //req : Only mint if the user pays a set price in native currency (ETH or MATIC)
            require(msg.value == 0.01 ether, "Not enough Funds!");
        _tokenIdCounter.inc();
        _mint(msg.sender, id);
        //req: Each whitelisted address should only be able to mint a free token ONCE. After that, they have to pay for additional mints.
        allowList[msg.sender]=false;
    }

    

}
