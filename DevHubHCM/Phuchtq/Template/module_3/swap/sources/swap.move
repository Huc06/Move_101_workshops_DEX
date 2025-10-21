module swap::swap;

use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};
use swap::b3t_token::B3T_TOKEN;
use swap::ryu_token::{Self, RYU_TOKEN};

public struct Pool has key {
    id: UID,
    ryu_token: Balance<RYU_TOKEN>,
    b3t_token: Balance<B3T_TOKEN>,
}

fun init(ctx: &mut TxContext) {
    let pool = Pool {
        id: object::new(ctx),
        ryu_token: balance::zero<RYU_TOKEN>(),
        b3t_token: balance::zero<B3T_TOKEN>(),
    };

    transfer::share_object(pool);
}

entry fun add_money_to_pool(
    pool: &mut Pool,
    ryu_token: Coin<RYU_TOKEN>,
    b3t_token: Coin<B3T_TOKEN>,
) {
    pool.ryu_token.join(ryu_token.into_balance());
    pool.b3t_token.join(b3t_token.into_balance());
}

public entry fun deposit_RYU_TOKEN(
    pool: &mut Pool,
    user_coin: Coin<RYU_TOKEN>,
    ctx: &mut TxContext,
) {
    coin::put(&mut pool.ryu_token, user_coin);
}

public entry fun deposit_B3T_TOKEN(
    pool: &mut Pool,
    user_coin: Coin<B3T_TOKEN>,
    ctx: &mut TxContext,
) {
    coin::put(&mut pool.b3t_token, user_coin);
}

public entry fun swap_RYU_TOKEN_to_B3T_TOKEN(
    pool: &mut Pool,
    ryu_token: Coin<RYU_TOKEN>,
    ctx: &mut TxContext,
) {
    let amount = ryu_token.value();
    assert!(amount > 0, 0);

    pool.ryu_token.join(ryu_token.into_balance());

    let output_coin = coin::take(&mut pool.b3t_token, amount, ctx);
    transfer::public_transfer(output_coin, ctx.sender());
}

public entry fun swap_B3T_TOKEN_to_RYU_TOKEN(
    pool: &mut Pool,
    b3t_token: Coin<B3T_TOKEN>,
    ctx: &mut TxContext,
) {
    let amount = b3t_token.value();
    assert!(amount > 0, 0);

    pool.b3t_token.join(b3t_token.into_balance());

    let output_coin = coin::take(&mut pool.ryu_token, amount, ctx);
    transfer::public_transfer(output_coin, ctx.sender());
}
