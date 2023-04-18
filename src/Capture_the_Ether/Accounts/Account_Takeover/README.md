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

**从交易获取私钥**

```sh
$ cd WTF-CTF

$ cargo run --bin priv_key
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

但是可惜的是它有问题的交易在 Ropsten test network 上，一个早已停掉的测试网。因此为了复现整个 Challenge，我在 Goerli test network 上复现整个操作，并用新地址代替 `0x6B477781b0e68031109f21887e6B5afEAaEB002b`

