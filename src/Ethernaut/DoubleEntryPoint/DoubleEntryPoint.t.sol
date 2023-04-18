// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./DoubleEntryPointFactory.sol";

contract DoubleEntryPointTest is Test, IDetectionBot {
    DoubleEntryPointFactory factory;
    address doubleEntryPoint;
    address public cryptoVault;
    Forta public forta;

    function setUp() public {
        factory = new DoubleEntryPointFactory();

        doubleEntryPoint = factory.createInstance(address(this));

        cryptoVault = DoubleEntryPoint(doubleEntryPoint).cryptoVault();

        forta = DoubleEntryPoint(doubleEntryPoint).forta();

        forta.setDetectionBot(address(this));
    }

    function handleTransaction(address user, bytes calldata msgData) public override {
        (address to, uint256 value, address origSender) = abi.decode(msgData[4:], (address, uint256, address));
        if (origSender == cryptoVault) {
            forta.raiseAlert(user);
        }
    }

    function testDoubleEntryPoint() public {
        assertTrue(factory.validateInstance(payable(doubleEntryPoint), address(this)));
    }
}
