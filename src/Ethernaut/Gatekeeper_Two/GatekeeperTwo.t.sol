// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./GatekeeperTwoFactory.sol";

contract GatekeeperOneTest is Test {
    GatekeeperTwoFactory factory;

    function setUp() public {
        factory = new GatekeeperTwoFactory();
    }

    function testGatekeeperTwo() public {
        address player = vm.addr(uint256(keccak256("player")));

        vm.startPrank(address(this), player);

        {
            address gatekeeperTwo = factory.createInstance(player);

            new GatebreakerTwo(gatekeeperTwo);

            assertTrue(factory.validateInstance(payable(address(gatekeeperTwo)), player));
        }

        vm.stopPrank();
    }
}

contract GatebreakerTwo {
    constructor(address gatekeeperTwo) {
        uint64 _gateKey = type(uint64).max ^ uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        GatekeeperTwo(gatekeeperTwo).enter(bytes8(_gateKey));
    }
}
