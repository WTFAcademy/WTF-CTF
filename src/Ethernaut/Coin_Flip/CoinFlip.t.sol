// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./CoinFlipFactory.sol";

contract CoinFlipTest is Test {
    CoinFlipFactory factory;

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function setUp() public {
        factory = new CoinFlipFactory();
    }

    function flip() internal view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        return side;
    }

    function testCoinFlip() public {
        address coinFlip = factory.createInstance(address(this));

        for (uint256 i = 0; i < 10; i++) {
            CoinFlip(coinFlip).flip(flip());

            vm.roll(block.number + 1);
        }

        assertTrue(factory.validateInstance(payable(address(coinFlip)), address(this)));
    }
}
