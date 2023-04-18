// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./GatekeeperOneFactory.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOneFactory factory;

    function setUp() public {
        factory = new GatekeeperOneFactory();
    }

    function testGatekeeperOne() public {
        address player = vm.addr(uint256(keccak256("player")));

        address gatekeeperOne = factory.createInstance(player);

        vm.prank(address(this), player);

        // 0xabcd00000000305c
        bytes8 _gateKey = bytes8(abi.encodePacked(hex"abcd00000000", uint16(uint160(player))));

        GatekeeperOne(gatekeeperOne).enter{gas: 82178}(_gateKey);

        assertTrue(factory.validateInstance(payable(address(gatekeeperOne)), player));
    }
}
