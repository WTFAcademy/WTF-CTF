# Denial

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x2427aF06f748A6adb651aCaB0cA8FbC7EaF802e6)

拒绝用户提取资金`withdraw()`（此时合约仍有资金，并且交易的 gas 为 1M 或更少）。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Denial -vvvvv
```

## 功能简述

call 如果异常会转账失败，只会返回false，不会最终停止执行， 没有gas限制

```solidity
// The recipient can revert, the owner will still get their share
partner.call{value: amountToSend}("");
```

call方法会将调用结果以true和false的形式返回，即调用过程中有错误发生，也不会影响后续的代码。

所以只有让gas在外部call时全部消耗掉，无法运行后续代码。

```solidity
receive() external payable {
 	// 消耗掉所有gas值
	while(true){}
}
```

或者进行重新攻击，转走合约中的所有本币。但是题目要求的`whilst the contract still has funds`。就不能转完合约里全部的钱。

如果使用低级别`call`外部调用，请确保指定固定的 gas 津贴。例如`call{gas: 100000}("")`。

