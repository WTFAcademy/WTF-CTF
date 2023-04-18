// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PublicKeyChallenge {
    address owner = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
    bool public isComplete;

    function authenticate(bytes memory publicKey) public {
        require(address(uint160(uint256(keccak256(publicKey)))) == owner);

        isComplete = true;
    }
}
