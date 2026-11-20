import { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import {
  createTLStore,
  parseTldrawJsonFile,
  serializeTldrawJson,
  Tldraw,
  type Editor,
  type TLStore,
} from "tldraw";
import "tldraw/tldraw.css";
import { createBoard, type Board } from "./board.ts";
import type { ExecReply, ExecRequest } from "./protocol.ts";

const SAVE_DEBOUNCE_MS = 400;
const api = { "X-Tldraw": "1" };

declare global {
  interface Window {
    editor?: Editor;
    board?: Board;
  }
}

const board = new URLSearchParams(location.search).get("board");
const boardQuery = board ? `board=${encodeURIComponent(board)}` : "";

/** Load the board file into a store, or null for a board that doesn't exist yet. */
async function loadStore(): Promise<TLStore | null> {
  const res = await fetch(`/api/board?${boardQuery}`, { headers: api });
  if (res.status === 404) return null;
  if (!res.ok) throw new Error(`load failed: ${res.status} ${await res.text()}`);
  const parsed = parseTldrawJsonFile({ json: await res.text(), schema: createTLStore().schema });
  if (!parsed.ok) throw new Error(`not a tldraw file: ${parsed.error.type}`);
  return parsed.value;
}

interface Autosave {
  /** Save now if a change is pending. */
  flush(): Promise<void>;
  dispose(): void;
}

/** Save the document to the board file shortly after each change. */
function autosave(editor: Editor): Autosave {
  let timer: ReturnType<typeof setTimeout> | undefined;
  // keepalive lets the page-close save outlive the page, but caps the body at 64 KB.
  const save = async (keepalive = false) => {
    clearTimeout(timer);
    timer = undefined;
    const res = await fetch(`/api/board?${boardQuery}`, {
      method: "PUT",
      headers: api,
      body: await serializeTldrawJson(editor),
      keepalive,
    });
    if (!res.ok) console.error("save failed", res.status, await res.text());
  };
  const stopListening = editor.store.listen(
    () => {
      clearTimeout(timer);
      timer = setTimeout(save, SAVE_DEBOUNCE_MS);
    },
    { scope: "document", source: "all" },
  );
  const onPageHide = () => {
    if (timer) void save(true);
  };
  window.addEventListener("pagehide", onPageHide);
  return {
    flush: async () => {
      if (timer) await save();
    },
    dispose: () => {
      stopListening();
      window.removeEventListener("pagehide", onPageHide);
      onPageHide();
    },
  };
}

const AsyncFunction = Object.getPrototypeOf(async () => {}).constructor as new (
  ...args: string[]
) => (editor: Editor, board: Board) => Promise<unknown>;

async function runExec(editor: Editor, board: Board, msg: ExecRequest): Promise<ExecReply> {
  try {
    // One history mark per exec, so Titus can undo an agent step with Ctrl+Z.
    editor.markHistoryStoppingPoint(`agent exec ${msg.id}`);
    const value = await new AsyncFunction("editor", "board", msg.code)(editor, board);
    // Round-trip through JSON so non-serializable values fail here, not in the server.
    return { type: "result", id: msg.id, ok: true, value: JSON.parse(JSON.stringify(value ?? null)) };
  } catch (err) {
    const error = err instanceof Error ? `${err.message}\n${err.stack ?? ""}` : String(err);
    return { type: "result", id: msg.id, ok: false, error };
  }
}

/** Keep a socket to the server open, reconnecting if the server restarts. */
function connect(editor: Editor, board: Board, saver: Autosave): () => void {
  let ws: WebSocket | undefined;
  let closed = false;
  let retry: ReturnType<typeof setTimeout> | undefined;
  const open = () => {
    ws = new WebSocket(`ws://${location.host}/ws?${boardQuery}`);
    ws.onmessage = async (event) => {
      const msg = JSON.parse(String(event.data)) as ExecRequest;
      if (msg.type !== "exec") return;
      const reply = await runExec(editor, board, msg);
      // Agent edits are on disk by the time the CLI returns.
      await saver.flush();
      ws?.send(JSON.stringify(reply));
    };
    ws.onclose = () => {
      if (!closed) retry = setTimeout(open, 1000);
    };
  };
  open();
  return () => {
    closed = true;
    clearTimeout(retry);
    ws?.close();
  };
}

function App() {
  const [store, setStore] = useState<TLStore | null | undefined>(undefined);
  const [error, setError] = useState<string>();

  useEffect(() => {
    if (!board) return setError("Open this page with ?board=/absolute/path.tldr (use `tldraw open`).");
    document.title = board.split("/").pop()?.replace(/\.tldr$/, "") ?? "tldraw";
    loadStore().then(setStore, (err: Error) => setError(err.message));
  }, []);

  if (error) return <pre style={{ padding: 24, font: "14px monospace" }}>{error}</pre>;
  if (store === undefined) return null;

  return (
    <Tldraw
      {...(store ? { store } : {})}
      onMount={(editor) => {
        const board = createBoard(editor);
        if (store) editor.zoomToFit();
        window.editor = editor;
        window.board = board;
        const saver = autosave(editor);
        const disconnect = connect(editor, board, saver);
        return () => {
          disconnect();
          saver.dispose();
        };
      }}
    />
  );
}

const root = document.getElementById("root");
if (!root) throw new Error("missing #root");
createRoot(root).render(<App />);
