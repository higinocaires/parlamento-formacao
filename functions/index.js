const {onRequest} = require("firebase-functions/v2/https");
const {setGlobalOptions} = require("firebase-functions/v2");

setGlobalOptions({maxInstances: 10});

const UPSTREAM_ORIGIN = "https://api.votoaberto.org";

/**
 * Proxies /api/** to api.votoaberto.org so Flutter Web can call the API
 * without browser CORS blocks. Used via Firebase Hosting rewrite.
 */
exports.votoabertoProxy = onRequest({cors: true, invoker: "public"}, async (req, res) => {
  if (req.method !== "GET" && req.method !== "OPTIONS") {
    res.status(405).send("Method Not Allowed");
    return;
  }

  const path = req.path.startsWith("/api") ? req.path : `/api${req.path}`;
  const queryIndex = req.url.indexOf("?");
  const query = queryIndex >= 0 ? req.url.slice(queryIndex) : "";
  const targetUrl = `${UPSTREAM_ORIGIN}${path}${query}`;

  try {
    const upstream = await fetch(targetUrl, {
      method: "GET",
      headers: {Accept: "application/json"},
    });

    const body = await upstream.text();
    res.status(upstream.status);
    res.set(
        "Content-Type",
        upstream.headers.get("content-type") || "application/json",
    );
    res.send(body);
  } catch (error) {
    console.error("votoabertoProxy error:", error);
    res.status(502).json({error: "Failed to reach upstream API"});
  }
});
