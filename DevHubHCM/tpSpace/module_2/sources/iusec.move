module iusec::iusec;

use sui::coin::{Self, TreasuryCap, Coin};
use sui::coin_registry;

/// One-Time-Witness for the token
public struct IUSEC has drop {}

/// Initialize the token with metadata
/// This function is called only once when the module is published
fun init(witness: IUSEC, ctx: &mut TxContext) {
    // Create the currency with metadata using coin_registry
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        6, // Decimals
        b"IUSEC".to_string(), // Symbol
        b"IU Security".to_string(), // Name
        b"Community token of IU Security".to_string(), // Description
        b"https://lh3.googleusercontent.com/a/ACg8ocI2veqTRtgSnXy6dF6-gxpcTxkUahbn0DxbD8rUDpp_wLPYONk=s360-c-no".to_string(), // Icon URL
        ctx,
    );

    let metadata_cap = builder.finalize(ctx);

    // Freeze the metadata object (standard practice)
    transfer::public_freeze_object(metadata_cap);

    // Transfer the treasury cap to the deployer
    transfer::public_transfer(treasury_cap, ctx.sender());
}

/// Mint new tokens
/// Only the holder of TreasuryCap can call this function
entry fun mint(
    treasury_cap: &mut TreasuryCap<IUSEC>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient);
}

/// Burn tokens
/// Anyone can burn their own tokens
entry fun burn(treasury_cap: &mut TreasuryCap<IUSEC>, coin: Coin<IUSEC>) {
    coin::burn(treasury_cap, coin);
}
