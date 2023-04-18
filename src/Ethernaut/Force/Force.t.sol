// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./ForceFactory.sol";

contract ForceTest is Test {
    ForceFactory factory;

    function setUp() public {
        factory = new ForceFactory();
    }

    function testForce() public {
        address force = factory.createInstance(address(this));

        vm.deal(address(this), 1);
        selfdestruct(payable(force));

        assertTrue(factory.validateInstance(payable(address(force)), address(this)));
    }
}
