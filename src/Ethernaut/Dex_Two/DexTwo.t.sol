// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./DexTwoFactory.sol";

contract DexTwoTest is Test {
    DexTwoFactory factory;

    function setUp() public {
        factory = new DexTwoFactory();
    }

    function testDexTwo() public {
        address dex = factory.createInstance(address(this));

        address token1 = DexTwo(dex).token1();
        address token2 = DexTwo(dex).token2();
        SwappableTokenTwo token3 = new SwappableTokenTwo(
            address(this),
            "Token 3",
            "TKN3",
            400
        );

        token3.approve(dex, type(uint256).max);
        DexTwo(dex).approve(dex, type(uint256).max);

        token3.transfer(dex, 100);

        DexTwo(dex).swap(address(token3), token1, 100);
        DexTwo(dex).swap(address(token3), token2, 200);

        assertEq(IERC20(token1).balanceOf(dex), 0);
        assertEq(IERC20(token2).balanceOf(dex), 0);

        assertTrue(factory.validateInstance(payable(dex), address(this)));
    }
}
