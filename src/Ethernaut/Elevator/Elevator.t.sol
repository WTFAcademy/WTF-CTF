// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./ElevatorFactory.sol";

contract ElevatorTest is Building, Test {
    ElevatorFactory factory;
    bool flag = false;

    function setUp() public {
        factory = new ElevatorFactory();
    }

    function isLastFloor(uint256) external returns (bool) {
        bool _flag = flag;
        flag = !flag;
        return _flag;
    }

    function testElevator() public {
        address elevator = factory.createInstance(address(this));

        // ”真男人就上100层“
        Elevator(elevator).goTo(100);
        assertTrue(Elevator(elevator).top());

        assertTrue(factory.validateInstance(payable(address(elevator)), address(this)));
    }
}
