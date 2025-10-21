# Module 2: Create Your Token

## ✅ Tasks

- [x] Create your token (IUSEC)
- [x] Implement `init` function
- [x] Implement `mint` function
- [x] Implement `burn` function
- [x] Deploy to testnet
- [x] Mint test tokens (1,000,000 IUSEC)

## 📦 Token Metadata

- **Token Name**: IU Security
- **Token Symbol**: IUSEC
- **Decimals**: 6
- **Description**: Community token of IU Security
- **Icon URL**: https://lh3.googleusercontent.com/a/ACg8ocI2veqTRtgSnXy6dF6-gxpcTxkUahbn0DxbD8rUDpp_wLPYONk=s360-c-no

## 📦 Deployment Info

- **Package ID**: `0xdfa1d342ae653d980dc26b26be450063dc035744de649eb33623be16824decce`
- **TreasuryCap ID**: `0x546919667c7df7ac39340bfec4b901db600147a2675f80f65cfb0f11c8cb0d66`

## 🔗 Transactions

- **Deploy TX**: https://suiscan.xyz/testnet/tx/4Uw9exroieFXuQ74BhVRGFVHdmHBXyCS2RJs3FM6qioz
- **Mint TX**: https://suiscan.xyz/testnet/tx/9kRAGYsWdFJ5yetNs1ZyYPoate9vdQZfgMAeDBNkEdKa
- **Minted Coin**: https://suiscan.xyz/testnet/object/0x6581d25f4009a64ee19e40b928befe3b849410b0ae4d0bce77ce3454a700ee4c

## 📂 Files

Implementation in:

- `sources/iusec.move`

## 🚀 Deployment Steps (Executed Commands)

### 1. Build the package
```bash
sui move build
```

### 2. Check gas balance
```bash
sui client gas
```

### 3. Deploy to testnet

```bash
sui client publish --gas-budget 50000000
```

**Result:**

- Package ID: `0xdfa1d342ae653d980dc26b26be450063dc035744de649eb33623be16824decce`
- TreasuryCap ID: `0x546919667c7df7ac39340bfec4b901db600147a2675f80f65cfb0f11c8cb0d66`
- Deploy TX: `4Uw9exroieFXuQ74BhVRGFVHdmHBXyCS2RJs3FM6qioz`

### 4. Get active address

```bash
sui client active-address
```

**Result:** `0x06c69714bd8c50f1c2b50f4bf4f8343648d2d72fc12df4dc267ad8636410cdc1`

### 5. Mint tokens (1,000,000 IUSEC)

```bash
sui client call \
  --package 0xdfa1d342ae653d980dc26b26be450063dc035744de649eb33623be16824decce \
  --module iusec \
  --function mint \
  --args 0x546919667c7df7ac39340bfec4b901db600147a2675f80f65cfb0f11c8cb0d66 1000000000000 0x06c69714bd8c50f1c2b50f4bf4f8343648d2d72fc12df4dc267ad8636410cdc1 \
  --gas-budget 10000000
```

**Result:**

- Mint TX: `9kRAGYsWdFJ5yetNs1ZyYPoate9vdQZfgMAeDBNkEdKa`
- Minted Coin Object: `0x6581d25f4009a64ee19e40b928befe3b849410b0ae4d0bce77ce3454a700ee4c`
- Amount: 1,000,000 IUSEC (1000000000000 with 6 decimals)

### 6. Burn tokens (optional)

```bash
sui client call \
  --package 0xdfa1d342ae653d980dc26b26be450063dc035744de649eb33623be16824decce \
  --module iusec \
  --function burn \
  --args 0x546919667c7df7ac39340bfec4b901db600147a2675f80f65cfb0f11c8cb0d66 <COIN_OBJECT_ID> \
  --gas-budget 10000000
```

**Note:** Amount includes decimals (6), so 1,000,000 tokens = 1000000000000

## 📝 Key Functions

### `init(witness: IUSEC, ctx: &mut TxContext)`

- Automatically called on deployment
- Creates token with metadata
- Transfers TreasuryCap to deployer

### `mint(treasury_cap: &mut TreasuryCap<IUSEC>, amount: u64, recipient: address, ctx: &mut TxContext)`

- Mints new tokens
- Requires TreasuryCap ownership
- Transfers minted coins to recipient

### `burn(treasury_cap: &mut TreasuryCap<IUSEC>, coin: Coin<IUSEC>)`

- Burns tokens permanently
- Requires TreasuryCap for authorization
- Reduces total supply

## 📅 Completion

- **Submission Date**: October 13, 2025
- **Status**: ✅ Completed - Deployed & Minted Successfully
