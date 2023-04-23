# Preservation

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x7ae0655F0Ee1e7752D7C62493CEa1E69A810e2ed)

获得Preservation合约的owner权限

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Preservation -vvvvv
```

## 功能简述

Preservation 合约使用 delegatecall 时只会使用 LibraryContract合约的代码逻辑。

LibraryContract合约寻找变量时会按照 LibraryContract合约变量所在的插槽寻找 Preservation合约对应插槽中的变量。

首先调用 Preservation合约的 setFirstTime函数，函数参数为：Attack合约的地址。此时，Preservation合约中的timeZone1Library变量就修改为了Attack合约的地址。

```solidity
Preservation(preservation).setFirstTime(uint256(uint160(attack)));
```

然后再调用 Preservation合约的 setFirstTime函数，函数参数为：我的账户地址。因为Attack合约寻找变量时会按照 Attack合约变量所在的插槽寻找 Preservation合约对应插槽中的变量。从而改变owner账户的地址。

```solidity
Preservation(preservation).setFirstTime(uint256(uint160(address(this))));
```

所以，在使用代理调用delegatecall时，需要保证proxy合约和implementation合约的内存插槽不要有冲突，如果proxy合约中有变量，implementation合约中就不要使用proxy合约中变量占据的插槽位置。另一个解决办法是proxy合约存储变量时尽量指定插槽位置，不使用默认从0开始的插槽排布

```solidity
assembly {
	param.slot := slot
}
```

具体，可以查看[ERC-1967: Proxy Storage Slots](https://eips.ethereum.org/EIPS/eip-1967)或openzeppelin对代理合约的[实现](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/proxy)和[文档](https://docs.openzeppelin.com/contracts/4.x/api/proxy)，另外[ERC-2535: Diamonds, Multi-Facet Proxy](https://eips.ethereum.org/EIPS/eip-2535) 可以同时代理多个合约。