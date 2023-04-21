// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./AssumeOwnershipChallenge.sol";

contract AssumeOwnershipChallengeTest is Test {
    AssumeOwnershipChallenge public assumeOwnershipChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        assumeOwnershipChallenge = new AssumeOwnershipChallenge();
    }

    function testAssumeOwnership() public {
        emit log_named_string("before hack, isComplete", assumeOwnershipChallenge.isComplete() ? "true" : "false");

        vm.startPrank(hacker);
        assumeOwnershipChallenge.AssumeOwmershipChallenge();
        assumeOwnershipChallenge.authenticate();
        vm.stopPrank();

        emit log_named_string("after hack, isComplete", assumeOwnershipChallenge.isComplete() ? "true" : "false");

        assertTrue(assumeOwnershipChallenge.isComplete());
    }
}
