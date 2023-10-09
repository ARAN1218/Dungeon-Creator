'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "0cad587cbfe2f3f6e285cf9ea02abb80",
"index.html": "8691b2c19c2b10a3a268b74f6a040a03",
"/": "8691b2c19c2b10a3a268b74f6a040a03",
"main.dart.js": "39eab9fcd508d538d09ed3af65728462",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"favicon.png": "00cdf5f37aa4d47f4e6d6fcc51d66719",
"icons/Icon-192.png": "00cdf5f37aa4d47f4e6d6fcc51d66719",
"icons/Icon-maskable-192.png": "00cdf5f37aa4d47f4e6d6fcc51d66719",
"icons/Icon-maskable-512.png": "00cdf5f37aa4d47f4e6d6fcc51d66719",
"icons/Icon-512.png": "00cdf5f37aa4d47f4e6d6fcc51d66719",
"manifest.json": "a1a1a31bfb204574ca0af57bd349a8c6",
"assets/AssetManifest.json": "f5d86926bfb7592a27255ec865b7651d",
"assets/NOTICES": "257e8a96bc281cd1ab2e557f3c9d6deb",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/select.mp3": "e6a82c8e57332c90123d1062d1b5623f",
"assets/assets/dungeon_clear.mp3": "dfc91a3d4b03d1f63ac9cc21f82598e9",
"assets/assets/images/tool.png": "6bbe4bad5f5ecf91e65323719cb8d94d",
"assets/assets/images/explanation.png": "daebf28689338e589f655c3cce1a3c19",
"assets/assets/images/GOAL.png": "6d52e0b7557e52c46334b57f15ed24f2",
"assets/assets/images/silver_helmet.png": "8f4527e455096f2f032f4258c15c8c0a",
"assets/assets/images/title.png": "00cdf5f37aa4d47f4e6d6fcc51d66719",
"assets/assets/images/zunda.png": "10a7f3ca7be9630d4e0e8ca7a466da61",
"assets/assets/images/bronze_armor.png": "8775dfe507331d0c420c6d6a1003ae2c",
"assets/assets/images/silver_sword.png": "eccaf2ac6fd7ba63c7dda3dfd4063e3a",
"assets/assets/images/slime.png": "b24a0720320730c1b6047032383f9708",
"assets/assets/images/trawl.png": "e899f6952d15d4ae63594caa5cff8760",
"assets/assets/images/gold_sword.png": "1616bec039f0f7beec0f48f31effa365",
"assets/assets/images/gold_armor.png": "534c9e3e2f135b28b7fc9e0e1cdf6769",
"assets/assets/images/zombie.png": "459bcc79effa1e658a6ad5479ccb996d",
"assets/assets/images/silver_armor.png": "aed32594c4fff2fb788546edffb0ff34",
"assets/assets/images/bronze_sword.png": "c9303c4aaa5b3621e86b800ccb9a959e",
"assets/assets/images/None.png": "cbf3b995f02328885a9b79ec5348bbe1",
"assets/assets/images/bronze_helmet.png": "e1d3cad81803e1beaa67e4db8ede25dc",
"assets/assets/images/gold_helmet.png": "3cb8aadee6e5a9f28c24271d6a994afe",
"assets/assets/images/2.png": "f5ee86f02949e2754929acf6b88ffd26",
"assets/assets/images/hato_shortbread.png": "0402e54e0402d32b1d491cfe00266b02",
"assets/assets/images/3.png": "f4dd181e821766a9013dd8ae10b8da27",
"assets/assets/images/1.png": "800c13818f28ca2db3b92331e47f413c",
"assets/assets/images/0.png": "8258cf3d4dda03891ee161c0f5075609",
"assets/assets/drop.mp3": "9a5be2e7a543efee304b6586ba02c546",
"assets/assets/menu.mp3": "29f52c47c2b2fcab2126d16a0ebf3c17",
"assets/assets/hungry.mp3": "7ce69ca7a09015a6a1f381135e945c50",
"assets/assets/doping.mp3": "7c938506f73cdbcc4b8b8faaab4db825",
"assets/assets/monster_attack.mp3": "a80e2e66ab4b28f15b4583192d593ef2",
"assets/assets/cure.mp3": "ff8db3d3d2e1dff3ceeeb9e0fd4064d7",
"assets/assets/attack.mp3": "204190051a629312548538f51e20a879",
"assets/assets/composite.mp3": "cd34e03aaf34424191b13b8a79d0902a",
"assets/assets/search.mp3": "15d36847f7747499de3ed903ead4375f",
"assets/assets/weapon_break.mp3": "39499b2e2b0d54482eebfceff5d5aae5",
"assets/assets/equip.mp3": "cd6b7819e2b19364ab556df3c0c3183f",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
