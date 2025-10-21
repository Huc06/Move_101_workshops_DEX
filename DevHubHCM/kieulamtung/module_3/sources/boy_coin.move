module boy::Boy_coin;

use sui::coin::{Self, TreasuryCap};
use sui::transfer;
use sui::tx_context;
use sui::url::{Self, new_unsafe_from_bytes};

//One Time witness
public struct BOY_COIN has drop {}

fun init(witness: BOY_COIN, ctx: &mut TxContext) {
    let (treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        9,
        b"BOY",
        b"Boy_coin",
        b"I am boy",
        option::some(
            url::new_unsafe_from_bytes(
                b"https://png.pngtree.com/png-clipart/20220913/ourlarge/pngtree-3d-blue-male-gender-icon-png-image_6174082.png",
            ),
        ),
        ctx,
    );

    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap, ctx.sender());
}

entry fun mint_token(treasury_cap: &mut TreasuryCap<BOY_COIN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury_cap, 1_000_000_000_000_000, ctx);
    transfer::public_transfer(coin_object, ctx.sender())
}