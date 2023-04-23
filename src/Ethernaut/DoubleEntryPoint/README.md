# DoubleEntryPoint

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x34bD06F195756635a10A7018568E033bC15F3FB5)

找出错误`CryptoVault合约`错误，并防止它被耗尽token。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/DoubleEntryPoint -vvvvv
```

## 功能简述

题目说`CryptoVault`合约中有bug。经查：定位到`CryptoVault`合约将`DoubleEntryPointToken`代币设置为`underlying`不可sweep。但如果使用`LegacyToken`代币进行`sweep`时，`LegacyToken`代币的`transfer`会调用`DoubleEntryPoint`代币的`delegateTransfer`方法进行转移。那么在`CryptoVault`合约将`DoubleEntryPointToken`代币设置为`underlying`就无效了。

bug找到，如何避免。

`Forta`提供了一种预防方法。在`DoubleEntryPointToken`代币进行`delegateTransfer`时，会进行`fortaNotify`检测。`notify`函数中对外部函数调取了`try-catch`操作，所以在`notify`中进行`revert`等终止操作，是没有效果的。

但`fortaNotify`中会检测`botRaisedAlerts`是否进行了增加。所以可以通过增加`botRaisedAlerts`，达到结束交易的工作。

所以，当我们检测到转移`CryptoVault`合约中的`DoubleEntryPoint代币`时，增加`botRaisedAlerts`，结束交易。

```solidity
function handleTransaction(address user, bytes calldata msgData) public override {
        (address to, uint256 value, address origSender) = abi.decode(msgData[4:], (address, uint256, address));
        if (origSender == cryptoVault) {
            forta.raiseAlert(user);
        }
    }
```



该题目给我们展示了一种处理合约bug的模式，除了使用代理模式实现合约可升级来处理合约中的bug。也可以在合约中实现类似Forta合约，针对合约中的函数在执行前调用外部合约来检测本次调用是否有危险操作。