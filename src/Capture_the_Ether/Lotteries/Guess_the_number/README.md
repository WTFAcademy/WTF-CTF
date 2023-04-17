# Guess the number

## 题目描述

[原题链接](https://capturetheether.com/challenges/lotteries/guess-the-number/)

原题目要求 GuessTheNumberChallenge 合约的 ether 余额为 0。而调用 guess 并输入正确答案即可转移 ether 出去。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Lotteries/Guess_the_number -vvv
```

## 功能简述

根据 GuessTheNumberChallenge contract 里面的 guess 函数，当我们调用 guess 时，需要往合约里面转入 1 ether，并输入一个 uint8 类型的参数，如果参数等于 answer，42，就能从合约里面转移 2 ether 到调用者。
```solidity
    function guess(uint8 n) public payable {
        require(msg.value == 1 ether);

        if (n == answer) {
            payable(msg.sender).transfer(2 ether);
        }
    }
```

因此在测试合约中的 setUp，我们先给 hacker 转入 1 ether 用于后续调用 guess，然后创建 GuessTheNumberChallenge。
```solidity
    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheNumberChallenge = new GuessTheNumberChallenge{value: 1 ether}();
    }
```

在测试合约的 testGuessTheNumber 中，我们调用 guess，设置参数为 42，并携带 1 ether 就能成功完成挑战
```solidity
        vm.startPrank(hacker);
        guessTheNumberChallenge.guess{value: 1 ether}(42);
        vm.stopPrank();
```