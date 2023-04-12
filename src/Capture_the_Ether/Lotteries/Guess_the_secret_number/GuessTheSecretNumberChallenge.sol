// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.19;

contract GuessTheSecretNumberChallenge {
    bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;

    constructor() payable {
        require(msg.value == 1 ether);
    }
    
    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable {
        require(msg.value == 1 ether);

        if (keccak256(abi.encodePacked(n))== answerHash) {
            payable(msg.sender).transfer(2 ether);
        }
    }
}