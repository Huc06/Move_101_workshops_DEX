module module_3::swap;

use std::u128;
use sui::balance::{Self, Balance, Supply};
use sui::coin::{Self, Coin};
use sui::sui::SUI;

// === Constants ===

const EInvalidAmount: u64 = 0;
const EInsufficientOutput: u64 = 1;

// === Structs ===

/// Liquidity pool for token X and SUI
public struct Pool<phantom X> has key {
    id: UID,
    reserve_x: Balance<X>,
    reserve_sui: Balance<SUI>,
    lp_supply: Supply<LP<X>>,
    fee_bps: u64, // e.g., 30 = 0.3%
}

/// LP token marker type
public struct LP<phantom X> has drop {}

// === Functions ===

/// Create a new liquidity pool
public fun create_pool<X>(fee_bps: u64, ctx: &mut TxContext) {
    let pool = Pool {
        id: object::new(ctx),
        reserve_x: balance::zero<X>(),
        reserve_sui: balance::zero<SUI>(),
        lp_supply: balance::create_supply(LP<X> {}),
        fee_bps,
    };
    transfer::share_object(pool);
}

/// Add liquidity with both tokens
public fun add_liquidity<X>(
    pool: &mut Pool<X>,
    x: Coin<X>,
    sui: Coin<SUI>,
    ctx: &mut TxContext,
): Coin<LP<X>> {
    let x_val = coin::value(&x);
    let sui_val = coin::value(&sui);
    assert!(x_val > 0 && sui_val > 0, EInvalidAmount);

    // Calculate LP tokens to mint (geometric mean for initial, proportional otherwise)
    let lp_amount: u128 = if (balance::supply_value(&pool.lp_supply) == 0) {
        u128::sqrt((x_val as u128) * (sui_val as u128)) // Initial mint
    } else {
        u128::min(
            ((x_val as u128) * (balance::supply_value(&pool.lp_supply) as u128)) / (balance::value(&pool.reserve_x) as u128),
            ((sui_val as u128) * (balance::supply_value(&pool.lp_supply) as u128)) / (balance::value(&pool.reserve_sui) as u128),
        )
    };

    // Update reserves
    balance::join(&mut pool.reserve_x, coin::into_balance(x));
    balance::join(&mut pool.reserve_sui, coin::into_balance(sui));

    // Mint LP tokens
    let minted = balance::increase_supply(&mut pool.lp_supply, (lp_amount as u64));
    coin::from_balance(minted, ctx)
}

/// Swap X to SUI
public fun swap_x_to_sui<X>(
    pool: &mut Pool<X>,
    dx: Coin<X>,
    min_dy: u64,
    ctx: &mut TxContext,
): Coin<SUI> {
    let dx_val = coin::value(&dx);
    let fee = dx_val * pool.fee_bps / 10_000;
    let dx_after_fee = dx_val - fee;

    // Constant product formula (with casting to avoid overflow)
    let dy_val: u64 =
        (
            ((dx_after_fee as u128) * (balance::value(&pool.reserve_sui) as u128)) /
        ((balance::value(&pool.reserve_x) as u128) + (dx_after_fee as u128)),
        ) as u64;
    assert!(dy_val >= min_dy, EInsufficientOutput);

    // Update reserves
    balance::join(&mut pool.reserve_x, coin::into_balance(dx));
    let dy = balance::split(&mut pool.reserve_sui, dy_val);
    coin::from_balance(dy, ctx)
}

/// Swap SUI to X
public fun swap_sui_to_x<X>(
    pool: &mut Pool<X>,
    dy: Coin<SUI>,
    min_dx: u64,
    ctx: &mut TxContext,
): Coin<X> {
    let dy_val = coin::value(&dy);
    let fee = dy_val * pool.fee_bps / 10_000;
    let dy_after_fee = dy_val - fee;

    // Constant product formula (with casting to avoid overflow)
    let dx_val: u64 =
        (
            ((dy_after_fee as u128) * (balance::value(&pool.reserve_x) as u128)) /
        ((balance::value(&pool.reserve_sui) as u128) + (dy_after_fee as u128)),
        ) as u64;
    assert!(dx_val >= min_dx, EInsufficientOutput);

    // Update reserves
    balance::join(&mut pool.reserve_sui, coin::into_balance(dy));
    let dx = balance::split(&mut pool.reserve_x, dx_val);
    coin::from_balance(dx, ctx)
}
