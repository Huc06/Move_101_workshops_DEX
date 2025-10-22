
//sai_token
module module_3::sai_token;

use sui::coin::{Self, TreasuryCap};
use sui::transfer;
use sui::tx_context;
use sui::url::{Self, new_unsafe_from_bytes};

// one-time witness type for creating the currency
public struct SAI_TOKEN has drop {}

fun init(witness: SAI_TOKEN, ctx: &mut TxContext) {
    let icon = option::some(new_unsafe_from_bytes(
        b"https://img.lovepik.com/png/20231113/lava-ball-character-icon-on-white-background-vector-illustration-clipart_580637_wh860.png",
    ));

    let (treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        9, // decimals
        b"sai",
        b"sai",
        b"sai liquidity token",
        icon,
        ctx,
    );

    // Freeze metadata and transfer the treasury cap to the transaction sender
    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
}

entry fun mint_token(treasury_cap: &mut TreasuryCap<SAI_TOKEN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury_cap, 1_000_000_000_000, ctx); // 1,000 sai with 9 decimals
    transfer::public_transfer(coin_object, tx_context::sender(ctx));
}