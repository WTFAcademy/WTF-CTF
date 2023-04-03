// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./DeployChallenge.sol";

contract NicknameChallengeTest is Test {
    CaptureTheEther public captureTheEther;

    function setUp() public {
        captureTheEther = new CaptureTheEther();
    }

    function testSetNickname() public {
        captureTheEther.setNickname(bytes32(0x8000000000000000000000000000000000000000000000000000000000000000));

        vm.startPrank(address(captureTheEther));
        NicknameChallenge nicknameChallenge = new NicknameChallenge(address(this));
        vm.stopPrank();

        emit log_bytes32(captureTheEther.nicknameOf(address(this)));

        emit log_named_address("captureTheEther", address(captureTheEther));
        emit log_named_address("nicknameChallenge", address(nicknameChallenge));
        emit log_named_address("cte", nicknameChallenge.cteAddress());

        if (nicknameChallenge.isComplete()) {
            emit log_string("true");
        } else {
            emit log_string("false");
        }
        assertEq(nicknameChallenge.isComplete(), true);
    }

}
