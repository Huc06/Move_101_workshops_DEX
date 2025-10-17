module gold_coin::gold_coin;

use sui::coin::{Self, TreasuryCap, Coin};
use sui::url::{Self};

public struct GOLD_COIN has drop {}

fun init(witness: GOLD_COIN, ctx: &mut TxContext) {

     let (treasury_cap, coin_metadata) = coin::create_currency<GOLD_COIN>(
        witness,
        9,
        b"GOLD COIN",
        b"Sui Dev",
        b"Sui Dev created by ahkiet22",
        option::some(
            url::new_unsafe_from_bytes(
                b"https://avatars.githubusercontent.com/u/179363806?v=4",
            ),
        ),
        ctx,
    );

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_freeze_object(coin_metadata);
}

public fun mint_gc(
    treasury_cap: &mut TreasuryCap<GOLD_COIN>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let gc = coin::mint(treasury_cap, amount, ctx);

    transfer::public_transfer(gc, recipient);
}

public fun burn_gc(treasury_cap: &mut TreasuryCap<GOLD_COIN>, coin: Coin<GOLD_COIN>) {
    coin::burn(treasury_cap, coin);
}