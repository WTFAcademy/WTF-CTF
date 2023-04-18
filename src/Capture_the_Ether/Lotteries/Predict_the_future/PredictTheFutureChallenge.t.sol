// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./PredictTheFutureChallenge.sol";
import "./Attacker.sol";

contract PredictTheFutureChallengeTest is Test {
    PredictTheFutureChallenge public predictTheFutureChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        predictTheFutureChallenge = new PredictTheFutureChallenge{value: 1 ether}();
    }

    function testPredictTheFurture() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("predictTheFutureChallenge's balance", address(predictTheFutureChallenge).balance);

        vm.startPrank(hacker);
        Attacker attacker = new Attacker(address(predictTheFutureChallenge));
        attacker.lockInGuess{value: 1 ether}(6);

        /*
        // TODO
        uint blockNum = block.number;
        uint i = 1;

        while(there are reverts) {
            vm.roll(blockNum + i);

            attacker.attack();

            ++i;
        }
        */

        vm.stopPrank();

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint("predictTheFutureChallenge's new balance", address(predictTheFutureChallenge).balance);

        // assertTrue(predictTheFutureChallenge.isComplete());
    }
}
