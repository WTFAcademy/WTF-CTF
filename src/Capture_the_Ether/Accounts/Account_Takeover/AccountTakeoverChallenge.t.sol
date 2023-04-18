// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./AccountTakeoverChallenge.sol";

contract AccountTakeoverChallengeTest is Test {
    AccountTakeoverChallenge public accountTakeoverChallenge;

    function setUp() public {
        accountTakeoverChallenge = new AccountTakeoverChallenge();
    }

    function testAccountTakeover() public {
        emit log_named_string("before hack, isComplete", accountTakeoverChallenge.isComplete() ? "true" : "false");

        uint256 privateKey = 1;
        vm.startBroadcast(privateKey);
        // Stops collecting onchain transactions

        vm.stopBroadcast();

        emit log_named_string("after hack, isComplete", accountTakeoverChallenge.isComplete() ? "true" : "false");

        // assertTrue(AccountTakeoverChallenge.isComplete());
    }
}
