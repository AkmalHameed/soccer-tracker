// Soccer Tracker Service Worker
const CACHE_NAME = "soccer-tracker-v1";
const OFFLINE_URL = "/offline";

const STATIC_ASSETS = [
  "/",
  "/assets/css/app.css",
  "/assets/js/app.js",
  "/manifest.json"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS);
    })
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) =>
      Promise.all(
        cacheNames
          .filter((name) => name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      )
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", (event) => {
  // Only cache GET requests, skip WebSocket/LiveView connections
  if (event.request.method !== "GET") return;
  if (event.request.url.includes("/live/")) return;
  if (event.request.url.includes("websocket")) return;

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        // Cache successful static asset responses
        if (response.ok && event.request.url.includes("/assets/")) {
          const responseClone = response.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseClone);
          });
        }
        return response;
      })
      .catch(() => {
        return caches.match(event.request);
      })
  );
});
