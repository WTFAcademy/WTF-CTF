# Puzzle Wallet

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x725595BA16E76ED1F6cC1e1b65A88365cC494824)

获取PuzzleProxy的admin权限

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Puzzle_Wallet -vvvvv
```

## 功能简述

项目采用可升级架构，使用代理调整来实现附加的功能。`PuzzleWallet`合约中的函数调用，都通过`PuzzleProxy合约`的`fallback`和`receive`函数进行了代理调用。

因为是代理调用，**每次调用函数（call）所使用的调用量变化量都是`PuzzleProxy`合约插槽中的数据。**`PuzzleProxy`合约插槽0中有`pendingAdmin`（地址占20字节）变量。目标是让我们的账户地址成为`PuzzleProxy`合约的`admin`。也就是说要修改`PuzzleProxy`合约插槽1中的数据。

但`PuzzleProxy`合约中可以修改插槽1中的数据的操作，有`constructor`构造函数和`approveNewAdmin`函数，构造函数不能重新使用。`approveNewAdmin`函数只能账户`admin`才能调整使用。

而`PuzzleWallet`合约中有可以改变插槽1中的数据的操作（即改变`maxBalance`改变量（uint256占32位）的值）。有构造函数和`setMaxBalance`函数，构造参数不能重新使用。`setMaxBalance`两个限制，一个是合约地址的ETH余额为0，另外一个是调用地址是白名单用户。

1. 让`PuzzleProxy合约`ETH余额变为0。初始状态下`PuzzleProxy合约`下有0.001个ETH。合约中可以转移ETH操作只有`execute`函数。而`execute`函数提取ETH时要求我们在合约中的余额大于等于本次提取的余额。但合约提供了函数`multicall`，允许我们可以一次笔交易调用多次，在多次调使用中的`msg.value`是不变的，从而可以达到只转一次钱，但合约中我们的余额增加多次。重入攻击。但`multicall`函数中不允许我们多次调用`deposit`函数，可`multicall`函数并没有限制多次使用`multicall`函数进行重入。多次调用`multicall`函数从达到多次调用`deposit`函数的效果。然后调用`execute函数`将合约中所有eth提走。
2. 让我们的账号成为白名单用户。只能通过`addToWhitelist`函数，但这个函数只能由owner账号地址调用。owner变量存储在插槽0中，可以通过`PuzzleProxy`合约的`proposeNewAdmin`函数，让我们的账户地址存储在插槽0中，插槽0中的数据在`PuzzleProxy`合约中是`pendingAdmin`变量，在`PuzzleWallet`合约中是`owner`变量。从而我们的账户地址就变成了`PuzzleWallet`合约的`owner`。可以调用`addToWhitelist`函数。

使用代理合约时，必须注意不要引入存储冲突，如本关卡所示。

