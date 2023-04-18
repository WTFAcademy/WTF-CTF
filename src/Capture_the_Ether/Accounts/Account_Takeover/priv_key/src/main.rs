use ethers::{
    core::types::{H256, U256},
    providers::{Http, Middleware, Provider},
    types::transaction::eip2718::TypedTransaction,
};
use eyre::Result;
use std::str::FromStr;

#[derive(Debug)]
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

#[tokio::main]
async fn main() -> Result<()> {
    let provider = Provider::<Http>::try_from("https://eth.llamarpc.com")?;

    let tx_hashs: Vec<H256> = vec![
        H256::from_str("0xfa962bf18706bb5d87b21065cf84e5cb13240d0fd8927cacad8bf6c199391529")?,
        H256::from_str("0xbf8d8e49c72805ef11a442d3f5fe6c44c23d1260208ba61ee5cc16bc5076443f")?,
        H256::from_str("0x8d3da22c66daf11d242201928db26e436254fbd1bda65cf4f8b9e36d48621194")?,
        H256::from_str("0xb462822ffd162e02433969bdfeb2050908f8201a7d55c63d193abeb6f222db11")?,
        H256::from_str("0x3611fe9a172170ef3fd160af96b42b59ff2ba896beb26e433e98da139b39311c")?,
        H256::from_str("0x37a1539399ccebfbcad308ce2f3af9d11d19adf854c775a63fa6fee1c3103d05")?,
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

    println!("signatures: {:?}", signatures);

    Ok(())
}
