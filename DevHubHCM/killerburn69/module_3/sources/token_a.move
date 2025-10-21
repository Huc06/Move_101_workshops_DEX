module module_3::token_a {
    use sui::coin::{Self, TreasuryCap, CoinMetadata};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::ascii::String;

    public struct TOKEN_A has drop {}

    fun init(witness: TOKEN_A, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency<TOKEN_A>(
            witness,
            6,                
            b"TKN_A",          
            b"Token A",       
            b"My_A_coin",           
            option::none(), 
            ctx

        );
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, ctx.sender());
    }

    /// Mint thêm token A
    public entry fun mint_token(treasury: &mut TreasuryCap<TOKEN_A>, amount: u64, ctx: &mut TxContext){
        coin::mint_and_transfer(treasury, amount, ctx.sender(), ctx);
    }

    /// burn token A
    public entry fun burn(treasury: &mut TreasuryCap<TOKEN_A>, coins: coin::Coin<TOKEN_A>) {
        coin::burn(treasury, coins);
    }
}