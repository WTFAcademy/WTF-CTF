# Assume ownership

## 题目描述

[原题链接](https://capturetheether.com/challenges/miscellaneous/assume-ownership/)

原题目要求 AssumeOwnershipChallenge 合约的 isComplete 变量设置成 true。

## 运行

**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Miscellaneous/Assume_ownership -vvv
```

## 功能简述

以前合约的构造函数的**函数名**使用**合约名**，但是这个设计有问题，会导致比如这个 Challenge 一样，如果构造函数不小心拼写错误，则成了所有人都可以调用的公开函数：`AssumeOwnershipChallenge`，`AssumeOwmershipChallenge()`。所以后来使用 constructor 关键字来申明构造函数来避免这个问题。

所以我们这里直接调用 `AssumeOwmershipChallenge` 来获取 owner 权限，并再调用 `authenticate()` 将 `isComplete` 设置为 true。