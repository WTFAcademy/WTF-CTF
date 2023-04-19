// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AccountTakeoverChallenge {
    address owner = 0xE6984F0F9dC2930bbe0c824d6D67712A6A411062;
    bool public isComplete;

    function authenticate() public {
        require(msg.sender == owner);

        isComplete = true;
    }
}
