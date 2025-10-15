module module_2::upbo_coin;

use sui::coin::{Self, TreasuryCap, Coin};
use sui::coin_registry;

// === Structs ===

/// OTW for the coin.
public struct UPBO_COIN has drop {}

// === Functions ===

/// Module initializer is called once on module publish. A `TreasuryCap` is sent
/// to the publisher, who then controls minting and burning. `MetadataCap` is also
/// sent to the Publisher.
fun init(witness: UPBO_COIN, ctx: &mut TxContext) {
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        8, // Decimals
        b"UPBO".to_string(), // Symbol
        b"Upbo Coin".to_string(), // Name
        b"Upbo coin is a Standard Unregulated Coin".to_string(), // Description
        b"https://imgbox.com/uc3OWNeu".to_string(), // Icon URL
        ctx,
    );
    let metadata_cap = builder.finalize(ctx);
    // Freezing this object makes the metadata immutable, including the title, name, and icon image.
    // If you want to allow mutability, share it with public_share_object instead.
    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_transfer(metadata_cap, ctx.sender());
}

/// Mint a new coin with the given amount.
public fun mint(
    treasury: &mut TreasuryCap<UPBO_COIN>,
    amount: u64,
    ctx: &mut TxContext,
): Coin<UPBO_COIN> {
    coin::mint(treasury, amount, ctx)
}

/// Burn the given coin and return the burned amount.
public fun burn(treasury: &mut TreasuryCap<UPBO_COIN>, coin: Coin<UPBO_COIN>): u64 {
    coin::burn(treasury, coin)
}

#[test_only]
public fun init_for_test(ctx: &mut TxContext) {
    init(UPBO_COIN {}, ctx);
}
