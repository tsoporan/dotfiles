// `board`: a flat diagram layer over the tldraw Editor, for agents.
//
// Shapes are addressed by short string ids ("api", "db"). tldraw ids are
// "shape:<id>", so `add({ id: "api" })` creates `shape:api`, and read() reports
// every shape, including ones Titus drew, by its id without the prefix.
// Arrows made by connect() are bound to both ends, so they follow the boxes
// when either side moves or when layout() rearranges them.

import ELK, { type ElkExtendedEdge, type ElkNode } from "elkjs/lib/elk.bundled.js";
import {
  createShapeId,
  toRichText,
  type Editor,
  type TLArrowBinding,
  type TLArrowShape,
  type TLCreateShapePartial,
  type TLDefaultColorStyle,
  type TLDefaultDashStyle,
  type TLDefaultFillStyle,
  type TLGeoShapeGeoStyle,
  type TLShape,
  type TLShapeId,
  type TLShapePartial,
} from "tldraw";

export interface NodeSpec {
  /** Short id, e.g. "api". Re-adding an existing id updates that shape. */
  id: string;
  text?: string;
  /** box: geo shape (default). note: sticky. text: free text. frame: a container (state group, boundary). */
  kind?: "box" | "note" | "text" | "frame";
  /** For boxes: rectangle (default), ellipse, diamond, cloud, hexagon, oval, ... */
  geo?: TLGeoShapeGeoStyle;
  /** Page coordinates, or relative to the parent frame. Omit and call layout(). */
  x?: number;
  y?: number;
  w?: number;
  h?: number;
  color?: TLDefaultColorStyle;
  fill?: TLDefaultFillStyle;
  dash?: TLDefaultDashStyle;
  /** Id of a frame to put this shape in. */
  parent?: string;
}

export interface EdgeSpec {
  from: string;
  to: string;
  text?: string;
  /** Defaults to "<from>-><to>". Re-connecting the same id replaces the arrow. */
  id?: string;
  /** arc (default) or elbow (right-angled). */
  kind?: "arc" | "elbow";
  color?: TLDefaultColorStyle;
  dash?: TLDefaultDashStyle;
  bend?: number;
  /** Where the label sits along the arrow, 0 (start) to 1 (end). Default 0.5. */
  labelPosition?: number;
}

export interface LayoutOptions {
  /** RIGHT (default) for flows and statecharts, DOWN for hierarchies. */
  direction?: "RIGHT" | "DOWN" | "LEFT" | "UP";
  /** Gap between nodes in pixels. Default 60. */
  gap?: number;
  /** Lay out only these shapes (and what is inside them). Default: every box, note, text and frame. */
  ids?: string[];
}

export interface ShapeInfo {
  id: string;
  type: string;
  geo?: string;
  text?: string;
  color?: string;
  parent?: string;
  /** Page bounds, rounded. */
  x: number;
  y: number;
  w: number;
  h: number;
}

export interface ArrowInfo {
  id: string;
  /** Shape ids the ends are bound to; absent when an end is loose. */
  from?: string;
  to?: string;
  text?: string;
}

export interface BoardRead {
  shapes: ShapeInfo[];
  arrows: ArrowInfo[];
  selected: string[];
}

const LAYOUT_TYPES = new Set(["geo", "note", "text", "frame"]);
const DEFAULT_BOX = { w: 180, h: 80 };
const FRAME_PADDING = "[top=60,left=40,bottom=40,right=40]";

/** Wide enough that a label doesn't wrap mid-word (sized for the wider draw font, size m). */
const boxWidthFor = (text: string | undefined) =>
  Math.max(DEFAULT_BOX.w, ...(text ?? "").split("\n").map((line) => line.length * 15 + 48));

const short = (id: TLShapeId | string) => id.replace(/^shape:/, "");
const full = (id: string) => createShapeId(id);
const round = (n: number) => Math.round(n);

export type Board = ReturnType<typeof createBoard>;

export function createBoard(editor: Editor) {
  const elk = new ELK();

  const textOf = (shape: TLShape): string | undefined =>
    editor.getShapeUtil(shape).getText(shape)?.trim() || undefined;

  const typeFor = (kind: NodeSpec["kind"]) =>
    kind === "frame" ? "frame" : kind === "note" ? "note" : kind === "text" ? "text" : "geo";

  /** Where new shapes without coordinates go: a row under everything on the page. */
  function nextSlot() {
    const bounds = editor.getCurrentPageBounds();
    let x = bounds?.minX ?? 0;
    const y = bounds ? bounds.maxY + 80 : 0;
    return (w: number) => {
      const at = x;
      x += w + 40;
      return { x: at, y };
    };
  }

  /** Where new children of a frame go without coordinates: a row under its other children. */
  function frameSlot(frameId: TLShapeId) {
    const bottoms = editor
      .getSortedChildIdsForParent(frameId)
      .map((id) => editor.getShape(id))
      .filter((c) => c !== undefined)
      .map((c) => c.y + editor.getShapeGeometry(c).bounds.h);
    let x = 40;
    const y = bottoms.length ? Math.max(...bottoms) + 40 : 60;
    return (w: number) => {
      const at = x;
      x += w + 40;
      return { x: at, y };
    };
  }

  /** Grow (never shrink) a frame so none of its children are clipped. */
  function growFrame(frameId: TLShapeId) {
    const frame = editor.getShape(frameId);
    if (frame?.type !== "frame") return;
    let w = 0;
    let h = 0;
    for (const id of editor.getSortedChildIdsForParent(frameId)) {
      const child = editor.getShape(id);
      if (!child) continue;
      const b = editor.getShapeGeometry(child).bounds;
      w = Math.max(w, child.x + b.w + 40);
      h = Math.max(h, child.y + b.h + 40);
    }
    const props = frame.props as { w: number; h: number };
    if (w > props.w || h > props.h) {
      editor.updateShape({ id: frameId, type: "frame", props: { w: Math.max(w, props.w), h: Math.max(h, props.h) } });
    }
  }

  function propsFor(spec: NodeSpec): Record<string, unknown> {
    const style = {
      ...(spec.color && { color: spec.color }),
      ...(spec.dash && { dash: spec.dash }),
      ...(spec.fill && { fill: spec.fill }),
    };
    switch (typeFor(spec.kind)) {
      case "frame":
        return {
          ...(spec.text !== undefined && { name: spec.text }),
          ...(spec.color && { color: spec.color }),
          ...(spec.w !== undefined && { w: spec.w }),
          ...(spec.h !== undefined && { h: spec.h }),
        };
      case "note":
        return {
          ...(spec.text !== undefined && { richText: toRichText(spec.text) }),
          ...(spec.color && { color: spec.color }),
        };
      case "text":
        return {
          ...(spec.text !== undefined && { richText: toRichText(spec.text) }),
          ...(spec.color && { color: spec.color }),
        };
      default:
        return {
          ...style,
          ...(spec.geo && { geo: spec.geo }),
          ...(spec.text !== undefined && { richText: toRichText(spec.text) }),
          ...(spec.w !== undefined && { w: spec.w }),
          ...(spec.h !== undefined && { h: spec.h }),
        };
    }
  }

  /**
   * Create or update shapes, in the order given: layout() reads that order as
   * left-to-right (or top-to-bottom), so list a flow's entry point first.
   * A frame must be listed before the shapes inside it.
   */
  function add(nodes: NodeSpec | NodeSpec[]): string[] {
    const list = Array.isArray(nodes) ? nodes : [nodes];
    const slot = nextSlot();
    const frameSlots = new Map<TLShapeId, (w: number) => { x: number; y: number }>();
    const touchedFrames = new Set<TLShapeId>();
    editor.run(() => {
      for (const spec of list) {
        const id = full(spec.id);
        const type = typeFor(spec.kind);
        const parentId = spec.parent ? full(spec.parent) : editor.getCurrentPageId();
        if (spec.parent && !editor.getShape(parentId as TLShapeId)) {
          throw new Error(`parent "${spec.parent}" does not exist; list the frame before its children`);
        }
        const existing = editor.getShape(id);
        if (existing && existing.type !== type) {
          throw new Error(`"${spec.id}" is a ${existing.type}, not a ${type}; remove it first`);
        }
        const props = propsFor(spec);
        const pos = {
          ...(spec.x !== undefined && { x: spec.x }),
          ...(spec.y !== undefined && { y: spec.y }),
        };
        if (existing) {
          editor.updateShape({ id, type, ...pos, props } as TLShapePartial);
          if (spec.parent) {
            editor.reparentShapes([id], parentId);
            touchedFrames.add(parentId as TLShapeId);
          }
          continue;
        }
        const w = spec.w ?? (type === "frame" ? 400 : type === "geo" ? boxWidthFor(spec.text) : DEFAULT_BOX.w);
        let placed = { x: 0, y: 0 };
        if (spec.x === undefined || spec.y === undefined) {
          if (spec.parent) {
            const frameId = parentId as TLShapeId;
            if (!frameSlots.has(frameId)) frameSlots.set(frameId, frameSlot(frameId));
            placed = frameSlots.get(frameId)!(w);
          } else {
            placed = slot(w);
          }
        }
        if (spec.parent) touchedFrames.add(parentId as TLShapeId);
        editor.createShape({
          id,
          type,
          parentId,
          x: spec.x ?? placed.x,
          y: spec.y ?? placed.y,
          props: {
            // New shapes get a tinted fill and the sans font: the hand-drawn
            // default reads as a sketch, and an unfilled box looks lighter than its arrows.
            ...(type === "geo" && { w, h: DEFAULT_BOX.h, fill: "solid" }),
            ...(type !== "frame" && { font: "sans" }),
            ...(type === "frame" && { w: 400, h: 300 }),
            ...props,
          },
        } as TLCreateShapePartial);
      }
      for (const frameId of touchedFrames) growFrame(frameId);
    });
    return list.map((n) => n.id);
  }

  /** Create bound arrows between existing shapes. */
  function connect(edges: EdgeSpec | EdgeSpec[]): string[] {
    const list = Array.isArray(edges) ? edges : [edges];
    const ids: string[] = [];
    editor.run(() => {
      for (const spec of list) {
        const fromId = full(spec.from);
        const toId = full(spec.to);
        const fromBounds = editor.getShapePageBounds(fromId);
        const toBounds = editor.getShapePageBounds(toId);
        if (!fromBounds) throw new Error(`no shape "${spec.from}"`);
        if (!toBounds) throw new Error(`no shape "${spec.to}"`);
        const key = spec.id ?? `${spec.from}->${spec.to}`;
        const id = full(key);
        if (editor.getShape(id)) editor.deleteShape(id);
        const start = fromBounds.center;
        const end = toBounds.center;
        editor.createShape<TLArrowShape>({
          id,
          type: "arrow",
          x: start.x,
          y: start.y,
          props: {
            start: { x: 0, y: 0 },
            end: { x: end.x - start.x, y: end.y - start.y },
            kind: spec.kind ?? "arc",
            richText: toRichText(spec.text ?? ""),
            ...(spec.color && { color: spec.color }),
            ...(spec.dash && { dash: spec.dash }),
            ...(spec.bend !== undefined && { bend: spec.bend }),
            ...(spec.labelPosition !== undefined && { labelPosition: spec.labelPosition }),
            font: "sans",
          },
        });
        const binding = (terminal: "start" | "end", target: TLShapeId) => ({
          type: "arrow" as const,
          fromId: id,
          toId: target,
          props: {
            terminal,
            normalizedAnchor: { x: 0.5, y: 0.5 },
            isExact: false,
            isPrecise: false,
            snap: "none" as const,
          },
        });
        editor.createBindings([binding("start", fromId), binding("end", toId)]);
        ids.push(key);
      }
    });
    return ids;
  }

  /** Arrange boxes, notes, text and frames with ELK's layered layout, following arrows. */
  async function layout(opts: LayoutOptions = {}): Promise<{ moved: number }> {
    const gap = opts.gap ?? 60;
    const pageShapes = editor.getCurrentPageShapes();
    const nodes = pageShapes.filter((s) => LAYOUT_TYPES.has(s.type));

    // Restrict to the requested shapes plus everything inside them.
    let included = new Set(nodes.map((s) => s.id));
    if (opts.ids) {
      included = new Set(opts.ids.map(full));
      for (const s of nodes) {
        if (editor.findShapeAncestor(s, (a) => included.has(a.id))) included.add(s.id);
      }
    }
    const laid = nodes.filter((s) => included.has(s.id));
    if (!laid.length) return { moved: 0 };

    // Keep the laid-out group where it was: anchor at the old top-left.
    const before = laid
      .filter((s) => !included.has(s.parentId as TLShapeId))
      .map((s) => editor.getShapePageBounds(s))
      .filter((b) => b !== undefined);
    const originX = Math.min(...before.map((b) => b.minX));
    const originY = Math.min(...before.map((b) => b.minY));

    const elkNodes = new Map<TLShapeId, ElkNode>();
    for (const s of laid) {
      const { w, h } = editor.getShapeGeometry(s).bounds;
      elkNodes.set(s.id, {
        id: s.id,
        width: w,
        height: h,
        children: [],
        ...(s.type === "frame" && { layoutOptions: { "elk.padding": FRAME_PADDING } }),
      });
    }
    const root: ElkNode = {
      id: "root",
      layoutOptions: {
        "elk.algorithm": "layered",
        "elk.direction": opts.direction ?? "RIGHT",
        "elk.hierarchyHandling": "INCLUDE_CHILDREN",
        "elk.spacing.nodeNode": String(gap),
        "elk.layered.spacing.nodeNodeBetweenLayers": String(gap * 2),
        "elk.spacing.edgeLabel": "8",
        // Follow the order shapes were added: earlier shapes sit further left
        // (or up), and edges pointing back against that order become the back edges.
        "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
        "elk.layered.cycleBreaking.strategy": "MODEL_ORDER",
      },
      children: [],
      edges: [],
    };
    for (const s of laid) {
      const node = elkNodes.get(s.id);
      const parent = elkNodes.get(s.parentId as TLShapeId);
      if (!node) continue;
      (parent ?? root).children?.push(node);
    }

    const edges: ElkExtendedEdge[] = [];
    const laidArrows: { arrow: TLArrowShape; from: TLShapeId; to: TLShapeId }[] = [];
    for (const arrow of pageShapes.filter((s): s is TLArrowShape => s.type === "arrow")) {
      const ends = arrowEnds(arrow);
      if (!ends.from || !ends.to) continue;
      const from = full(ends.from);
      const to = full(ends.to);
      if (!elkNodes.has(from) || !elkNodes.has(to)) continue;
      laidArrows.push({ arrow, from, to });
      const text = textOf(arrow);
      edges.push({
        id: arrow.id,
        sources: [from],
        targets: [to],
        ...(text && { labels: [{ text, width: text.length * 9, height: 24 }] }),
      });
    }
    root.edges = edges;

    const result = await elk.layout(root);
    let moved = 0;
    editor.run(() => {
      const outerFrames = new Set<TLShapeId>();
      const place = (node: ElkNode, isTop: boolean) => {
        const shape = editor.getShape(node.id as TLShapeId);
        if (shape) {
          // ELK gives children of a laid-out frame frame-relative positions, as tldraw
          // stores them. Top-level positions are page points; a shape whose frame was
          // not laid out needs them converted into that frame's space.
          let at = { x: node.x ?? 0, y: node.y ?? 0 };
          if (isTop) {
            at = editor.getPointInParentSpace(shape, { x: at.x + originX, y: at.y + originY });
            if (editor.getShape(shape.parentId as TLShapeId)) outerFrames.add(shape.parentId as TLShapeId);
          }
          editor.updateShape({
            id: shape.id,
            type: shape.type,
            x: at.x,
            y: at.y,
            ...(shape.type === "frame" &&
              node.children?.length && { props: { w: node.width, h: node.height } }),
          } as TLShapePartial);
          moved++;
        }
        for (const child of node.children ?? []) place(child, false);
      };
      for (const child of result.children ?? []) place(child, true);
      for (const frameId of outerFrames) growFrame(frameId);
      bendArrows(laidArrows, [...elkNodes.keys()], opts.direction ?? "RIGHT");
    });
    return { moved };
  }

  /**
   * tldraw draws arrows as single arcs, not ELK's routed polylines, so a
   * straight arrow can cut through boxes. Curve the ones that would: back edges
   * (pointing against the flow) arc over the row, and forward edges that cross
   * another box bend away from it. The rest are straightened.
   */
  function bendArrows(
    arrows: { arrow: TLArrowShape; from: TLShapeId; to: TLShapeId }[],
    boxes: TLShapeId[],
    direction: NonNullable<LayoutOptions["direction"]>,
  ) {
    const axis = { RIGHT: { x: 1, y: 0 }, LEFT: { x: -1, y: 0 }, DOWN: { x: 0, y: 1 }, UP: { x: 0, y: -1 } }[direction];
    for (const { arrow, from, to } of arrows) {
      const a = editor.getShapePageBounds(from)?.center;
      const b = editor.getShapePageBounds(to)?.center;
      if (!a || !b) continue;
      const dx = b.x - a.x;
      const dy = b.y - a.y;
      const distance = Math.hypot(dx, dy);
      let bend = 0;
      if (dx * axis.x + dy * axis.y <= 0) {
        bend = Math.min(Math.max(distance * 0.3, 60), 240);
      } else {
        const blocker = firstBoxCrossed(a, b, boxes, [from, to]);
        if (blocker) {
          // tldraw bends a positive arrow toward the left normal (-dy, dx) of its direction.
          const side = (blocker.x - a.x) * -dy + (blocker.y - a.y) * dx;
          bend = (side > 0 ? -1 : 1) * Math.min(Math.max(distance * 0.2, 50), 160);
        }
      }
      editor.updateShape<TLArrowShape>({ id: arrow.id, type: "arrow", props: { bend } });
    }
  }

  /** Center of the first box (other than the ends and their frames) on the segment a-b. */
  function firstBoxCrossed(
    a: { x: number; y: number },
    b: { x: number; y: number },
    boxes: TLShapeId[],
    ends: TLShapeId[],
  ) {
    const skip = new Set<TLShapeId>(ends);
    for (const end of ends) {
      for (const ancestor of editor.getShapeAncestors(end)) skip.add(ancestor.id);
    }
    for (const id of boxes) {
      if (skip.has(id)) continue;
      const box = editor.getShapePageBounds(id)?.clone().expandBy(8);
      if (!box) continue;
      for (let t = 0.05; t < 1; t += 0.05) {
        if (box.containsPoint({ x: a.x + (b.x - a.x) * t, y: a.y + (b.y - a.y) * t })) return box.center;
      }
    }
    return undefined;
  }

  function arrowEnds(arrow: TLArrowShape): { from?: string; to?: string } {
    const bindings = editor.getBindingsFromShape<TLArrowBinding>(arrow, "arrow");
    const end = (terminal: "start" | "end") => {
      const b = bindings.find((x) => x.props.terminal === terminal);
      return b ? short(b.toId) : undefined;
    };
    const from = end("start");
    const to = end("end");
    return { ...(from && { from }), ...(to && { to }) };
  }

  /** Everything on the current page, compactly: what the agent reads after Titus edits. */
  function read(): BoardRead {
    const shapes: ShapeInfo[] = [];
    const arrows: ArrowInfo[] = [];
    for (const shape of editor.getCurrentPageShapesSorted()) {
      const text = textOf(shape);
      if (shape.type === "arrow") {
        arrows.push({ id: short(shape.id), ...arrowEnds(shape as TLArrowShape), ...(text && { text }) });
        continue;
      }
      const b = editor.getShapePageBounds(shape);
      const props = shape.props as { geo?: string; color?: string };
      const parent = editor.getShape(shape.parentId as TLShapeId);
      shapes.push({
        id: short(shape.id),
        type: shape.type,
        ...(props.geo && { geo: props.geo }),
        ...(text && { text }),
        ...(props.color && { color: props.color }),
        ...(parent && { parent: short(parent.id) }),
        x: round(b?.x ?? shape.x),
        y: round(b?.y ?? shape.y),
        w: round(b?.w ?? 0),
        h: round(b?.h ?? 0),
      });
    }
    return { shapes, arrows, selected: editor.getSelectedShapeIds().map(short) };
  }

  /** PNG of the page (or some shapes) as a data URL; cli.ts writes it to a file. */
  async function shot(opts: { ids?: string[]; scale?: number } = {}) {
    const ids = opts.ids ? opts.ids.map(full) : [...editor.getCurrentPageShapeIds()];
    if (!ids.length) return null;
    const { url, width, height } = await editor.toImageDataUrl(ids, {
      format: "png",
      background: true,
      padding: 32,
      scale: opts.scale ?? 1,
    });
    return { url, width, height };
  }

  function remove(ids: string | string[]): void {
    editor.deleteShapes((Array.isArray(ids) ? ids : [ids]).map(full));
  }

  function clear(): void {
    editor.deleteShapes([...editor.getCurrentPageShapeIds()]);
  }

  function fit(): void {
    editor.zoomToFit({ animation: { duration: 200 } });
  }

  return { add, connect, layout, read, shot, remove, clear, fit };
}
