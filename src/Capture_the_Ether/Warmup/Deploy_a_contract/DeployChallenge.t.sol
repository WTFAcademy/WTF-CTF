// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./DeployChallenge.sol";

contract DeployChallengeTest is Test {
    DeployChallenge public deployChallenge;

    function setUp() public {
        deployChallenge = new DeployChallenge();
    }

    function testIsComplete() public {
        assertTrue(deployChallenge.isComplete());
    }
}
