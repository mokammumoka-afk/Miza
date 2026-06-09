import type { Metadata, Viewport } from 'next'
import { Analytics } from '@vercel/analytics/next'
import './globals.css'

export const metadata: Metadata = {
  title: 'MIZA Quant Terminal Pro',
  description: 'Professional AI-powered crypto trading terminal with real-time signals, ML/RL engine, multi-timeframe scanner, and autonomous Telegram alerts.',
  keywords: ['crypto trading', 'AI trading signals', 'MIZA', 'quantitative trading', 'BTC signals', 'crypto scanner'],
  authors: [{ name: 'MIZA Quant OS' }],
  creator: 'MIZA Quant OS',
  publisher: 'MIZA Quant OS',
  manifest: '/manifest.json',
  appleWebApp: {
    capable: true,
    statusBarStyle: 'black-translucent',
    title: 'MIZA Pro',
  },
  openGraph: {
    type: 'website',
    title: 'MIZA Quant Terminal Pro',
    description: 'AI-powered crypto trading terminal with autonomous signals.',
    siteName: 'MIZA Quant OS',
  },
  twitter: {
    card: 'summary',
    title: 'MIZA Quant Terminal Pro',
    description: 'AI-powered crypto trading terminal with autonomous signals.',
  },
  icons: {
    icon: [
      { url: '/icon.svg', type: 'image/svg+xml' },
      { url: '/icon-dark-32x32.png', sizes: '32x32', type: 'image/png' },
    ],
    apple: '/apple-icon.png',
    shortcut: '/icon.svg',
  },
}

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  themeColor: '#04040c',
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en">
      <body>
        {children}
        {process.env.NODE_ENV === 'production' && <Analytics />}
      </body>
    </html>
  )
}
