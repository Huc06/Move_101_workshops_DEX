module sd_coin::SD;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::coin_registry;

public struct SD has drop {}

fun init(witness: SD, ctx: &mut TxContext) {
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        6,
        b"SD".to_string(),
        b"Sui Dev".to_string(),
        b"Sui Dev created by huubao".to_string(),
        b"https://avatars.githubusercontent.com/u/79296917?v=4".to_string(),
        ctx,
    );

    let metadata_cap = builder.finalize(ctx);

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_freeze_object(metadata_cap);
}

public fun mint_sd(
    treasury_cap: &mut TreasuryCap<SD>,
    value: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let sd_coin = coin::mint(treasury_cap, value, ctx);

    transfer::public_transfer(sd_coin, recipient);
}

public fun burn_sd(treasury_cap: &mut TreasuryCap<SD>, coin: Coin<SD>) {
    coin::burn(treasury_cap, coin);
}