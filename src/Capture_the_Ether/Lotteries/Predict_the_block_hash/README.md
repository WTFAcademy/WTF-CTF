# Predict the block_hash

## 题目描述

[原题链接](https://capturetheether.com/challenges/lotteries/predict-the-block-hash/)

原题目要求 PredictTheBlockHashChallenge 合约里面的余额为 0。参与过程分成两步，第一步时锁定答案，第二步揭示答案。如果锁定的答案等于当前 blockhash，即可转移 2 ether 出去。

## 运行

**安装 Foundry**

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Lotteries/Predict_the_block_hash -vvv
```

## 功能简述

PredictTheBlockHashChallenge 和 PredictTheFutureChallenge 很类似，但是解决思路不一样。原因在于预测一个 blockhash 的概率太小了，即使矿工也没办法，有这个能力还不如直接去预测私钥了。

> `blockhash(uint blockNumber) returns (bytes32)`: hash of the given block when `blocknumber` is one of the 256 most recent blocks; otherwise returns zero. 

-- from [Block and Transaction Properties](https://docs.soliditylang.org/en/develop/units-and-global-variables.html#block-and-transaction-properties)

解决思路是，我们 lockInGuess 并转入一个 ether 时，我们将 hash 设置为 zero，然后 过了 257 个块再调用 settle。
