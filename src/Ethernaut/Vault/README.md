# Vault

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xB7257D8Ba61BD1b3Fb7249DCd9330a023a5F3670)

解锁 vault 来通过这一关!

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Vault -vvvvv
```

## 功能简述

要解锁Vault合约，需要我们输入一个password，这个password需要与合约创建时传入password一致。可合约的password是一个私有变量，在合约abi（[WTF Solidity极简入门: 27. ABI编码解码](https://github.com/AmazingAng/WTF-Solidity/tree/main/27_ABIEncode)）中被没有方法进行读取。

但一个变量设制成私有, 只能保证不让别的合约访问他. 但链上数据是公开的，我们可以读取合约中所有插槽的数据。（对于存储中的状态变量储存结构可以阅读solidity的[官方文档](https://docs.soliditylang.org/zh/latest/internals/layout_in_storage.html)）。

Vault合约中的password存储在插槽1中，所以我们可以插槽1中的数据获取password的值。使用Foundry的cheatcode读取插槽数据

```solidity
bytes32 password = vm.load(vault, bytes32(uint256(1)))
```

我们也可以通过Foundry中的cast工具读取链上任意合约任意插槽的数据。

```sh
$ cast storage -h
Get the raw value of a contract's storage slot.

Usage: cast storage [OPTIONS] <ADDRESS> [SLOT]

Arguments:
  <ADDRESS>  The contract address
  [SLOT]     The storage slot number

Options:
  -B, --block <BLOCK>            The block height you want to query at
  -r, --rpc-url <URL>            The RPC endpoint [env: ETH_RPC_URL=]
      --flashbots                Use the Flashbots RPC URL (https://rpc.flashbots.net)
  -e, --etherscan-api-key <KEY>  The Etherscan (or equivalent) API key [env: ETHERSCAN_API_KEY=]
  -c, --chain <CHAIN>            The chain name or EIP-155 chain ID [env: CHAIN=]
  -h, --help                     Print help (see more with '--help')
```

为了确保数据私有, 需要在上链前加密. 在这种情况下, 密钥绝对不要公开, 否则会被任何想知道的人获得.

另外 [zk-SNARKs](https://blog.ethereum.org/2016/12/05/zksnarks-in-a-nutshell/) 提供了一个可以判断某个人是否有某个秘密参数的方法,但是不必透露这个参数.