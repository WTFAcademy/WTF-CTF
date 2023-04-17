use ethers::{
    core::types::H256,
    providers::{Http, Middleware, Provider},
    types::transaction::eip2718::TypedTransaction,
};
use eyre::Result;
use pubkey::Signature;
use std::str::FromStr;

#[tokio::main]
async fn main() -> Result<()> {
    let provider = Provider::<Http>::try_from("https://eth.llamarpc.com")?;

    let tx_hash: H256 =
        H256::from_str("0x4c45f8cb8661da76ec11c8dd1d1e7bf77685f57417be26dea97e4ea9bc05ecd4")?;
    let tx = provider.get_transaction(tx_hash).await?.unwrap();
    let typed_tx: TypedTransaction = (&tx).into();
    let sign_hash = typed_tx.sighash().as_ref().to_vec();

    let signature = Signature::new(tx.r, tx.s, tx.v.as_u64());
    let pubkey = signature.recover_pubkey(sign_hash.clone())?;
    let addr = signature.recover_addr(sign_hash)?;

    println!("public key: {}", hex::encode(&pubkey[1..]));
    println!("address: {:?}", addr);

    Ok(())
}
