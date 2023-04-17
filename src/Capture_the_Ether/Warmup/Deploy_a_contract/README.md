# Deploy a contract

## 题目描述

[原题链接](https://capturetheether.com/challenges/warmup/deploy)

题目要求在 Ropsten test network 部署 [DeployChallenge](./DeployChallenge.sol) 合约，我们根据实际情况，修改合约里面的 solidity 版本为 `^0.8.19`，并使用 forge 将合约部署到 Goerli test network。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh)配置好运行环境后，于本项目下执行下列命令：

**部署**
```sh
# 进入项目根目录
$ cd WTF-CTF

# 新建 .env 文件，并设置好相关的值
$ cp .env.example .env
```

为了方便起见，这里贴出完整的 .env（在非测试环境下不要暴露这三个 key，尤其是 `PRIVATE_KEY`）。
```sh
# RPC URL sourced by scripts, used to send transactions to the blockchain 
# or query information on the blockchain
RPC_URL=https://goerli.infura.io/v3/e65f012a4dcb40f09fbcfccb10a355d8

# Private key, used to sign transactions. It is for testing only!
PRIVATE_KEY=b1a8c217eb38804358181757d866af32ff697d43c6a3949ca0ee170a6a14cd18

# Etherscan api key, used to verify contract's source code in etherscan
ETHERSCAN_API_KEY=1ZZGSIFYFZSKI3I649UQ35CDQT444ZKPCW
```

接着运行：
```sh
$ source .env

$ forge script ./src/Capture_the_Ether/Warmup/Deploy_a_contract/DeployChallenge.s.sol --fork-url $RPC_URL --broadcast -vvv

...
##### goerli
✅ Hash: 0xdd4d4f41fc0d7853aef3bf55a167dcf92db0ba89e00e2bf9f6efc00addcab6bd
Contract Address: 0x88d01d33e9f47cd539bf40c6068ca8cda6470fc9
Block: 8765678
Paid: 0.026034855166276983 ETH (79157 gas * 328.901489019 gwei)


Transactions saved to: /Users/flyq/workspace/github/flyq/WTF-CTF/broadcast/DeployChallenge.s.sol/5/run-latest.json



==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Total Paid: 0.026034855166276983 ETH (79157 gas * avg 328.901489019 gwei)

Transactions saved to: /Users/flyq/workspace/github/flyq/WTF-CTF/broadcast/DeployChallenge.s.sol/5/run-latest.json
```
可以看出，成功将新合约部署到 https://goerli.etherscan.io/address/0x88d01d33e9f47cd539bf40c6068ca8cda6470fc9

**本地测试**
```sh
forge test -C src/Capture_the_Ether/Warmup/Deploy_a_contract -vvv
```

## 功能简述

1. 使用 forge script 在测试网部署了合约。
   我们使用 xxx.s.sol 来告诉 forge 这是一个 forge script 文件，并且里面存在 `setUp()` 来初始化 script 和 `run()` 执行具体的功能。

    ```solidity
        // 获取 environment variable 里面 PRIVATE_KEY 的值
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // 使用 deployerPrivateKey 签署后续交易
        vm.startBroadcast(deployerPrivateKey);

        // 创建 DeployChallenge，如果 script 的 transactions 被发送到链上，则会在链上新建合约。
        new DeployChallenge();

        // 停止使用 deployerPrivateKey。即后续的操作不在使用 deployerPrivateKey 签名。
        vm.stopBroadcast();
    ```

2. 使用 forge test 在本地模拟测试。
   我们使用 xxx.t.sol 来告诉 forge 这是一个 forge test 文件，并且里面存在 `setUp()` 来初始化 test 和 `testXXX()` 执行对某个具体功能的测试。
    ```solidity
    contract DeployChallengeTest is Test {
        DeployChallenge public deployChallenge;

        // 在 setUp 里面部署 deployChallenge
        function setUp() public {
            deployChallenge = new DeployChallenge();
        }

        // 检查 deployChallenge 的函数 isComplete 是否为 true
        function testIsComplete() public {
            assertTrue(deployChallenge.isComplete());
        }

    }
    ```
