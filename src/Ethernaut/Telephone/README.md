# Telephone

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446)

获得合约的owner权限来完成这一关

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Telephone -vvvvv
```

## 功能简述

更换合约owner只能通过changeOwner函数，当交易的发送者和交易的原始发送者不同时，发生owner变动。

在`solidity`中，使用`tx.origin`可以获得启动交易的原始地址，它与`msg.sender`十分相似，下面我们用一个例子来区分它们之间不同的地方。

如果用户A调用了B合约，再通过B合约调用了C合约，那么在C合约看来，`msg.sender`就是B合约，而`tx.origin`就是用户A。

[![img](https://github.com/AmazingAng/WTF-Solidity/raw/main/S12_TxOrigin/img/S12_1.jpg)](https://github.com/AmazingAng/WTF-Solidity/blob/main/S12_TxOrigin/img/S12_1.jpg)

所以我们只需要写一个合约，让这个合约调用题目中的`changeOwner`方法即可。

