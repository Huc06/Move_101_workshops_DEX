module ryu_token::b3t_token;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::url::{Self, Url};

public struct B3T_TOKEN has drop {}

fun init(witness: B3T_TOKEN, ctx: &mut TxContext) {
    let (treasury_cap, metadata) = coin::create_currency<B3T_TOKEN>(
        witness,
        9, // decimals
        b"B3T", // symbol
        b"B3T", // name
        b"A sample coin created on Sui for swapping and bet platform", // description
        option::some<Url>(
            url::new_unsafe_from_bytes(
                b"https://play-lh.googleusercontent.com/slva_dISxtKJ3GxAv4fCgwxS-eRP1jCM0fMDwowCAfehMoHLGvOvuwSUYjPRFWqt7g",
            ),
        ), // icon URL
        ctx,
    );

    // Transfer the treasury cap to the publisher
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx));

    // Share the metadata object
    transfer::public_share_object(metadata);
}

public entry fun mint(treasury_cap: &mut TreasuryCap<B3T_TOKEN>, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);

    // Define a fixed mint amount
    let amount: u64 = 1_000_000_000; // equals 1 RTK if 9 decimals

    coin::mint_and_transfer(treasury_cap, amount, sender, ctx);
}

/// Manager can burn coins
public entry fun burn(treasury_cap: &mut TreasuryCap<B3T_TOKEN>, coin: Coin<B3T_TOKEN>) {
    coin::burn(treasury_cap, coin);
}

/// Get total supply
public fun total_supply(treasury_cap: &TreasuryCap<B3T_TOKEN>): u64 {
    coin::total_supply(treasury_cap)
}
