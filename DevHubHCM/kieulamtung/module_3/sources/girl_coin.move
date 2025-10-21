module girl::Girl_coin;

use sui::coin::{Self, TreasuryCap};
use sui::transfer;
use sui::tx_context;
use sui::url::{Self, new_unsafe_from_bytes};

//One Time witness
public struct GIRL_COIN has drop {}

fun init(witness: GIRL_COIN, ctx: &mut TxContext) {
    let (treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        9,
        b"GIRL",
        b"Girl_coin",
        b"I am boy",
        option::some(
            url::new_unsafe_from_bytes(
                b"https://png.pngtree.com/png-clipart/20230404/original/pngtree-3d-realistic-women-gender-vector-icon-png-image_9024871.png",
            ),
        ),
        ctx,
    );

    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap, ctx.sender());
}

entry fun mint_token(treasury_cap: &mut TreasuryCap<GIRL_COIN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury_cap, 1_000_000_000_000_000, ctx);
    transfer::public_transfer(coin_object, ctx.sender())
}