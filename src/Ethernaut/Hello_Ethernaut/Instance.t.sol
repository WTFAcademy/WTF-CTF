// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./InstanceFactory.sol";

contract InstanceTest is Test {
    InstanceFactory factory;

    function setUp() public {
        factory = new InstanceFactory();
    }

    function testInstance() public {
        address instance = factory.createInstance(address(this));

        string memory info = Instance(instance).info();
        assertEq(info, "You will find what you need in info1().");

        string memory info1 = Instance(instance).info1();
        assertEq(info1, 'Try info2(), but with "hello" as a parameter.');

        string memory info2 = Instance(instance).info2("hello");
        assertEq(info2, "The property infoNum holds the number of the next info method to call.");

        uint8 infoNum = Instance(instance).infoNum();
        assertEq(infoNum, 42);

        string memory info42 = Instance(instance).info42();
        assertEq(info42, "theMethodName is the name of the next method.");

        string memory theMethodName = Instance(instance).theMethodName();
        assertEq(theMethodName, "The method name is method7123949.");

        string memory method7123949 = Instance(instance).method7123949();
        assertEq(method7123949, "If you know the password, submit it to authenticate().");

        string memory password = Instance(instance).password();
        assertEq(password, "ethernaut0");

        Instance(instance).authenticate(password);

        assertTrue(factory.validateInstance(payable(instance), address(this)));
    }
}
