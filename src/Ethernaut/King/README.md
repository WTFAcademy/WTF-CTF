# King

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x3049C00639E6dfC269ED1451764a046f7aE500c6)

King合约表示了一个很简单的游戏: 任何一个发送了高于目前价格的人将成为新的国王。上一个国王将会获得新的出价, 这样可以赚得一些以太币. 看起像是庞氏骗局.

这么有趣的游戏, 你的目标是攻破他.

当你提交实例给关卡时, 关卡会重新申明王位. 你需要阻止他重获王位来通过这一关.

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/King -vvvvv
```

## 功能简述

合约账户在收到转账后，会自动执行receive函数或fallback函数（[区别](https://github.com/AmazingAng/WTF-Solidity/tree/main/19_Fallback#receive%E5%92%8Cfallback%E7%9A%84%E5%8C%BA%E5%88%AB)）。

合约中使用 transfer函数进行合约转账，transfer函数执行失败时，会回滚交易。而call函数进行转账时失败了只会返回false（[solidity三种发送ETH的方法](https://github.com/AmazingAng/WTF-Solidity/tree/main/20_SendETH)）。

所以我们可以使用合约申请为king，然后在合约的receive函数中revert掉所有转账交易。这样就没有人可以替代我们成为新王。

```solidity
receive() external payable {
	revert();
}
```

