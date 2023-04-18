// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./CallMeChallenge.sol";

contract CallmeChallengeTest is Test {
    CallMeChallenge public callMeChallenge;

    function setUp() public {
        callMeChallenge = new CallMeChallenge();
    }

    function testCallMe() public {
        emit log_named_string("before callme, the isComplete's value", callMeChallenge.isComplete() ? "true" : "false");
        assertFalse(callMeChallenge.isComplete());

        callMeChallenge.callme();

        emit log_named_string("after callme, the isComplete's value", callMeChallenge.isComplete() ? "true" : "false");
        assertTrue(callMeChallenge.isComplete());
    }
}
