#[test_only]
module module_3::swap_test;

use module_3::swap::{Self, Pool};
use module_3::test_token::{TEST_TOKEN, init_for_test};
use sui::coin::{Self, TreasuryCap, Coin, mint_for_testing};
use sui::sui::SUI;
use sui::test_scenario as ts;
use sui::transfer::public_transfer;

const FEE_BPS: u64 = 30; // 0.3%
const INITIAL_TEST_TOKEN: u64 = 1_000_000_000;
const INITIAL_SUI: u64 = 1_000_000_000;
const SWAP_AMOUNT: u64 = 1_000_000;

#[test]
fun test_create_pool() {
    let mut scenario = ts::begin(@0x1);
    {
        swap::create_pool<TEST_TOKEN>(FEE_BPS, scenario.ctx());
    };
    scenario.end();
}

#[test]
fun test_add_liquidity_initial() {
    let test_addr = @0x2;
    let mut scenario = ts::begin(test_addr);

    scenario.next_tx(test_addr);
    {
        init_for_test(ts::ctx(&mut scenario));
    };

    // mint TEST_TOKEN
    scenario.next_tx(test_addr);
    {
        let mut tc = ts::take_from_sender<TreasuryCap<TEST_TOKEN>>(&scenario);
        coin::mint_and_transfer<TEST_TOKEN>(
            &mut tc,
            INITIAL_TEST_TOKEN,
            test_addr,
            ts::ctx(&mut scenario),
        );
        ts::return_to_sender(&scenario, tc);

        let sui: Coin<SUI> = mint_for_testing(INITIAL_SUI, scenario.ctx());
        public_transfer(sui, test_addr);
    };

    scenario.next_tx(test_addr);
    {
        swap::create_pool<TEST_TOKEN>(FEE_BPS, scenario.ctx());
    };

    scenario.next_tx(test_addr);
    {
        let mut pool = ts::take_shared<Pool<TEST_TOKEN>>(&scenario);
        let mut treasury_cap = ts::take_from_sender<TreasuryCap<TEST_TOKEN>>(&scenario);
        let sui = ts::take_from_sender<Coin<SUI>>(&scenario);
        let x = coin::mint(&mut treasury_cap, INITIAL_TEST_TOKEN, scenario.ctx());

        let lp = swap::add_liquidity(&mut pool, x, sui, scenario.ctx());
        assert!(coin::value(&lp) > 0, 0);

        ts::return_shared(pool);
        ts::return_to_sender(&scenario, treasury_cap);
        transfer::public_transfer(lp, test_addr);
    };
    scenario.end();
}

#[test]
fun test_swap_x_to_sui() {
    let test_addr = @0x2;
    let mut scenario = ts::begin(test_addr);

    // init token TEST
    scenario.next_tx(test_addr);
    {
        init_for_test(ts::ctx(&mut scenario));
    };

    // mint token TEST
    scenario.next_tx(test_addr);
    {
        let mut tc = ts::take_from_sender<TreasuryCap<TEST_TOKEN>>(&scenario);
        coin::mint_and_transfer<TEST_TOKEN>(
            &mut tc,
            INITIAL_TEST_TOKEN,
            test_addr,
            ts::ctx(&mut scenario),
        );
        ts::return_to_sender(&scenario, tc);

        let sui: Coin<SUI> = mint_for_testing(INITIAL_SUI, scenario.ctx());
        public_transfer(sui, test_addr);
    };

    // create pool
    scenario.next_tx(test_addr);
    {
        swap::create_pool<TEST_TOKEN>(FEE_BPS, scenario.ctx());
    };

    // add liquidity
    scenario.next_tx(test_addr);
    {
        let mut pool = ts::take_shared<Pool<TEST_TOKEN>>(&scenario);
        let mut treasury_cap = ts::take_from_sender<TreasuryCap<TEST_TOKEN>>(&scenario);
        let sui = ts::take_from_sender<Coin<SUI>>(&scenario);
        let x = coin::mint(&mut treasury_cap, INITIAL_TEST_TOKEN, scenario.ctx());

        let lp = swap::add_liquidity(&mut pool, x, sui, scenario.ctx());
        public_transfer(lp, test_addr);

        ts::return_shared(pool);
        ts::return_to_sender(&scenario, treasury_cap);
    };

    // mint swap amount and perform swap
    scenario.next_tx(test_addr);
    {
        let mut treasury_cap = ts::take_from_sender<TreasuryCap<TEST_TOKEN>>(&scenario);
        let dx = coin::mint(&mut treasury_cap, SWAP_AMOUNT, scenario.ctx());

        let mut pool = ts::take_shared<Pool<TEST_TOKEN>>(&scenario);
        let min_dy = 0;

        let sui_out = swap::swap_x_to_sui(&mut pool, dx, min_dy, scenario.ctx());
        assert!(coin::value(&sui_out) > 0, 1);

        ts::return_shared(pool);
        ts::return_to_sender(&scenario, treasury_cap);
        public_transfer(sui_out, test_addr);
    };
    scenario.end();
}

#[test]
fun test_swap_sui_to_x() {
    let test_addr = @0x2;
    let mut scenario = ts::begin(test_addr);

    scenario.next_tx(test_addr);
    {
        init_for_test(ts::ctx(&mut scenario));
    };

    // mint initial liquidity
    scenario.next_tx(test_addr);
    {
        let mut tc = ts::take_from_sender<TreasuryCap<TEST_TOKEN>>(&scenario);
        coin::mint_and_transfer<TEST_TOKEN>(
            &mut tc,
            INITIAL_TEST_TOKEN,
            test_addr,
            ts::ctx(&mut scenario),
        );
        ts::return_to_sender(&scenario, tc);

        let sui: Coin<SUI> = mint_for_testing(INITIAL_SUI, scenario.ctx());
        public_transfer(sui, test_addr);
    };

    scenario.next_tx(test_addr);
    {
        swap::create_pool<TEST_TOKEN>(FEE_BPS, scenario.ctx());
    };

    scenario.next_tx(test_addr);
    {
        let mut pool = ts::take_shared<Pool<TEST_TOKEN>>(&scenario);
        let mut treasury_cap = ts::take_from_sender<TreasuryCap<TEST_TOKEN>>(&scenario);
        let sui = ts::take_from_sender<Coin<SUI>>(&scenario);
        let x = coin::mint(&mut treasury_cap, INITIAL_TEST_TOKEN, scenario.ctx());

        let lp = swap::add_liquidity(&mut pool, x, sui, scenario.ctx());
        public_transfer(lp, test_addr);

        ts::return_shared(pool);
        ts::return_to_sender(&scenario, treasury_cap);
    };

    // mint swap amount and perform swap
    scenario.next_tx(test_addr);
    {
        let dy: Coin<SUI> = mint_for_testing(SWAP_AMOUNT, scenario.ctx());
        let mut pool = ts::take_shared<Pool<TEST_TOKEN>>(&scenario);
        let min_dx = 0;

        let x_out = swap::swap_sui_to_x(&mut pool, dy, min_dx, scenario.ctx());
        assert!(coin::value(&x_out) > 0, 2);

        ts::return_shared(pool);
        public_transfer(x_out, test_addr);
    };
    scenario.end();
}
