# Token bank

## 题目描述

[原题链接](https://capturetheether.com/challenges/miscellaneous/token-bank/)

原题目要求 TokenBankChallenge 合约的 token balance 为 0。

## 运行

**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Miscellaneous/Token_bank -vvv
```

## 功能简述

为了能够复现 Challenge，在不改变原题意下，将 TokenBankChallenge 里面的withdraw 某行增加 unchecked。

解决思路是 withdraw 里面的 balanceOf 的减少是在 transfer 之后，因此我们可以 re-entrancy，在 transfer 的时候转多笔。

```solidity
        require(token.transfer(msg.sender, amount));
        unchecked {
            balanceOf[msg.sender] -= amount;
        }
```

新建一个 Attacker 合约，作为 Player，先从 TokenBankChallenge 里面提取 token，然后转给 Attacker。

Player 调用 Attacker 的 deposit，再把 token 从 Attacker 存入 TokenBankChallenge。

Player 调用 Attacker 的 withdraw，将 token 转给自己，然后 token 会调用 Attacker 的 tokenFallback，我们在这里再次调用 TokenBankChallenge 的 withdraw。即可将 TokenBankChallenge 的 token 余额转走。