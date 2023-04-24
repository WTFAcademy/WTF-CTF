# Recovery

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xAF98ab8F2e2B24F42C661ed023237f5B7acAB048)

合约创建者构建了一个非常简单的代币工厂合约。任何人都可以轻松创建新代币。在部署第一个代币合约后，创建者发送`0.001`以太币以获得更多代币。但是他们忘记了新代币的合约地址。我需要将他们新部署的代币合约中的`0.001`以太币取出。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Recovery -vvvvv
```

## 功能简述

要将SimpleToken合约中的ether取出，只能调用destroy函数，将SimpleToken合约自毁以取出SimpleToken合约中所有的以太币。

那现在问题就变成了，我如何获取新部署SimpleToken合约地址。

1. 如果在真实环境中，你可以通过区块链浏览器，查看部署交易中的内部交易，其中会有新部署的SimpleToken合约的地址。
2. 计算合约地址有两种方式[create](https://github.com/AmazingAng/WTF-Solidity/tree/main/24_Create)和[create2](https://github.com/AmazingAng/WTF-Solidity/tree/main/25_Create2)两种方式，RecoveryFactory合约只通过create方法进行的合约部署。所以我们只需要知道RecoveryFactory合约在部署SimpleToken合约交易的nonce值，也可以知道SimpleToken合约地址。

在solidity中，计算合约地址的两种方式为

```solidity
// create
address newContractAddress = address(uint160(uint256(keccak256(abi.encodePacked(
	uint8(0xd6), // 固定值
	uint8(0x94), // 固定值
	address(this), //创建者地址
	uint8(0x01)// 创建者创建该合约的nonce值，合约地址nonce值从1开始算（eip-161），如果是eoa账户，nonce为零时，此值为0x80
)))))

// create2
address newContractAddress = address(uint160(uint(keccak256(abi.encodePacked(
	bytes1(0xff),// 固定值
	address(this),//创建者地址
	salt,// 盐，随机数
	keccak256(type(newContract).creationCode)//待部署合约的字节码
 )))));
```

