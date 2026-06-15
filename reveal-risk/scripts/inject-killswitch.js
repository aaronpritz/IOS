// Build step: inject web fixes into the exported index.html.
//
// 1. Service-worker "kill-switch" — unregisters any leftover service worker (e.g.
//    a previously-deployed app at this Pages origin) and clears its caches on load.
//    CyberSpark registers no service worker of its own, so this is purely defensive.
//
// 2. Dynamic viewport height — pins the app to 100dvh so the bottom UI (e.g. the
//    lesson "Finish/Continue" footer) is never pushed behind the mobile browser
//    toolbar. `height: 100%` can exceed the *visible* viewport on mobile Safari.
const fs = require('fs');

const file = 'dist/index.html';
let html = fs.readFileSync(file, 'utf8');

const killSwitch =
  '<script>(function(){try{' +
  'if("serviceWorker" in navigator){navigator.serviceWorker.getRegistrations()' +
  '.then(function(rs){rs.forEach(function(r){r.unregister();});}).catch(function(){});}' +
  'if(window.caches&&caches.keys){caches.keys().then(function(ks){ks.forEach(function(k){caches.delete(k);});}).catch(function(){});}' +
  '}catch(e){}})();</script>';

// 100vh first as a fallback, then 100dvh wins where supported.
const viewportFix =
  '<style>html,body,#root{height:100vh;height:100dvh;max-height:100vh;max-height:100dvh;overflow:hidden;}</style>';

if (html.includes('navigator.serviceWorker.getRegistrations')) {
  console.log('Web fixes already present; skipping.');
} else {
  html = html.replace('<head>', '<head>' + killSwitch + viewportFix);
  fs.writeFileSync(file, html);
  console.log('Injected service-worker kill-switch + viewport fix into index.html');
}
