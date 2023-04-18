// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    constructor() payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        unchecked {
            require(msg.value == numTokens * PRICE_PER_TOKEN);
        }
        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens, "error balance");

        balanceOf[msg.sender] -= numTokens;
        payable(msg.sender).transfer(numTokens * PRICE_PER_TOKEN);
    }
}
