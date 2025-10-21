# Module 2: Create Your Token

## ✅ Tasks

- [x] Create your token (e.g., GOLD, SILVER, RUBY...)
- [x] Implement `init` function
- [x] Implement `mint` function
- [x] Deploy to testnet
- [x] Mint test tokens

## 📦 Deployment Info

- **Token Name**: UPBO Coin
- **Token Symbol**: UPBO
- **Decimals**: 8
- **Package ID**: `0x88f94f5a0ee6049650f5cb399d77c81025ce166db31e6542eaf793656d854710`
- **TreasuryCap ID**: `0x8abcc72ebc3b53292fe6c4f9df7bce887ede926260b86fbf7dec3bb0cc3d4291`

## 🔗 Transactions

- **Deploy TX**: https://suiscan.xyz/testnet/tx/F8Trp3cVwTPMPfFpUvsb49tgzG3LxnbemsepsTKoExh9
- **Mint TX**: https://suiscan.xyz/testnet/tx/5vQoTGWq7ExzQzUCKUcU9uScpN2pvn9zPNdHLiUt838F
- **Coin**: https://suiscan.xyz/testnet/coin/0x88f94f5a0ee6049650f5cb399d77c81025ce166db31e6542eaf793656d854710::upbo_coin::UPBO_COIN/txs

## 📂 Files

Add your code to:

- `sources/upbo_coin.move`

## 📅 Completion

- **Submission Date**: 13-10-2025
- **Status**: ✅ Completed

## PTB command to mint & transfer

```move
sui client ptb \
  --move-call sui::tx_context::sender \
  --assign sender \
  --assign treasury @0x8abcc72ebc3b53292fe6c4f9df7bce887ede926260b86fbf7dec3bb0cc3d4291 \
  --assign amount 1000000000 \
  --move-call 0x88f94f5a0ee6049650f5cb399d77c81025ce166db31e6542eaf793656d854710::upbo_coin::mint treasury amount \
  --assign coin \
  --transfer-objects "[coin]" sender \
  --gas-budget 100000000
```

## PTB command to split & burn 100000000

```move
sui client ptb \
  --move-call sui::tx_context::sender \
  --assign sender \
  --assign treasury @0x8abcc72ebc3b53292fe6c4f9df7bce887ede926260b86fbf7dec3bb0cc3d4291 \
  --assign full_coin @coin_object_id_to_burn_here \
  --split-coins full_coin "[100000000]" \
  --assign coins \
  --move-call 0x88f94f5a0ee6049650f5cb399d77c81025ce166db31e6542eaf793656d854710::upbo_coin::burn treasury coins.0 \
  --transfer-objects "[full_coin]" sender \
  --gas-budget 100000000
```
