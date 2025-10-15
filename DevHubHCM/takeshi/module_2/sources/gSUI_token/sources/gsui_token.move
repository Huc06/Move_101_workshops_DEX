
/// Module: gsui_token
module gsui_token::gsui_token;

use sui::coin::{Self, TreasuryCap};
use sui::transfer;
use sui::tx_context;
use sui::url::{Self, new_unsafe_from_bytes};

// one-time witness type for creating the currency
public struct GSUI_TOKEN has drop {}

fun init(witness: GSUI_TOKEN, ctx: &mut TxContext) {
    let icon = option::some(new_unsafe_from_bytes(
        b"https://c8.alamy.com/comp/2RJ9C11/gsi-circle-letter-logo-design-with-circle-and-ellipse-shape-gsi-ellipse-letters-with-typographic-style-the-three-initials-form-a-circle-logo-gsi-ci-2RJ9C11.jpg",
    ));

    let (treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        9, // decimals
        b"gSUI",
        b"gSUI",
        b"gSUI liquidity token",
        icon,
        ctx,
    );

    // Freeze metadata and transfer the treasury cap to the transaction sender
    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
}

entry fun mint_token(treasury_cap: &mut TreasuryCap<GSUI_TOKEN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury_cap, 1_000_000_000_000, ctx); // 1,000 gSUI with 9 decimals
    transfer::public_transfer(coin_object, tx_context::sender(ctx));
}