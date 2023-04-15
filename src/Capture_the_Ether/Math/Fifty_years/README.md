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

编译 `FiftyYearsChallenge.sol` 时会产生一些 warning，并导致 foundry-evm 产生一个 stderr，因为 [solc 无法忽略 warning](https://github.com/ethereum/solidity/issues/2675)。不过并不会影响测试的通过，忽略就好。

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Math/Fifty_years --ffi -vvv
```

## 功能简述

这个 Challenge 同样利用了未初始化的 storage 指针会修改 storage slot 0,1...，具体可以先完成 Mapping，Donation。

这个合约锁定了一定量的 ether，直到 50 年后才能提取。在此期间 Player 可以调用 upsert 继续存，并会导致一系列的 storage 的修改。我们需要怎么 hack 才能实现马上提取 ether 的目标？


forge-std/Test.sol 要求 solidity 版本大于等于 0.6.2: `pragma solidity >=0.6.2 <0.9.0`。也就是说，我们测试文件 `DonationChallenge.t.sol` 是无法 import `DonationChallenge.sol`。我们需要使用 0.4.26 版本的编译器单独编译并且部署 `DonationChallenge.sol`

为了能够复现这个 Challenge，我们需要一个 `BytesDeployer.sol`。
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

这个合约使用了 forge ffi 作弊码，它允许开发者执行任意 shell 命令并捕获输出。我们需要使用它来获取 `FiftyYearsChallenge.sol` 的 bytescode。合约里面的命令相当于在 terminal 执行 `cast abi-encode "f(bytes)" $(solc ./src/Capture_the_Ether/Math/F/DonationChallenge.sol --bin --optimize | tail -1)` 然后使用 assembly 部署合约，并返回新合约地址。

然后在 DonationChallenge.t.sol 合约中 setUp 函数中利用 Deployer 部署好 DonationChallenge。

到现在，我们可以来解决 DonationChallenge。思路就是利用 donate 里面的未初始化的 storage 指针来修改 owner 的值（位于 storage slot 1）

我们将自己的地址 hacker 作为 donate 的参数 etherAmount，并且 msg.value 为 `etherAmount / 10^36`，就能通过 donate 的检查，成功修改 owner 为 hacker。然后调用 withdraw 即可。
