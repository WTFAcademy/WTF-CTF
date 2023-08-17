// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import {HuffConfig} from "foundry-huff/HuffConfig.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import "./MagicNumFactory.sol";

contract MagicNumTest is Test {
    MagicNumFactory factory;
    address public solverHuff;
    address public solverAssembly;

    function setUp() public {
        factory = new MagicNumFactory();

        solverHuff = HuffDeployer.config().with_evm_version("paris").deploy("Ethernaut/MagicNumber/Solver");
        solverAssembly = address(new solver());

        assertEq(Solver(address(solverAssembly)).whatIsTheMeaningOfLife(), bytes32(uint256(0x2a)));
        assertEq(Solver(address(solverHuff)).whatIsTheMeaningOfLife(), bytes32(uint256(0x2a)));
    }

    function testMagicNum() public {
        address magicNum = factory.createInstance{value: 0.001 ether}(address(this));

        MagicNum(magicNum).setSolver(solverHuff);
        assertTrue(factory.validateInstance(payable(magicNum), address(this)));

        MagicNum(magicNum).setSolver(solverAssembly);
        assertTrue(factory.validateInstance(payable(magicNum), address(this)));
    }

    receive() external payable {}
}

contract solver {
    constructor() {
        assembly {
            mstore(0x00, 0x602a60005260206000f3)
            return(0x16, 0x0a)
        }
    }
}
