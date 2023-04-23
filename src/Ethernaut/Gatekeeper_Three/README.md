# Gatekeeper Three

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x5B50F1F5fE2Bef0a0429fD27B8214d856066F45e)

Gatekeeper Three，我是你的破壁人。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Gatekeeper_Three -vvvvv
```

## 功能简述

1. 对于gateOne，需要使用攻击合约调用`GatekeeperThree`合约，并且这个攻击合约地址还要是`GatekeeperThree`合约的`owner`。

    - `GatekeeperThree`合约在设置`owner`时，将构造函数`constructor`错误地写为了`construct0r`。所以攻击合约需要调用一次`construct0r`函数，成为`owner`。

        ```solidity
        GatekeeperThree(payable(gatekeeperThree)).construct0r();
        ```

2. 对于gateTwo，需要将`GatekeeperThree`合约的`allow_enterance`变量从`false`转为`true`。

    - `allow_enterance`变量只能在`getAllowance`函数中调用`trick`合约的`checkPassword`函数成功返回`true`时，才能修改为`true`。而`trick`合约的`checkPassword`函数需要判断传入的`_password`是否与合约存储的私有变量`password`相同。可链上没有私有数据。

        通过读取`trick`合约内存插槽`slot2`中存储的值，即可知道`password`。

        ```solidity
        uint256 _password =
                        uint256(vm.load(address(GatekeeperThree(payable(gatekeeperThree)).trick()), bytes32(uint256(2))));
        ```

3. 对于gateThree，需要给`GatekeeperThree`合约转大于`0.001 ether`，并且我们的攻击合约在接收`ETH`时需要失败。

    - 在调用`GatekeeperThree`合约的同时转移大于`0.001 ether`，并且在攻击合约的`receive `函数中无脑revert就好。

        ```solidity
        receive() external payable {
        	revert();
        }
        ```

        