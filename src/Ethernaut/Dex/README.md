# Dex

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xB468f8e42AC0fAe675B56bc6FDa9C0563B61A52F)

破解基本[DEX](https://en.wikipedia.org/wiki/Decentralized_exchange)合约并通过价格操纵窃取资金。

您将从 10 个标记`token1`和 10 个标记开始`token2`。DEX 合约以每个代币 100 个开始。

设法从合约中耗尽 2 个代币中的至少 1 个

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Dex -vvvvv
```

## 功能简述

```solidity
// swap的价格计算
((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)))
```

我开始有10个token1，10个token2，合约有100个token1，100个token2。

1. 我用10个token1换10个token2，因为 (10*100)/100 = 10 。 第一次swap后，我就有0个token1，20个token2；合约有110个token1，90个token2。
2. 我用20个token2换24个token1，因为 (20*110)/90 = 24 。第二次swap后，我就有24个token1，0个token2；合约有86个token1，110个token2。
3. 我用24个token1换30个token2，因为 (24*110)/86 = 30  。第三次swap后，我就有0个token1，30个token2；合约有110个token1，80个token2。
4. 我用30个token2换41个token1，因为 (30*110)/80 = 41  。第四次swap后，我就有41个token1，0个token2；合约有69个token1，110个token2。
5. 我用41个token1换65个token2，因为 (41*110)/69 = 65 。 第五次swap后，我就有0个token1，65个token2；合约有110个token1， 45个token2。
6. 我用45个token2换了110token1，因为 (45*110)/45 = 110 。第六次swap后，我就有110个token1，20个token2；合约有0个token1， 90个token2。

至此，经过6轮，合约中的token1已经被扫空了。



从任何单一来源获取价格或任何类型的数据是智能合约中的一个巨大的攻击方向。

从这个例子中可以清楚地看到，拥有大量资金的人可以一举操纵价格，并导致任何依赖它的应用程序使用错误的价格。

交易所本身是去中心化的，但资产的价格是中心化的，因为它来自 1 个 dex。这就是我们需要[预言机](https://betterprogramming.pub/what-is-a-blockchain-oracle-f5ccab8dbd72?source=friends_link&sk=d921a38466df8a9176ed8dd767d8c77d)的原因。预言机是将数据传入和传出智能合约的方法。我们应该从多个独立的分散来源获取我们的数据，否则我们可能会冒这个风险。

[Chainlink Data Feeds](https://docs.chain.link/docs/get-the-latest-price)是一种安全、可靠的方式，可以将去中心化数据传输到您的智能合约中。他们拥有包含许多不同来源的庞大库，还提供[安全随机性](https://docs.chain.link/docs/chainlink-vrf)、进行[任何 API 调用的](https://docs.chain.link/docs/make-a-http-get-request)能力、[模块化预言机网络创建](https://docs.chain.link/docs/architecture-decentralized-model)、[维护、操作和维护](https://docs.chain.link/docs/kovan-keeper-network-beta)以及无限定制。

[Uniswap TWAP Oracles依赖于称为](https://uniswap.org/docs/v2/core-concepts/oracles/)[TWAP 的](https://en.wikipedia.org/wiki/Time-weighted_average_price#)时间加权价格模型。虽然设计可能很有吸引力，但该协议在很大程度上取决于 DEX 协议的流动性，如果流动性太低，价格很容易被操纵。