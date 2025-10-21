module swap::swap {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::object;
    use sui::transfer;
    use sui::tx_context::TxContext;
    use boy::Boy_coin::BOY_COIN;
    use girl::Girl_coin::GIRL_COIN;

    /// Pool lưu trữ cả 2 token
    public struct Pool has key {
        id: UID,
        boy_coin: Balance<BOY_COIN>,
        girl_coin: Balance<GIRL_COIN>,
    }

    /// Khởi tạo pool swap
    public entry fun create_pool(ctx: &mut TxContext) {
        let pool = Pool {
            id: object::new(ctx),
            boy_coin: balance::zero<BOY_COIN>(),
            girl_coin: balance::zero<GIRL_COIN>(),
        };
        transfer::share_object(pool);
    }

    /// Nạp BOY coin vào pool
    public entry fun deposit_boy(
        pool: &mut Pool,
        user_coin: Coin<BOY_COIN>,
        ctx: &mut TxContext,
    ) {
        coin::put(&mut pool.boy_coin, user_coin);
    }

    /// Nạp GIRL coin vào pool
    public entry fun deposit_girl(
        pool: &mut Pool,
        user_coin: Coin<GIRL_COIN>,
        ctx: &mut TxContext,
    ) {
        coin::put(&mut pool.girl_coin, user_coin);
    }

    /// Swap BOY → GIRL
    public entry fun swap_BOY_to_GIRL(
        pool: &mut Pool,
        input_coin: Coin<BOY_COIN>,
        ctx: &mut TxContext,
    ) {
        let amount = input_coin.value();
        assert!(amount > 0, 0);

        // Người dùng gửi BOY vào pool
        pool.boy_coin.join(input_coin.into_balance());

        let output_amount = amount * 2;

        // Lấy GIRL tương ứng từ pool (tỷ lệ 1:1)
        let output = coin::take(&mut pool.girl_coin, amount, ctx);
        transfer::public_transfer(output, ctx.sender());
    }

    /// Swap GIRL → BOY
    public entry fun swap_GIRL_to_BOY(
        pool: &mut Pool,
        input_coin: Coin<GIRL_COIN>,
        ctx: &mut TxContext,
    ) {
        let amount = input_coin.value();
        assert!(amount > 0, 0);

        pool.girl_coin.join(input_coin.into_balance());

        let output_amount = amount / 2;

        let output = coin::take(&mut pool.boy_coin, amount, ctx);
        transfer::public_transfer(output, ctx.sender());
    }
    public fun quote_boy_to_girl(amount: u64): u64 {
        amount * 2
    }

    public fun quote_girl_to_boy(amount: u64): u64 {
        amount / 2
    }
}
