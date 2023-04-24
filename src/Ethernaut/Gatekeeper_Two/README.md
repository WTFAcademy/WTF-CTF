# Gatekeeper Two

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x0C791D1923c738AC8c4ACFD0A60382eE5FF08a23)

Gatekeeper Two，我是你的破壁人。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Gatekeeper_Two -vvvvv
```

## 功能简述

- 对于gateOne，使用合约进行调用。

- 对于gateTwo，在合约在执行构造函数constructor时，此时合约的 size == 0；

- 对于gateThree，只需要进行一次逆运算即可算出_gateKey。

    ```solidity
    uint64 _gateKey = type(uint64).max ^ uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
    ```

    