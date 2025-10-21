module swap::swap;

use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin, TreasuryCap};
use sui::coin_registry;
use std::u64;
use junia_coin::Junia::{JUNIA};
use g2_coin::g2::{G2};

const FEE_NUMERATOR: u64 = 997;
const FEE_DENOMINATOR: u64 = 1000;

public struct SWAP has drop {}

public struct Pool has key {
    id: UID,
    junia_reserve: Balance<JUNIA>,
    g2_reserve: Balance<G2>,
    lp_supply: Balance<SWAP>,
    lp_treasury_cap: TreasuryCap<SWAP>,
}

fun init(otw: SWAP, ctx: &mut TxContext) {

    let (builder, treasury_cap) = coin_registry::new_currency_with_otw(
        otw,
        6,
        b"SWAP".to_string(),
        b"SWAP Token".to_string(),
        b"SWAP Token represents ownership of liquidity pool".to_string(),
        b"".to_string(),
        ctx,
        );

    let metadata_cap = builder.finalize(ctx);
    
    let pool = Pool {
        id: object::new(ctx),
        junia_reserve: balance::zero<JUNIA>(),
        g2_reserve: balance::zero<G2>(),
        lp_supply: balance::zero<SWAP>(),
        lp_treasury_cap: treasury_cap
    };
    
    transfer::public_freeze_object(metadata_cap);
    transfer::share_object(pool);
}

entry fun deposit(
    pool: &mut Pool,
    junia_coin: Coin<JUNIA>,
    g2_coin: Coin<G2>,
    ctx: &mut TxContext
) {
    let total_lp = pool.lp_supply.value();
    let junia_amount = coin::value(&junia_coin);
    let g2_amount = coin::value(&g2_coin);

    let lp_minted = if (total_lp == 0) {
        u64::sqrt(junia_amount * g2_amount)
    } else {
        let junia_reserve = balance::value(&pool.junia_reserve);
        let g2_reserve = balance::value(&pool.g2_reserve);

        let lp_from_junia = junia_amount * total_lp / junia_reserve;
        let lp_from_g2 = g2_amount * total_lp / g2_reserve;

        u64::min(lp_from_junia, lp_from_g2)
    };

    let lp_token = coin::mint(&mut pool.lp_treasury_cap, lp_minted, ctx);

    balance::join(&mut pool.junia_reserve, coin::into_balance(junia_coin));
    balance::join(&mut pool.g2_reserve, coin::into_balance(g2_coin));

    transfer::public_transfer(lp_token, ctx.sender());
}

entry fun withdraw(pool: &mut Pool, lp_token: Coin<SWAP>, ctx: &mut TxContext) {
    
    let withdraw_amount = lp_token.value();
    let total_lp = pool.lp_supply.value();
    assert!(withdraw_amount > 0, 0);

    let junia_reserve = balance::value(&pool.junia_reserve);
    let g2_reserve = balance::value(&pool.g2_reserve);

    let junia_out = withdraw_amount * junia_reserve / total_lp;
    let g2_out = withdraw_amount * g2_reserve / total_lp;

    coin::burn(&mut pool.lp_treasury_cap, lp_token);


    let junia_balance = balance::split(&mut pool.junia_reserve, junia_out);
    let g2_balance = balance::split(&mut pool.g2_reserve, g2_out);

    let junia_token = coin::from_balance(junia_balance, ctx);
    let g2_token = coin::from_balance(g2_balance, ctx);

    transfer::public_transfer(junia_token, ctx.sender());
    transfer::public_transfer(g2_token, ctx.sender());
}

entry fun swap_g2_to_junia(pool: &mut Pool, g2_token: Coin<G2>, ctx: &mut TxContext) {
    let amount = g2_token.value();
    let junia_reserve = pool.junia_reserve.value();
    let g2_reserve = pool.g2_reserve.value();

    assert!(amount > 0, 0);
    assert!(junia_reserve > 0 && g2_reserve > 0, 1);

    let amount_after_fee = amount * FEE_NUMERATOR / FEE_DENOMINATOR;
    let junia_out = amount_after_fee * junia_reserve / (g2_reserve + amount_after_fee);
    assert!(junia_out > 0, 2);

    let junia_token = coin::take(&mut pool.junia_reserve, junia_out, ctx);

    coin::put(&mut pool.g2_reserve, g2_token);

    transfer::public_transfer(junia_token, ctx.sender());
}

entry fun swap_junia_to_g2(pool: &mut Pool, junia_token: Coin<JUNIA>, ctx: &mut TxContext ) {
    let amount = junia_token.value();
    let junia_reserve = pool.junia_reserve.value();
    let g2_reserve = pool.g2_reserve.value();

    assert!(amount > 0, 0);
    assert!(junia_reserve > 0 && g2_reserve > 0, 1);

    let amount_after_fee = amount * FEE_NUMERATOR / FEE_DENOMINATOR;
    let g2_out = amount_after_fee * g2_reserve / (junia_reserve + amount_after_fee);
    assert!(g2_out > 0, 2);

    let g2_token = coin::take(&mut pool.g2_reserve, g2_out, ctx);

    coin::put(&mut pool.junia_reserve, junia_token);

    transfer::public_transfer(g2_token, ctx.sender());
}