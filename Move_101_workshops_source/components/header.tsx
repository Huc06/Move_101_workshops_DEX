"use client";

import { Wallet, Grid3x3, HelpCircle, Menu } from "lucide-react";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { ConnectButton } from "@mysten/dapp-kit";

export default function Header() {
  const navItems = [
    { name: "Trade", href: "/" },
    { name: "Liquidity", href: "/liquidity" },
    { name: "xSUI", href: "#" },
    { name: "Vaults", href: "#" },
    { name: "Portfolio", href: "#" },
    { name: "Bridge", href: "#" },
    { name: "Leaderboard", href: "/leaderboard" },
  ];

  return (
    <header className="border-b border-(--color-border) bg-(--color-background)">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center gap-4 md:gap-8">
            <Link href="/" className="flex items-center gap-2">
              <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-blue-700 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-xl">M</span>
              </div>
              <span className="text-lg md:text-xl font-semibold text-white">
                Momentum
              </span>
            </Link>

            <nav className="hidden lg:flex items-center gap-4 xl:gap-6">
              {navItems.map((item) => (
                <Link
                  key={item.name}
                  href={item.href}
                  className="text-(--color-text-secondary) hover:text-white transition-colors text-sm"
                >
                  {item.name}
                </Link>
              ))}
            </nav>
          </div>

          <div className="flex items-center gap-2 md:gap-4">
            <button className="hidden md:block p-2 hover:bg-(--color-surface) rounded-lg transition-colors">
              <Grid3x3 className="w-5 h-5 text-(--color-text-secondary)" />
            </button>

            <div className="hidden sm:block text-xs md:text-sm text-(--color-text-secondary)">
              TVL : <span className="text-white">$537M</span>
            </div>

            <ConnectButton className="text-white" />

            <button className="hidden md:block p-2 hover:bg-(--color-surface) rounded-lg transition-colors">
              <HelpCircle className="w-5 h-5 text-(--color-text-secondary)" />
            </button>

            <button className="lg:hidden p-2 hover:bg-(--color-surface) rounded-lg transition-colors">
              <Menu className="w-5 h-5 text-(--color-text-secondary)" />
            </button>
          </div>
        </div>
      </div>
    </header>
  );
}
