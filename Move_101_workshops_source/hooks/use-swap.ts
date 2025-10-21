"use client"

import { useSignAndExecuteTransaction, useCurrentAccount } from "@mysten/dapp-kit"
import { Transaction } from "@mysten/sui/transactions"

const TOKEN_A_TYPE = process.env.NEXT_PUBLIC_TOKEN_A_TYPE!
const TOKEN_B_TYPE = process.env.NEXT_PUBLIC_TOKEN_B_TYPE!
const POOL_ID = process.env.NEXT_PUBLIC_POOL_ID!
const PKG = process.env.NEXT_PUBLIC_PACKAGE_ID!

const SWAP_MODULE = "swap"
const FN_A_TO_B = "swap_HULK_TOKEN_to_girlfriend"
const FN_B_TO_A = "swap_girlfriend_to_HULK_TOKEN"

export function useSwap() {
  const { mutateAsync: signAndExecuteTransaction } = useSignAndExecuteTransaction();
  const account = useCurrentAccount();

   const swapAtoB = async (coinObject: string) => {
     if (!PKG || !POOL_ID || !TOKEN_A_TYPE || !TOKEN_B_TYPE) {
       throw new Error("Missing environment variables")
     }

     const tx = new Transaction();
     tx.setGasBudget(50000000);
     tx.moveCall({
        target: `${PKG}::${SWAP_MODULE}::${FN_A_TO_B}`,
        arguments: [ 
            tx.object(POOL_ID),
            tx.object(coinObject)
        ]
     })

     return signAndExecuteTransaction({ transaction: tx });
   }

   const swapBtoA = async (coinObject: string) => {
    if (!PKG || !POOL_ID || !TOKEN_A_TYPE || !TOKEN_B_TYPE) {
      throw new Error("Missing environment variables")
    }

    const tx = new Transaction();
    tx.setGasBudget(50000000);
    tx.moveCall({
        target: `${PKG}::${SWAP_MODULE}::${FN_B_TO_A}`,
        arguments: [
            tx.object(POOL_ID),
            tx.object(coinObject)
        ]
    })

    return signAndExecuteTransaction({ transaction: tx });
   }

   return { 
    swapAtoB, 
    swapBtoA,
    isReady: !!(PKG && POOL_ID && TOKEN_A_TYPE && TOKEN_B_TYPE)
};
}