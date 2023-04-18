// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "./DeployChallenge.sol";

contract DeployChallengeScript is Script {
    function setUp() public {}

    function run() public {
        // 获取 environment variable 里面 PRIVATE_KEY 的值
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // 使用 deployerPrivateKey 签署后续交易
        vm.startBroadcast(deployerPrivateKey);

        // 创建 DeployChallenge，如果 script 的 transactions 被发送到链上，则会在链上新建合约。
        new DeployChallenge();

        // 停止使用 deployerPrivateKey。即后续的操作不在使用 deployerPrivateKey 签名。
        vm.stopBroadcast();
    }
}
