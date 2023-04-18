use get_addr::calc_addr;
use rand::Rng;

fn main() {
    let factory_addr =
        hex::decode("5020029b077577aae04d569234b7fefa73e33784").expect("address must be in hex");
    let code = hex::decode("608060405234801561001057600080fd5b50610121806100206000396000f3fe6080604052348015600f57600080fd5b506004361060325760003560e01c806306fdde031460375780636c4c174f146052575b600080fd5b640e6dac2e4f60db1b60405190815260200160405180910390f35b6061605d36600460bd565b6063565b005b6000819050806001600160a01b031663380c7a676040518163ffffffff1660e01b8152600401600060405180830381600087803b15801560a257600080fd5b505af115801560b5573d6000803e3d6000fd5b505050505050565b60006020828403121560ce57600080fd5b81356001600160a01b038116811460e457600080fd5b939250505056fea2646970667358221220fc6cbe37060c23bc84c7e434ee1e21e1304fd6a3a1ae223a7643f28b0fa784aa64736f6c63430008130033").expect("code must be in hex");

    let mut rng = rand::thread_rng();

    let mut fixed_addr = [0; 20];
    let mut fixed_salt = [0; 32];

    fixed_addr.copy_from_slice(&factory_addr[0..20]);

    loop {
        let salt: u64 = rng.gen();
        fixed_salt[24..32].copy_from_slice(&salt.to_be_bytes());
        let addr = calc_addr(&fixed_addr, &fixed_salt, &code);
        let addr = hex::encode(addr);

        if addr.contains("badc0de") {
            println!("addr: {}, nonce: {}", addr, salt);
            break;
        }
    }
}
