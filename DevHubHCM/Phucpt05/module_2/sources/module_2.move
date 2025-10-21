module module_2::brian_coin;

use sui::coin::{Self, TreasuryCap, Coin};
use sui::url;

public struct BRIAN_COIN has drop {}

fun init(witness: BRIAN_COIN, ctx: &mut TxContext) {
    let (treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        8, // Decimals
        b"Brian", // Symbol
        b"Brian Coin", // Name
        b"Brian coin is a Standard Unregulated Coin", // Description
        option::some(
            url::new_unsafe_from_bytes(
                b"https://phucqb.sirv.com/vote_yes_img.jpg",
            ),
        ),
        ctx,
    );
    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap, ctx.sender());
}

/// Mint a new coin with the given amount.
public fun mint(
    treasury: &mut TreasuryCap<BRIAN_COIN>,
    amount: u64,
    ctx: &mut TxContext,
): Coin<BRIAN_COIN> {
    coin::mint(treasury, amount, ctx)
}

entry fun mint_token(treasury_cap: &mut TreasuryCap<BRIAN_COIN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury_cap, 100000, ctx);
    transfer::public_transfer(coin_object, ctx.sender())
}
/// Burn the given coin and return the burned amount.
public fun burn(treasury: &mut TreasuryCap<BRIAN_COIN>, coin: Coin<BRIAN_COIN>): u64 {
    coin::burn(treasury, coin)
}
