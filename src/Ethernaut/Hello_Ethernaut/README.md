# Hello Ethernaut

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x7E0f53981657345B31C59aC44e9c21631Ce710c7)

本题目是Ethernaut的新手村教程，让玩家熟悉如何通过浏览器的控制台解决问题。

但本仓库使用Foundry框架，主要提供解题思路，不拘泥于形式。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Hello_Ethernaut -vvvvv
```

## 功能简述

题目引导我们如何完成一道题目的完整解题过程。

首先创建实例，在本仓库中就是通过工厂合约创建出一个题目。即调用`createInstance()`方法。

```solidity
// createInstance 创建题目实例

// _player 玩家地址，在本仓库中有时是测试合约地址，有时是玩家自己的EOA地址，已解决不同的题目，如果都可以时，默认是测试合约地址。

function createInstance(address _player) public payable override returns (address)
```

然后题目让我们调用`info()`，然后根据合约的返回值调用其他方法...

最后提交实例，以判断是否完成解题，即调用工厂合约的`validateInstance()`方法。

```solidity
// validateInstance 验证题目是否完成

// _instance 创建的实例题目地址
// _player 题目的玩家地址

function validateInstance(address payable _instance, address _player) public view override returns (bool)
```

