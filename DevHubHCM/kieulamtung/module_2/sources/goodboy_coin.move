module module_2::goodboy_coin;

use sui::coin::{Self, TreasuryCap};
use sui::transfer;
use sui::tx_context;
use sui::url::{Self, new_unsafe_from_bytes};

//One Time witness
public struct GOODBOY_COIN has drop {}

fun init(witness: GOODBOY_COIN, ctx: &mut TxContext) {
    let (treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        9,
        b"GDB",
        b"GoodBoy",
        b"I like It",
        option::some(
            url::new_unsafe_from_bytes(
                b"https://scontent.fsgn24-1.fna.fbcdn.net/v/t39.30808-6/494992055_122153443514515579_8543661755464771928_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=a5f93a&_nc_eui2=AeGJBouiQvCmls0h40JJAyJBo6iYxDBtHtajqJjEMG0e1lkfrxhtqUx6HXIKLuu24wkWZs106HwlBS1GPr-R6oNv&_nc_ohc=vETHcLQPZpUQ7kNvwH0sl8r&_nc_oc=AdlLUoyCw4RaV8jeWKu9OBvyvYAarfFXId9T5mccN0eRnxo3Hvwe-wC7Tv2LVPi9yzs&_nc_zt=23&_nc_ht=scontent.fsgn24-1.fna&_nc_gid=Imk_r0-pZxzVY_FRGsbyiQ&oh=00_AffJ53-4Yd8vMwFYjou3i1qUbePIqHKC1efE0HtDt63pOA&oe=68F5812E",
            ),
        ),
        ctx,
    );

    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap, ctx.sender());
}

entry fun mint_token(treasury_cap: &mut TreasuryCap<GOODBOY_COIN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury_cap, 1_000_000_000_000_000, ctx);
    transfer::public_transfer(coin_object, ctx.sender())
}