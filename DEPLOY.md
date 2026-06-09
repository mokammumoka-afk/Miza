# MIZA PRO v7 — Production Deployment Guide
## Real Web3 Payment System — TON Blockchain

---

## 📁 Project Structure

```
miza-web3/
├── backend/
│   ├── server.js          ← Node.js backend (TON verification)
│   ├── package.json
│   └── .env.example       ← Copy to .env and fill in values
├── frontend/
│   ├── index.html         ← Landing page (update API_BASE URL)
│   └── tonconnect-manifest.json  ← Update with your domain
└── DEPLOY.md              ← This file
```

---

## 🚀 Step 1 — Deploy the Backend

### Option A: Railway (Recommended, free tier available)

1. Go to https://railway.app
2. Click "New Project" → "Deploy from GitHub"
3. Upload/push the `backend/` folder
4. Set environment variables in Railway dashboard:

```
MERCHANT_WALLET=UQDVuE-qDUPaascd13TK9PKK07UuHxqA7LTOHdn3YUaTLxnT
PRICE_USDT=124
TOKEN_SECRET=<generate with: openssl rand -hex 32>
DOWNLOAD_URL=https://drive.google.com/file/d/1f86z3zirJ65Ums6-OtB0TocFrybTcM3I/view?usp=drivesdk
TONCENTER_API_KEY=<get free key at t.me/tonapibot>
ALLOWED_ORIGINS=https://your-frontend-domain.com
PORT=3001
```

5. Note your backend URL, e.g.: `https://miza-backend.railway.app`

### Option B: Render

1. Go to https://render.com → New Web Service
2. Connect your GitHub repo (backend/ folder)
3. Set the same environment variables as above
4. Deploy

### Option C: VPS (DigitalOcean / Hetzner)

```bash
# Install Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone/upload backend
cd /var/www/miza-backend
npm install --production

# Set env variables
cp .env.example .env
nano .env  # fill in your values

# Start with PM2
npm install -g pm2
pm2 start server.js --name miza-backend
pm2 save
pm2 startup
```

---

## 🌐 Step 2 — Deploy the Frontend

### Option A: Vercel (Free, fast CDN)

```bash
npm install -g vercel
cd frontend/
vercel --prod
```

### Option B: Netlify

1. Drag & drop `frontend/` folder at https://app.netlify.com/drop
2. Note your URL, e.g.: `https://miza-pro.netlify.app`

### Option C: Nginx on VPS

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/miza-frontend;
    index index.html;

    # Proxy API requests to backend
    location /api/ {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## ⚙️ Step 3 — Update Configuration

### 3a. Update Frontend API URL

In `frontend/index.html`, find:

```javascript
const API_BASE = window.location.hostname === 'localhost'
  ? 'http://localhost:3001'
  : 'https://YOUR-BACKEND-URL.railway.app'; // ← CHANGE THIS
```

Replace with your actual backend URL:

```javascript
const API_BASE = 'https://miza-backend.railway.app';
```

### 3b. Update TonConnect Manifest

In `frontend/tonconnect-manifest.json`:

```json
{
  "url": "https://your-actual-domain.com",
  "name": "MIZA PRO v7",
  "iconUrl": "https://your-actual-domain.com/icon.png"
}
```

**Important:** The manifest URL must be publicly accessible.
Host it at: `https://your-domain.com/tonconnect-manifest.json`

---

## 🔑 Step 4 — Get TON Center API Key (Important!)

1. Open Telegram and message @tonapibot
2. Type /get_key
3. Follow instructions to get free API key
4. Add key to backend `.env` as `TONCENTER_API_KEY`

**Without API key:** Rate limited to ~1 req/sec (may cause slow verification)
**With free key:** 10 req/sec (sufficient for production)

---

## 🤖 Step 5 — Create Telegram Bot & Web App

1. Message @BotFather in Telegram
2. Create bot: /newbot
3. Set Web App URL: /newapp → point to your frontend URL
4. Users access via: t.me/YourBot/app

---

## 💎 Step 6 — USDT on TON Setup

The system handles USDT (Tether) on TON blockchain.

**Your merchant wallet:** `UQDVuE-qDUPaascd13TK9PKK07UuHxqA7LTOHdn3YUaTLxnT`

To receive USDT on TON:
1. Install Tonkeeper wallet
2. Import your wallet
3. Add USDT token (TON USDT contract: `EQCxE6mUtQJKFnGfaROTKOt1lZbDiiX1kCixRv7Nw2Id_sDs`)

---

## ✅ Step 7 — Test the Flow

1. Open your Telegram bot Web App
2. Click "Connect Wallet" → choose Tonkeeper
3. Connect your test wallet
4. Click "Buy Now"
5. Confirm the USDT transaction in Tonkeeper
6. Wait for blockchain confirmation (~10-30 seconds)
7. Download modal should appear

---

## 🔒 Security Notes

- `DOWNLOAD_URL` is **never** stored in frontend HTML
- It's only returned by `/api/download` with a valid HMAC token
- Tokens expire after 15 minutes
- Each token is tied to a specific wallet + tx hash
- Rate limiting: 100 requests/minute per IP
- Frontend source code inspection reveals NO download URL

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| "TonConnect SDK not loaded" | Check internet, CDN not blocked |
| "Backend init failed" | Verify API_BASE URL is correct |
| "Verification timeout" | TON network slow — normal, retry |
| "Access denied" on download | Token expired, re-verify payment |
| Wallet not connecting | Check tonconnect-manifest.json URL |

---

## 📞 Support

Telegram: @Tradeixboom_bot
