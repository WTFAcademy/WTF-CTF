# Coin Flip

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF)

这是一个掷硬币的游戏，你需要连续的猜对结果。完成这一关，你需要通过你的超能力来连续猜对十次。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Coin_Flip -vvvvv
```

## 功能简述

该合约中所使用的随机数算法依靠块高，而且FACTOR也为public变量。这种随机数方法对于其他合约就变成了伪随机。

我们可以在自己的合约中逆向模拟CoinFlip合约验证过程，以保证成功验证。

```solidity
// 逆向计算需要输入的bool值
function flip() internal view returns (bool) {
	uint256 blockValue = uint256(blockhash(block.number - 1));
	uint256 coinFlip = blockValue / FACTOR;
	bool side = coinFlip == 1 ? true : false;
	return side;
}
```

## 建议的随机数算法

想要获得密码学上的随机数,你可以使用 [Chainlink VRF](https://docs.chain.link/docs/get-a-random-number), 它使用预言机, LINK token, 和一个链上合约来检验这是不是真的是一个随机数.

可以查看[WTF Solidity极简入门: 39. 链上随机数](https://github.com/AmazingAng/WTF-Solidity/tree/main/39_Random)教程

