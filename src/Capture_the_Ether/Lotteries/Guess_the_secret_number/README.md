# Guess the secret number

## 题目描述

[原题链接](https://capturetheether.com/challenges/lotteries/guess-the-secret-number/)

原题目要求 GuessTheSecretNumberChallenge 合约的 ether 余额为 0。而调用 guess 并输入答案，如果答案的 hash 等于 answerHash 即可转移 ether 出去。

## 运行

**安装 Foundry**

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境。

**安装 Rust**
```sh
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
并根据提示继续操作。

**获取 secret number**
```sh
$ cd WTF-CTF

$ cargo run --bin get_hash
keccak256(170): "db81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365"
```
即获得 secret 为 170。具体 rust 代码在 [get_hash](./get_hash/)

**运行测试**

```sh
$ cd WTF-CTF

$ forge test -C src/Capture_the_Ether/Lotteries/Guess_the_secret_number -vvv
```

## 功能简述

因为 guess 的参数是 uint8 类型，因此解空间大小为 256，我们可以在链下暴力破解：
```rs
fn main() {
    for i in 0..=255 {
        let mut hasher = Keccak256::default();
        hasher.update(&[i]);
        let bytes_i = hasher.finalize().to_vec();
        let hex_i = hex::encode(bytes_i);
        if hex_i.contains("db81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365") {
            println!("keccak256({}): {:?}", i, hex_i);
        }
    }
}
```
通过遍历 0-256 的 hash，如果有等于 `answerHash` 的，输出结果。


在测试合约中的 setUp，我们先给 hacker 转入 1 ether 用于后续调用 guess，然后创建 GuessTheSecretNumberChallenge
```solidity
    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheSecretNumberChallenge = new GuessTheSecretNumberChallenge{value: 1 ether}();
    }
```

在测试合约的 testGuessTheSecretNumber 中，我们调用 guess，设置参数为 170，并携带 1 ether 就能成功完成挑战
```solidity
        vm.startPrank(hacker);
        guessTheSecretNumberChallenge.guess{value: 1 ether}(170);
        vm.stopPrank();
```