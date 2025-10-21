module junia_coin::JUNIA;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::coin_registry;

public struct JUNIA has drop {}

fun init(witness: JUNIA, ctx: &mut TxContext) {
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        6,
        b"JUNIA".to_string(),
        b"Sui Dev".to_string(),
        b"Sui Dev created by junia".to_string(),
        b"https://avatars.githubusercontent.com/u/92973580?s=400&u=74f294ece66ae089ae66c02f7e0403ee68ddf3c1&v=4".to_string(),
        ctx,
    );

    let metadata_cap = builder.finalize(ctx);

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_freeze_object(metadata_cap);
}

public fun mint_junia(
    treasury_cap: &mut TreasuryCap<JUNIA>,
    value: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let junia_coin = coin::mint(treasury_cap, value, ctx);

    transfer::public_transfer(junia_coin, recipient);
}

public fun burn_junia(treasury_cap: &mut TreasuryCap<JUNIA>, coin: Coin<JUNIA>) {
    coin::burn(treasury_cap, coin);
}