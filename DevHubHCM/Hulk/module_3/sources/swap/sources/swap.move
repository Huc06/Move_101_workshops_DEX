module 0x0::swap;

use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};
use swap::girlfriend::GIRLFRIEND;
use swap::hulk_token::{Self, HULK_TOKEN};

public struct Pool has key {
    id: UID,
    hulk_token: Balance<HULK_TOKEN>,
    girlfriend: Balance<GIRLFRIEND>,
}

fun init(ctx: &mut TxContext) {
    let pool = Pool {
        id: object::new(ctx),
        hulk_token: balance::zero<HULK_TOKEN>(),
        girlfriend: balance::zero<GIRLFRIEND>(),
    };

    transfer::share_object(pool);
}

#[allow(unused_function)]
entry fun add_money_to_pool(
    pool: &mut Pool,
    hulk_token: Coin<HULK_TOKEN>,
    girlfriend: Coin<GIRLFRIEND>,
) {
    pool.hulk_token.join(hulk_token.into_balance());
    pool.girlfriend.join(girlfriend.into_balance());
}

public entry fun deposit_HULK_TOKEN(
    pool: &mut Pool,
    user_coin: Coin<HULK_TOKEN>,
    ctx: &mut TxContext,
) {
    coin::put(&mut pool.hulk_token, user_coin);
}

public entry fun deposit_girlfriend(
    pool: &mut Pool,
    user_coin: Coin<GIRLFRIEND>,
    ctx: &mut TxContext,
) {
    coin::put(&mut pool.girlfriend, user_coin);
}

public entry fun swap_HULK_TOKEN_to_girlfriend(
    pool: &mut Pool,
    hulk_token: Coin<HULK_TOKEN>,
    ctx: &mut TxContext,
) {
    let amount = hulk_token.value();
    assert!(amount > 0, 0);

    pool.hulk_token.join(hulk_token.into_balance());

    let output_coin = coin::take(&mut pool.girlfriend, amount, ctx);
    transfer::public_transfer(output_coin, ctx.sender());
}

public entry fun swap_girlfriend_to_HULK_TOKEN(
    pool: &mut Pool,
    hulk_token: Coin<GIRLFRIEND>,
    ctx: &mut TxContext,
) {
    let amount = hulk_token.value();
    assert!(amount > 0, 0);

    pool.girlfriend.join(hulk_token.into_balance());

    let output_coin = coin::take(&mut pool.hulk_token, amount, ctx);
    transfer::public_transfer(output_coin, ctx.sender());
}
