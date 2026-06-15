// Build step: inject web fixes into the exported site.
//
// 1. Self-destruct service worker (dist/sw.js) — the old "chen-kong-platformer"
//    project registered a CACHE-FIRST service worker at /IOS/sw.js that got stuck
//    serving stale content forever. Browsers re-check the registered worker script
//    on navigation, so shipping a new sw.js at the same path lets us take it over,
//    wipe all caches, unregister, and reload — evicting the stale worker for good.
//
// 2. Kill-switch <script> in index.html — belt-and-suspenders: unregisters any
//    service worker and clears caches on load (for browsers without the stuck SW).
//
// 3. Dynamic viewport height — pins the app to 100dvh so the lesson Finish/Continue
//    footer is never pushed behind the mobile browser toolbar.
const fs = require('fs');

// ---- 1. Self-destruct service worker -------------------------------------
const selfDestructSW = `// Self-destruct worker — evicts the stale platformer cache at /IOS/.
self.addEventListener('install', function () { self.skipWaiting(); });
self.addEventListener('activate', function (event) {
  event.waitUntil((async function () {
    try { var keys = await caches.keys(); await Promise.all(keys.map(function (k) { return caches.delete(k); })); } catch (e) {}
    try { await self.clients.claim(); } catch (e) {}
    try { await self.registration.unregister(); } catch (e) {}
    try {
      var cls = await self.clients.matchAll({ type: 'window' });
      cls.forEach(function (c) { c.navigate(c.url); });
    } catch (e) {}
  })());
});
// Network-only while briefly active; never serve from cache.
self.addEventListener('fetch', function (event) {
  event.respondWith(fetch(event.request).catch(function () { return new Response('', { status: 504 }); }));
});
`;
fs.writeFileSync('dist/sw.js', selfDestructSW);

// ---- 2 + 3. index.html injections ----------------------------------------
const file = 'dist/index.html';
let html = fs.readFileSync(file, 'utf8');

const killSwitch =
  '<script>(function(){try{' +
  'if("serviceWorker" in navigator){navigator.serviceWorker.getRegistrations()' +
  '.then(function(rs){rs.forEach(function(r){r.unregister();});}).catch(function(){});}' +
  'if(window.caches&&caches.keys){caches.keys().then(function(ks){ks.forEach(function(k){caches.delete(k);});}).catch(function(){});}' +
  '}catch(e){}})();</script>';

const viewportFix =
  '<style>html,body,#root{height:100vh;height:100dvh;max-height:100vh;max-height:100dvh;overflow:hidden;}</style>';

if (html.includes('navigator.serviceWorker.getRegistrations')) {
  console.log('index.html fixes already present; wrote dist/sw.js.');
} else {
  html = html.replace('<head>', '<head>' + killSwitch + viewportFix);
  fs.writeFileSync(file, html);
  console.log('Injected kill-switch + viewport fix into index.html; wrote self-destruct dist/sw.js.');
}
