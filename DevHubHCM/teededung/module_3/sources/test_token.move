module module_3::test_token;

use sui::coin::{Self, TreasuryCap};

entry fun mint(
    c: &mut TreasuryCap<TEST_TOKEN>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    coin::mint_and_transfer(c, amount, recipient, ctx);
}

public struct TEST_TOKEN has drop {}

fun init(otw: TEST_TOKEN, ctx: &mut TxContext) {
    let treasury_cap = my_create_currency(otw, ctx);
    transfer::public_transfer(treasury_cap, ctx.sender());
}

#[allow(deprecated_usage)]
fun my_create_currency<T: drop>(otw: T, ctx: &mut TxContext): TreasuryCap<T> {
    let (treasury_cap, metadata) = coin::create_currency(
        otw,
        6,
        b"TEST",
        b"TEST TOKEN",
        b"TEST description",
        option::none(),
        ctx,
    );

    transfer::public_freeze_object(metadata);
    treasury_cap
}

#[test_only]
public fun init_for_test(ctx: &mut TxContext) {
    init(TEST_TOKEN {}, ctx);
}
