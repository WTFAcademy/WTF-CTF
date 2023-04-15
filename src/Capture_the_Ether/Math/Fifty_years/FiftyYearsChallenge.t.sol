// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/utils/BytesDeployer.sol";

interface IFiftyYearsChallenge {
    function isComplete() external view returns (bool);
    function upsert(uint256, uint256) external payable;
    function withdraw(uint256) external;
}

contract FiftyYearsChallengeTest is Test {
    IFiftyYearsChallenge public fiftyYearsChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        Deployer deployer = new Deployer();
        fiftyYearsChallenge = IFiftyYearsChallenge(
            deployer.deployContract{value: 1 ether}("src/Capture_the_Ether/Math/Fifty_years/FiftyYearsChallenge.sol")
        );
    }

    function testFiftyYears() public {
        vm.startPrank(hacker);
    }
}
