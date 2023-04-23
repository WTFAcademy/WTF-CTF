# Naught Coin

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x80934BE6B8B872B364b470Ca30EaAd8AEAC4f63F)

NaughtCoin 是一种 ERC20 代币，而且您已经持有这些代币。问题是您只能在 10 年之后才能转移它们。您能尝试将它们转移到另一个地址，以便您可以自由使用它们吗？通过将您的代币余额变为 0 来完成此关卡。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Naught_Coin -vvvvv
```

## 功能简述

先授权给其他人，再让其他人再把钱转走。

在使用第三方库时，最好充分了解其实现逻辑，并且尽量使用通过审计或广泛使用的第三方代码库。

在这个案例中, 开发人员认为 transfer 函数是移动Token的唯一方法，但发现还有其他方法可以使用不同的实现来执行相同的操作。