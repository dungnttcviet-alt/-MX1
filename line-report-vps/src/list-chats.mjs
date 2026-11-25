import { createLineClient } from "./client.mjs";

const { client } = await createLineClient();
const chats = await client.fetchJoinedChats();
for (const chat of chats) console.log(`${chat.mid}\t${chat.name}`);
