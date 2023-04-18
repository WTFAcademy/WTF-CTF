// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./GuessTheSecretNumberChallenge.sol";

contract GuessTheSecretNumberChallengeTest is Test {
    GuessTheSecretNumberChallenge public guessTheSecretNumberChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheSecretNumberChallenge = new GuessTheSecretNumberChallenge{value: 1 ether}();
    }

    function testGuessTheSecretNumber() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("guessTheSecretNumberChallenge's balance", address(guessTheSecretNumberChallenge).balance);

        vm.startPrank(hacker);
        guessTheSecretNumberChallenge.guess{value: 1 ether}(170);
        vm.stopPrank();

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint(
            "guessTheSecretNumberChallenge's new balance", address(guessTheSecretNumberChallenge).balance
        );

        assertTrue(guessTheSecretNumberChallenge.isComplete());
    }
}
