module module_3::swap{
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use module_3::token_a::{TOKEN_A};
    use module_3::token_b::{TOKEN_B};


    public struct Pool has key{
        id: UID,
        token_a: Balance<TOKEN_A>,
        token_b: Balance<TOKEN_B>,
    }
    fun init(ctx: &mut TxContext){
        let pool = Pool{
            id: object::new(ctx),
            token_a: balance::zero<TOKEN_A>(),
            token_b: balance::zero<TOKEN_B>()
        };
        transfer::share_object(pool);
    }
    public entry fun add_money_to_pool(pool: &mut Pool, coin_a: Coin<TOKEN_A>, coin_b: Coin<TOKEN_B>){
        pool.token_a.join(coin::into_balance(coin_a));
        pool.token_b.join(coin::into_balance(coin_b));
    }
    public entry fun deposit_token_a(pool: &mut Pool, coin_a: Coin<TOKEN_A>){
        coin::put(&mut pool.token_a, coin_a);
    }
    public entry fun deposit_token_b(pool: &mut Pool, coin_b: Coin<TOKEN_B>){
        coin::put(&mut pool.token_b, coin_b);
    }
    public entry fun swap_token_a_to_token_b(pool: &mut Pool, coin_a: Coin<TOKEN_A>, ctx: &mut TxContext){
        let amount = coin::value(&coin_a);
        coin::put(&mut pool.token_a, coin_a);
        assert!(amount > 0, 0);
        let output_token_took = coin::take(&mut pool.token_b, amount, ctx);
        transfer::public_transfer(output_token_took, ctx.sender());
    } 
    public entry fun swap_token_b_to_token_a(pool: &mut Pool, coin_b: Coin<TOKEN_B>, ctx: &mut TxContext){
        let amount = coin::value(&coin_b);
        coin::put(&mut pool.token_b, coin_b);
        assert!(amount > 0, 1);
        let output_token_took = coin::take(&mut pool.token_a, amount, ctx);
        transfer::public_transfer(output_token_took, ctx.sender());
    }

}