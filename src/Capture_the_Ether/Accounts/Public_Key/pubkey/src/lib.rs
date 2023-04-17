use elliptic_curve::{consts::U32, sec1::ToEncodedPoint};
use ethers::{core::types::U256, types::Address};
use generic_array::GenericArray;
use k256::{
    ecdsa::{
        Error, RecoveryId, Signature as RecoverableSignature, Signature as K256Signature,
        VerifyingKey,
    },
    PublicKey as K256PublicKey,
};
use tiny_keccak::{Hasher, Keccak};

/// An ECDSA signature
pub struct Signature {
    /// R value
    pub r: U256,
    /// S Value
    pub s: U256,
    /// V value
    pub v: u64,
}

impl Signature {
    pub fn new(r: U256, s: U256, v: u64) -> Signature {
        Signature { r, s, v }
    }

    pub fn recover_pubkey(&self, msg_hash: Vec<u8>) -> Result<Vec<u8>, Error> {
        let (recoverable_sig, recovery_id) = self.as_signature()?;

        let verify_key =
            VerifyingKey::recover_from_prehash(&msg_hash, &recoverable_sig, recovery_id)?;

        let public_key = K256PublicKey::from(&verify_key);
        let public_key = public_key.to_encoded_point(/* compress = */ false);

        Ok(public_key.as_bytes().to_vec())
    }

    pub fn recover_addr(&self, msg_hash: Vec<u8>) -> Result<Address, Error> {
        let public_key = self.recover_pubkey(msg_hash)?;

        let mut output = [0u8; 32];

        let mut hasher = Keccak::v256();
        hasher.update(&public_key[1..]);
        hasher.finalize(&mut output);

        Ok(Address::from_slice(&output[12..]))
    }

    /// Retrieves the recovery signature.
    pub fn as_signature(&self) -> Result<(RecoverableSignature, RecoveryId), Error> {
        let recovery_id = self.recovery_id();
        let signature = {
            let mut r_bytes = [0u8; 32];
            let mut s_bytes = [0u8; 32];
            self.r.to_big_endian(&mut r_bytes);
            self.s.to_big_endian(&mut s_bytes);
            let gar: &GenericArray<u8, U32> = GenericArray::from_slice(&r_bytes);
            let gas: &GenericArray<u8, U32> = GenericArray::from_slice(&s_bytes);
            K256Signature::from_scalars(*gar, *gas)?
        };

        Ok((signature, recovery_id))
    }

    /// Retrieve the recovery ID.
    pub fn recovery_id(&self) -> RecoveryId {
        let standard_v = normalize_recovery_id(self.v);
        RecoveryId::from_byte(standard_v).expect("normalized recovery id always valid")
    }
}

fn normalize_recovery_id(v: u64) -> u8 {
    match v {
        0 => 0,
        1 => 1,
        27 => 0,
        28 => 1,
        v if v >= 35 => ((v - 1) % 2) as _,
        _ => 4,
    }
}
