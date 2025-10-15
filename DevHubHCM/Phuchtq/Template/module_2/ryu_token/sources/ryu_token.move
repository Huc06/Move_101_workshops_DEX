module ryu_token::ryu_token;

use sui::coin::{Self, Coin, TreasuryCap};
use sui::url::{Self, Url};

public struct RYU_TOKEN has drop {}

fun init(witness: RYU_TOKEN, ctx: &mut TxContext) {
    let (treasury_cap, metadata) = coin::create_currency<RYU_TOKEN>(
        witness,
        9, // decimals
        b"RTK", // symbol
        b"Ryu Coin", // name
        b"A sample coin created on Sui for bet platform", // description
        option::some<Url>(
            url::new_unsafe_from_bytes(
                b"https://cdn.pixabay.com/photo/2024/04/09/01/30/ai-generated-8684820_1280.png",
            ),
        ), // icon URL
        ctx,
    );

    // Transfer the treasury cap to the publisher
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx));

    // Share the metadata object
    transfer::public_share_object(metadata);
}

public entry fun mint(treasury_cap: &mut TreasuryCap<RYU_TOKEN>, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);

    // Define a fixed mint amount
    let amount: u64 = 1_000_000_000; // equals 1 RTK if 9 decimals

    coin::mint_and_transfer(treasury_cap, amount, sender, ctx);
}

/// Manager can burn coins
public entry fun burn(treasury_cap: &mut TreasuryCap<RYU_TOKEN>, coin: Coin<RYU_TOKEN>) {
    coin::burn(treasury_cap, coin);
}

/// Get total supply
public fun total_supply(treasury_cap: &TreasuryCap<RYU_TOKEN>): u64 {
    coin::total_supply(treasury_cap)
}
