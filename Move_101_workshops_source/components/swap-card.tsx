"use client"

import { useState, useEffect } from "react"
import { ChevronDown, ArrowDownUp, Settings, Loader2 } from "lucide-react"
import { Button } from "@/components/ui/button"
import { SlippageSettings } from "./slippage-settings"
import { useBalance } from "@/hooks/use-balance"
import { useSwap } from "@/hooks/use-swap"
import { useMint } from "@/hooks/use-mint"
import { useCurrentAccount, useSuiClient } from "@mysten/dapp-kit"
import { toast } from "sonner"

export default function SwapCard() {
  const [fromAmount, setFromAmount] = useState("0.0")
  const [toAmount, setToAmount] = useState("0.0")
  const [slippage, setSlippage] = useState(0.5)
  const [isSlippageOpen, setIsSlippageOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [selectedFromToken, setSelectedFromToken] = useState("HULK")
  const [selectedToToken, setSelectedToToken] = useState("GIRL")

  const account = useCurrentAccount()
  const client = useSuiClient()
  const { data: balanceData, isLoading: balanceLoading, refetch: refetchBalance } = useBalance()
  const { swapAtoB, swapBtoA, isReady: swapReady } = useSwap()
  const { mintHulkToken, mintGirlfriendToken } = useMint()

  // expected price
  useEffect(() => {
    if (fromAmount && !isNaN(Number(fromAmount))) {
      setToAmount(fromAmount) // ty gia 1:1
    }
  }, [fromAmount])

  // get coin object from balance
  const getCoinObject = async (tokenType: string, amount: bigint) => {
    if (!account) throw new Error("No account connected")
    const coins = await client.getCoins({
      owner: account.address,
      coinType: tokenType,
    })
    const coin = coins.data.find(coin => BigInt(coin.balance) >= amount)
    if (!coin) throw new Error("Insufficient balance")
    return coin.coinObjectId
  }

  // handle swap
  const handleSwap = async () => {
    if (!account) {
      toast.error("Please connect your wallet")
      return
    }
    if (!fromAmount || Number(fromAmount) <= 0) {
      toast.error("Please enter a valid amount")
      return
    }
    if (!swapReady) {
      toast.error("Swap contract not ready")
      return
    }

    setIsLoading(true)
    try {
      const amount = BigInt(Number(fromAmount) * 1e9) // convert to decimal
      
      if (selectedFromToken === "HULK" && selectedToToken === "GIRL") {
        const coinObject = await getCoinObject(
          process.env.NEXT_PUBLIC_TOKEN_A_TYPE!,
          amount
        )
        const result = await swapAtoB(coinObject)
        toast.success(`Swap HULK → GIRL successful! TX: ${result.digest}`)
      } else if (selectedFromToken === "GIRL" && selectedToToken === "HULK") {
        const coinObject = await getCoinObject(
          process.env.NEXT_PUBLIC_TOKEN_B_TYPE!,
          amount
        )
        const result = await swapBtoA(coinObject)
        toast.success(`Swap GIRL → HULK successful! TX: ${result.digest}`)
      }

      // Refresh balances
      refetchBalance()
      setFromAmount("0.0")
      setToAmount("0.0")
    } catch (error: any) {
      console.error("Swap failed:", error)
      toast.error(error.message || "Swap failed")
    } finally {
      setIsLoading(false)
    }
  }

  // handle mint token
  const handleMint = async (tokenType: "HULK" | "GIRL") => {
    if (!account) {
      toast.error("Please connect your wallet")
      return
    }
    
    setIsLoading(true)
    try {
      if (tokenType === "HULK") {
        const result = await mintHulkToken() // Mint tokens (amount is fixed in Move contract)
        toast.success(`Minted HULK tokens! TX: ${result.digest}`)
      } else {
        const result = await mintGirlfriendToken() // Mint tokens (amount is fixed in Move contract)
        toast.success(`Minted GIRL tokens! TX: ${result.digest}`)
      }

      refetchBalance()
    } catch (error: any) {
      console.error("Mint failed:", error)
      toast.error(error.message || "Mint failed")
    } finally {
      setIsLoading(false)
    }
  }

  // handle switch tokens
  const handleSwitchTokens = () => {
   setSelectedFromToken(selectedToToken)
   setSelectedToToken(selectedFromToken)
   setFromAmount(toAmount)
   setToAmount(fromAmount) 
  }

  const formatBalance = (balance: string) => {
    return (Number(balance) / 1e9).toFixed(2) //Convert to smallest units
  }

  // Helper functions để hiển thị dữ liệu
  const getCurrentBalance = () => {
    if (!balanceData) return "0.00"
    return selectedFromToken === "HULK" 
      ? formatBalance(balanceData.tokenA) 
      : formatBalance(balanceData.tokenB)
  }

  const getToBalance = () => {
    if (!balanceData) return "0.00"
    return selectedToToken === "HULK" 
      ? formatBalance(balanceData.tokenA) 
      : formatBalance(balanceData.tokenB)
  }

  const canSwap = () => {
    if (!account || !swapReady || !fromAmount || Number(fromAmount) <= 0) return false
    if (!balanceData) return false
    
    const requiredBalance = selectedFromToken === "HULK" 
      ? balanceData.hasTokenA 
      : balanceData.hasTokenB
    
    return requiredBalance
  }

  return (
    <>
      <div className="w-full max-w-lg bg-(--color-surface) rounded-xl md:rounded-2xl p-4 md:p-6">
        <div className="flex items-center justify-between mb-4 md:mb-6">
          <h3 className="text-xl md:text-2xl font-semibold text-white">Swap</h3>
          <button
            onClick={() => setIsSlippageOpen(true)}
            className="flex items-center gap-2 text-(--color-text-secondary) text-sm hover:text-white transition-colors"
          >
            <span>{slippage}%</span>
            <Settings className="w-4 h-4" />
          </button>
        </div>

        {/* Mint Token Buttons */}
        {account && (
          <div className="flex gap-2 mb-4">
            <Button
              onClick={() => handleMint("HULK")}
              disabled={isLoading}
              className="flex-1 bg-green-600 hover:bg-green-700 text-white"
            >
              {isLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : "Mint HULK"}
            </Button>
            <Button
              onClick={() => handleMint("GIRL")}
              disabled={isLoading}
              className="flex-1 bg-pink-600 hover:bg-pink-700 text-white"
            >
              {isLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : "Mint GIRL"}
            </Button>
          </div>
        )}

        <div className="space-y-1">
          <div className="bg-(--color-background) rounded-xl p-3 md:p-4">
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs md:text-sm text-(--color-text-secondary)">From</span>
            </div>

            <div className="flex items-center justify-between mb-2 gap-2">
              <input
                type="text"
                value={fromAmount}
                onChange={(e) => setFromAmount(e.target.value)}
                className="bg-transparent text-2xl md:text-3xl font-semibold text-white outline-none w-full"
                placeholder="0.0"
              />

              <button className="flex items-center gap-1.5 md:gap-2 bg-(--color-surface) hover:bg-(--color-surface-hover) rounded-lg px-2 md:px-3 py-2 transition-colors flex-shrink-0">
                <div className="w-5 h-5 md:w-6 md:h-6 bg-green-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-xs font-bold">{selectedFromToken[0]}</span>
                </div>
                <span className="text-white font-medium text-sm md:text-base">{selectedFromToken}</span>
                <ChevronDown className="w-4 h-4 text-(--color-text-secondary)" />
              </button>
            </div>

            <div className="flex items-center justify-between flex-wrap gap-2">
              <span className="text-xs md:text-sm text-(--color-text-muted)">$0.00</span>
              <div className="flex items-center gap-2 text-xs md:text-sm">
                <span className="text-(--color-text-secondary)">
                  Balance: {balanceLoading ? "Loading..." : getCurrentBalance()}
                </span>
                <button 
                  onClick={() => setFromAmount(getCurrentBalance())}
                  className="text-(--color-primary) hover:text-(--color-primary-hover) font-medium"
                >
                  MAX
                </button>
              </div>
            </div>
          </div>

          <div className="flex justify-center -my-2 relative z-10">
            <button 
              onClick={handleSwitchTokens}
              className="bg-(--color-surface) hover:bg-(--color-surface-hover) rounded-lg p-2 border-4 border-(--color-background) transition-colors"
            >
              <ArrowDownUp className="w-5 h-5 text-(--color-text-secondary)" />
            </button>
          </div>

          <div className="bg-(--color-background) rounded-xl p-3 md:p-4">
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs md:text-sm text-(--color-text-secondary)">To</span>
            </div>

            <div className="flex items-center justify-between mb-2 gap-2">
              <input
                type="text"
                value={toAmount}
                onChange={(e) => setToAmount(e.target.value)}
                className="bg-transparent text-2xl md:text-3xl font-semibold text-white outline-none w-full"
                placeholder="0.0"
              />

              <button className="flex items-center gap-1.5 md:gap-2 bg-(--color-surface) hover:bg-(--color-surface-hover) rounded-lg px-2 md:px-3 py-2 transition-colors flex-shrink-0">
                <div className="w-5 h-5 md:w-6 md:h-6 bg-pink-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-xs font-bold">{selectedToToken[0]}</span>
                </div>
                <span className="text-white font-medium text-sm md:text-base">{selectedToToken}</span>
                <ChevronDown className="w-4 h-4 text-(--color-text-secondary)" />
              </button>
            </div>

            <div className="flex items-center justify-between">
              <span className="text-xs md:text-sm text-(--color-text-muted)">$0.00</span>
              <span className="text-xs md:text-sm text-(--color-text-secondary)">
                Balance: {balanceLoading ? "Loading..." : getToBalance()}
              </span>
            </div>
          </div>
        </div>

        <Button 
          onClick={handleSwap}
          disabled={!canSwap() || isLoading}
          className="w-full bg-(--color-primary) hover:bg-(--color-primary-hover) text-white rounded-xl py-5 md:py-6 mt-4 md:mt-6 text-base md:text-lg font-semibold disabled:opacity-50"
        >
          {!account ? "Connect Wallet" : 
           !swapReady ? "Contract Not Ready" :
           isLoading ? (
            <>
              <Loader2 className="w-5 h-5 animate-spin mr-2" />
              Swapping...
            </>
          ) : (
            `Swap ${selectedFromToken} → ${selectedToToken}`
          )}
        </Button>
      </div>

      {isSlippageOpen && (
        <SlippageSettings
          currentSlippage={slippage.toString()}
          onClose={() => setIsSlippageOpen(false)}
          onSave={(value) => {
            setSlippage(Number.parseFloat(value))
            setIsSlippageOpen(false)
          }}
        />
      )}
    </>
  )
}
