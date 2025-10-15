#[test_only]
module module_2::goodboy_coin_tests;

use module_2::goodboy_coin::{Self, init_for_test, GOODBOY_COIN};
use sui::coin::{TreasuryCap, Coin};      // bỏ 'Self' để hết warning unused alias
use sui::test_scenario as ts;            // dùng ts::begin, ts::ctx
// KHÔNG dùng: `use sui;`  <-- dòng này gây lỗi

/// Verify init transfers TreasuryCap to sender.
#[test]
fun test_init() {
    let addr = @0xA;
    let mut sc = ts::begin(addr);
    { init_for_test(ts::ctx(&mut sc)); };

    sc.next_tx(addr);

    let tcap = sc.take_from_sender<TreasuryCap<GOODBOY_COIN>>();
    sc.return_to_sender(tcap);

    sc.end();
}

/// Verify mint mints exact amount.
#[test]
fun test_mint() {
    let addr = @0xA;
    let mut sc = ts::begin(addr);
    { init_for_test(ts::ctx(&mut sc)); };

    sc.next_tx(addr);
    {
        let mut tcap = sc.take_from_sender<TreasuryCap<GOODBOY_COIN>>();
        let coin_minted = goodboy_coin::mint(&mut tcap, 1000, sc.ctx());
        assert!(sui::coin::value(&coin_minted) == 1000, 0);
        sui::transfer::public_transfer(coin_minted, addr);
        sc.return_to_sender(tcap);
    };
    sc.end();
}

/// Verify burn returns burned amount.
#[test]
fun test_burn() {
    let addr = @0xA;
    let mut sc = ts::begin(addr);
    { init_for_test(ts::ctx(&mut sc)); };

    sc.next_tx(addr);
    {
        let mut tcap = sc.take_from_sender<TreasuryCap<GOODBOY_COIN>>();
        let coin_minted = goodboy_coin::mint(&mut tcap, 1000, sc.ctx());
        assert!(sui::coin::value(&coin_minted) == 1000, 0);

        let burned = goodboy_coin::burn(&mut tcap, coin_minted);
        assert!(burned == 1000, 1);

        sc.return_to_sender(tcap);
    };
    sc.end();
}

/// Split a coin and burn half.
#[test]
fun test_split_and_burn() {
    let addr = @0xA;
    let mut sc = ts::begin(addr);
    { init_for_test(ts::ctx(&mut sc)); };

    // Tx1: mint
    sc.next_tx(addr);
    {
        let mut tcap = sc.take_from_sender<TreasuryCap<GOODBOY_COIN>>();
        let coin_minted = goodboy_coin::mint(&mut tcap, 1000, sc.ctx());
        assert!(sui::coin::value(&coin_minted) == 1000, 0);
        sui::transfer::public_transfer(coin_minted, addr);
        sc.return_to_sender(tcap);
    };

    // Tx2: split & burn
    sc.next_tx(addr);
    {
        let mut tcap = sc.take_from_sender<TreasuryCap<GOODBOY_COIN>>();
        let mut coin_taken = sc.take_from_sender<Coin<GOODBOY_COIN>>();

        let half = sui::coin::split(&mut coin_taken, 500, sc.ctx());
        assert!(sui::coin::value(&half) == 500, 1);
        assert!(sui::coin::value(&coin_taken) == 500, 2);

        let burned = goodboy_coin::burn(&mut tcap, half);
        assert!(burned == 500, 3);

        sc.return_to_sender(tcap);
        sc.return_to_sender(coin_taken);
    };
    sc.end();
}
