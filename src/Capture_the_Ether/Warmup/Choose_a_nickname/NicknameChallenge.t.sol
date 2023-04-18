// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./NicknameChallenge.sol";

contract NicknameChallengeTest is Test {
    CaptureTheEther public captureTheEther;
    NicknameChallenge public nicknameChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        captureTheEther = new CaptureTheEther();

        vm.startPrank(address(captureTheEther));
        nicknameChallenge = new NicknameChallenge(hacker);
        vm.stopPrank();
    }

    function testNickname() public {
        emit log_named_string(
            "before change the name, the isComplete's value", nicknameChallenge.isComplete() ? "true" : "false"
        );
        assertFalse(nicknameChallenge.isComplete());

        vm.startPrank(hacker);
        // set my name to UINT256_MAX
        captureTheEther.setNickname(bytes32(UINT256_MAX));
        vm.stopPrank();

        emit log_named_string(
            "after change the name, the isComplete's value", nicknameChallenge.isComplete() ? "true" : "false"
        );
        assertTrue(nicknameChallenge.isComplete());
    }
}
