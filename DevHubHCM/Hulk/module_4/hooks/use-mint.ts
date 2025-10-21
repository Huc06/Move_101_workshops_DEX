"use client"

import { useSignAndExecuteTransaction } from "@mysten/dapp-kit"
import { Transaction } from "@mysten/sui/transactions"

const TOKEN_A_TYPE = process.env.NEXT_PUBLIC_TOKEN_A_TYPE!
const TOKEN_B_TYPE = process.env.NEXT_PUBLIC_TOKEN_B_TYPE!
const TREASURY_CAP_A = process.env.NEXT_PUBLIC_TREASURY_CAP_A!
const TREASURY_CAP_B = process.env.NEXT_PUBLIC_TREASURY_CAP_B!
const PKG = process.env.NEXT_PUBLIC_PACKAGE_ID!

const HULK_TOKEN_MODULE = "hulk_token"
const GIRLFIEND_MODULE = "girlfriend"
const FN_MINT_HULK_TOKEN = "mint_token"
const FN_MINT_GIRLFRIEND = "mint_token"

export function useMint() {
    const { mutateAsync: signAndExecuteTransaction } = useSignAndExecuteTransaction();
    
    const mintHulkToken = async () => {
        if (!TOKEN_A_TYPE || !TREASURY_CAP_A || !PKG) {
            throw new Error("Missing environment variables");
        }

        const tx = new Transaction();
        tx.setGasBudget(30000000);
        tx.moveCall({
            target: `${PKG}::${HULK_TOKEN_MODULE}::${FN_MINT_HULK_TOKEN}`,
            arguments: [
                tx.object(TREASURY_CAP_A)
            ]
        })

        return signAndExecuteTransaction({ transaction: tx });
    }

    const mintGirlfriendToken = async () => {
        if (!TOKEN_B_TYPE || !TREASURY_CAP_B || !PKG) {
            throw new Error("Missing environment variables");
        }

        const tx = new Transaction();
        tx.setGasBudget(30000000);
        tx.moveCall({
            target: `${PKG}::${GIRLFIEND_MODULE}::${FN_MINT_GIRLFRIEND}`,
            arguments: [
                tx.object(TREASURY_CAP_B)
            ]
        })
        
        return signAndExecuteTransaction({ transaction: tx });
    }

    return { mintHulkToken, mintGirlfriendToken };
}