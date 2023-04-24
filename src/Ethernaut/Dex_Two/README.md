# Dex Two

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xf59112032D54862E199626F55cFad4F8a3b0Fce9)

从`DexTwo`合约中耗尽 token1 和 token2 的所有余额才能成功通过此级别。

您仍将以 10 个标记`token1`和 10 个标记开始`token2`。DEX 合约仍然以每个代币 100 个开始。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Dex_Two -vvvvv
```

## 功能简述

```solidity
// swap的价格计算
// 但是Dex Two 并没有限制to/from 必须是 token1/token2
((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)))
```

铸造400个token3，给合约转100个token3。

我开始有10个token1，10个token2，300个token3，合约有100个token1，100个token2，100个token3。

1. 我用100个token3换100个token1，因为 (100*100)/100 = 100 。 第一次swap后，我就有110个token1，10个token2，200个token3 ；合约有0个token1，100个token2，200个token3。
2. 我用200个token3换100个token2，因为 (200*100)/200 = 100  。第二次swap后，我就有110个token1，110个token2，0个token3 ；合约有0个token1，0个token2，400个token3。

至此，经过2轮，合约中的token1与token2已经被掏空了。