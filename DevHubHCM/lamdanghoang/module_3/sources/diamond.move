module module_3::diamond;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::coin_registry;

public struct DIAMOND has drop {}

fun init(witness: DIAMOND, ctx: &mut TxContext) {
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        6,
        b"DIAMOND".to_string(),
        b"Diamond".to_string(),
        b"Simulated Diamond Token created by lamdanghoang".to_string(),
        b"https://images.unsplash.com/photo-1600119612651-0db31b3a7baa".to_string(),
        ctx,
    );

    let metadata_cap = builder.finalize(ctx);

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_freeze_object(metadata_cap);
}

public fun mint_diamond(
    treasury_cap: &mut TreasuryCap<DIAMOND>,
    value: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let diamond_coin = coin::mint(treasury_cap, value, ctx);

    transfer::public_transfer(diamond_coin, recipient);
}

public fun burn_diamond(treasury_cap: &mut TreasuryCap<DIAMOND>, coin: Coin<DIAMOND>) {
    coin::burn(treasury_cap, coin);
}
