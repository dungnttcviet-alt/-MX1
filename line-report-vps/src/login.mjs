import { chmod, mkdir } from "node:fs/promises";
import { BaseClient } from "@evex-dev/linejs/base";
import { FileStorage } from "@evex-dev/linejs/storage";

const dataDir = process.env.LINE_DATA_DIR ?? "/var/lib/dmx-line-report";
await mkdir(dataDir, { recursive: true, mode: 0o700 });

const storage = new FileStorage(`${dataDir}/session.json`);
const tokenKey = "userAuthToken";
const base = new BaseClient({
  device: "ANDROIDSECONDARY",
  storage,
  // LINE's encrypted LEGY gateway has returned empty HTTP 404 responses
  // since 2026-11-18. The plain transport remains operational; message
  // content continues to use LINE Letter Sealing/E2EE where applicable.
  legy: { encrypted: false },
});

let tokenSave = Promise.resolve();
base.on("update:authtoken", (token) => {
  base.authToken = token;
  tokenSave = tokenSave
    .then(() => storage.set(tokenKey, token))
    .then(() => chmod(`${dataDir}/session.json`, 0o600));
  console.log("SESSION_TOKEN_SAVED");
});
base.on("qrcall", (url) => console.log(`LOGIN_QR_URL=${url}`));
base.on("pincall", (pin) => console.log(`LOGIN_PIN=${pin}`));

const savedToken = await storage.get(tokenKey);

if (typeof savedToken === "string" && savedToken.length > 0) {
  await base.loginProcess.login({ authToken: savedToken, skipCheck: true });
} else {
  await base.loginProcess.withQrCode({ v3: true });
}

await tokenSave;
await base.loginProcess.ready();
await tokenSave;

console.log(`LOGIN_OK=${base.profile?.displayName ?? "unknown"}`);
