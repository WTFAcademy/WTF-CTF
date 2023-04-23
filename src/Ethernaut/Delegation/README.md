# Delegation

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x73379d8B82Fda494ee59555f333DF7D44483fD58)

这一关的目标是获得创建实例的所有权.

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Delegation -vvvvv
```

## 功能简述

创建的实例是Delegation。我们可以触发Delegation合约的fallback函数同时在msg.data中发送Delegate的pwn函数调用，已获得Delegation的owner权限。

对于Delegatecall的使用方法可以阅读[WTF Solidity极简入门: 23. Delegatecall](https://github.com/AmazingAng/WTF-Solidity/tree/main/23_Delegatecall)

另外，早期链上也有许多代理调用使用不当发生的攻击。[The Parity Wallet Hack Explained](https://blog.openzeppelin.com/on-the-parity-wallet-multisig-hack-405a8c12e8f7/)



