// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./DexFactory.sol";

contract DexTest is Test {
    DexFactory factory;

    function setUp() public {
        factory = new DexFactory();
    }

    function testDex() public {
        address dex = factory.createInstance(address(this));
        address token1 = Dex(dex).token1();
        address token2 = Dex(dex).token2();

        Dex(dex).approve(dex, type(uint256).max);

        Dex(dex).swap(token1, token2, 10);
        Dex(dex).swap(token2, token1, 20);
        Dex(dex).swap(token1, token2, 24);
        Dex(dex).swap(token2, token1, 30);
        Dex(dex).swap(token1, token2, 41);
        Dex(dex).swap(token2, token1, 45);

        assertEq(IERC20(token1).balanceOf(dex), 0);

        assertTrue(factory.validateInstance(payable(dex), address(this)));
    }
}
