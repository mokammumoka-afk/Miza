// MIZA Pro Service Worker v1
const CACHE_NAME = 'miza-pro-v1';
const STATIC_ASSETS = [
  '/miza.html',
  '/manifest.json',
  '/icon.svg',
  '/apple-icon.png',
];

// External CDN assets to cache
const CDN_ASSETS = [
  'https://cdn.jsdelivr.net/npm/lightweight-charts@4.1.3/dist/lightweight-charts.standalone.production.js',
  'https://cdn.jsdelivr.net/npm/mathjs@12.2.1/lib/browser/math.js',
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      // Cache static assets silently
      return Promise.allSettled([
        ...STATIC_ASSETS.map(url => cache.add(url).catch(() => {})),
        ...CDN_ASSETS.map(url => cache.add(url).catch(() => {})),
      ]);
    })
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);

  // Never cache Binance API, Telegram API, or Supabase
  if (
    url.hostname.includes('binance') ||
    url.hostname.includes('telegram') ||
    url.hostname.includes('supabase')
  ) {
    return; // Let through to network
  }

  // Cache-first for CDN assets
  if (url.hostname.includes('jsdelivr') || url.hostname.includes('cdn')) {
    event.respondWith(
      caches.match(event.request).then(cached => {
        return cached || fetch(event.request).then(res => {
          const clone = res.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
          return res;
        });
      })
    );
    return;
  }

  // Network-first for the main app (always fresh)
  if (url.pathname === '/miza.html' || url.pathname === '/') {
    event.respondWith(
      fetch(event.request).catch(() => caches.match('/miza.html'))
    );
    return;
  }

  // Cache-first for other static assets
  event.respondWith(
    caches.match(event.request).then(cached => cached || fetch(event.request))
  );
});
