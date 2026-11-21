---
name: tldraw
description: Think visually with Titus on a live tldraw whiteboard open in his own browser - architecture and system design, statecharts and state machines, request and data flows, domain maps, and brainstorms with sticky notes. Claude draws through the `tldraw` CLI (boxes, frames, bound arrows, auto-layout), Titus moves and adds things by hand, and Claude reads his changes back as JSON and as a PNG. Boards are .tldr files in the project (docs/diagrams/). Use whenever Titus says tldraw, whiteboard, canvas, board, draw, diagram, sketch, map it out, visualize, "show me", statechart or architecture diagram, or when a plan, design or state machine under discussion would be clearer as a picture than as prose. This local board, not a claude.ai Artifact, is what he means by "canvas" or "whiteboard".
---

# tldraw board

**Not an Artifact.** When Titus says canvas, whiteboard, board, sketch or
diagram, he means this local board. Use the Artifact tool (a claude.ai page,
or its Design type) only when he says "artifact" or wants a page he can share
by link. If he asks for both, draw here first and publish afterwards.

A tldraw board open in Titus's browser, which both of you edit. The `tldraw`
CLI sends JavaScript to that tab and returns the result as JSON. The tab
autosaves the board to a `.tldr` file, which tldraw.com and the VS Code tldraw
extension can also open.

```bash
tldraw open <board>                 # start the server if needed, open the tab (on Titus's screen)
tldraw exec <board> [file.js]       # run JS (file or stdin) in the tab; prints the return value as JSON
tldraw read <board>                 # shapes, arrows, selection as JSON
tldraw shot <board> <out.png>       # render the page, then Read the PNG to look at it
tldraw status | stop
```

`<board>` is a name (`auth-flow` → `./docs/diagrams/auth-flow.tldr` under the
current directory) or a path to a `.tldr` file. Run `tldraw` from the project
root so the board lands in that repo.

## The loop

1. **Open.** `tldraw open <board>` opens a browser tab on Titus's screen, so
   say so in the same message. If the board is already open, it just prints the URL.
2. **Draw.** `tldraw exec <board> <<'EOF' … EOF`, or write the JS to a
   scratchpad file and pass its path (better for anything you'll re-run).
3. **Look before you report.** `tldraw shot <board> <scratchpad>/<name>.png`,
   then Read the PNG. Fix any overlaps, unreadable labels or crossings, then
   tell Titus what is on the board. Never describe a diagram you haven't seen.
4. **Titus edits by hand.** When he says he changed something ("look",
   "I moved…", "what do you think now"), run `tldraw read` plus a `shot`.
   `selected` holds whatever he has selected, which is usually what he means
   by "this". His shapes have random ids, and freehand strokes show up only
   as `draw` shapes with bounds, so read those from the PNG.
5. **Keep his arrangement.** Once Titus has moved things, don't run
   `layout()` over the whole board again. Give a new shape explicit x/y
   near what it relates to (from `read()`). For a new group of shapes,
   `layout({ ids })` arranges just them among themselves, where they
   already sit.

The page saves each exec before the CLI returns. Ctrl+Z in the tab undoes a
whole agent exec, so Titus can revert one of your steps.

## The `board` helpers

Exec code is the body of an async function `(editor, board)`. `return` sends
a value back. `editor` is the full tldraw `Editor` for anything the helpers
don't cover.

```js
board.add([                       // create or update by id, in this order
  { id: "idle", text: "Idle", geo: "oval" },
  { id: "session", kind: "frame", text: "Session" },          // container
  { id: "authing", text: "Authenticating", parent: "session", color: "blue" },
  { id: "idea", kind: "note", text: "cache tokens?", color: "yellow" },
]);
board.connect([                   // arrows bound to both shapes; they follow moves
  { from: "idle", to: "authing", text: "LOGIN" },
  { from: "authing", to: "idle", text: "FAIL", dash: "dashed" },
]);
await board.layout({ direction: "RIGHT" });   // ELK layered layout, then
board.fit();                                   // zoom the tab to the content
return board.read();
```

- `add(specs)`: `id`, `text`, and `kind` (`box` by default, or `note`,
  `text`, `frame`). Boxes take `geo`: `rectangle`, `ellipse`, `oval`,
  `diamond`, `hexagon`, `cloud`, `trapezoid`, and so on. Every kind takes
  `x`, `y`, `color` and `parent` (a frame id; x/y are then relative to that
  frame, and the frame grows to fit). Boxes also take `w`, `h`, `fill` and
  `dash`, and frames take `w` and `h`. Notes and text size themselves.
  Boxes widen to fit their label. Re-adding an id updates the shape.
  List a frame before its children.
- `connect(edges)`: `from`, `to`, `text`, `id` (default `from->to`),
  `kind` (`arc` by default, or `elbow`), `color`, `dash`, `bend`, and
  `labelPosition` (0 at the start to 1 at the end) to move a label into
  clear space. Connecting the same id again replaces the arrow. An arrow can
  also point at a frame, which reads as "this whole group".
- `layout({ direction, gap, ids })`: `RIGHT` suits flows and statecharts,
  `DOWN` suits architecture and hierarchies. Model order matters: the
  shapes and arrows you add first go first, so list the entry point first.
  Arrows that point back against the flow, or that would cut through a box,
  get curved.
- `read()` returns `{ shapes: [{ id, type, geo, text, color, parent, x, y, w, h }], arrows: [{ id, from, to, text }], selected }`.
- `remove(ids)`, `clear()`, `fit()`, `shot()` (the CLI's `shot` calls this).
- Colors: `black grey light-violet violet blue light-blue yellow orange green light-green light-red red white`.
- Dash: `draw solid dashed dotted`. Fill: `none semi solid pattern`.

## Diagram conventions

- **Architecture:** `DOWN`. Clients on top, then the edge, then services,
  then data stores at the bottom. Use a frame for each boundary (cluster, VPC,
  team). Data stores are `ellipse` and green, queues `ellipse` and orange,
  third parties `cloud` and violet. Label an arrow only when the protocol or
  payload matters.
- **Statecharts:** `RIGHT`. The initial state comes first as an `oval`.
  Nested states go in a frame, and final states are `ellipse`. Label
  transitions `EVENT [guard] / action`. Failure states are red, and their
  transitions dashed. A statechart that mirrors code (XState or similar)
  should come from that code: read the machine, then draw every state and
  transition, without simplifying.
- **Flows:** `RIGHT`. Decisions are `diamond`, with the branch on the arrow
  label (`yes` or `no`).
- **Brainstorms:** sticky notes (`kind: "note"`) in a loose grid, with
  explicit x/y and no layout. Cluster them by theme under `text` headings,
  and only connect them once Titus starts drawing links.

New shapes get a tinted fill and the sans font. Pass `fill: "none"` for an
outline box.

**Large maps** (a system or multi-team architecture): place by hand in lanes
with explicit x/y, a frame per group, instead of `layout()`, which tangles
arrows that cross between groups. Put each group next to what it talks to,
connect between groups at frame level where the exact box doesn't matter,
and stamp the board with the date and the commits it was drawn from.

Keep labels short: one to four words in a box, with detail in a nearby note.
Over about 25 shapes, split the work into several frames or boards.

## When something fails

- `no open tab for …`: the tab was closed. Run `tldraw open <board>` again.
- After the app's own code changes (`~/.local/share/tldraw/web/`), reload the
  tab. The server bundles the code on each page load.
- Server log: `~/.local/state/tldraw/server.log`.
