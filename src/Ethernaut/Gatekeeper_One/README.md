# Gatekeeper One

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xb5858B8EDE0030e46C0Ac1aaAedea8Fb71EF423C)

我最喜欢的面壁计划。

Gatekeeper One，我是你的破壁人。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Gatekeeper_One -vvvvv
```

## 功能简述

- 对于gateOne，用合约进行调用即可。

- 对于gateTwo，保证gasleft取到的gas值为8191的整数倍即可，可以在合约调用时调整call时的gas值。

    - 这里使用Foundry的console.sol合约打印执行到gateTwo()时剩余的gas值。

        我们首先将调用enter方法的gas值定为81910，此时console.log打印出81642，就是说在执行到gateTwo()时剩余的gas值为81642，也就是GatekeeperOne合约在执行gateTwo()修饰器的require()前，一共使用了81910-81642 = 268 gas值，所以，我们只需要在最初调用enter方法的gas值上加 268 gas值即可。81910 +  268 = 82178

- 对于gateThree，EVM是栈虚拟机，采用大端模式。

    - 对于gateThree part one，保证gateKey后4位与gateKey后8位转为数字后相同，即为0000abcd。
    - 对于gateThree part two，保证gateKey后8位与gateKey全16位转为数字后不同，即前8位与后8为不同，即为efgh00000000abcd。
    - 对于gateThree part three，保证账户（tx.origin）的后4位与gateKey后8位转为数字后相同，若player账户后4位为：305c。即abcd = 305c（另外：efgh != abcd = 305c）
    - 综上， gateKey为 0xabcd00000000305c（若player账户后4位为：305c）