# WTF-CTF [![tests](https://github.com/WTFAcademy/WTF-CTF/actions/workflows/ci.yml/badge.svg?label=tests)](https://github.com/WTFAcademy/WTF-CTF/actions/workflows/ci.yml) ![license](https://img.shields.io/github/license/WTFAcademy/WTF-CTF?label=license) ![solidity](https://img.shields.io/badge/solidity-^0.8.19-green) [![Foundry - ^0.8.0](https://img.shields.io/static/v1?label=Foundry&message=^0.8.0&color=black&logo=ethereum&logoColor=white)](https://book.getfoundry.sh/)


Collect CTFs related to evm, and provide solutions, using [Foundry](https://book.getfoundry.sh/). 收集 EVM 类的 CTF 挑战，并提供解决方案。

Lead by [flyq](https://github.com/flyq)

## 安装依赖


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

## 使用说明

如果需要运行所有的测试：
```sh
$ git clone https://github.com/WTFAcademy/WTF-CTF.git

$ cd ./WTF-CTF

$ forge install openzeppelin-contracts-05=OpenZeppelin/openzeppelin-contracts@v2.5.0 openzeppelin-contracts-06=OpenZeppelin/openzeppelin-contracts@v3.4.0 openzeppelin-contracts-08=OpenZeppelin/openzeppelin-contracts@v4.8.3

$ forge install

$ forge test --ffi -vvv 
```

如果只运行某一个挑战的测试(示例)：
```sh
$ cd ./WTF-CTF

$ forge test -C ./src/Capture_the_Ether/Warmup/Deploy_a_contract -vvv
```

## Capture the Ether

- Warmup
  - **Deploy a contract**: [代码](./src/Capture_the_Ether/Warmup/Deploy_a_contract/DeployChallenge.s.sol) | [文章](./src/Capture_the_Ether/Warmup/Deploy_a_contract/README.md)
  - **Call me**: [代码](./src/Capture_the_Ether/Warmup/Call_me/CallMeChallenge.t.sol) | [文章](./src/Capture_the_Ether/Warmup/Call_me/README.md)
  - **Chosse a nickname**: [代码](./src/Capture_the_Ether/Warmup/Choose_a_nickname/NicknameChallenge.t.sol) | [文章](./src/Capture_the_Ether/Warmup/Choose_a_nickname/README.md)
- Lotteries
  - **Guess the number**: [代码](./src/Capture_the_Ether/Lotteries/Guess_the_number/GuessTheNumberChallenge.t.sol) | [文章](./src/Capture_the_Ether/Lotteries/Guess_the_number/README.md)
  - **Guess the secret number**: [代码](./src/Capture_the_Ether/Lotteries/Guess_the_secret_number/GuessTheSecretNumberChallenge.t.sol) | [文章](./src/Capture_the_Ether/Lotteries/Guess_the_secret_number/README.md)
  - **Guess the random number**: [代码](./src/Capture_the_Ether/Lotteries/Guess_the_random_number/GuessTheRandomNumberChallenge.t.sol) | [文章](./src/Capture_the_Ether/Lotteries/Guess_the_random_number/README.md)
  - **Guess the new number**: [代码](./src/Capture_the_Ether/Lotteries/Guess_the_new_number/Attacker.sol) | [文章](./src/Capture_the_Ether/Lotteries/Guess_the_new_number/README.md)
  - **Predict the future**: [代码](./src/Capture_the_Ether/Lotteries/Predict_the_future/Attacker.sol) ｜ [文章](./src/Capture_the_Ether/Lotteries/Predict_the_future/README.md)
  - **Predict the block hash**: [代码](./src/Capture_the_Ether/Lotteries/Predict_the_block_hash/PredictTheBlockHashChallenge.t.sol) | [文章](./src/Capture_the_Ether/Lotteries/Predict_the_block_hash/README.md)
- Math
  - **Token sale**: [代码](./src/Capture_the_Ether/Math/Token_sale/TokenSaleChallenge.t.sol) | [文章](./src/Capture_the_Ether/Math/Token_sale/README.md)
  - **Token whale**: [代码](./src/Capture_the_Ether/Math/Token_whale/TokenWhaleChallenge.t.sol) | [文章](./src/Capture_the_Ether/Math/Token_whale/README.md)
  - **Retirement fund**: [代码](./src/Capture_the_Ether/Math/Retirement_fund/RetirementFundChallenge.t.sol) | [文章](./src/Capture_the_Ether/Math/Retirement_fund/README.md)
  - **Mapping**: [代码](./src/Capture_the_Ether/Math/Mapping/MappingChallenge.t.sol) | [文章](./src/Capture_the_Ether/Math/Mapping/README.md)
  - **Donation**: [代码](./src/Capture_the_Ether/Math/Donation/DonationChallenge.t.sol) | [文章](./src/Capture_the_Ether/Math/Donation/README.md)
  - **Fifty years**: [代码](./src/Capture_the_Ether/Math/Fifty_years/FiftyYearsChallenge.t.sol) | [文章](./src/Capture_the_Ether/Math/Fifty_years/README.md)
- Accounts
  - **Fuzzy identity**: [代码](./src/Capture_the_Ether/Accounts/Fuzzy_identity/FuzzyIdentityChallenge.t.sol) ｜ [文章](./src/Capture_the_Ether/Accounts/Fuzzy_identity/README.md)
  - **Public Key**: [代码](./src/Capture_the_Ether/Accounts/Public_Key/PublicKeyChallenge.t.sol) | [文章](./src/Capture_the_Ether/Accounts/Public_Key/README.md)
  - **Account Takeover** [代码](./src/Capture_the_Ether/Accounts/Account_Takeover/AccountTakeoverChallenge.t.sol) | [文章](./src/Capture_the_Ether/Accounts/Account_Takeover/README.md)
- Miscellaneous
  - **Assume ownership**: [代码](./src/Capture_the_Ether/Miscellaneous/Assume_ownership/AssumeOwnershipChallenge.t.sol) | [文章](./src/Capture_the_Ether/Miscellaneous/Assume_ownership/README.md)
  - **Token bank**: [代码](./src/Capture_the_Ether/Miscellaneous/Token_bank/TokenBankChallenge.t.sol) | [文章](./src/Capture_the_Ether/Miscellaneous/Token_bank/README.md)

## Ethernaut

- **Hello Ethernaut**: [代码](./src/Ethernaut/Hello_Ethernaut/Instance.t.sol) | [文章](./src/Ethernaut/Hello_Ethernaut/README.md)
- **Fallback**: [代码](./src/Ethernaut/Fallback/Fallback.t.sol) | [文章](./src/Ethernaut/Fallback/README.md)
- **Coin Flip**: [代码](./src/Ethernaut/Coin_Flip/CoinFlip.t.sol) |  [文章](./src/Ethernaut/Coin_Flip/README.md)
- **Telephone**: [代码](./src/Ethernaut/Telephone/Telephone.t.sol) |  [文章](./src/Ethernaut/Telephone/README.md)
- **Token**: [代码](./src/Ethernaut/Token/Token.t.sol) |  [文章](./src/Ethernaut/Token/README.md)
- **Delegation**: [代码](./src/Ethernaut/Delegation/Delegation.t.sol) |  [文章](./src/Ethernaut/Delegation/README.md)
- **Force**: [代码](./src/Ethernaut/Force/Force.t.sol) |  [文章](./src/Ethernaut/Force/README.md)
- **Vault**: [代码](./src/Ethernaut/Vault/Vault.t.sol) |  [文章](./src/Ethernaut/Vault/README.md)
- **King**: [代码](./src/Ethernaut/King/King.t.sol) |  [文章](./src/Ethernaut/King/README.md)
- **Re-entrancy**: [代码](./src/Ethernaut/Re-entrancy/Reentrance.t.sol) |  [文章](./src/Ethernaut/Re-entrancy/README.md)
- **Elevator**: [代码](./src/Ethernaut/Elevator/Elevator.t.sol) |  [文章](./src/Ethernaut/Elevator/README.md)
- **Privacy**: [代码](./src/Ethernaut/Privacy/Privacy.t.sol) |  [文章](./src/Ethernaut/Privacy/README.md)
- **Gatekeeper One**: [代码](./src/Ethernaut/Gatekeeper_One/GatekeeperOne.t.sol) | [文章](./src/Ethernaut/Gatekeeper_One/README.md)
- **Gatekeeper Two**: [代码](./src/Ethernaut/Gatekeeper_Two/GatekeeperTwo.t.sol) |  [文章](./src/Ethernaut/Gatekeeper_Two/README.md)
- **Naught Coin**: [代码](./src/Ethernaut/Naught_Coin/NaughtCoin.t.sol) |  [文章](./src/Ethernaut/Naught_Coin/README.md)
- **Preservation**: [代码](./src/Ethernaut/Preservation/Preservation.t.sol) |  [文章](./src/Ethernaut/Preservation/README.md)
- **Recovery**: [代码](./src/Ethernaut/Recovery/Recovery.t.sol) |  [文章](./src/Ethernaut/Recovery/README.md)
- **MagicNumber**: [代码](./src/Ethernaut/MagicNumber/MagicNum.t.sol) |  [文章](./src/Ethernaut/MagicNumber/README.md)
- **Alien Codex**: [代码](./src/Ethernaut/Alien_Codex/AlienCodex.t.sol) |  [文章](./src/Ethernaut/Alien_Codex/README.md)
- **Denial**: [代码](./src/Ethernaut/Denial/Denial.t.sol) | [文章](./src/Ethernaut/Denial/README.md)
- **Shop**: [代码](./src/Ethernaut/Shop/Shop.t.sol) |  [文章](./src/Ethernaut/Shop/README.md)
- **Dex**: [代码](./src/Ethernaut/Dex/Dex.t.sol) |  [文章](./src/Ethernaut/Dex/README.md)
- **Dex Two**: [代码](./src/Ethernaut/Dex_Two/DexTwo.t.sol) | [文章](./src/Ethernaut/Dex_Two/README.md)
- **Puzzle Wallet**: [代码](./src/Ethernaut/Puzzle_Wallet/PuzzleWallet.t.sol) |  [文章](./src/Ethernaut/Puzzle_Wallet/README.md)
- **Motorbike**: [代码](./src/Ethernaut/Motorbike/Motorbike.t.sol) |  [文章](./src/Ethernaut/Motorbike/README.md)
- **DoubleEntryPoint**: [代码](./src/Ethernaut/DoubleEntryPoint/DoubleEntryPoint.t.sol) |  [文章](./src/Ethernaut/DoubleEntryPoint/README.md)
- **Good Samaritan**: [代码](./src/Ethernaut/Good_Samaritan/GoodSamaritan.t.sol) |  [文章](./src/Ethernaut/Good_Samaritan/README.md)
- **Gatekeeper Three**: [代码](./src/Ethernaut/Gatekeeper_Three/GatekeeperThree.t.sol) |  [文章](./src/Ethernaut/Gatekeeper_Three/README.md)
- **Switch**: [代码](./src/Ethernaut/Switch/Switch.t.sol) | [文章](./src/Ethernaut/Switch/README.md)

## 参考

* [Capture the Ether](https://capturetheether.com/)
* [Ethernaut](https://ethernaut.openzeppelin.com/)
* [Damn Vulnerable DeFi](https://www.damnvulnerabledefi.xyz/)
* [Paradigm CTF](https://ctf.paradigm.xyz/)
* [Mr Steal Yo Crypto](https://mrstealyocrypto.xyz/)
* [QuillCTF](https://quillctf.super.site/)
* Lists
  * [Blocksec CTFs](https://github.com/blockthreat/blocksec-ctfs)
  * [Awesome Ethereum Security](https://github.com/crytic/awesome-ethereum-security)
  * [CTF Blockchain Challenges](https://github.com/minaminao/ctf-blockchain)
  * [CTFGym](https://github.com/PumpkingWok/CTFGym)



## WTF 贡献者
<div align="center">
  <h4 align="center">
    贡献者是WTF学院的基石
  </h4>
  <a href="https://github.com/WTFAcademy/WTF-CTF/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=WTFAcademy/WTF-CTF" />
  </a>
</div>

## 使用许可
[MIT](LICENSE) (c) 2023 WTF.Academy
