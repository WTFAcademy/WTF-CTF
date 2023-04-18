// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";
import "./GoodSamaritanFactory.sol";

contract GoodSamaritanTest is Test, INotifyable {
    GoodSamaritanFactory factory;

    error NotEnoughBalance();

    function setUp() public {
        factory = new GoodSamaritanFactory();
    }

    function notify(uint256 amount) public pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }

    function testGoodSamaritan() public {
        address goodSamaritan = factory.createInstance(address(this));

        GoodSamaritan(goodSamaritan).requestDonation();
        assertTrue(factory.validateInstance(payable(goodSamaritan), address(this)));
    }
}
