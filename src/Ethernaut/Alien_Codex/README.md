# Alien Codex

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x27bC920e7C426500a0e7D63Bb037800A7288abC1)

获取Alien 合约的owner所有权

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Alien_Codex -vvvvv
```

## 功能简述

solidity在v0.6.0+commit.26b70077版本前，允许变长数组的长度属性被程序员修改。

所以如果我们将一个长度为0的变长数组的长度减一，就会触发内存溢出，将长度从零变为115792089237316195423570985008687907853269984665640564039457584007913129639935 = 2^256-1。

而solidty的内存插槽一共有 2^256 个（每个插槽有256bits = 32bytes）,这样如果这个数组的类型为bytes32类型，那么就意味着，该变长数组可以访问和修改所有数据。

只要我们知道了特定变量的数据所在插槽，就可以修改该变量，比如将owner修改。

不过在v0.6.0+commit.26b70077版本开始，变长数组的长度属性已经变为只读变量。不能修改了。如果尝试修改就会出现如下错误：

```
TypeError: Member "length" is read-only and cannot be used to resize arrays.
```

首先，查看合约中owner变量存储在哪个插槽，合约一共有3个变量。

```solidity
address private _owner;// address 占20字节，在插槽slot0中，此时插槽slot0还剩10字节
bool public contact;// bool 占1个字节，在插槽slot0中，此时插槽slot0还剩9字节
bytes32[] public codex;// bytes32 占32字节，插槽slot0中不够存储，所以codex变量存储在插槽slot1中。
```

不过插槽slot1中存储的是，变长数组codex的长度属性，即codex.length。codex的第一个数据（codex[0]）存储在插槽下标为

keccak256(byte32(1)) = 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6（此时应该把这个看作数字而不是字符串）的插槽中。所以我们只需找到插槽slot0属于变长数组的第几个元素（即找到slot0在数组codex的下标是多少）。

一共2^256个插槽，插槽下标从0开始。插槽编号 [0 ~ 2^256) 半闭半开。所以slot0在codex的下标为 

```
2^256 - 1 + 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6 + 1
```

等于

```
35707666377435648211887908874984608119992236509074197713628505308453184860938
```

覆盖slot0中内容,将owner变成自己的账号