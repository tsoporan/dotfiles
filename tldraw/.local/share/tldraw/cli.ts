// tldraw: open a tldraw board in the browser and drive it from the terminal.
// Run `tldraw help` for usage.

import { mkdir } from "node:fs/promises";
import { homedir } from "node:os";
import { join, resolve } from "node:path";

const port = Number(process.env.TLDRAW_PORT ?? 4747);
const base = `http://localhost:${port}`;
const serverPath = join(import.meta.dir, "server.ts");
const logPath = join(process.env.XDG_STATE_HOME ?? join(homedir(), ".local/state"), "tldraw/server.log");

const USAGE = `tldraw: a live tldraw board shared by you and Claude

  tldraw open <board>            start the server if needed, open the board in the browser
  tldraw exec <board> [file.js]  run JS in the open tab (file or stdin); prints the return value as JSON
  tldraw read <board>            shapes, arrows and selection as JSON
  tldraw shot <board> <out.png>  render the page to a PNG
  tldraw path <board>            print the board's file path
  tldraw status                  server pid and open boards
  tldraw stop                    stop the server

<board> is a name ("auth-flow" -> ./docs/diagrams/auth-flow.tldr) or a path to a .tldr file.
Exec code is the body of an async function (editor, board); use \`return\` for a result.
Server log: ${logPath}`;

function die(message: string): never {
  console.error(`tldraw: ${message}`);
  process.exit(1);
}

function boardPath(arg: string | undefined): string {
  if (!arg) die("missing <board>\n\n" + USAGE);
  if (arg.includes("/") || arg.endsWith(".tldr")) {
    const p = resolve(arg);
    return p.endsWith(".tldr") ? p : `${p}.tldr`;
  }
  return resolve("docs/diagrams", `${arg}.tldr`);
}

async function api(path: string, init: RequestInit = {}): Promise<Response> {
  return fetch(`${base}${path}`, { ...init, headers: { "X-Tldraw": "1", ...init.headers } });
}

interface Status {
  ok: boolean;
  pid: number;
  boards: { board: string; tabs: number }[];
}

async function status(): Promise<Status | null> {
  try {
    const res = await api("/api/status");
    return res.ok ? ((await res.json()) as Status) : null;
  } catch {
    return null;
  }
}

async function waitFor<T>(what: string, ms: number, probe: () => Promise<T | null | undefined>): Promise<T> {
  const deadline = Date.now() + ms;
  while (Date.now() < deadline) {
    const value = await probe();
    if (value) return value;
    await Bun.sleep(200);
  }
  die(`timed out waiting for ${what}`);
}

async function ensureServer(): Promise<Status> {
  const running = await status();
  if (running) return running;
  await mkdir(join(logPath, ".."), { recursive: true });
  // setsid -f detaches the server from this shell, so it outlives the command.
  Bun.spawn(["setsid", "-f", process.execPath, serverPath], {
    stdin: "ignore",
    stdout: Bun.file(logPath),
    stderr: Bun.file(logPath),
    env: { ...process.env, TLDRAW_PORT: String(port) },
  });
  return waitFor(`the server (see ${logPath})`, 10_000, status);
}

async function exec(board: string, code: string): Promise<unknown> {
  const res = await api(`/api/exec?board=${encodeURIComponent(board)}`, { method: "POST", body: code });
  const reply = (await res.json()) as { ok: boolean; value?: unknown; error?: string };
  if (!reply.ok) die(reply.error ?? `exec failed (${res.status})`);
  return reply.value;
}

async function open(board: string): Promise<void> {
  const s = await ensureServer();
  const url = `${base}/?board=${encodeURIComponent(board)}`;
  if (!s.boards.some((b) => b.board === board)) {
    Bun.spawn(["xdg-open", url], { stdin: "ignore", stdout: "ignore", stderr: "ignore" });
    await waitFor("the browser tab to connect", 20_000, async () =>
      (await status())?.boards.some((b) => b.board === board),
    );
  }
  console.log(`open ${board}\n${url}`);
}

const [cmd, ...args] = process.argv.slice(2);

switch (cmd) {
  case "open":
    await open(boardPath(args[0]));
    break;
  case "exec": {
    const board = boardPath(args[0]);
    const code = args[1] ? await Bun.file(args[1]).text() : await Bun.stdin.text();
    if (!code.trim()) die("no code: pass a file or pipe JS on stdin");
    console.log(JSON.stringify(await exec(board, code), null, 2));
    break;
  }
  case "read":
    console.log(JSON.stringify(await exec(boardPath(args[0]), "return board.read()"), null, 2));
    break;
  case "shot": {
    const board = boardPath(args[0]);
    const out = args[1] ?? die("missing <out.png>");
    const img = (await exec(board, "return board.shot()")) as { url: string; width: number; height: number } | null;
    if (!img) die("the page is empty");
    const png = Buffer.from(img.url.replace(/^data:image\/png;base64,/, ""), "base64");
    await Bun.write(out, png);
    console.log(`${resolve(out)} ${img.width}x${img.height}`);
    break;
  }
  case "path":
    console.log(boardPath(args[0]));
    break;
  case "status": {
    const s = await status();
    if (!s) {
      console.log("server not running");
      break;
    }
    console.log(`server pid ${s.pid} on ${base}`);
    for (const b of s.boards) console.log(`  ${b.board} (${b.tabs} tab${b.tabs === 1 ? "" : "s"})`);
    break;
  }
  case "stop":
    if (await status()) {
      const res = await api("/api/stop", { method: "POST" });
      if (!res.ok) die(`stop failed: ${res.status} ${await res.text()}`);
      await waitFor("the server to exit", 5_000, async () => !(await status()));
    }
    console.log("stopped");
    break;
  case undefined:
  case "help":
  case "-h":
  case "--help":
    console.log(USAGE);
    break;
  default:
    die(`unknown command "${cmd}"\n\n${USAGE}`);
}
