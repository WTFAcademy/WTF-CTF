# Public Key

## 题目描述

[原题链接](https://capturetheether.com/challenges/accounts/public-key/)

原题目要求 PublicKeyChallenge 合约的 isComplete 状态变量为 true。但是原题 owner 地址仅在 Ropsten test network 有交易，Ropsten test network 已经关闭，因此在不损失一般性的情况下，我们将 Challenge 里面的 owner 修改为 vitalik.eth 的地址：`0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045`。

## 运行

**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**安装 Rust**
```sh
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
并根据提示继续操作。

**从交易获取公钥**

```sh
$ cd WTF-CTF

$ cargo run --bin pubkey
   Compiling pubkey v0.1.0 (/Users/flyq/workspace/github/flyq/WTF-CTF/src/Capture_the_Ether/Accounts/Public_Key/pubkey)
    Finished dev [unoptimized + debuginfo] target(s) in 1.52s
     Running `target/debug/pubkey`
public key: e95ba0b752d75197a8bad8d2e6ed4b9eb60a1e8b08d257927d0df4f3ea6860992aac5e614a83f1ebe4019300373591268da38871df019f694f8e3190e493e711
address: 0xd8da6bf26964af9d7eed9e03e53415d37aa96045
```
Rust 源码在 [Public_Key/pubkey](./pubkey/)

将 public key 添加到 PublicChallenge.t.sol（已添加好），直接运行测试：

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Accounts/Public_Key -vvv
```

## 功能简述

这个 Challenge 需要找到指定地址的公钥。我们通过在链上获取该地址发起的交易，里面包含签名，可以恢复出公钥。

在 pubkey rust 代码中，先用 ethers 从链上获取某笔交易，并从交易中获取签名用的 hash（和 tx hash 还不一样），以及签名的字段：v, r, s。

然后使用一些 crypto 库，k256 以及 elliptic_curve 恢复出公钥。
