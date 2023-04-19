use crypto_bigint::modular::runtime_mod::{DynResidue, DynResidueParams};
use crypto_bigint::{Wrapping, U256 as BU256};
use ethers::{
    core::types::{H256, U256},
    providers::{Http, Middleware, Provider},
    types::transaction::eip2718::TypedTransaction,
};
use eyre::Result;
use std::{env, fmt, process::exit, str::FromStr};

pub struct Signature {
    /// R value
    pub r: U256,
    /// S Value
    pub s: U256,
    /// V value
    pub v: u64,
    /// hash
    pub hash: H256,
}

impl fmt::Debug for Signature {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Signature ")?;
        write!(f, "r: 0x{:x} ", self.r)?;
        write!(f, "s: 0x{:x} ", self.s)?;
        write!(f, "v: {:?} ", self.v)?;
        write!(f, "hash: {:?}\n", self.hash)?;

        Ok(())
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() != 2 {
        println!("usage: priv_key [get_tx/get_key]");
        exit(1);
    }

    if args[1] == "get_tx".to_string() {
        let provider = Provider::<Http>::try_from(
            "https://goerli.infura.io/v3/e65f012a4dcb40f09fbcfccb10a355d8",
        )?;

        let tx_hashs: Vec<H256> = vec![
            H256::from_str("0x51b2e167c96cb0c49bf0a81974dfedff51b7586270ec62f5569d2503ebc3ba07")?,
            H256::from_str("0x03c236e0204730b6639e05adb9060f72932179822c3bf9842e42649447fe5761")?,
        ];

        let mut signatures: Vec<Signature> = Vec::new();

        for hash in tx_hashs {
            let tx = provider.get_transaction(hash).await?.unwrap();
            let typed_tx: TypedTransaction = (&tx).into();
            let sign_hash = typed_tx.sighash();

            let signature = Signature {
                r: tx.r,
                s: tx.s,
                v: tx.v.as_u64(),
                hash: sign_hash,
            };
            signatures.push(signature);
        }

        println!("signatures: {:x?}", signatures);
        Ok(())
    } else if args[1] == "get_key" {
        let hash0 =
            BU256::from_be_hex("89cdf07d31fa0f2ad08362754e1cc7b555002b1838d423c176c686862d021693");

        let _r0 =
            BU256::from_be_hex("79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798");

        let s0 =
            BU256::from_be_hex("6be76413a3d3ba49034be459bf55f7a026164de3baf534630aad3b1db9026744");

        let hash1 =
            BU256::from_be_hex("ffd4ff16d839a1db7a11d301da5b21a5fbf39bc11c847885bb3b4a504e519e89");

        let r1 =
            BU256::from_be_hex("79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798");

        let s1 =
            BU256::from_be_hex("1e118d52b5ecb3065325ab19b46bae6deda51e5a10a3171470b05fa4f5e45207");

        let p =
            BU256::from_be_hex("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141");

        let modulo = DynResidueParams::new(&p);

        let delta_hash = hash0.sub_mod(&hash1, &p);
        let delta_s = s0.sub_mod(&s1, &p);

        let temp = DynResidue::new(&delta_s, modulo);
        let inv_delta_s: BU256 = temp.invert().0.retrieve();
        let temp = DynResidue::new(&r1, modulo);
        let inv_r1 = temp.invert().0.retrieve();

        let winv_delta_s = Wrapping(inv_delta_s);
        let wdelta_hash = Wrapping(delta_hash);
        let ws1 = Wrapping(s1);
        let whash1 = Wrapping(hash1);
        let winv_r1 = Wrapping(inv_r1);

        let ws0 = Wrapping(s0);
        let whash0 = Wrapping(hash0);
        let winv_r0 = Wrapping(inv_r1);

        let key = (winv_delta_s * wdelta_hash * ws1 - whash1) * winv_r1;

        let key0 = (winv_delta_s * wdelta_hash * ws0 - whash0) * winv_r0;

        println!("key: {:?}", key.0);

        println!("key0: {:?}", key0.0);

        Ok(())
    } else {
        println!("usage: priv_key [get_tx/get_key]");
        exit(1);
    }
}
