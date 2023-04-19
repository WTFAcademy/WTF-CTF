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

        uint256 privateKey = uint256(0x32e890da68f49d9be6d3642b2a1163fd8233cf995e9766a459d4cb5545913faa);
        vm.startBroadcast(privateKey);
        accountTakeoverChallenge.authenticate();
        vm.stopBroadcast();

        emit log_named_string("after hack, isComplete", accountTakeoverChallenge.isComplete() ? "true" : "false");

        // assertTrue(AccountTakeoverChallenge.isComplete());
    }
}
