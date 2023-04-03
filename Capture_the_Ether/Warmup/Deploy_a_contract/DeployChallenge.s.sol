// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/DeployChallenge.sol";

contract DeployChallengeScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new DeployChallenge();

        vm.stopBroadcast();
    }
}
