module module_3::swap;

use module_3::diamond::DIAMOND;
use module_3::dollar::DOLLAR;
use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};

public struct POOL has key {
    id: UID,
    diamond_balance: Balance<DIAMOND>,
    dollar_balance: Balance<DOLLAR>,
}

fun init(ctx: &mut TxContext) {
    let pool = POOL {
        id: object::new(ctx),
        diamond_balance: balance::zero<DIAMOND>(),
        dollar_balance: balance::zero<DOLLAR>(),
    };

    transfer::share_object(pool);
}

public fun add_LP_to_pool(pool: &mut POOL, diamond_coin: Coin<DIAMOND>, dollar_coin: Coin<DOLLAR>) {
    pool.diamond_balance.join(diamond_coin.into_balance());
    pool.dollar_balance.join(dollar_coin.into_balance());
}

public fun deposit_diamond_to_pool(pool: &mut POOL, diamond_coin: Coin<DIAMOND>) {
    coin::put(&mut pool.diamond_balance, diamond_coin);
}

public fun deposit_dollar_to_pool(pool: &mut POOL, dollar_coin: Coin<DOLLAR>) {
    coin::put(&mut pool.dollar_balance, dollar_coin);
}

#[allow(lint(self_transfer))]
public fun swap_diamond_to_dollar(
    pool: &mut POOL,
    diamond_coin: Coin<DIAMOND>,
    ctx: &mut TxContext,
) {
    let diamond_value = diamond_coin.value();
    assert!(diamond_value > 0, 0);

    pool.diamond_balance.join(diamond_coin.into_balance());
    let dollar_coin = coin::take(&mut pool.dollar_balance, diamond_value, ctx);

    transfer::public_transfer(dollar_coin, ctx.sender());
}

#[allow(lint(self_transfer))]
public fun swap_dollar_to_diamond(pool: &mut POOL, dollar_coin: Coin<DOLLAR>, ctx: &mut TxContext) {
    let dollar_value = dollar_coin.value();
    assert!(dollar_value > 0, 0);

    pool.dollar_balance.join(dollar_coin.into_balance());
    let diamond_coin = coin::take(&mut pool.diamond_balance, dollar_value, ctx);

    transfer::public_transfer(diamond_coin, ctx.sender());
}
