// Build step: inject a service-worker "kill-switch" into the exported index.html.
// Any leftover service worker from a previously-deployed app (e.g. the platformer
// that used to live at this Pages origin) is unregistered and its caches cleared
// the moment CyberSpark's HTML loads. CyberSpark registers no service worker of its
// own, so this is purely defensive cleanup.
const fs = require('fs');

const file = 'dist/index.html';
let html = fs.readFileSync(file, 'utf8');

const snippet =
  '<script>(function(){try{' +
  'if("serviceWorker" in navigator){navigator.serviceWorker.getRegistrations()' +
  '.then(function(rs){rs.forEach(function(r){r.unregister();});}).catch(function(){});}' +
  'if(window.caches&&caches.keys){caches.keys().then(function(ks){ks.forEach(function(k){caches.delete(k);});}).catch(function(){});}' +
  '}catch(e){}})();</script>';

if (html.includes('navigator.serviceWorker.getRegistrations')) {
  console.log('Kill-switch already present; skipping.');
} else {
  html = html.replace('<head>', '<head>' + snippet);
  fs.writeFileSync(file, html);
  console.log('Injected service-worker kill-switch into index.html');
}
