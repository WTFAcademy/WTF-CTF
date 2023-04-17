# Choose a nickname

## 题目描述

[原题链接](https://capturetheether.com/challenges/warmup/nickname/)

原题目要求调用 Ropsten test network 上 CaptureTheEther 合约 (`0x71c46Ed333C35e4E6c62D32dc7C8F00D125b4fee`) 的 setNickname 函数，以便用于 leaderboard 的展示。我们根据实际情况，修改合约里面的 solidity 版本为 `^0.8.19`，并使用 forge test 在本地模拟这个过程。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Warmup/Choose_a_nickname -vvv
```

## 功能简述

根据 NicknameChallenge contract 里面使用 msg.sender 来创建 CaptureTheEther contract 的对象，推测 CaptureTheEther contract 有部署 NicknameChallenge contract 的逻辑，但是题目里面把这块省略了：
```solidity
contract NicknameChallenge {
    CaptureTheEther cte = CaptureTheEther(msg.sender);
    ...
}
```

在 NicknameChallenge.t.sol 中，通过 setUp() 进行初始化设置，我们先创建 CaptureTheEther 合约，然后使用作弊码 startPrank 为所有后续调用设置 msg.sender 为 captureTheEther 地址，直到调用 stopPrank：
```solidity
    function setUp() public {
        captureTheEther = new CaptureTheEther();

        vm.startPrank(address(captureTheEther));
        nicknameChallenge = new NicknameChallenge(hacker);
        vm.stopPrank();
    }
```

然后，我们在测试函数 testNickname() 里面使用作弊码 startPrank 为所有后续调用设置 msg.sender 为 hacker 地址，并调用 setNickname：
```solidity
        vm.startPrank(hacker);
        // set my name to UINT256_MAX
        captureTheEther.setNickname(bytes32(UINT256_MAX));
        vm.stopPrank();
```