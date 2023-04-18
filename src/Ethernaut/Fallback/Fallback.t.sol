// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./FallbackFactory.sol";

contract FallbackTest is Test {
    FallbackFactory factory;

    function setUp() public {
        factory = new FallbackFactory();
    }

    function testFallback() public {
        address fallBack = factory.createInstance(address(this));

        Fallback(payable(fallBack)).contribute{value: 1}();

        (bool success, bytes memory data) = payable(fallBack).call{value: 1}("");
        if (!success) {
            revert(string(data));
        }

        address owner = Fallback(payable(fallBack)).owner();

        assertEq(owner, address(this));

        Fallback(payable(fallBack)).withdraw();

        assertTrue(factory.validateInstance(payable(fallBack), address(this)));
    }

    receive() external payable {}
}
