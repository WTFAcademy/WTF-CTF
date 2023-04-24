# Good Samaritan

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x36E92B2751F260D6a4749d7CA58247E7f8198284)

将wallet合约中的Coin代币余额清零。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Good_Samaritan -vvvvv
```

## 功能简述

题目说我们要掏空`Wallet`中的`Coin`

1. 重入攻击

    合约中的`requestDonation`函数没有检查重入攻击，一次请求10个，一共10**6个。怕是要花不少Gas。

2. 当`Wallet`合约中`Coin`余额不足10时，会触发`transferRemainder`将剩余所有`Coin`转移给请求者。

    而触发`transferRemainder`的条件是`GoodSamaritan`合约检测到`NotEnoughBalance()`错误。

    但`GoodSamaritan`合约却无法知道这个`NotEnoughBalance()`错误是谁发出的。

    `Coin`代币在`transfer`时会检测接受地址是否为合约地址，如果是合约地址，会进行`notify`接口调用。

    所以我们可以写攻击合约，在攻击合约接受`Coin`代币时发出`NotEnoughBalance()`错误。让`GoodSamaritan`合约将`Wallet`合约中的所有`Coin`转给我们。

```solidity
function notify(uint256 amount) public pure {
	if (amount == 10) {
		revert NotEnoughBalance();
	}
}
```

