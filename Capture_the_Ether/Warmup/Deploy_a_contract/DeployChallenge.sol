// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.19;

contract DeployChallenge {
    // This tells the CaptureTheFlag contract that the challenge is complete.
    function isComplete() public pure returns (bool) {
        return true;
    }
}
