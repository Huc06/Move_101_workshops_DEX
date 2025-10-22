module module3::swap;

use module3::sd_coin::SD_COIN;
use module3::su_coin::SU_COIN;
use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};

public struct POOL has key {
    id: UID,
    sd_coin_balance: Balance<SD_COIN>,
    su_coin_balance: Balance<SU_COIN>,
}

fun init(ctx: &mut TxContext) {
    let pool = POOL {
        id: object::new(ctx),
        sd_coin_balance: balance::zero<SD_COIN>(),
        su_coin_balance: balance::zero<SU_COIN>(),
    };

    transfer::share_object(pool);
}

public fun add_LP_to_pool(pool: &mut POOL, sd_coin_coin: Coin<SD_COIN>, su_coin_coin: Coin<SU_COIN>) {
    pool.sd_coin_balance.join(sd_coin_coin.into_balance());
    pool.su_coin_balance.join(su_coin_coin.into_balance());
}

public fun deposit_sd_coin_to_pool(pool: &mut POOL, sd_coin_coin: Coin<SD_COIN>) {
    coin::put(&mut pool.sd_coin_balance, sd_coin_coin);
}

public fun deposit_su_coin_to_pool(pool: &mut POOL, su_coin_coin: Coin<SU_COIN>) {
    coin::put(&mut pool.su_coin_balance, su_coin_coin);
}

#[allow(lint(self_transfer))]
public fun swap_sd_coin_to_su_coin(
    pool: &mut POOL,
    sd_coin_coin: Coin<SD_COIN>,
    ctx: &mut TxContext,
) {
    let sd_coin_value = sd_coin_coin.value();
    assert!(sd_coin_value > 0, 0);

    pool.sd_coin_balance.join(sd_coin_coin.into_balance());
    let su_coin_coin = coin::take(&mut pool.su_coin_balance, sd_coin_value, ctx);

    transfer::public_transfer(su_coin_coin, ctx.sender());
}

#[allow(lint(self_transfer))]
public fun swap_su_coin_to_sd_coin(pool: &mut POOL, su_coin_coin: Coin<SU_COIN>, ctx: &mut TxContext) {
    let su_coin_value = su_coin_coin.value();
    assert!(su_coin_value > 0, 0);

    pool.su_coin_balance.join(su_coin_coin.into_balance());
    let sd_coin_coin = coin::take(&mut pool.sd_coin_balance, su_coin_value, ctx);

    transfer::public_transfer(sd_coin_coin, ctx.sender());
}