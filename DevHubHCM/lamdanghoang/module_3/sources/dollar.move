module module_3::dollar;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::coin_registry;

public struct DOLLAR has drop {}

fun init(witness: DOLLAR, ctx: &mut TxContext) {
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        6,
        b"DOLLAR".to_string(),
        b"Simulated Dollar".to_string(),
        b"Simulated Dollar Token created by lamdanghoang".to_string(),
        b"https://images.unsplash.com/photo-1550565118-3a14e8d0386f".to_string(),
        ctx,
    );

    let metadata_cap = builder.finalize(ctx);

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_freeze_object(metadata_cap);
}

public fun mint_dollar(
    treasury_cap: &mut TreasuryCap<DOLLAR>,
    value: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let dollar_coin = coin::mint(treasury_cap, value, ctx);

    transfer::public_transfer(dollar_coin, recipient);
}

public fun burn_dollar(treasury_cap: &mut TreasuryCap<DOLLAR>, coin: Coin<DOLLAR>) {
    coin::burn(treasury_cap, coin);
}
