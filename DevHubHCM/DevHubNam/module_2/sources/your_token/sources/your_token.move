/*
 Module: your_token
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module your_token::your_token {
 

// One-time witness used to initialize the currency
public struct YOUR_TOKEN has drop {}

fun init(witness: YOUR_TOKEN, ctx: &mut sui::tx_context::TxContext) {
    let (treasury_cap, coin_metadata) = sui::coin::create_currency(
        witness,
        9,
        b"Y",
        b"Your",
        b"I like It",
        std::option::some(
            sui::url::new_unsafe_from_bytes(
                b"https://avatars.githubusercontent.com/u/23027766?s=400&u=12235a39fac4aa597d808f837bb7ece1b007669e&v=4",
            ),
        ),
        ctx,
    );

    sui::transfer::public_freeze_object(coin_metadata);
    sui::transfer::public_transfer(treasury_cap, sui::tx_context::sender(ctx));
}

public fun mint_token(treasury_cap: &mut sui::coin::TreasuryCap<YOUR_TOKEN>, ctx: &mut sui::tx_context::TxContext) {
    let coin_object = sui::coin::mint(treasury_cap, 1_000_000_000_000_000, ctx);
    sui::transfer::public_transfer(coin_object, sui::tx_context::sender(ctx));
}

// Helper function to mint a specific amount
public fun mint_amount(treasury_cap: &mut sui::coin::TreasuryCap<YOUR_TOKEN>, amount: u64, ctx: &mut sui::tx_context::TxContext) {
    let coin_object = sui::coin::mint(treasury_cap, amount, ctx);
    sui::transfer::public_transfer(coin_object, sui::tx_context::sender(ctx));
}

// Simple mint function that works with TreasuryCap object
public fun mint_simple(treasury_cap: &mut sui::coin::TreasuryCap<YOUR_TOKEN>, amount: u64, ctx: &mut sui::tx_context::TxContext) {
    let coin_object = sui::coin::mint(treasury_cap, amount, ctx);
    sui::transfer::public_transfer(coin_object, sui::tx_context::sender(ctx));
}

// Entry function that takes TreasuryCap object directly
public fun mint_entry(treasury_cap: &mut sui::coin::TreasuryCap<YOUR_TOKEN>, amount: u64, ctx: &mut sui::tx_context::TxContext) {
    let coin_object = sui::coin::mint(treasury_cap, amount, ctx);
    sui::transfer::public_transfer(coin_object, sui::tx_context::sender(ctx));
}

// Simple mint function that works with TreasuryCap ID
public entry fun mint(mut treasury_cap: sui::coin::TreasuryCap<YOUR_TOKEN>, amount: u64, ctx: &mut sui::tx_context::TxContext) {
    let coin_object = sui::coin::mint(&mut treasury_cap, amount, ctx);
    sui::transfer::public_transfer(coin_object, sui::tx_context::sender(ctx));
    sui::transfer::public_transfer(treasury_cap, sui::tx_context::sender(ctx));
}

}
