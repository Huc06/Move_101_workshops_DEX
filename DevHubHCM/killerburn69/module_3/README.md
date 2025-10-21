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

- **Token A**: (Token A)
- **Token B**: (Token B)
- **TreasuryCap ID A**: `0xb04b6721fba2bb2f7b36c293e7c968080ba1c3455e316f9b881151b14110717d`
- **Coin ID A**: `0xa25779c35e8c891b8ddb5ae825f5d0f0180e1f709877ac64d2fa6174f5cc6d5e`
- **TreasuryCap ID B**: `0x648ceedd19eadd2e39a7127fefddc88f70d8d546a2c2b2731130811dceb05465`
- **Coin ID B**: `0x517341b9a357ad30dd12ef431918b7181c900c5e9877af368dc526f5ef754348`
- **Package ID**: `0xbd8ab4002518ed2aa64b2486144a544224c5040f335822a3d429278d43151195`
- **Pool ID**: `0xccfd9c727f1574fa6d1d95e2b52d4cfacf22f44b14f3330d0293f3cfadbf4e0f`
- **Exchange Rate**: 1 Token A = 1 Token B

## 🔗 Transactions

- **Deploy TX**: https://suiscan.xyz/testnet/tx/GicCu3dgGRgd2TQZSrxr1bEE1yebJ3wxNDxSL9LXCz4i
- **Add liquidity into Pool TX**: https://suiscan.xyz/testnet/tx/6GFobP4PcrkqevjRnURi11sT1R2TXig9gvHpybSuUTkJ
- **Deposit TX A**: https://suiscan.xyz/testnet/tx/Dmvb2bMmazAKjEgbXY7P5mZCkmxXNmtpCMcpTh6ZGCCf
- **Deposit TX B**: https://suiscan.xyz/testnet/tx/BNtNNZzVdUNyZBDtKhxymVPBoJ1SSe5UgWC4BXfEoQyK
- **Swap TX 1**: https://suiscan.xyz/testnet/tx/DyhY53mcUAjNmgZLh6b227RJzaVo9NdByq1W11MCLbQS
- **Swap TX 2**: https://suiscan.xyz/testnet/tx/67oz6jAX65rc6tEFgMomNXgxfUjapbeBcZYzBVvworvc

## 📂 Files

Add your code to:
- `sources/swap.move` 
- `tests/swap_tests.move`

## 📅 Completion

- **Submission Date**: 22/10/2025
- **Status**:  ✅ Completed


## 🧠 How to Run

### 1️⃣ Mint Tokens
Trước khi nạp hoặc swap, bạn **phải mint lại** `Token A` và `Token B`, vì mỗi `Coin` chỉ dùng được **một lần** trong giao dịch (sau khi swap/deposit, object bị consume).

```bash
# Mint Token A
sui client call \
  --package 0xbd8ab4002518ed2aa64b2486144a544224c5040f335822a3d429278d43151195 \
  --module token_a \
  --function mint_token \
  --args \
    0xb04b6721fba2bb2f7b36c293e7c968080ba1c3455e316f9b881151b14110717d \
    1000000000 \
  --gas-budget 100000000


  # Mint Token B
sui client call \
  --package 0xbd8ab4002518ed2aa64b2486144a544224c5040f335822a3d429278d43151195 \
  --module token_b \
  --function mint_token \
  --args \
    0x648ceedd19eadd2e39a7127fefddc88f70d8d546a2c2b2731130811dceb05465 \
    1000000000 \
  --gas-budget 100000000



sui client call \
  --package 0xbd8ab4002518ed2aa64b2486144a544224c5040f335822a3d429278d43151195 \
  --module swap \
  --function add_money_to_pool \
  --args \
    0xccfd9c727f1574fa6d1d95e2b52d4cfacf22f44b14f3330d0293f3cfadbf4e0f \
    <COIN_A_ID> \
    <COIN_B_ID> \
  --gas-budget 100000000


sui client call \
  --package 0xbd8ab4002518ed2aa64b2486144a544224c5040f335822a3d429278d43151195 \
  --module swap \
  --function swap_token_a_to_token_b \
  --args \
    0xccfd9c727f1574fa6d1d95e2b52d4cfacf22f44b14f3330d0293f3cfadbf4e0f \
    <COIN_A_ID> \
  --gas-budget 100000000



sui client call \
  --package 0xbd8ab4002518ed2aa64b2486144a544224c5040f335822a3d429278d43151195 \
  --module swap \
  --function swap_token_b_to_token_a \
  --args \
    0xccfd9c727f1574fa6d1d95e2b52d4cfacf22f44b14f3330d0293f3cfadbf4e0f \
    <COIN_B_ID> \
  --gas-budget 100000000
