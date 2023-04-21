# Account Takeover

## 题目描述

[原题链接](https://capturetheether.com/challenges/accounts/account-takeover/)

原题目要求 AccountTakeoverChallenge 合约的 isComplete 状态变量为 true。

## 运行

**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**安装 Rust**
```sh
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
并根据提示继续操作。

**从链上获取交易签名**

```sh
$ cd WTF-CTF

$ cargo run --bin priv_key get_tx
     Running `target/debug/priv_key get_tx`
signatures: [Signature r: 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798 s: 0x6be76413a3d3ba49034be459bf55f7a026164de3baf534630aad3b1db9026744 v: 45 hash: 0x89cdf07d31fa0f2ad08362754e1cc7b555002b1838d423c176c686862d021693
, Signature r: 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798 s: 0x1e118d52b5ecb3065325ab19b46bae6deda51e5a10a3171470b05fa4f5e45207 v: 46 hash: 0xffd4ff16d839a1db7a11d301da5b21a5fbf39bc11c847885bb3b4a504e519e89
]
```

**从签名获取私钥**

```sh
$ cd WTF-CTF

$ cargo run --bin priv_key get_key
key: Uint(0x2B4D29A7B86DC19BBF4F85784AF5AB452D85A3A19C49BA76696ABA45AEB9A520)
key0: Uint(0x05E173293FA43D426BD9D17FCA89D16A0CD47ADC500F8BBB77C50D2FEC1474AE)
```
Rust 源码在 [Account_Takeover/priv_key](./priv_key/)

将 private key 添加到 AccountTakeoverChallenge.t.sol（已添加好），直接运行测试：

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Accounts/Account_Takeover -vvv
```

## 功能简述

这个 Challenge 要求 msg.sender 是特定地址，`0x6B477781b0e68031109f21887e6B5afEAaEB002b`，这个容易，我们直接使用 `vm.startPrank(address(0x6B477781b0e68031109f21887e6B5afEAaEB002b))` 就行了（划掉。

根据 [etherscan](https://etherscan.io/address/0x6B477781b0e68031109f21887e6B5afEAaEB002b)，这是一个 EOA 地址。因此唯一的办法是找到这个地址的私钥。这个 Challenge 的目的是考察我们能否通过某个地址已有的 transactions 里面的不正确的随机数使用，找到它的私钥。

但是可惜的是它有问题的交易在 Ropsten test network 上，一个早已停掉的测试网。因此为了复现整个 Challenge，我魔改了 [libsecp256k1](https://github.com/flyq/libsecp256k1)，它有个致命缺陷，所有生成的签名的 r 字段都是一样的。并且使用它签署了[两笔交易](https://goerli.etherscan.io/address/0xe6984f0f9dc2930bbe0c824d6d67712a6a411062)，发送到 Goerli test network 上。然后在 `AccountTakeoverChallenge.sol` 里用新地址 `0xE6984F0F9dC2930bbe0c824d6D67712A6A411062` 代替 `0x6B477781b0e68031109f21887e6B5afEAaEB002b`。

接下来需要恢复出私钥，这对 ECDSA 有深入的了解。这里就不深入的解释相关原理，这里花了 [4 篇文章](https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/)把它讲解得足够清晰了。

$$

n = FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 \\

k = \frac{signhash_1 - signhash_2}{s_1 - s_2} \ mod \ n \\ 

key = r_1^{-1} \times (s_1 \times k - signhash_1) \ mod \ n

$$

// TODO

Rust 程序还需要根据上面的公式修改，以获取正确的私钥。

## 参考
* https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/
* https://docs.google.com/presentation/d/1_Z-0bjIM15UaZjq6lpizZCV2azGn_zcz/edit#slide=id.p1


