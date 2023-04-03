# WTF-CTF [![tests](https://github.com/WTFAcademy/WTF-CTF/actions/workflows/ci.yml/badge.svg?label=tests)](https://github.com/WTFAcademy/WTF-CTF/actions/workflows/ci.yml) ![license](https://img.shields.io/github/license/WTFAcademy/WTF-CTF?label=license) ![solidity](https://img.shields.io/badge/solidity-^0.8.19-green) [![Foundry - ^0.8.0](https://img.shields.io/static/v1?label=Foundry&message=^0.8.0&color=black&logo=ethereum&logoColor=white)](https://book.getfoundry.sh/)


CTF（Capture The Flag，夺旗赛）是一种网络安全竞赛，源于黑客和网络安全社区。CTF比赛通常由一系列安全挑战组成，参赛者需要发挥他们的技术、创造力和解决问题的能力，以找出并利用各种网络安全漏洞来完成任务。比赛的目的是让参赛者在模拟的真实场景中学习和练习网络安全技能。

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
