// Messages between server.ts and the tab, over the board's WebSocket.

export interface ExecRequest {
  type: "exec";
  id: string;
  /** Body of an async function called as (editor, board). Use `return` for a result. */
  code: string;
}

export type ExecReply =
  | { type: "result"; id: string; ok: true; value: unknown }
  | { type: "result"; id: string; ok: false; error: string };
