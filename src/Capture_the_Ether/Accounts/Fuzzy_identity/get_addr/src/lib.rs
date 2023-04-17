use sha3::{Digest, Keccak256};

/// Deterministically calculates the address a contract will be deployed to using `CREATE2`.
///
/// This implements the following formula https://eips.ethereum.org/EIPS/eip-1014
pub fn calc_addr(address: &[u8; 20], salt: &[u8; 32], init_code: &[u8]) -> [u8; 20] {
    let mut hasher = Keccak256::new();
    hasher.update(init_code);

    let mut code_hash = [0; 32];
    code_hash.copy_from_slice(&hasher.finalize());
    calc_addr_with_hash(address, salt, &code_hash)
}

pub fn calc_addr_with_hash(address: &[u8; 20], salt: &[u8; 32], code_hash: &[u8; 32]) -> [u8; 20] {
    let mut buf = [0; 85];

    buf[0] = 0xFF;
    buf[1..21].copy_from_slice(address);
    buf[21..53].copy_from_slice(salt);
    buf[53..85].copy_from_slice(code_hash);

    let mut hasher = Keccak256::new();
    hasher.update(&buf[..]);

    let mut ret = [0; 20];
    ret.copy_from_slice(&hasher.finalize()[12..32]);
    ret
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn simple() {
        let addr = calc_addr(&[0; 20], &[0; 32], &[0; 1]);

        assert_eq!(
            addr.to_vec(),
            hex::decode("4D1A2e2bB4F88F0250f26Ffff098B0b30B26BF38").expect("valid addr")
        )
    }

    #[test]
    fn more_complex() {
        let mut addr = [0; 20];
        let mut salt = [0; 32];
        let init_code = hex::decode("deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef").expect("valid code");

        hex::decode_to_slice("deadbeef", &mut addr[16..]).expect("valid addr");
        hex::decode_to_slice("cafebabe", &mut salt[28..]).expect("valid salt");

        let addr = calc_addr(&addr, &salt, &init_code);

        assert_eq!(
            addr.to_vec(),
            hex::decode("1d8bfDC5D46DC4f61D6b6115972536eBE6A8854C").expect("valid addr")
        )
    }
}
