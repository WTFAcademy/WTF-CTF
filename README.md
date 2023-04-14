# WTF-CTF [![tests](https://github.com/WTFAcademy/WTF-CTF/actions/workflows/ci.yml/badge.svg?label=tests)](https://github.com/WTFAcademy/WTF-CTF/actions/workflows/ci.yml) ![license](https://img.shields.io/github/license/WTFAcademy/WTF-CTF?label=license) ![solidity](https://img.shields.io/badge/solidity-^0.8.19-green) [![Foundry - ^0.8.0](https://img.shields.io/static/v1?label=Foundry&message=^0.8.0&color=black&logo=ethereum&logoColor=white)](https://book.getfoundry.sh/)


Collect CTFs related to evm, and provide solutions, using [Foundry](https://book.getfoundry.sh/). 收集 EVM 类的 CTF 挑战，并提供解决方案。

Lead by [flyq](https://github.com/flyq)

## 使用说明

如果需要运行所有的测试：
```sh
$ git clone https://github.com/WTFAcademy/WTF-CTF.git

$ cd ./WTF-CTF

$ forge install

$ forge test -vvv 
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
