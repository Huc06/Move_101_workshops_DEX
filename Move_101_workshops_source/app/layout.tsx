import type React from "react";
import type { Metadata } from "next";
import { GeistSans } from "geist/font/sans";
import { GeistMono } from "geist/font/mono";
import { Analytics } from "@vercel/analytics/next";
import { Toaster } from "sonner";
import "./globals.css";
import Header from "@/components/header";
import { Suspense } from "react";
import { Providers } from "./providers";

export const metadata: Metadata = {
  title: "Move_101",
  description: "Created with DevHubHCM",
  generator: "DEX.app",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={`font-sans ${GeistSans.variable} ${GeistMono.variable}`}>
        <Providers>
          <Suspense fallback={<div>Loading...</div>}>
            <Header />
          </Suspense>
          {children}
          <Analytics />
          <Toaster theme="dark" />
        </Providers>
      </body>
    </html>
  );
}
