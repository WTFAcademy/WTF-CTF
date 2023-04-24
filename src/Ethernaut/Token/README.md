## Token

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x478f3476358Eb166Cb7adE4666d04fbdDB56C407)

这一关的目标是攻破这个基础 token 合约

你最开始有20个 token, 如果你通过某种方法可以增加你手中的 token 数量,你就可以通过这一关,当然越多越好

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Token -vvvvv
```

## 功能简述

uint变量一定是大于0的；而且在0.8.0之前版本的solidity是没有内置safemath的，所以 `0 - 1` 会变成 `0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff`那莫大。

所以我们只需要给其他人转21个代币，然后我们账户的余额就会下溢出。