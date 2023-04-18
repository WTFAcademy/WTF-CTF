// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./MagicNumFactory.sol";

contract MagicNumTest is Test {
    MagicNumFactory factory;

    function setUp() public {
        factory = new MagicNumFactory();
    }

    function testMagicNum() public {
        address magicNum = factory.createInstance{value: 0.001 ether}(address(this));

        solver solver_ = new solver();
        assertEq(Solver(address(solver_)).whatIsTheMeaningOfLife(), bytes32(uint256(0x2a)));

        MagicNum(magicNum).setSolver(address(solver_));

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
