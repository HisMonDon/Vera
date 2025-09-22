'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "1a4dad85c6b19dddbf67841b13d712e9",
"assets/AssetManifest.bin.json": "9f204b319a3f01834e688bd4d33d80d8",
"assets/AssetManifest.json": "235256eab4b530803c330e7fafeb4bb1",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "8a1ca77e8587988c8f1132233cb3fc19",
"assets/images/ap_courses.jpg": "dad766861eae9964491fceb59812237f",
"assets/images/ap_physics_2.png": "b1a30b63193325cf1379b67f3e64ccf0",
"assets/images/dynamics.jpg": "f9a03fc2c8549b9d75d4723af43a821b",
"assets/images/electricity.jpg": "1630c5c3b38422e8f5c9bdd0a8c0dc6f",
"assets/images/electrostatics.png": "b300f2a4448af77e4551a7c0d9378543",
"assets/images/energy.png": "797428f40fd7edd212a578ea72e6647b",
"assets/images/featured_video_background.png": "c2c52a37b6b49035e2fa3c4b8a7d3c43",
"assets/images/fluids.png": "23313c98530e0f979d510db781c838ed",
"assets/images/harmonics.jpg": "66e52135f181bcf0f6d3af1518178123",
"assets/images/ib_physics_hl.jpg": "0c7fc864bc20ba576c251e2b36c11080",
"assets/images/intro_to_physics.jpg": "6a9c774801392140b7e6f9996b072bc6",
"assets/images/kinematics.jpg": "ae1043a2fbbf4b1bcd3a8b61d5e3281b",
"assets/images/locked_text_background.png": "48792e8fc4b44be9b0333f209ebee261",
"assets/images/momentum.jpg": "9f32a0ff1e1f21f2661f9d46a4262708",
"assets/images/optics.png": "dbbf5e32a0ad54eab7c74e531afc135f",
"assets/images/other.jpg": "80df04bc696096d0ba571a52363c4541",
"assets/images/physics_11.jpg": "ccd51140e8714cb5532705525f4f304e",
"assets/images/physics_12.jpg": "3d2f9f301552b9669f76eb67fa015db6",
"assets/images/quantum_mechanics.jpg": "69120f5a86f92a3d40815fd784f81304",
"assets/images/rotational_motion.jpg": "45443ff94ea01e86de36d444e80c845b",
"assets/images/text_background.jpg": "274d9a518f1c49bd0d7ad8444a8d66d9",
"assets/images/text_background_light.png": "8f2b35a9061448000f04decca949fa49",
"assets/images/thermal_physics.jpg": "2643a60454758d72f006cf409070a986",
"assets/images/torque.jpg": "1be3a093fb946701efd7eff2d53eade5",
"assets/images/work_and_energy.jpg": "0f7e1112eb6701d40aa2e61bfa84b1a6",
"assets/images_tutorial/vera_tutorial_one.png": "03a91bb3f5e8bdfc49f004c278207a80",
"assets/images_tutorial/vera_tutorial_three.png": "a554cab856bb4f69dbb0b7f4c296aae8",
"assets/images_tutorial/vera_tutorial_two.png": "a2db100f8e8138edeac23d253ccf3f81",
"assets/NOTICES": "873805511079dc7cc20e849122f7d79c",
"assets/packages/media_kit/assets/web/hls1.4.10.js": "bd60e2701c42b6bf2c339dcf5d495865",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "5f6c2fe61b27584aab82474c2a4da721",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "7991767795c75a5cb01063aa52fd16fb",
"/": "7991767795c75a5cb01063aa52fd16fb",
"main.dart.js": "9025e27dcad674525af6beebfd6119d5",
"manifest.json": "261aa7bdc86f8ba14848ab9fe048b85d",
"version.json": "18b03ad8a1b2e6b28536574e7abd834b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
