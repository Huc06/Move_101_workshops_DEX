module hulk_token::hulk_token;

use sui::coin::{Self, TreasuryCap};
use sui::transfer;
use sui::tx_context;
use sui::url::{Self, new_unsafe_from_bytes};

//One Time witness
public struct HULK_TOKEN has drop {}

fun init(witness: HULK_TOKEN, ctx: &mut TxContext) {
    let (treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        9,
        b"H",
        b"Hulk",
        b"I like It",
        option::some(
            url::new_unsafe_from_bytes(
                b"https://scontent.fsgn2-9.fna.fbcdn.net/v/t39.30808-6/488251048_1183086246507040_6705550056713285703_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=Hfam5NSGw6oQ7kNvwHdvK9H&_nc_oc=AdlaycrbCDKzPBpgqiDz2yL88VkjVU2FgWFS2xDsuWYYrUbHqHzhzI1CCwO3lehLGoY&_nc_zt=23&_nc_ht=scontent.fsgn2-9.fna&_nc_gid=OhyNfk9H19xE_enPdoPg1Q&oh=00_AfeSRlukB6F-V010D_DpsWQOcBo_6FH9OrsIVFittSjwaA&oe=68F2DC46",
            ),
        ),
        ctx,
    );

    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap, ctx.sender());
}

entry fun mint_token(treasury_cap: &mut TreasuryCap<HULK_TOKEN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury_cap, 1_000_000_000_000_000, ctx);
    transfer::public_transfer(coin_object, ctx.sender())
}
