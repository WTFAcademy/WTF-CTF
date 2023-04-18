// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./RecoveryFactory.sol";

contract RecoveryTest is Test {
    RecoveryFactory factory;

    function setUp() public {
        factory = new RecoveryFactory();
    }

    function testRecovery() public {
        address recovery = factory.createInstance{value: 0.001 ether}(address(this));

        SimpleToken(
            payable(
                address(uint160(uint256(keccak256(abi.encodePacked(uint8(0xd6), uint8(0x94), recovery, uint8(0x01))))))
            )
        ).destroy(payable(address(this)));

        assertTrue(factory.validateInstance(payable(recovery), address(this)));
    }

    receive() external payable {}
}
