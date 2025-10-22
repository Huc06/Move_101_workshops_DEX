module module3::su_coin;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::coin_registry;

public struct SU_COIN has drop {}

fun init(witness: SU_COIN, ctx: &mut TxContext) {
    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        witness,
        6,
        b"SU".to_string(),
        b"Sui User".to_string(),
        b"Sui User created by huubao".to_string(),
        b"https://cdn.lu.ma/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=112,height=112/avatars-default/avatar_30.png".to_string(),
        ctx,
    );

    let metadata_cap = builder.finalize(ctx);

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_freeze_object(metadata_cap);
}

public fun mint_su(
    treasury_cap: &mut TreasuryCap<SU_COIN>,
    value: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let su_coin = coin::mint(treasury_cap, value, ctx);

    transfer::public_transfer(su_coin, recipient);
}

public fun burn_su(treasury_cap: &mut TreasuryCap<SU_COIN>, coin: Coin<SU_COIN>) {
    coin::burn(treasury_cap, coin);
}