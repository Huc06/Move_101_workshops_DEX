module olysui_token::olysui_token;

use sui::coin::{Self, TreasuryCap, CoinMetadata, Coin};
use sui::transfer;
use sui::tx_context;
use std::option;
use sui::url;

public struct OLYSUI_TOKEN has drop {}

fun init(witness: OLYSUI_TOKEN, ctx: &mut tx_context::TxContext) {
let (treasury_cap, metadata): (TreasuryCap<OLYSUI_TOKEN>, CoinMetadata<OLYSUI_TOKEN>) = coin::create_currency<OLYSUI_TOKEN>(
witness,
9,
b"OLY",
b"OLYSUI",
b"OLY SUI",
option::some(url::new_unsafe_from_bytes(b"https://pbs.twimg.com/profile_images/1971374702347321344/jw95E7NJ_400x400.jpg")),
ctx
);
transfer::public_freeze_object(metadata);
transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
}

public entry fun mint(treasury_cap: &mut TreasuryCap<OLYSUI_TOKEN>, amount: u64, recipient: address, ctx: &mut tx_context::TxContext) {
let new_coins: Coin<OLYSUI_TOKEN> = coin::mint(treasury_cap, amount, ctx);
transfer::public_transfer(new_coins, recipient);
}

public entry fun burn(treasury_cap: &mut TreasuryCap<OLYSUI_TOKEN>, c: Coin<OLYSUI_TOKEN>) {
coin::burn(treasury_cap, c);
}