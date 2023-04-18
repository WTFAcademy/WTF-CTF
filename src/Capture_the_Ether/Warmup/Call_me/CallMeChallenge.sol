// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CallMeChallenge {
    bool public isComplete = false;

    function callme() public {
        isComplete = true;
    }
}
