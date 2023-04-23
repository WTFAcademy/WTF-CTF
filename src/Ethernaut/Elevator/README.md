# Elevator

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x6DcE47e94Fa22F8E2d8A7FDf538602B1F86aBFd2)

电梯不会让你达到大楼顶部, 对吧?

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Elevator -vvvvv
```

## 功能简述

只要两次调用`isLastFloor`方法返回的bool值不同即可。

而题目定义的`isLastFloor`接口并没有限制函数类型，所以每次调用我们可以通过`isLastFloor`方法改变攻击合约中的值，来保证两次调用的返回值不同。

```solidity
interface Building {
    function isLastFloor(uint256) external returns (bool);
}
```

你可以在接口使用 `view` 函数修改器来防止状态被篡改. `pure` 修改器也可以防止状态被篡改. 认真阅读 [Solidity's documentation](http://solidity.readthedocs.io/en/develop/contracts.html#view-functions) 并学习注意事项.

完成这一关的另一个方法是构建一个 view 函数, 这个函数根据不同的输入数据返回不同的结果, 但是不更改状态, 比如 `gasleft()`.我们将在后续的某道题中使用该方法。