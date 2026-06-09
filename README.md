# MIZA Quant OS v8 — Professional Setup Guide

## 🚀 Deploy to Vercel (Recommended)

1. Upload this folder to GitHub (or drag & drop to Vercel)
2. Connect your GitHub repo to Vercel
3. Deploy — no environment variables needed (all config is in miza.html)

## 🗄️ Supabase Setup (Required for cloud features)

1. Go to [supabase.com](https://supabase.com) and open your project
2. Navigate to **SQL Editor**
3. Run the contents of `supabase-schema.sql`
4. Done — MIZA will connect automatically

## 📱 PWA Installation

On mobile: tap the **📲 INSTALL** button in the header (or use browser's "Add to Home Screen")

## 🤖 Telegram Setup

- Bot Token is pre-configured in miza.html
- Open Telegram and send `/start` to your bot
- You'll receive a welcome message and be subscribed to signals
- Commands: `/start`, `/stop`, `/status`, `/help`

## 📁 Project Structure

```
├── public/
│   ├── miza.html        — Full trading terminal app (all-in-one)
│   ├── manifest.json    — PWA manifest
│   ├── sw.js            — Service worker (offline + CDN cache)
│   └── icon.svg         — MIZA branded icon
├── app/
│   ├── page.tsx         — Redirects root to /miza.html
│   └── layout.tsx       — SEO metadata + Vercel Analytics
├── supabase-schema.sql  — Database schema (run once in Supabase)
└── package.json         — Next.js 16 + Vercel deployment config
```

## ✅ What's New in V8 (vs V7)

- **AI Engine**: RL weights × Optimized weights now multiply into every score
- **ML Fusion**: KNN prediction integrated as ±8 point boost/penalty
- **Delta Imbalance**: CVD delta score integrated into final signal
- **Auto-Optimizer**: Runs every 5 min + after every 5 closed trades  
- **TG Commands**: `/status` and `/help` added
- **Cloud Subscribers**: Synced to Supabase across all devices
- **PWA**: Installable as a native app on mobile
- **35+ async fixes**: All fetch/supabase/telegram functions properly async
- **Replay fix**: Uses live ENGINE_STATE candles
- **Zero duplicate functions**: All dead/conflicting code removed
