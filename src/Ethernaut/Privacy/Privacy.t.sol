// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./PrivacyFactory.sol";

contract PrivacyTest is Test {
    PrivacyFactory factory;

    function setUp() public {
        factory = new PrivacyFactory();
    }

    function testPrivacy() public {
        address privacy = factory.createInstance(address(this));

        bytes32 key = vm.load(privacy, bytes32(uint256(5)));

        Privacy(privacy).unlock(bytes16(key));

        assertTrue(factory.validateInstance(payable(address(privacy)), address(this)));
    }
}
