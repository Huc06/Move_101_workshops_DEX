# Module 2: Create Your Token

## ✅ Tasks

- [x] Create your token (e.g., GOLD, SILVER, RUBY...)
- [x] Implement `init` function
- [x] Implement `mint` function
- [x] Deploy to testnet
- [x] Mint test tokens

## 📦 Deployment Info

- **Token Name**: Sui Dev
- **Token Symbol**: SD
- **Decimals**: 9
- **Package ID**: 0x686df6ae2772db19f10f288e35f0a0d774190ea36fbcca60fe91a413b992bf5e
- **TreasuryCap ID**: 0xb946472394170167c141a549eba5de8d9798335fb98ba694686b25f67fcba1e1

## 🔗 Transactions

- **Deploy TX**: https://suiscan.xyz/testnet/tx/A19ps4aFGxCLhR2p8SxDxpoZWnkPxEhNBYMzfsRvQiMr
- **Mint TX**: https://suiscan.xyz/testnet/tx/Ai5kELEfQGDUifgpQWX3beoPGK417bx1C8eGGvazsG3o

## 📂 Files

Add your code to:
- `sources/your_token.move`

## 📅 Completion

- **Submission Date**: 21/10/2025
- **Status**: ✅ Completed

sui client call --package 0x686df6ae2772db19f10f288e35f0a0d774190ea36fbcca60fe91a413b992bf5e \
  --module SD \
  --function mint_sd \
  --args 0xb946472394170167c141a549eba5de8d9798335fb98ba694686b25f67fcba1e1 100000000 0x0ea5ff0a9eb0a154033484491e7695803ff0bf83030affd272d841376d4ddd93 \
  --gas-budget 100000000