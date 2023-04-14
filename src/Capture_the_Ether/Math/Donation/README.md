cast abi-encode "f(bytes)" $(solc ./src/Capture_the_Ether/Math/Donation/DonationChallenge.sol --bin --optimize | tail -1)
forge test -C src/Capture_the_Ether/Math/Donation --ffi -vvv