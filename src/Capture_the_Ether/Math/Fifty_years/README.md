# Fifty years

## 题目描述

[原题链接](https://capturetheether.com/challenges/math/fifty-years/)

原题目要求 FiftyYearsChallenge 合约的 ether 余额为 0。最开始的时候 构造函数里面会充值 1 ether 到合约。

## 运行

**安装 Rust**

```sh
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
并根据提示继续操作。

**安装 svm**

[svm-rs](https://github.com/roynalnaruto/svm-rs) is Solidity Compiler Version Manager

```sh
$ cargo install svm-rs
```

**设置 solc 版本**

```sh
$ svm install 0.4.26

$ svm use 0.4.26

$ solc --version
```


**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Math/Fifty_years --ffi -vvv
```

## 功能简述

这个 Challenge 是 Math 下面前几个 Challenge 的“集大成者”，完成挑战需要同时使用了整型溢出，强制改变合约余额，通过未初始化 storage 指针修改前几个 storage slot 等。因此为了更方便理解，建议先完成之前的挑战。

同样，为了能够完整的复现原 Challenge，只能使用 `^0.4.21` 版本, forge-std/Test.sol 要求 solidity 版本大于等于 0.6.2: `pragma solidity >=0.6.2 <0.9.0`。也就是说，我们测试文件 `FiftyYearsChallenge.t.sol` 是无法 import `FiftyYearsChallenge.sol`。我们需要使用 0.4.26 版本的编译器单独编译并且部署 `FiftyYearsChallenge.sol`

因此我们需要一个 `BytesDeployer.sol`。
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";

contract Deployer is Test {
    ///@notice Compiles a contract before 0.6.0 and returns the address that the contract was deployed to
    ///@notice If deployment fails, an error will be thrown
    ///@param path - The path of the contract. For example, the file name for "MappingChallenge.sol" is
    /// "src/Capture_the_Ether/Math/Mapping/MappingChallenge.sol"
    ///@return deployedAddress - The address that the contract was deployed to
    function deployContract(string memory path) public payable returns (address) {
        string memory bashCommand =
            string.concat('cast abi-encode "f(bytes)" $(solc ', string.concat(path, " --bin --optimize | tail -1)"));

        string[] memory inputs = new string[](3);
        inputs[0] = "bash";
        inputs[1] = "-c";
        inputs[2] = bashCommand;

        bytes memory bytecode = abi.decode(vm.ffi(inputs), (bytes));

        ///@notice deploy the bytecode with the create instruction
        address deployedAddress;
        uint256 value = msg.value;
        assembly {
            deployedAddress := create(value, add(bytecode, 0x20), mload(bytecode))
        }

        ///@notice check that the deployment was successful
        require(deployedAddress != address(0), "YulDeployer could not deploy contract");

        ///@notice return the address that the contract was deployed to
        return deployedAddress;
    }
}
```

Deployer 使用了 forge ffi 作弊码，它允许开发者执行任意 shell 命令并捕获输出。我们需要使用它来获取 `FiftyYearsChallenge.sol` 的 bytescode。合约里面的命令相当于在 terminal 执行 `cast abi-encode "f(bytes)" $(solc ./src/Capture_the_Ether/Math/F/DonationChallenge.sol --bin --optimize | tail -1)` 然后使用 assembly 部署合约，并返回新合约地址。

这个合约锁定了一定量的 ether，直到 50 年后才能提取。在此期间 Player 可以调用 upsert 继续存，并会导致一系列的 storage 的修改。我们需要怎么 hack 才能实现马上提取 ether 的目标？

首先在 FiftyYearsChallenge.t.sol 合约中 setUp 函数中利用 Deployer 部署好 FiftyYearsChallenge。

此时 FiftyYearsChallenge 的 storage layout 为：


| slot               | var                      | value    |
| ------------------ | ------------------------ | -------- |
| slot 0             | queue.length             | 1        |
| slot 1             | head                     | 0        |
| slot 2             | owner                    | player   |
| ...                |
| slot keccak(0) + 0 | queue[0].amount          | 1 ether  |
| slot keccak(0) + 1 | queue[0].unlockTimestamp | 50 years |
| ...                |


address(this).balance = 1 ether

现在开始操作：

**第一步**

通过调用 `upsert(1, 2^256-1 days)` 来新增 queue[1]，`msg.value` 设置为 1 wei。我们一行一行来分析：
```solidity
         else {
            // Append a new contribution. Require that each contribution unlock
            // at least 1 day after the previous one.
            require(timestamp >= queue[queue.length - 1].unlockTimestamp + 1 days);

            contribution.amount = msg.value;
            contribution.unlockTimestamp = timestamp;
            queue.push(contribution);
        }
```
require 那行通过检查没问题。

`contribution.amount = msg.value` 将会修改 slot 0 为 1。

`contribution.unlockTimestamp = timestamp` 将会修改 slot 1 为 2^256-1 days。

`queue.push(contribution)` 将会**先增加** queue.length，即 slot 0 的值自增 1，在刚刚 1 的基础上变成 2。再把 slot 0 和 slot 1 的值复制 slot keccak(0) + 2 和 slot keccak(0) + 3，即 queue[1] 应该存储的位置。因此 storage layout 变为：

| slot               | var                      | value          |
| ------------------ | ------------------------ | -------------- |
| slot 0             | queue.length             | 2              |
| slot 1             | head                     | 2^256 - 1 days |
| slot 2             | owner                    | player         |
| ...                |
| slot keccak(0) + 0 | queue[0].amount          | 1 ether        |
| slot keccak(0) + 1 | queue[0].unlockTimestamp | 50 years       |
| slot keccak(0) + 2 | queue[1].amount          | 2              |
| slot keccak(0) + 3 | queue[1].unlockTimestamp | 2^256 - 1 days |
| ...                |

address(this).balance = 1 ether + 1

**第二步**

再次调用 `upsert(2, 0)` 来新增 queue[2]，`msg.value` 为 2 wei。

因为 `queue[1].unlockTimestamp + 1 days = 0 mod 2^256`， 因此 require 那行检查将会通过。

`contribution.amount = msg.value` 将会修改 slot 0 为 2。

`contribution.unlockTimestamp = timestamp` 将会修改 slot 1 为 0。

`queue.push(contribution)` 将会**先增加** queue.length，即 slot 0 的值自增 1，在刚刚 2 的基础上变成 3。再把 slot 0 和 slot 1 的值复制 slot keccak(0) + 4 和 slot keccak(0) + 5，即 queue[2] 应该存储的位置。因此 storage layout 变为：




storage layout：
| slot               | var                      | value          |
| ------------------ | ------------------------ | -------------- |
| slot 0             | queue.length             | 3              |
| slot 1             | head                     | 0              |
| slot 2             | owner                    | player         |
| ...                |
| slot keccak(0) + 0 | queue[0].amount          | 1 ether        |
| slot keccak(0) + 1 | queue[0].unlockTimestamp | 50 years       |
| slot keccak(0) + 2 | queue[1].amount          | 2              |
| slot keccak(0) + 3 | queue[1].unlockTimestamp | 2^256 - 1 days |
| slot keccak(0) + 4 | queue[1].amount          | 3              |
| slot keccak(0) + 5 | queue[1].unlockTimestamp | 0              |
| ...                |

address(this).balance = 1 ether + 3


此时调用 withdraw，在 `msg.sender.transfer(total)` 这一行，total = 1 ether + 5，而实际 address(this).balance = 1 ether + 3，因此我们需要强制转入 2 wei

**第三步**

调用 Attacker 合约强制转入 2 wei：

```solidity
contract Attacker {
    constructor(address payable target) payable {
        require(msg.value > 0);
        selfdestruct(target);
    }
}
```

**第四步**

调用 withdraw，将 FiftyYearsChallenge 合约所有的 ether balance 转走。