# Module 3: Swap Contract

## ✅ Tasks

- [x] Create Pool structure (2 tokens)
- [x] Implement deposit functions (2 tokens)
- [x] Implement swap function (Token A → Token B)
- [x] Implement swap function (Token B → Token A)
- [x] Set exchange rate
- [x] Write tests
- [x] Deploy to testnet
- [x] Test swap transactions

## 📦 Deployment Info

- **Token A**: TEST
- **Token B**: SUI
- **Package ID**: `0x67452e74099ae7ba3c5d7a2f9b4274b3cac24edbe81fdab7f470b1e667393d7d`
- **Pool ID**: `0x418cc6fb912e895319717a5b454587a18a44b5d3ee06c00c1ca3ec55656573a8`
- **TreasuryCap ID A**: `0x4e4ab932a358e66e79cce1d94457d50029af1e750482ca3619ea3dd41f1c62b4`
- **TreasuryCap ID B**: `SUI`
- **Exchange Rate**: 90 TEST = 1 SUI

## 🔗 Transactions

- **Deploy TX**: https://suiscan.xyz/testnet/tx/EbzgzuqLiniT45JNypAHb6VMqzZtNeVsjmRcuFypk42k
- **Create Pool TX**: https://suiscan.xyz/testnet/tx/5n1vBWL4khd6FxbiU9RASR4wxYvrFSNL7CSKhuLoo6Tu,
- **Deposit TX**: https://suiscan.xyz/testnet/tx/3fLi3cstD6VH5jpE2nKHrwKvKTpEm7phdx1mbLaj3QLw
- **Swap TX 1**: https://suiscan.xyz/testnet/tx/EmUw2Dt9c9G1Z3wWm2yVGgZQarECeK2eQL8HB5CV9Dp2
- **Swap TX 2**: https://suiscan.xyz/testnet/tx/37r1kt85YQMosEBN7NxvTviF4rszmoB3YmJWJHyHxYS7

## 📂 Files

My code:

- `sources/test_token.move`
- `sources/swap.move`
- `tests/swap_tests.move`

## 📅 Completion

- **Submission Date**: 16-10-2025
- **Status**: ✅ Completed

## 🐝 Command CLI

### Create Pool

Note: remember to replace `<package_id>` with your Package ID, for example `--package 0xabc123...`

```
sui client call \
  --package <package_id> \
  --module swap \
  --function create_pool \
  --type-args <package_id>::test_token::TEST_TOKEN \
  --args 30
```

### Split coin

Note: You need to split your `SUI` and `TEST` coins.
Here’s the PTB command to split your SUI coin.
Replace `<sui_coin_id>` with your SUI coin ID.
`10000000000` equals `10 SUI`.
Do the same for the `TEST` coin.

```
sui client ptb \
  --move-call sui::tx_context::sender \
  --assign sender \
  --split-coins @<sui_coin_id> "[10000000000]" \
  --assign new_suis \
  --transfer-objects "[new_suis.0]" sender \
  --gas-budget 100000000
```

### Add Liquidity

```
sui client ptb \
  --move-call sui::tx_context::sender \
  --assign sender \
  --assign splitted_sui @<splitted_sui_coin_id> \
  --assign splitted_test @<slitted_test_coin_id>
  --move-call <package_id>::swap::add_liquidity "<<package_id>::test_token::TEST_TOKEN>" @<pool_id> splitted_test splitted_sui \
  --assign lp \
  --transfer-objects "[lp]" sender \
  --gas-budget 100000000
```

### Swap SUI to TEST

```
sui client ptb \
  --assign splitted_sui @<splitted_sui_coin_id> \
  --move-call sui::tx_context::sender --assign sender \
  --move-call <package_id>::swap::swap_sui_to_x "<<package_id>::test_token::TEST_TOKEN>" @<pool_id> split_sui 0 \
  --assign x_out \
  --transfer-objects "[x_out]" sender \
  --gas-budget 100000000
```

### Swap TEST to SUI

```
sui client ptb \
  --assign splitted_test @<splitted_test_coin_id> \
  --move-call sui::tx_context::sender --assign sender \
  --move-call <package_id>::swap::swap_x_to_sui "<<package_id>::test_token::TEST_TOKEN>" @<pool_id> splitted_test 0 \
  --assign sui_out \
  --transfer-objects "[sui_out]" sender \
  --gas-budget 100000000
```
