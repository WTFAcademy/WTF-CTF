// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./FuzzyIdentityChallenge.sol";
import "./Factory.sol";

interface IAttacker {
    function hack(address) external;
}

contract FuzzyIdentityChallengeTest is Test {
    FuzzyIdentityChallenge public fuzzyIdentityChallenge;
    FactoryAssembly factoryAsm;
    address hacker = makeAddr("hacker");

    function setUp() public {
        fuzzyIdentityChallenge = new FuzzyIdentityChallenge();

        vm.startPrank(hacker);
        factoryAsm = new FactoryAssembly();
        vm.stopPrank();
    }

    function testGetBytecodeAndFactoryAddr() public {
        emit log_named_address("factory address", address(factoryAsm));

        bytes memory bytecode = factoryAsm.getBytecode();
        emit log_named_bytes("bytecode", bytecode);
        address attacker = factoryAsm.getAddress(bytecode, 0);
        emit log_named_address("attacker address", attacker);
    }

    function testFuzzyIdentity() public {
        vm.startPrank(hacker);
        emit log_named_string("before hack, isComplete", fuzzyIdentityChallenge.isComplete() ? "true" : "false");

        bytes memory bytecode = factoryAsm.getBytecode();
        uint256 salt = 531213936274198893;

        address attackerAddr = factoryAsm.deploy(bytecode, salt);
        IAttacker attacker = IAttacker(attackerAddr);

        attacker.hack(address(fuzzyIdentityChallenge));

        emit log_named_string("after hack, isComplete", fuzzyIdentityChallenge.isComplete() ? "true" : "false");

        assertTrue(fuzzyIdentityChallenge.isComplete());
    }
}
