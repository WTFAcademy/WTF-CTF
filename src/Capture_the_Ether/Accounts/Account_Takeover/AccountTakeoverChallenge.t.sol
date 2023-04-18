// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./AccountTakeoverChallenge.sol";

contract AccountTakeoverChallengeTest is Test {
    AccountTakeoverChallenge public accountTakeoverChallenge;

    function setUp() public {
        accountTakeoverChallenge = new AccountTakeoverChallenge();
    }

    function testPublicKey() public {
        emit log_named_string("before hack, isComplete", accountTakeoverChallenge.isComplete() ? "true" : "false");

        function startBroadcast(uint256 privateKey) external;
        // Stops collecting onchain transactions
        function stopBroadcast() external;


        emit log_named_string("after hack, isComplete", AccountTakeoverChallenge.isComplete() ? "true" : "false");

        assertTrue(AccountTakeoverChallenge.isComplete());
    }
}
