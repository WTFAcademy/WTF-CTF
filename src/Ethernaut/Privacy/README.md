# Privacy

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x6DcE47e94Fa22F8E2d8A7FDf538602B1F86aBFd2)

这个合约的制作者非常小心的保护了敏感区域的 storage.

解开这个合约来完成这一关.

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Privacy -vvvvv
```

## 功能简述

解锁合约需要得到data[2]的前16个字节。在Privacy合约中的变量

```solidity
bool public locked = true;// locked占插槽0的1个字节，插槽0剩余31字节
uint256 public ID = block.timestamp;// 插槽0中只剩31个字节，不够ID存放，所以ID存放在插槽1中，占32个字节，插槽1已满
uint8 private flattening = 10;// flattening占插槽2的1个字节，插槽2剩余31字节
uint8 private denomination = 255;// denomination占插槽2的1个字节，插槽2剩余30字节
uint16 private awkwardness = uint16(now);// awkwardness占插槽2的2个字节，插槽2剩余29字节
bytes32[3] private data;// 插槽2剩余29字节，不够data存放，data[0]占满插槽3的32个字节，data[1]占满插槽4的32个字节，data[2]占满插槽5的32个字节
```

所以data[2]在插槽5中，只需要读取到插槽5的前16个字节即可解锁合约。

```solidity
bytes16(vm.load(privacy, bytes32(uint256(5))))
```

在EVM链上, 没有什么是私有的。 private 关键词只是 solidity 中人为规定的一个结构。 我们其实可以读取 storage 中的任何信息, 虽然有些数据读取的时候会比较麻烦。 

想要知道如何读取合约中更多的信息, 可以参见 "Darius" 写的这篇详细的文章: [How to read Ethereum contract storage](https://medium.com/aigang-network/how-to-read-ethereum-contract-storage-44252c8af925)