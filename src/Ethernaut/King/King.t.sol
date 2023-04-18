// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./KingFactory.sol";

contract KingTest is Test {
    KingFactory factory;

    function setUp() public {
        factory = new KingFactory();
    }

    function testKing() public {
        address king = factory.createInstance{value: 0.001 ether}(address(this));

        (bool success, bytes memory data) = king.call{value: 0.0011 ether}("");
        if (!success) {
            revert(string(data));
        }

        assertTrue(factory.validateInstance(payable(address(king)), address(this)));
    }

    receive() external payable {
        revert();
    }
}
