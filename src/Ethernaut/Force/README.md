# Force

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xb6c2Ec883DaAac76D8922519E63f875c2ec65575)

有些合约就是拒绝你的付款,就是这么任性 `¯\_(ツ)_/¯`

这一关的目标是使合约的余额大于0

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Force -vvvvv
```

## 功能简述

在日常进行solidity开发时，有时能看到这样的报错

```
Invalid implicit conversion from address to address payable requested.
```

即某个地址不具备payable属性，这时一般就会进行强转：

```
payable(_address)
```

如果一个合约要接受 ether, fallback函数或receive函数必须设置为 `payable`.

在合约不接受转账时，如何强制给合约账户进行转账？

`selfdestruct(address)`

> The `selfdestruct(address)` function removes all bytecode from the contract address and sends all ether stored to the specified address. If this specified address is also a contract, **no functions (including the fallback) get called**.

具体使用方法请参考：[WTF Solidity极简入门: 26. 删除合约](https://github.com/AmazingAng/WTF-Solidity/tree/main/26_DeleteContract)

并没有什么办法可以阻止攻击者通过自毁合约向任意地址发送 ether。

从solidity的[v0.8.18](https://github.com/ethereum/solidity/releases/tag/v0.8.18)后，使用`selfdestruct`会产生编译警告，不过目前只是警告，并没有禁用。

