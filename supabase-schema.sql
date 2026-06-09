-- MIZA Quant OS v8 — Supabase Database Schema
-- Run this in your Supabase SQL Editor to create all required tables

-- 1. Signals table
CREATE TABLE IF NOT EXISTS signals (
  id BIGSERIAL PRIMARY KEY,
  signal_id TEXT UNIQUE NOT NULL,
  symbol TEXT NOT NULL,
  timeframe TEXT,
  direction TEXT,
  strength TEXT,
  confidence NUMERIC,
  score NUMERIC,
  entry_price NUMERIC,
  sl_price NUMERIC,
  tp1_price NUMERIC,
  tp2_price NUMERIC,
  rr_ratio NUMERIC,
  regime TEXT,
  rsi_val NUMERIC,
  macd_hist NUMERIC,
  funding_rate NUMERIC,
  oi_change NUMERIC,
  cvd_delta NUMERIC,
  exhaustion_warn TEXT,
  timing_filter TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Trades table
CREATE TABLE IF NOT EXISTS trades (
  id BIGSERIAL PRIMARY KEY,
  trade_id TEXT UNIQUE NOT NULL,
  signal_id TEXT REFERENCES signals(signal_id),
  symbol TEXT,
  direction TEXT,
  entry_price NUMERIC,
  sl_price NUMERIC,
  tp1_price NUMERIC,
  tp2_price NUMERIC,
  exit_price NUMERIC,
  outcome TEXT DEFAULT 'OPEN',
  pnl_pct NUMERIC DEFAULT 0,
  mfe NUMERIC DEFAULT 0,
  mae NUMERIC DEFAULT 0,
  duration_candles INTEGER DEFAULT 0,
  entry_time TIMESTAMPTZ,
  exit_time TIMESTAMPTZ,
  slippage_est NUMERIC,
  confidence NUMERIC,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. AI Memory table (stores RL weights, optimizer results, etc.)
CREATE TABLE IF NOT EXISTS ai_memory (
  id BIGSERIAL PRIMARY KEY,
  memory_key TEXT UNIQUE NOT NULL,
  memory_value JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Telegram Subscribers table
CREATE TABLE IF NOT EXISTS tg_subscribers (
  id BIGSERIAL PRIMARY KEY,
  chat_id TEXT UNIQUE NOT NULL,
  active BOOLEAN DEFAULT TRUE,
  joined_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Scanner results table
CREATE TABLE IF NOT EXISTS scanner_results (
  id BIGSERIAL PRIMARY KEY,
  scan_id TEXT,
  symbol TEXT,
  timeframe TEXT,
  direction TEXT,
  strength TEXT,
  confidence NUMERIC,
  score NUMERIC,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS) with anon access for all tables
ALTER TABLE signals ENABLE ROW LEVEL SECURITY;
ALTER TABLE trades ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_memory ENABLE ROW LEVEL SECURITY;
ALTER TABLE tg_subscribers ENABLE ROW LEVEL SECURITY;
ALTER TABLE scanner_results ENABLE ROW LEVEL SECURITY;

-- Allow anon read/write (since MIZA uses the anon key)
CREATE POLICY "anon_all_signals" ON signals FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_trades" ON trades FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_ai_memory" ON ai_memory FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_tg_subscribers" ON tg_subscribers FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_scanner_results" ON scanner_results FOR ALL TO anon USING (true) WITH CHECK (true);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_signals_symbol ON signals(symbol);
CREATE INDEX IF NOT EXISTS idx_signals_created ON signals(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_trades_outcome ON trades(outcome);
CREATE INDEX IF NOT EXISTS idx_trades_created ON trades(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tg_subscribers_active ON tg_subscribers(active);
