// 极简 Gemini 代理（Render）
// Node >=18（原生 fetch），仅依赖 express
const express = require("express");
const app = express();
app.use(express.json({ limit: "5mb" }));

const BASE = "https://generativelanguage.googleapis.com";

app.all("/v1beta/*", async (req, res) => {
  try {
    // 拼目标地址（包含查询串）
    const pathWithQuery = req.originalUrl; // 形如 /v1beta/...?...=...
    const url = new URL(BASE + pathWithQuery);

    // 从环境变量注入 key（优先级：URL ?key=xxx > 环境变量）
    if (!url.searchParams.get("key") && process.env.GEMINI_API_KEY) {
      url.searchParams.set("key", process.env.GEMINI_API_KEY);
    }

    const upstream = await fetch(url.toString(), {
      method: req.method,
      headers: { "content-type": "application/json" },
      body: req.method === "GET" ? undefined : JSON.stringify(req.body)
    });

    // 透传状态码和头，并加上 CORS 方便本地/扩展调试
    res.status(upstream.status);
    upstream.headers.forEach((v, k) => res.setHeader(k, v));
    res.setHeader("access-control-allow-origin", "*");
    res.setHeader("access-control-allow-headers", "*");

    const buf = Buffer.from(await upstream.arrayBuffer());
    res.send(buf);
  } catch (e) {
    res.status(500).json({ error: String(e) });
  }
});

app.get("/", (_, res) => res.send("Gemini proxy running"));
app.listen(process.env.PORT || 10000, () => {
  console.log("Proxy on", process.env.PORT || 10000);
});
