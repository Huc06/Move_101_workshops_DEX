module tokena::tokena;

use sui::coin::{Self, Coin, TreasuryCap};

public struct TOKENA has drop {}


// &mut là có thể thay đổi
fun init(witness: TOKENA, ctx: &mut TxContext) {
    // Create the TokenA currency with 9 decimal places, symbol "TKA", name "Token A", and an empty URL.
    // let là lệnh khai báo biến "let x = ...", khai báo nhiều biến cùng lúc "let (x, y) = ..."
    let (treasurycap, coinmetadata) = coin::create_currency<TOKENA>(
        witness,
        9, 
        b"TKA", 
        b"Token A", 
        b"Token A.",
        option::none(),
        ctx
    );

    // Store the TreasuryCap and CoinMetadata in the global storage so that they can be accessed later.
    // dữ liệu của coin này sẽ không được thay đổi
    transfer::public_freeze_object(coinmetadata);

    transfer::public_transfer(treasurycap, ctx.sender());

}

entry fun CreateTokenA(treasurycap: &mut TreasuryCap<TOKENA>, amount: u64,  recipient: address, ctx: &mut TxContext){
    // The Coin type must also use the witness: Coin<SAIGONTOKEN>
    let coin_obj: Coin<TOKENA> = coin::mint(treasurycap, amount, ctx);
    transfer::public_transfer(coin_obj, recipient);
}