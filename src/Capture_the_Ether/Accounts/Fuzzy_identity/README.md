# Fuzzy identity

## 题目描述

[原题链接](https://capturetheether.com/challenges/accounts/fuzzy-identity/)

原题目要求 FuzzyIdentityChallenge 合约的 isComplete 状态变量为 true。

## 运行

**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**安装 Rust**
```sh
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
并根据提示继续操作。

**Create2 的 Nonce**

搜索符合条件的 nonce

```sh
$ cd WTF-CTF

$ cargo build -p get_addr --release

$ ./target/release/get_addr 
```
需要ban
将 nonce 添加到 Attacker.sol（这里已添加好），所以可以直接运行测试：

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Accounts/Fuzzy_identity -m testFuzzyIdentity -vvv
```

## 功能简述

这个 Challenge 需要使用某个合约调用 authenticate，对合约的要求是它的地址里面包含 `badc0de`，然后里面有个 name 函数能够返回 `smarx`。

我们需要让 hacker 部署一个 Factory 合约，它里面使用 create2 来部署 Attacker 合约，通过大量尝试 create2 的不同 nonce 来获取能够满足条件的 Attacker 地址。

根据 [Factory.sol](./Factory.sol) 里面，create2 确定地址需要 factory 地址，要部署合约的 bytecode，nonce。因此我们先运行 testGetBytecodeAndFactoryAddr 获取 factory 地址，以及 bytecode：

```sh
$ forge test -C src/Capture_the_Ether/Accounts/Fuzzy_identity -m testGetBytecodeAndFactoryAddr -vvv

[PASS] testGetBytecodeAndFactoryAddr() (gas: 21073)
Logs:
  factory address: 0x5020029b077577aae04d569234b7fefa73e33784
  bytecode: 0x608060405234801561001057600080fd5b50610121806100206000396000f3fe6080604052348015600f57600080fd5b506004361060325760003560e01c806306fdde031460375780636c4c174f146052575b600080fd5b640e6dac2e4f60db1b60405190815260200160405180910390f35b6061605d36600460bd565b6063565b005b6000819050806001600160a01b031663380c7a676040518163ffffffff1660e01b8152600401600060405180830381600087803b15801560a257600080fd5b505af115801560b5573d6000803e3d6000fd5b505050505050565b60006020828403121560ce57600080fd5b81356001600160a01b038116811460e457600080fd5b939250505056fea2646970667358221220fc6cbe37060c23bc84c7e434ee1e21e1304fd6a3a1ae223a7643f28b0fa784aa64736f6c63430008130033
  attacker address: 0x090482e2692adf575ee1d7296643441360da10a7
```

然后修改 rust 代码并运行：
```sh
$ cargo build -p get_addr  --release

$ ./target/release/get_addr 
addr: e9d72e839b9ce9506f0c9a9725ce7badc0de6572, nonce: 11044009889962758569
```

e9d72e839b9ce9506f0c9a9725ce7`badc0de`6572

rust 源码在 [Fuzzy_identity/get_addr](./get_addr/)。

大概跑了 40+s 就出结果了。

然后修改 testFuzzyIdentity，将 nonce 设置为 11044009889962758569 Attacker


# reference
* https://github.com/lightclient/create2
* https://solidity-by-example.org/app/create2/