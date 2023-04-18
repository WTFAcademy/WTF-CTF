// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./PublicKeyChallenge.sol";

contract PublicKeyChallengeTest is Test {
    PublicKeyChallenge public publicKeyChallenge;

    function setUp() public {
        publicKeyChallenge = new PublicKeyChallenge();
    }

    function testPublicKey() public {
        emit log_named_string("before hack, isComplete", publicKeyChallenge.isComplete() ? "true" : "false");

        bytes memory publicKey =
            hex"e95ba0b752d75197a8bad8d2e6ed4b9eb60a1e8b08d257927d0df4f3ea6860992aac5e614a83f1ebe4019300373591268da38871df019f694f8e3190e493e711";

        publicKeyChallenge.authenticate(publicKey);

        emit log_named_string("after hack, isComplete", publicKeyChallenge.isComplete() ? "true" : "false");

        assertTrue(publicKeyChallenge.isComplete());
    }
}
