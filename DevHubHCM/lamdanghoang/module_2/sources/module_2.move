module module_2::GOLD;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::coin_registry;

public struct GOLD has drop {}

fun init(witness: GOLD, ctx: &mut TxContext) {
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        6,
        b"GOLD".to_string(),
        b"Gold".to_string(),
        b"Gold Token created by lamdanghoang".to_string(),
        b"https://cdn.pixabay.com/photo/2014/11/01/22/33/gold-513062_1280.jpg".to_string(),
        ctx,
    );

    let metadata_cap = builder.finalize(ctx);

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_freeze_object(metadata_cap);
}

public fun mint_gold(
    treasury_cap: &mut TreasuryCap<GOLD>,
    value: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let gold_coin = coin::mint(treasury_cap, value, ctx);

    transfer::public_transfer(gold_coin, recipient);
}

public fun burn_gold(treasury_cap: &mut TreasuryCap<GOLD>, coin: Coin<GOLD>) {
    coin::burn(treasury_cap, coin);
}
