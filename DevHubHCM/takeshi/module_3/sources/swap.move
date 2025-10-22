module module_3::swap;


use sui::balance::{Self, Balance};

use sui::coin::{Self, Coin};

use module_3::sai_token::SAI_TOKEN;

use module_3::sao_token::{Self, SAO_TOKEN};


public struct Pool has key {

   id: UID,

   sao_token: Balance<SAO_TOKEN>,

   sai_token: Balance<SAI_TOKEN>,

}


fun init(ctx: &mut TxContext) {

   let pool = Pool {

       id: object::new(ctx),

       sao_token: balance::zero<SAO_TOKEN>(),

       sai_token: balance::zero<SAI_TOKEN>(),

   };


   transfer::share_object(pool);

}


#[allow(unused_function)]

entry fun add_money_to_pool(

   pool: &mut Pool,

   sao_token: Coin<SAO_TOKEN>,

   sai_token: Coin<SAI_TOKEN>,

) {

   pool.sao_token.join(sao_token.into_balance());

   pool.sai_token.join(sai_token.into_balance());

}


public entry fun deposit_sao_token(

   pool: &mut Pool,

   user_coin: Coin<SAO_TOKEN>,

   ctx: &mut TxContext,

) {

   coin::put(&mut pool.sao_token, user_coin);

}


public entry fun deposit_sai_token(

   pool: &mut Pool,

   user_coin: Coin<SAI_TOKEN>,

   ctx: &mut TxContext,

) {

   coin::put(&mut pool.sai_token, user_coin);

}


public entry fun swap_sao_token_to_sai_token(

   pool: &mut Pool,

   sao_token: Coin<SAO_TOKEN>,

   ctx: &mut TxContext,

) {

   let amount = sao_token.value();

   assert!(amount > 0, 0);


   pool.sao_token.join(sao_token.into_balance());


   let output_coin = coin::take(&mut pool.sai_token, amount, ctx);

   transfer::public_transfer(output_coin, ctx.sender());

}


public entry fun swap_sai_token_to_sao_token(

   pool: &mut Pool,

   sao_token: Coin<SAI_TOKEN>,

   ctx: &mut TxContext,

) {

   let amount = sao_token.value();

   assert!(amount > 0, 0);


   pool.sai_token.join(sao_token.into_balance());


   let output_coin = coin::take(&mut pool.sao_token, amount, ctx);

   transfer::public_transfer(output_coin, ctx.sender());

}