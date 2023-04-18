// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "./TokenFactory.sol";

contract TokenTest is Test {
    TokenFactory factory;

    function setUp() public {
        factory = new TokenFactory();
    }

    function testTransfer() public {
        address token = factory.createInstance(address(this));

        // any address other than this contract address
        address anyone = vm.addr(uint256(keccak256("anyone")));
        Token(token).transfer(anyone, 21);

        assertTrue(factory.validateInstance(payable(address(token)), address(this)));
    }
}
