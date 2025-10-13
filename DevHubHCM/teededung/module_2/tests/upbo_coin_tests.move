#[test_only]
module module_2::upbo_coin_tests;

use module_2::upbo_coin::{Self, init_for_test, UPBO_COIN};
use sui::coin::{Self, TreasuryCap, Coin};
use sui::coin_registry::MetadataCap;
use sui::test_scenario as ts;

/// Test the initialization of the UPBO_COIN module.
/// Verifies that TreasuryCap and MetadataCap are transferred to the publisher.
#[test]
fun test_init() {
    let addr = @0xA;

    // Simulate module initialization.
    let mut scenario = ts::begin(addr);
    {
        init_for_test(ts::ctx(&mut scenario));
    };

    // Advance to the next transaction to check transferred objects.
    scenario.next_tx(addr);

    // Verify TreasuryCap is owned by the sender.
    let treasury_cap = scenario.take_from_sender<TreasuryCap<UPBO_COIN>>();
    scenario.return_to_sender(treasury_cap);

    // Verify MetadataCap is owned by the sender (assuming MetadataCap type from coin_registry).
    let metadata_cap = scenario.take_from_sender<MetadataCap<UPBO_COIN>>();
    scenario.return_to_sender(metadata_cap);

    scenario.end();
}

/// Test the mint function.
/// Verifies that a new coin can be minted with the correct value.
#[test]
fun test_mint() {
    let addr = @0xA;

    // Simulate module initialization to create TreasuryCap.
    let mut scenario = ts::begin(addr);
    {
        init_for_test(ts::ctx(&mut scenario));
    };

    // Advance to the next transaction.
    scenario.next_tx(addr);

    // Mint a coin using the TreasuryCap.
    {
        let mut treasury_cap = scenario.take_from_sender<TreasuryCap<UPBO_COIN>>();

        let coin = upbo_coin::mint(&mut treasury_cap, 1000, scenario.ctx());

        // Verify the minted coin has the correct value.
        assert!(coin.value() == 1000, 0);

        // Clean up: transfer coin back and return TreasuryCap.
        transfer::public_transfer(coin, addr);
        scenario.return_to_sender(treasury_cap);
    };

    // Clean up MetadataCap (assuming it's present).
    let metadata_cap = scenario.take_from_sender<MetadataCap<UPBO_COIN>>();
    scenario.return_to_sender(metadata_cap);

    scenario.end();
}

/// Test the burn function.
/// Verifies that a coin can be burned and the correct amount is returned.
#[test]
fun test_burn() {
    let addr = @0xA;

    // Simulate module initialization to create TreasuryCap.
    let mut scenario = ts::begin(addr);
    {
        init_for_test(ts::ctx(&mut scenario));
    };

    // Advance to the next transaction.
    scenario.next_tx(addr);

    // Mint and then burn a coin using the TreasuryCap.
    {
        let mut treasury_cap = scenario.take_from_sender<TreasuryCap<UPBO_COIN>>();

        let coin = upbo_coin::mint(&mut treasury_cap, 1000, scenario.ctx());

        // Verify the minted coin has the correct value.
        assert!(coin.value() == 1000, 0);

        // Burn the coin and verify the burned amount.
        let burned_amount = upbo_coin::burn(&mut treasury_cap, coin);
        assert!(burned_amount == 1000, 1);

        // Return TreasuryCap.
        scenario.return_to_sender(treasury_cap);
    };

    // Clean up MetadataCap (assuming it's present).
    let metadata_cap = scenario.take_from_sender<MetadataCap<UPBO_COIN>>();
    scenario.return_to_sender(metadata_cap);

    scenario.end();
}

#[test]
fun test_split_and_burn() {
    let addr = @0xA;

    // Khởi tạo module và tạo TreasuryCap.
    let mut scenario = ts::begin(addr);
    {
        init_for_test(ts::ctx(&mut scenario));
    };

    // Transaction 1: Mint coin.
    scenario.next_tx(addr);
    {
        // Lấy TreasuryCap từ sender.
        let mut treasury_cap = scenario.take_from_sender<TreasuryCap<UPBO_COIN>>();

        // Mint 1 coin giá trị 1000.
        let coinMinted = upbo_coin::mint(&mut treasury_cap, 1000, scenario.ctx());
        assert!(coinMinted.value() == 1000, 0);

        transfer::public_transfer(coinMinted, addr);
        scenario.return_to_sender(treasury_cap);
    };

    // Transaction 2: Split and burn coin.
    scenario.next_tx(addr);
    {
        let mut treasury_cap = scenario.take_from_sender<TreasuryCap<UPBO_COIN>>();
        let mut coinTaked = scenario.take_from_sender<Coin<UPBO_COIN>>();

        // Split coin ra thành 2 nửa: mỗi nửa 500.
        let half = coin::split(&mut coinTaked, 500, scenario.ctx());

        // Kiểm tra giá trị sau khi split.
        assert!(half.value() == 500, 1);
        assert!(coinTaked.value() == 500, 2);

        // Burn một nửa.
        let burned_amount = upbo_coin::burn(&mut treasury_cap, half);
        assert!(burned_amount == 500, 2);

        // Trả lại TreasuryCap và phần coin còn lại.
        scenario.return_to_sender(treasury_cap);
        scenario.return_to_sender(coinTaked);
    };

    scenario.end();
}
