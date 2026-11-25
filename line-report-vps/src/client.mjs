import { chmod } from "node:fs/promises";
import { BaseClient } from "@evex-dev/linejs/base";
import { Client } from "@evex-dev/linejs";
import { FileStorage } from "@evex-dev/linejs/storage";

const dataDir = process.env.LINE_DATA_DIR ?? "/var/lib/dmx-line-report";
const sessionPath = `${dataDir}/session.json`;

export async function createLineClient() {
  const storage = new FileStorage(sessionPath);
  const base = new BaseClient({
    device: "ANDROIDSECONDARY",
    storage,
    legy: { encrypted: false },
  });
  let save = Promise.resolve();
  base.on("update:authtoken", (token) => {
    base.authToken = token;
    save = save
      .then(() => storage.set("userAuthToken", token))
      .then(() => chmod(sessionPath, 0o600));
  });
  const token = await storage.get("userAuthToken");
  if (typeof token !== "string" || !token) throw new Error("Chưa có phiên LINE. Hãy chạy npm run login.");
  await base.loginProcess.login({ authToken: token, skipCheck: true });
  await base.loginProcess.ready();
  await save;
  return { base, client: new Client(base) };
}
