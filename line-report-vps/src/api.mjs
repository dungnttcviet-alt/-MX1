const SUPABASE_URL = process.env.SUPABASE_URL ?? "https://isxrxeaxytyiydxiwvuc.supabase.co";
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SECRET_KEY
  ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzeHJ4ZWF4eXR5aXlkeGl3dnVjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NDQ1OTY1OCwiZXhwIjoyMTAwMDM1NjU4fQ.V7zW8iMiwuKCHGY-1tG1ociK-aeUXwX0BnhqDf1rTo4";

export async function sbRest(path, { method = "GET", query = {}, body, prefer, single = false } = {}) {
  const url = new URL(`/rest/v1/${path}`, SUPABASE_URL);
  for (const [k, v] of Object.entries(query)) {
    if (v !== undefined && v !== null && v !== "") url.searchParams.set(k, String(v));
  }
  const headers = {
    apikey: SUPABASE_SERVICE_KEY,
    Authorization: `Bearer ${SUPABASE_SERVICE_KEY}`,
    "Content-Type": "application/json",
    Accept: single ? "application/vnd.pgrst.object+json" : "application/json",
  };
  if (prefer) headers.Prefer = prefer;
  const res = await fetch(url, {
    method,
    headers,
    body: body !== undefined ? JSON.stringify(body) : undefined,
  });
  if (single && res.status === 406) return null;
  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`Supabase REST ${method} ${path} failed (${res.status}): ${text}`);
  }
  if (res.status === 204) return null;
  const text = await res.text();
  return text ? JSON.parse(text) : null;
}

export async function sbStorageSign(bucket, objectPath, expiresIn = 1800) {
  const url = new URL(`/storage/v1/object/sign/${bucket}/${objectPath}`, SUPABASE_URL);
  const res = await fetch(url, {
    method: "POST",
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: `Bearer ${SUPABASE_SERVICE_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ expiresIn }),
  });
  if (!res.ok) return "";
  const data = await res.json().catch(() => ({}));
  const raw = data?.signedURL || data?.signedUrl || "";
  if (!raw) return "";
  if (raw.startsWith("http")) return raw;
  return `${SUPABASE_URL}/storage/v1${raw.startsWith("/") ? "" : "/"}${raw}`;
}

