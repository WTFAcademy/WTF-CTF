# Deploy a contract

## 题目描述

[原题链接](https://capturetheether.com/challenges/warmup/call-me)

题目要求调用 [CallMeChallenge](./CallMeChallenge.sol.sol) 合约的 `callme` 函数来改变 `isComplete` 的值，我们根据实际情况，修改合约里面的 solidity 版本为 `^0.8.19`，并使用 forge test 在本地模拟这个过程。


## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Warmup/Call_me -vvv
```

## 功能简述

在 CallMeChallenge.t.sol 中调用 `callme` 函数。