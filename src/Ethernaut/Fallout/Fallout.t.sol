// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
// https://github.com/foundry-rs/foundry/issues/4376
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "./FalloutFactory.sol";

contract FalloutTest is Test {
    FalloutFactory factory;

    function setUp() public {
        factory = new FalloutFactory();
    }

    function testFallout() public {
        address fallout = factory.createInstance(address(this));

        Fallout(fallout).Fal1out();
        assertEq(Fallout(fallout).owner(), address(this));

        assertTrue(factory.validateInstance(payable(address(fallout)), address(this)));
    }
}
