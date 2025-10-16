module module_3::token_b {
    use sui::coin::{Self, TreasuryCap, CoinMetadata};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::ascii::String;

    public struct TOKEN_B has drop {}

    fun init(witness: TOKEN_B, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency<TOKEN_B>(
            witness,
            6,                
            b"TKNB",          
            b"Token B",       
            b"My_B_coin",           
            option::none(), 
            ctx

        );
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, ctx.sender());
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<TOKEN_B>, amount: u64, ctx: &mut TxContext){
        coin::mint_and_transfer(treasury, amount, ctx.sender(), ctx);
    }

    public entry fun burn(treasury: &mut TreasuryCap<TOKEN_B>, coins: coin::Coin<TOKEN_B>) {
        coin::burn(treasury, coins);
    }
}
