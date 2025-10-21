# 🚀 Hướng dẫn Setup DEX Frontend

## ✅ Đã hoàn thành

### 1. **Hooks đã được sửa:**
- ✅ `use-balance.ts` - Lấy balance từ blockchain
- ✅ `use-swap.ts` - Thực hiện swap transactions  
- ✅ `use-mint.ts` - Mint tokens

### 2. **UI đã được cập nhật:**
- ✅ `swap-card.tsx` - Giao diện swap hoàn chỉnh
- ✅ `layout.tsx` - Thêm Toaster cho notifications
- ✅ Hiển thị balance thực từ blockchain
- ✅ Loading states và error handling

## 🔧 Cần làm tiếp

### 1. **Cài đặt dependencies:**
```bash
cd "/Users/huc/Downloads/momentum-defi-clone (1)/Move_101_workshops_source"
npm install sonner
```

### 2. **Tạo file `.env.local`:**
```env
# Sui Network Configuration
NEXT_PUBLIC_SUI_NETWORK=testnet

# Token Types (thay bằng token types thực tế của bạn)
NEXT_PUBLIC_TOKEN_A_TYPE=0x71a07c9a90824015c53d5c902e0cf8fb70e7f6e86f641fe0c17e9937d49e172e::hulk::HULK
NEXT_PUBLIC_TOKEN_B_TYPE=0x20958ffe5e9ed0be143822c218fb0d72e0cca73ee17acb080378d1ff9b970544::gf::GIRL

# Pool and Package IDs (thay bằng IDs thực tế của bạn)
NEXT_PUBLIC_POOL_ID=0xacba92299fea101b08e89b896010f90efc0b0c2cad217f414255536937322344
NEXT_PUBLIC_PACKAGE_ID=0x91531e57e6d877ab580f2e496080a81d41f7198c529003a59ccf2375c0637eaa

# Treasury Cap IDs (thay bằng Treasury Cap IDs thực tế của bạn)
NEXT_PUBLIC_TREASURY_CAP_A=0x664c292315e40173c6c6a578c76c418c1e9d2e21f9b28bea12a846d101941313
NEXT_PUBLIC_TREASURY_CAP_B=0x375fda4f40a545322b662bcd90d8945350a051c1993fd4f0465a21dfe428e56d
```

### 3. **Cập nhật Header để hiển thị ConnectButton:**
Trong `components/header.tsx`, thay thế text "Connect Wallet" bằng:
```tsx
import { ConnectButton } from '@mysten/dapp-kit'

// Trong JSX:
<ConnectButton />
```

### 4. **Chạy ứng dụng:**
```bash
npm run dev
```

## 🎯 Tính năng đã có

### **Swap Interface:**
- ✅ Hiển thị balance thực từ blockchain
- ✅ Chọn token từ/đến (HULK ↔ GIRL)
- ✅ Đổi token bằng nút mũi tên
- ✅ Nút MAX để set amount tối đa
- ✅ Validation input và balance

### **Mint Tokens:**
- ✅ Nút mint HULK token (1000 tokens)
- ✅ Nút mint GIRL token (1000 tokens)
- ✅ Chỉ hiện khi đã connect wallet

### **Swap Transactions:**
- ✅ Swap HULK → GIRL
- ✅ Swap GIRL → HULK
- ✅ Hiển thị transaction digest
- ✅ Auto refresh balance sau swap

### **Error Handling:**
- ✅ Toast notifications cho success/error
- ✅ Loading states
- ✅ Validation wallet connection
- ✅ Validation contract readiness

## 🔍 Kiểm tra

1. **Connect wallet** - Bấm Connect Wallet
2. **Mint tokens** - Bấm Mint HULK/GIRL để có token
3. **Check balance** - Xem balance hiển thị đúng
4. **Test swap** - Nhập amount và bấm Swap
5. **Verify transaction** - Kiểm tra transaction trên Suiscan

## 🐛 Troubleshooting

### Nếu gặp lỗi "Missing environment variables":
- Kiểm tra file `.env.local` có đúng format
- Restart dev server sau khi thêm env vars

### Nếu balance không hiển thị:
- Kiểm tra token types trong `.env.local`
- Đảm bảo wallet đã connect
- Kiểm tra network (testnet)

### Nếu swap không hoạt động:
- Kiểm tra Pool ID và Package ID
- Đảm bảo có đủ balance
- Kiểm tra function names trong Move contract

## 📝 Lưu ý

- Tất cả amounts được convert từ UI (1.0) sang smallest unit (1000000000) với 9 decimals
- Tỷ giá hiện tại là 1:1, có thể thay đổi logic trong `useEffect`
- Transaction fees sẽ được trừ từ SUI balance
- Cần có SUI để trả gas fees

Chúc bạn thành công! 🎉
