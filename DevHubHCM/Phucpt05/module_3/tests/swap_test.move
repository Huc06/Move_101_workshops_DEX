#[test_only]
module module_3::swap_test {
    use sui::test_scenario;
    use sui::coin::{Self, Coin, TreasuryCap, mint_and_transfer};
    use module_3::token_a::{Self, TOKEN_A};
    use module_3::token_b::{Self, TOKEN_B};
    use module_3::swap::{Self, Pool};

    #[test]
    fun test_swap_token_a_to_token_b_success() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;

        // Setup: Tạo TreasuryCap và Pool
        {
            let ctx = test_scenario::ctx(scenario);
            
            // Tạo token A
            token_a::init(TOKEN_A {}, ctx);
            let treasury_a = test_scenario::take_from_sender<TreasuryCap<TOKEN_A>>(scenario);
            
            // Tạo token B
            token_b::init(TOKEN_B {}, ctx);
            let treasury_b = test_scenario::take_from_sender<TreasuryCap<TOKEN_B>>(scenario);
            
            // Tạo Pool
            swap::init(ctx);
            let pool = test_scenario::take_shared<Pool>(scenario);
            
            // Add liquidity vào pool
            let coin_a = coin::mint(&mut treasury_a, 1000000, ctx); // 1 TOKEN_A với 6 decimals
            let coin_b = coin::mint(&mut treasury_b, 1000000, ctx); // 1 TOKEN_B với 6 decimals
            swap::add_money_to_pool(&mut pool, coin_a, coin_b);
            
            test_scenario::return_shared(pool);
            test_scenario::return_to_sender(scenario, treasury_a);
            test_scenario::return_to_sender(scenario, treasury_b);
        };

        // Test swap
        {
            let ctx = test_scenario::ctx(scenario);
            let treasury_a = test_scenario::take_from_sender<TreasuryCap<TOKEN_A>>(scenario);
            let pool = test_scenario::take_shared<Pool>(scenario);
            
            // Mint token A để swap
            let coin_a_to_swap = coin::mint(&mut treasury_a, 100000, ctx); // 0.1 TOKEN_A
            let coin_a_value = coin::value(&coin_a_to_swap);
            
            // Thực hiện swap
            swap::swap_token_a_to_token_b(&mut pool, coin_a_to_swap, ctx);
            
            // Verify: Token A đã được deposit vào pool
            let pool_token_a_balance = coin::value(&pool.token_a);
            assert!(pool_token_a_balance == 1100000, 0); // 1M + 0.1M
            
            test_scenario::return_shared(pool);
            test_scenario::return_to_sender(scenario, treasury_a);
        };

        // Verify: User nhận được Token B
        {
            let received_coin_b = test_scenario::take_from_sender<Coin<TOKEN_B>>(scenario);
            let received_amount = coin::value(&received_coin_b);
            assert!(received_amount == 100000, 1); // Nhận được 0.1 TOKEN_B
            
            transfer::public_burn_coin(received_coin_b);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code = 0, location = module_3::swap)]
    fun test_swap_token_a_to_token_b_with_zero_amount() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;

        // Setup
        {
            let ctx = test_scenario::ctx(scenario);
            token_a::init(TOKEN_A {}, ctx);
            token_b::init(TOKEN_B {}, ctx);
            swap::init(ctx);
            
            let treasury_a = test_scenario::take_from_sender<TreasuryCap<TOKEN_A>>(scenario);
            let treasury_b = test_scenario::take_from_sender<TreasuryCap<TOKEN_B>>(scenario);
            let pool = test_scenario::take_shared<Pool>(scenario);
            
            // Add minimal liquidity
            let coin_a = coin::mint(&mut treasury_a, 1000000, ctx);
            let coin_b = coin::mint(&mut treasury_b, 1000000, ctx);
            swap::add_money_to_pool(&mut pool, coin_a, coin_b);
            
            test_scenario::return_shared(pool);
            test_scenario::return_to_sender(scenario, treasury_a);
            test_scenario::return_to_sender(scenario, treasury_b);
        };

        // Test swap với 0 amount
        {
            let ctx = test_scenario::ctx(scenario);
            let pool = test_scenario::take_shared<Pool>(scenario);
            let zero_coin_a = coin::zero<TOKEN_A>(ctx); // Coin với value = 0
            
            // Swap sẽ fail vì amount = 0
            swap::swap_token_a_to_token_b(&mut pool, zero_coin_a, ctx);
            
            test_scenario::return_shared(pool);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code = ::std::option::EOption)]
    fun test_swap_with_insufficient_token_b_in_pool() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;

        // Setup với pool có ít token B
        {
            let ctx = test_scenario::ctx(scenario);
            token_a::init(TOKEN_A {}, ctx);
            token_b::init(TOKEN_B {}, ctx);
            swap::init(ctx);
            
            let treasury_a = test_scenario::take_from_sender<TreasuryCap<TOKEN_A>>(scenario);
            let treasury_b = test_scenario::take_from_sender<TreasuryCap<TOKEN_B>>(scenario);
            let pool = test_scenario::take_shared<Pool>(scenario);
            
            // Add ít token B vào pool
            let coin_a = coin::mint(&mut treasury_a, 1000000, ctx);
            let coin_b = coin::mint(&mut treasury_b, 50000, ctx); // Chỉ 0.05 TOKEN_B
            swap::add_money_to_pool(&mut pool, coin_a, coin_b);
            
            test_scenario::return_shared(pool);
            test_scenario::return_to_sender(scenario, treasury_a);
            test_scenario::return_to_sender(scenario, treasury_b);
        };

        // Test swap với amount lớn hơn pool có
        {
            let ctx = test_scenario::ctx(scenario);
            let treasury_a = test_scenario::take_from_sender<TreasuryCap<TOKEN_A>>(scenario);
            let pool = test_scenario::take_shared<Pool>(scenario);
            
            let coin_a_to_swap = coin::mint(&mut treasury_a, 100000, ctx); // 0.1 TOKEN_A
            // Thử swap sẽ fail vì pool chỉ có 0.05 TOKEN_B
            
            swap::swap_token_a_to_token_b(&mut pool, coin_a_to_swap, ctx);
            
            test_scenario::return_shared(pool);
            test_scenario::return_to_sender(scenario, treasury_a);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_swap_token_a_to_token_b_multiple_times() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;

        // Setup
        {
            let ctx = test_scenario::ctx(scenario);
            token_a::init(TOKEN_A {}, ctx);
            token_b::init(TOKEN_B {}, ctx);
            swap::init(ctx);
            
            let treasury_a = test_scenario::take_from_sender<TreasuryCap<TOKEN_A>>(scenario);
            let treasury_b = test_scenario::take_from_sender<TreasuryCap<TOKEN_B>>(scenario);
            let pool = test_scenario::take_shared<Pool>(scenario);
            
            let coin_a = coin::mint(&mut treasury_a, 2000000, ctx);
            let coin_b = coin::mint(&mut treasury_b, 2000000, ctx);
            swap::add_money_to_pool(&mut pool, coin_a, coin_b);
            
            test_scenario::return_shared(pool);
            test_scenario::return_to_sender(scenario, treasury_a);
            test_scenario::return_to_sender(scenario, treasury_b);
        };

        // Multiple swaps
        let mut total_swapped_a = 0;
        let mut total_received_b = 0;
        
        {
            let ctx = test_scenario::ctx(scenario);
            let treasury_a = test_scenario::take_from_sender<TreasuryCap<TOKEN_A>>(scenario);
            let pool = test_scenario::take_shared<Pool>(scenario);
            
            // Swap lần 1
            let coin_a1 = coin::mint(&mut treasury_a, 100000, ctx);
            swap::swap_token_a_to_token_b(&mut pool, coin_a1, ctx);
            total_swapped_a = total_swapped_a + 100000;
            total_received_b = total_received_b + 100000;
            
            // Swap lần 2
            let coin_a2 = coin::mint(&mut treasury_a, 50000, ctx);
            swap::swap_token_a_to_token_b(&mut pool, coin_a2, ctx);
            total_swapped_a = total_swapped_a + 50000;
            total_received_b = total_received_b + 50000;
            
            test_scenario::return_shared(pool);
            test_scenario::return_to_sender(scenario, treasury_a);
        };

        // Verify balances sau multiple swaps
        {
            let pool = test_scenario::take_shared<Pool>(scenario);
            let pool_token_a = coin::value(&pool.token_a);
            let pool_token_b = coin::value(&pool.token_b);
            
            assert!(pool_token_a == 2000000 + total_swapped_a, 2);
            assert!(pool_token_b == 2000000 - total_received_b, 3);
            
            test_scenario::return_shared(pool);
        };

        // Verify user nhận được đúng số token B
        {
            let coin_b1 = test_scenario::take_from_sender<Coin<TOKEN_B>>(scenario);
            let coin_b2 = test_scenario::take_from_sender<Coin<TOKEN_B>>(scenario);
            
            assert!(coin::value(&coin_b1) == 100000, 4);
            assert!(coin::value(&coin_b2) == 50000, 5);
            
            transfer::public_burn_coin(coin_b1);
            transfer::public_burn_coin(coin_b2);
        };

        test_scenario::end(scenario_val);
    }
}