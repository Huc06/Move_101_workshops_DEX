module module_2::goodboy_coin;

use sui::coin::{Self, TreasuryCap, Coin};

/// One-Time Witness for the coin type.
public struct GOODBOY_COIN has drop {}

/// Called once on publish to create the currency.
/// NOTE: `init` MUST NOT be public.
fun init(witness: GOODBOY_COIN, ctx: &mut sui::tx_context::TxContext) {
    let icon = std::option::some(sui::url::new_unsafe_from_bytes(
        b"https://imgbox.com/7aR9IPLD",
    ));

    // create_currency(witness, decimals, symbol, name, description, icon_url, ctx)
    let (treasury, metadata) = coin::create_currency<GOODBOY_COIN>(
        witness,                                         // witness
        8u8,                                             // decimals: u8  ✅
        b"GDB",                                          // symbol: vector<u8>
        b"Goodboy Coin",                                 // name: vector<u8>
        b"Goodboy coin is a Standard Unregulated Coin",  // description: vector<u8>
        icon,                                            // Option<Url>
        ctx,                                             // &mut TxContext
    );

    sui::transfer::public_transfer(treasury, ctx.sender());
    sui::transfer::public_transfer(metadata, ctx.sender());
}

/// Mint a new coin with the given amount.
public fun mint(
    treasury: &mut TreasuryCap<GOODBOY_COIN>,
    amount: u64,
    ctx: &mut sui::tx_context::TxContext,
): Coin<GOODBOY_COIN> {
    coin::mint(treasury, amount, ctx)
}

/// Burn a coin and return the burned amount.
public fun burn(treasury: &mut TreasuryCap<GOODBOY_COIN>, coin: Coin<GOODBOY_COIN>): u64 {
    coin::burn(treasury, coin)
}

#[test_only]
public fun init_for_test(ctx: &mut sui::tx_context::TxContext) {
    init(GOODBOY_COIN {}, ctx);
}
