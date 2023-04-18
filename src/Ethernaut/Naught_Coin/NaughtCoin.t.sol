// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./NaughtCoinFactory.sol";

contract NaughtCoinTest is Test {
    NaughtCoinFactory factory;

    function setUp() public {
        factory = new NaughtCoinFactory();
    }

    function testNaughtCoin() public {
        address naughtCoin = factory.createInstance(address(this));
        address anyone = vm.addr(uint256(keccak256("anyone")));

        NaughtCoin(naughtCoin).approve(anyone, type(uint256).max);

        vm.startPrank(anyone, anyone);

        {
            NaughtCoin(naughtCoin).transferFrom(address(this), anyone, NaughtCoin(naughtCoin).balanceOf(address(this)));
        }

        vm.stopPrank();

        assertTrue(factory.validateInstance(payable(address(naughtCoin)), address(this)));
    }
}
