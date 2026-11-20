// Local bridge between Claude (via cli.ts) and a tldraw tab in Titus's browser.
//
// The tab is the only editor. The server serves the page, reads and writes
// .tldr board files, and relays `exec` requests from the CLI to the tab over a
// WebSocket, returning whatever the tab's code returns.
//
// Every /api request must carry `X-Tldraw: 1`. A custom header forces a CORS
// preflight, which this server never answers, so a web page in some other tab
// cannot drive the board or write files through it. The WebSocket checks
// Origin for the same reason.

import { mkdir, rename } from "node:fs/promises";
import { dirname, isAbsolute, normalize } from "node:path";
import index from "./web/index.html";
import type { ExecReply, ExecRequest } from "./web/protocol.ts";

const port = Number(process.env.TLDRAW_PORT ?? 4747);
const origin = `http://localhost:${port}`;
const allowedHosts = new Set([`localhost:${port}`, `127.0.0.1:${port}`]);
const EXEC_TIMEOUT_MS = 30_000;

type Socket = Bun.ServerWebSocket<{ board: string }>;

// Board path -> open tabs, newest last. Exec goes to the newest tab.
const tabs = new Map<string, Socket[]>();
const pending = new Map<
  string,
  { ws: Socket; resolve: (r: ExecReply) => void; timer: ReturnType<typeof setTimeout> }
>();

function boardPath(raw: string | null): string {
  if (!raw) throw new HttpError(400, "missing ?board=");
  const p = normalize(raw);
  if (!isAbsolute(p) || !p.endsWith(".tldr")) {
    throw new HttpError(400, `board must be an absolute .tldr path: ${raw}`);
  }
  return p;
}

class HttpError extends Error {
  constructor(
    readonly status: number,
    message: string,
  ) {
    super(message);
  }
}

function requireApiHeader(req: Request): void {
  if (req.headers.get("x-tldraw") !== "1") throw new HttpError(403, "missing X-Tldraw header");
}

async function handleApi(req: Request, url: URL): Promise<Response> {
  requireApiHeader(req);
  const route = `${req.method} ${url.pathname}`;

  if (route === "GET /api/status") {
    const boards = [...tabs].map(([board, list]) => ({ board, tabs: list.length }));
    return Response.json({ ok: true, pid: process.pid, boards });
  }

  if (route === "POST /api/stop") {
    setTimeout(() => process.exit(0), 50);
    return Response.json({ ok: true });
  }

  const board = boardPath(url.searchParams.get("board"));

  if (route === "GET /api/board") {
    const file = Bun.file(board);
    if (!(await file.exists())) return new Response(null, { status: 404 });
    return new Response(file, { headers: { "content-type": "application/json" } });
  }

  if (route === "PUT /api/board") {
    const body = await req.text();
    JSON.parse(body); // refuse to write anything that isn't JSON
    await mkdir(dirname(board), { recursive: true });
    const tmp = `${board}.${crypto.randomUUID()}.tmp`;
    await Bun.write(tmp, body);
    await rename(tmp, board);
    return new Response(null, { status: 204 });
  }

  if (route === "POST /api/exec") {
    const list = tabs.get(board);
    const tab = list?.at(-1);
    if (!tab) throw new HttpError(409, `no open tab for ${board}; run: tldraw open`);
    const id = crypto.randomUUID();
    const request: ExecRequest = { type: "exec", id, code: await req.text() };
    const reply = await new Promise<ExecReply>((resolve) => {
      const timer = setTimeout(() => {
        pending.delete(id);
        resolve({ type: "result", id, ok: false, error: `timed out after ${EXEC_TIMEOUT_MS}ms` });
      }, EXEC_TIMEOUT_MS);
      pending.set(id, { ws: tab, resolve, timer });
      tab.send(JSON.stringify(request));
    });
    return Response.json(reply, { status: reply.ok ? 200 : 422 });
  }

  throw new HttpError(404, `no route ${route}`);
}

const server = Bun.serve<{ board: string }>({
  hostname: "127.0.0.1",
  port,
  development: { hmr: false, console: false },
  routes: { "/": index },
  async fetch(req, server) {
    const url = new URL(req.url);
    try {
      // DNS rebinding: a hostile domain resolved to 127.0.0.1 would be same-origin
      // with this server, so the X-Tldraw header alone wouldn't stop it. Its
      // requests still carry that domain as Host.
      if (!allowedHosts.has(req.headers.get("host") ?? "")) throw new HttpError(403, "bad host");
      if (url.pathname === "/ws") {
        if (req.headers.get("origin") !== origin) throw new HttpError(403, "bad origin");
        const board = boardPath(url.searchParams.get("board"));
        if (server.upgrade(req, { data: { board } })) return undefined;
        throw new HttpError(400, "websocket upgrade failed");
      }
      if (url.pathname.startsWith("/api/")) return await handleApi(req, url);
      return new Response("not found", { status: 404 });
    } catch (err) {
      const status = err instanceof HttpError ? err.status : 500;
      const message = err instanceof Error ? err.message : String(err);
      if (status === 500) console.error(err);
      return Response.json({ ok: false, error: message }, { status });
    }
  },
  websocket: {
    open(ws) {
      const list = tabs.get(ws.data.board) ?? [];
      list.push(ws);
      tabs.set(ws.data.board, list);
      console.log(`tab open  ${ws.data.board} (${list.length})`);
    },
    message(_ws, raw) {
      const reply = JSON.parse(String(raw)) as ExecReply;
      const waiter = pending.get(reply.id);
      if (!waiter) return;
      clearTimeout(waiter.timer);
      pending.delete(reply.id);
      waiter.resolve(reply);
    },
    close(ws) {
      const list = (tabs.get(ws.data.board) ?? []).filter((t) => t !== ws);
      if (list.length) tabs.set(ws.data.board, list);
      else tabs.delete(ws.data.board);
      for (const [id, waiter] of pending) {
        if (waiter.ws !== ws) continue;
        clearTimeout(waiter.timer);
        pending.delete(id);
        waiter.resolve({ type: "result", id, ok: false, error: `tab closed for ${ws.data.board}` });
      }
      console.log(`tab close ${ws.data.board} (${list.length})`);
    },
  },
});

console.log(`tldraw server on ${origin} (pid ${process.pid})`);
export { server };
