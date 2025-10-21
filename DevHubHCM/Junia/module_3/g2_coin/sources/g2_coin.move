module g2_coin::g2;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::coin_registry;

public struct G2 has drop {}

fun init(witness: G2, ctx: &mut TxContext) {
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        6,
        b"G2".to_string(),
        b"G2 Token".to_string(),
        b"G2 token created by junia".to_string(),
        b"https://g2esports.com/cdn/shop/files/G2-Esports-2020-Logo_87bf0678-e67f-4834-8b09-e56137ffaa80.png?v=1641913940".to_string(),
        ctx,
    );

    let metadata_cap = builder.finalize(ctx);

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_freeze_object(metadata_cap);
}

entry fun mint(
    treasury_cap: &mut TreasuryCap<G2>,
    value: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let g2_coin = coin::mint(treasury_cap, value, ctx);

    transfer::public_transfer(g2_coin, recipient);
}

entry fun burn(treasury_cap: &mut TreasuryCap<G2>, coin: Coin<G2>) {
    coin::burn(treasury_cap, coin);
}