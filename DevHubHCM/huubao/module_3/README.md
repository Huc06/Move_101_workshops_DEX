# Module 3: Swap Contract

## ✅ Tasks

- [x] Create Pool structure (2 tokens)
- [x] Implement deposit functions (2 tokens)
- [x] Implement swap function (Token A → Token B)
- [x] Implement swap function (Token B → Token A)
- [x] Set exchange rate
- [ ] Write tests
- [x] Deploy to testnet
- [x] Test swap transactions

## 📦 Deployment Info

- **Token A**: SD_COIN (Sui Dev)
- **Token B**: SU_COIN (Sui User)
- **Package ID**: `0x2f691f4e363b09943567177d1f6be2402f787c2b8b9d9f4330737f6b7fd2c34b`
- **Pool ID**: `0xd207ba24b3a3e9cc100ca23b5f21e333087eae8d4a7974f3e3b7b8fbedb4a81d`
- **Treasury Cap SD**: `0x7925432e2acc34bc7600caf7a8d828ed691b101bf7da2cd3752526afe1d5bb12`
- **Treasury Cap SU**: `0x8750701f53e123102815f688d59a3c76225f78dd1cc0ae05604179fa4b54a2d1`
- **Exchange Rate**: 1 SD_COIN = 1 SU_COIN (1:1 ratio)

## 🔗 Transactions

- **Deploy TX**: https://suiscan.xyz/testnet/tx/CvRqjnDMShvZwu7Fr6VkWxEu1TxS8AFdLm7AFkZ6EY3G
- **Create Pool TX**: https://suiscan.xyz/testnet/tx/CvRqjnDMShvZwu7Fr6VkWxEu1TxS8AFdLm7AFkZ6EY3G
- **Mint SD TX**: https://suiscan.xyz/testnet/tx/szv9bDiV5qf5eLovqDM6EAewSTLZu46gXXpEXEq2S2i
- **Mint SU TX**: https://suiscan.xyz/testnet/tx/6xwfBExHU8LCUETEzwGVuQ6VG29rNEomn5uwhDLbrH3X
- **Deposit SD TX**: https://suiscan.xyz/testnet/tx/8ybjuQK5EJw56m4XfLE3F4FghGDmbHVbjttVSKJZY7FS
- **Deposit SU TX**: https://suiscan.xyz/testnet/tx/5MWYbUWMisfVV7heVJk7umdfgBiWyRRtLZmx6hXzcsvg
- **Swap SD→SU TX**: https://suiscan.xyz/testnet/tx/AppDkMeKZn8KTTpT2SWhqvky6ezznk3XFtqs5jNWMBVZ
- **Swap SU→SD TX**: https://suiscan.xyz/testnet/tx/5vMVUGAA5nuWKNUiE3YUyG35HhodmFYAeRemy9YngydT

## 📂 Files

Smart Contracts:
- `sources/sd_coin.move` - SD Token implementation
- `sources/su_coin.move` - SU Token implementation
- `sources/swap.move` - Swap Pool implementation
- `tests/swap_tests.move` - Test cases (To be implemented)

## 📅 Completion

- **Submission Date**: October 22, 2025
- **Status**: 🚧 In Progress
- **Deployed By**: huubao

