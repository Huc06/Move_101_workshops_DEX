"use client"

import { useCurrentAccount, useSuiClient } from "@mysten/dapp-kit"
import { useQuery } from "@tanstack/react-query"

const TOKEN_A_TYPE = process.env.NEXT_PUBLIC_TOKEN_A_TYPE!
const TOKEN_B_TYPE = process.env.NEXT_PUBLIC_TOKEN_B_TYPE!

export function useBalance() {
  const account = useCurrentAccount()
  const client = useSuiClient()

  return useQuery({
    queryKey: ["balance", account?.address, TOKEN_A_TYPE, TOKEN_B_TYPE],
    enabled: !!account,
    queryFn: async () => {
      if (!account) return { tokenA: "0", tokenB: "0" }

      const getSum = async (coinType: string) => {
        const response = await client.getCoins({ 
          owner: account.address, 
          coinType 
        })
        return response.data.reduce((sum, coin) => sum + BigInt(coin.balance), BigInt(0)).toString()
      }

      const [tokenA, tokenB] = await Promise.all([
        getSum(TOKEN_A_TYPE), 
        getSum(TOKEN_B_TYPE)
      ])
      
      return { 
        tokenA, 
        tokenB,
        // Thêm các helper functions
        tokenABalance: (Number(tokenA) / 1e9).toFixed(2), // Convert to readable format
        tokenBBalance: (Number(tokenB) / 1e9).toFixed(2),
        hasTokenA: BigInt(tokenA) > BigInt(0),
        hasTokenB: BigInt(tokenB) > BigInt(0)
      }
    },
    refetchInterval: 10000,
  })
}