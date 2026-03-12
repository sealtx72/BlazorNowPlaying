export default async function (request) {
    // Incoming request URL e.g. https://your-site.net/TMDB/movie/popular?...
    const url = new URL(request.url);

    // Environment variables set in Netlify site settings
    const API_KEY = process.env.API_KEY || "";
    const API_URL = process.env.API_URL || "";

    if (!API_URL) {
        return new Response("API_URL not configured", { status: 500 });
    }

    // Build the path to forward (remove leading /TMDB or /TMDB/)
    const forwardedPath = url.pathname.replace(/^\/TMDB\/?/, "");

    // Rebuild target URL preserving query string
    const base = API_URL.endsWith("/") ? API_URL : API_URL + "/";
    const targetUrl = new URL(forwardedPath, base);
    targetUrl.search = url.search; // preserve query string

    // Build headers for the proxied request
    const headers = {};
    // Forwarding a minimal set of headers; adjust as needed
    headers["Authorization"] = API_KEY ? `Bearer ${API_KEY}` : "";
    // If original request had content-type, forward it
    const contentType = request.headers.get("content-type");
    if (contentType) headers["content-type"] = contentType;

    // Proxy the request
    const proxied = await fetch(targetUrl.toString(), {
        method: request.method,
        headers,
        // request.body is a ReadableStream in Edge; pass it through for non-GET methods
        body: request.method === "GET" || request.method === "HEAD" ? undefined : request.body,
    });

    // Copy response headers
    const respHeaders = new Headers(proxied.headers);
    // Optionally strip hop-by-hop headers or adjust CORS here

    // Return proxied response body and status
    const body = proxied.body ? proxied.body : null;
    return new Response(body, {
        status: proxied.status,
        headers: respHeaders,
    });
}