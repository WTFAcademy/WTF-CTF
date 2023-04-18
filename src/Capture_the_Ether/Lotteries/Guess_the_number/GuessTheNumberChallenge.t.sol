// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./GuessTheNumberChallenge.sol";

contract GuessTheNumberChallengeTest is Test {
    GuessTheNumberChallenge public guessTheNumberChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheNumberChallenge = new GuessTheNumberChallenge{value: 1 ether}();
    }

    function testGuessTheNumber() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("guessTheNumberChallenge's balance", address(guessTheNumberChallenge).balance);

        vm.startPrank(hacker);
        guessTheNumberChallenge.guess{value: 1 ether}(42);
        vm.stopPrank();

        emit log_named_uint("my new balance", hacker.balance);
        emit log_named_uint("guessTheNumberChallenge's new balance", address(guessTheNumberChallenge).balance);

        assertTrue(guessTheNumberChallenge.isComplete());
    }
}
