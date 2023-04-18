// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./GuessTheNewNumberChallenge.sol";
import "./Attacker.sol";

contract GuessTheNewNumberChallengeTest is Test {
    GuessTheNewNumberChallenge public guessTheNewNumberChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheNewNumberChallenge = new GuessTheNewNumberChallenge{value: 1 ether}();
    }

    function testGuessTheNewNumber() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("guessTheNewNumberChallenge's balance", address(guessTheNewNumberChallenge).balance);

        vm.startPrank(hacker);
        Attacker attacker = new Attacker();
        attacker.attack{value: 1 ether}(address(guessTheNewNumberChallenge));
        vm.stopPrank();

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint("guessTheNewNumberChallenge's new balance", address(guessTheNewNumberChallenge).balance);

        assertTrue(guessTheNewNumberChallenge.isComplete());
    }
}
