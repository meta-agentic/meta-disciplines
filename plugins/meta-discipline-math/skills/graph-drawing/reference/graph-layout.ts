// graph-layout.ts — a dependency-free, framework-agnostic layout engine that makes the
// graph-drawing skill's method executable. Pure functions over plain {nodes, edges} data;
// no DOM, no React, no canvas — mutates only x/y (and vx/vy for the force step), so it
// drops into any renderer: an SVG artifact, a React/Vite/Zustand app (isohub), <canvas>,
// or a server rendering to a file.
//
// The skill's Method, in code:
//   step 1  classify()        — measure the graph before drawing (never assume)
//   step 2  auto()            — let the classification pick the convention
//   step 3  the caller declares the aesthetic priority (this file measures, doesn't rank)
//   step 4  layered/radial/force — the matching pipelines, each labeled heuristic/exact
//   step 5  countCrossings()  — promise nothing you did not measure on the OUTPUT
//
// Every optimization step here is a HEURISTIC with no global guarantee (barycenter
// ordering, longest-path layering, spring energy) — see each function. Exact ILP/flow
// methods are out of scope for a portable core; a caller that needs them swaps the phase.

export type NodeId = string;

export interface GraphNode {
  id: NodeId;
  /** free layout coordinates — written by the layout functions */
  x: number;
  y: number;
  /** force-step velocity — only used by force(); ignored by layered/radial */
  vx?: number;
  vy?: number;
  /** optional grouping key for radial() and type-anchored force layouts */
  group?: string;
  /** collision radius; defaults to DEFAULT_RADIUS */
  r?: number;
}

export interface GraphEdge<N extends GraphNode = GraphNode> {
  /** source and target node references (not ids) — resolve ids to nodes before calling */
  s: N;
  t: N;
}

export interface Classification {
  n: number;
  m: number;
  /** weakly-connected component count (undirected reachability) */
  components: number;
  /** true iff the directed graph has no cycle (Kahn topological sort completes) */
  acyclic: boolean;
  /** maximum total (in+out) degree */
  maxDegree: number;
  /** density flag: m <= 3n-6 is the planar edge ceiling — above it the graph is non-planar */
  exceedsPlanarEdgeBound: boolean;
}

export type LayoutMode = 'auto' | 'layered' | 'radial' | 'force';

const DEFAULT_RADIUS = 10;

/** step 1 — classify the graph before drawing anything. All measured, never assumed. */
export function classify<N extends GraphNode>(nodes: N[], edges: GraphEdge<N>[]): Classification {
  const index = new Map<N, number>(nodes.map((nd, i) => [nd, i]));

  // weakly-connected components via union-find over undirected edges
  const parent = nodes.map((_, i) => i);
  const find = (i: number): number => (parent[i] === i ? i : (parent[i] = find(parent[i])));
  for (const e of edges) {
    const a = find(index.get(e.s)!);
    const b = find(index.get(e.t)!);
    if (a !== b) parent[a] = b;
  }
  const roots = new Set(nodes.map((_, i) => find(i)));

  // acyclicity via Kahn's algorithm (topological sort completes iff acyclic)
  const indeg = new Map<N, number>(nodes.map((nd) => [nd, 0]));
  const out = new Map<N, N[]>(nodes.map((nd) => [nd, []]));
  for (const e of edges) {
    indeg.set(e.t, (indeg.get(e.t) ?? 0) + 1);
    out.get(e.s)!.push(e.t);
  }
  const queue = nodes.filter((nd) => (indeg.get(nd) ?? 0) === 0);
  let visited = 0;
  while (queue.length) {
    const nd = queue.pop()!;
    visited++;
    for (const to of out.get(nd)!) {
      indeg.set(to, (indeg.get(to) ?? 0) - 1);
      if ((indeg.get(to) ?? 0) === 0) queue.push(to);
    }
  }

  const deg = new Map<N, number>(nodes.map((nd) => [nd, 0]));
  for (const e of edges) {
    deg.set(e.s, (deg.get(e.s) ?? 0) + 1);
    deg.set(e.t, (deg.get(e.t) ?? 0) + 1);
  }

  const n = nodes.length;
  return {
    n,
    m: edges.length,
    components: roots.size,
    acyclic: visited === n,
    maxDegree: n ? Math.max(...deg.values()) : 0,
    exceedsPlanarEdgeBound: edges.length > 3 * n - 6,
  };
}

/**
 * step 5 — count edge crossings on the ACTUAL drawing (proper segment intersections;
 * shared endpoints do not count). O(m^2); fine for the diagram-scale graphs this core
 * targets. This is the number you report — never a spring-energy value dressed up as a
 * crossing count.
 */
export function countCrossings<N extends GraphNode>(edges: GraphEdge<N>[]): number {
  const ccw = (ax: number, ay: number, bx: number, by: number, cx: number, cy: number) =>
    (bx - ax) * (cy - ay) - (by - ay) * (cx - ax);
  let crossings = 0;
  for (let i = 0; i < edges.length; i++) {
    for (let j = i + 1; j < edges.length; j++) {
      const a = edges[i];
      const b = edges[j];
      if (a.s === b.s || a.s === b.t || a.t === b.s || a.t === b.t) continue; // adjacent
      const d1 = ccw(a.s.x, a.s.y, a.t.x, a.t.y, b.s.x, b.s.y);
      const d2 = ccw(a.s.x, a.s.y, a.t.x, a.t.y, b.t.x, b.t.y);
      const d3 = ccw(b.s.x, b.s.y, b.t.x, b.t.y, a.s.x, a.s.y);
      const d4 = ccw(b.s.x, b.s.y, b.t.x, b.t.y, a.t.x, a.t.y);
      if (d1 * d2 < 0 && d3 * d4 < 0) crossings++;
    }
  }
  return crossings;
}

/** step 2 — the skill's decision rule: a graph with meaningful, acyclic direction gets a
 *  layered (Sugiyama-style) layout; everything else defaults to force-directed. Trees and
 *  cluster-keyed graphs are better served by an explicit 'radial'/tree choice by the caller. */
export function auto(cls: Classification): Exclude<LayoutMode, 'auto'> {
  return cls.m > 0 && cls.acyclic ? 'layered' : 'force';
}

const avg = (xs: number[]): number | null =>
  xs.length ? xs.reduce((a, b) => a + b, 0) / xs.length : null;

export interface LayeredOptions {
  hGap?: number;
  vGap?: number;
  cx?: number;
  top?: number;
  sweeps?: number;
}

/**
 * step 4 — layered / Sugiyama-style layout [HEURISTIC].
 * Longest-path layering (cycle-tolerant: the pass cap bounds the loop on a cyclic graph)
 * + barycenter ordering sweeps (no crossing-minimization guarantee — barycenter is the
 * standard heuristic, not an optimum) + centered coordinate assignment. No dummy vertices,
 * so long edges are straight lines rather than routed bends.
 */
export function layered<N extends GraphNode>(
  nodes: N[],
  edges: GraphEdge<N>[],
  opts: LayeredOptions = {},
): void {
  const { hGap = 130, vGap = 115, cx = 0, top = 60, sweeps = 6 } = opts;

  const layer = new Map<N, number>(nodes.map((nd) => [nd, 0]));
  for (let pass = 0; pass < nodes.length; pass++) {
    let changed = false;
    for (const e of edges) {
      if ((layer.get(e.t) ?? 0) < (layer.get(e.s) ?? 0) + 1) {
        layer.set(e.t, (layer.get(e.s) ?? 0) + 1);
        changed = true;
      }
    }
    if (!changed) break;
  }

  const rows: N[][] = [];
  for (const nd of nodes) {
    const l = layer.get(nd) ?? 0;
    (rows[l] = rows[l] ?? []).push(nd);
  }
  const layers = rows.filter(Boolean);

  const pos = new Map<N, number>();
  layers.forEach((row) => row.forEach((nd, i) => pos.set(nd, i)));
  const nbrs = new Map<N, N[]>(nodes.map((nd) => [nd, []]));
  for (const e of edges) {
    nbrs.get(e.s)!.push(e.t);
    nbrs.get(e.t)!.push(e.s);
  }
  for (let s = 0; s < sweeps; s++) {
    for (const row of layers) {
      row.sort((a, b) => {
        const ba = avg(nbrs.get(a)!.filter((x) => pos.has(x)).map((x) => pos.get(x)!));
        const bb = avg(nbrs.get(b)!.filter((x) => pos.has(x)).map((x) => pos.get(x)!));
        return (ba ?? pos.get(a)!) - (bb ?? pos.get(b)!);
      });
      row.forEach((nd, i) => pos.set(nd, i));
    }
  }

  layers.forEach((row, li) =>
    row.forEach((nd, i) => {
      nd.x = cx + (i - (row.length - 1) / 2) * hGap;
      nd.y = top + li * vGap;
      nd.vx = 0;
      nd.vy = 0;
    }),
  );
}

export interface RadialOptions {
  cx?: number;
  cy?: number;
  r0?: number;
  rStep?: number;
  sweeps?: number;
}

/**
 * step 4 — concentric-ring layout by group key [HEURISTIC].
 * Smallest group on the innermost ring; barycenter angular-ordering sweeps reduce (do not
 * minimize) inter-ring crossings. Good when a grouping (node type, cluster) is the message.
 */
export function radial<N extends GraphNode>(
  nodes: N[],
  edges: GraphEdge<N>[],
  groupOf: (n: N) => string,
  opts: RadialOptions = {},
): void {
  const { cx = 0, cy = 0, r0 = 80, rStep = 120, sweeps = 4 } = opts;

  const groups = new Map<string, N[]>();
  for (const nd of nodes) {
    const g = groupOf(nd);
    (groups.get(g) ?? groups.set(g, []).get(g)!).push(nd);
  }
  const rings = [...groups.values()].sort((a, b) => a.length - b.length);

  const nbrs = new Map<N, N[]>(nodes.map((nd) => [nd, []]));
  for (const e of edges) {
    nbrs.get(e.s)!.push(e.t);
    nbrs.get(e.t)!.push(e.s);
  }
  const ang = new Map<N, number>();
  rings.forEach((g) => g.forEach((nd, i) => ang.set(nd, (2 * Math.PI * i) / g.length)));
  for (let s = 0; s < sweeps; s++) {
    for (const g of rings) {
      g.sort((a, b) => {
        const aa = avg(nbrs.get(a)!.filter((x) => ang.has(x)).map((x) => ang.get(x)!));
        const bb = avg(nbrs.get(b)!.filter((x) => ang.has(x)).map((x) => ang.get(x)!));
        return (aa ?? ang.get(a)!) - (bb ?? ang.get(b)!);
      });
      g.forEach((nd, i) => ang.set(nd, (2 * Math.PI * (i + 0.5)) / g.length));
    }
  }
  rings.forEach((g, ri) => {
    const r = r0 + ri * rStep;
    g.forEach((nd) => {
      nd.x = cx + r * Math.cos(ang.get(nd)!);
      nd.y = cy + r * Math.sin(ang.get(nd)!);
      nd.vx = 0;
      nd.vy = 0;
    });
  });
}

export interface ForceOptions {
  width?: number;
  height?: number;
  iterations?: number;
  /** optional anchor: pulls nodes toward a per-group target region (type-anchored layout) */
  anchor?: (n: GraphNode) => { x: number; y: number } | null;
}

/**
 * step 4 — force-directed layout [HEURISTIC, no crossing guarantee].
 * Spring attraction on edges + inverse-square repulsion + a hard collision floor so nodes
 * never overlap. Runs `iterations` synchronous steps (no animation loop — the caller may
 * instead call forceStep() per frame for an interactive/animated layout). Reveals clusters
 * and symmetry; the default when direction is absent or the graph is cyclic.
 */
export function force<N extends GraphNode>(
  nodes: N[],
  edges: GraphEdge<N>[],
  opts: ForceOptions = {},
): void {
  const { width = 900, height = 600, iterations = 220, anchor } = opts;
  for (const nd of nodes) {
    nd.vx = nd.vx ?? 0;
    nd.vy = nd.vy ?? 0;
  }
  for (let i = 0; i < iterations; i++) forceStep(nodes, edges, { width, height, anchor }, 1);
}

/** one integration step of the force model — call per animation frame with a cooling alpha. */
export function forceStep<N extends GraphNode>(
  nodes: N[],
  edges: GraphEdge<N>[],
  opts: { width?: number; height?: number; anchor?: (n: GraphNode) => { x: number; y: number } | null } = {},
  alpha = 0.12,
): void {
  const { width = 900, height = 600, anchor } = opts;
  const K = 0.9;

  for (let i = 0; i < nodes.length; i++) {
    for (let j = i + 1; j < nodes.length; j++) {
      const a = nodes[i];
      const b = nodes[j];
      let dx = b.x - a.x;
      let dy = b.y - a.y;
      const d2 = dx * dx + dy * dy || 1;
      const d = Math.sqrt(d2);
      const rep = 2600 / d2;
      dx /= d;
      dy /= d;
      a.vx! -= dx * rep * K;
      a.vy! -= dy * rep * K;
      b.vx! += dx * rep * K;
      b.vy! += dy * rep * K;
      const minD = (a.r ?? DEFAULT_RADIUS) + (b.r ?? DEFAULT_RADIUS) + 16;
      if (d < minD) {
        const push = (minD - d) * 0.35;
        a.vx! -= dx * push;
        a.vy! -= dy * push;
        b.vx! += dx * push;
        b.vy! += dy * push;
      }
    }
  }
  for (const e of edges) {
    let dx = e.t.x - e.s.x;
    let dy = e.t.y - e.s.y;
    const d = Math.sqrt(dx * dx + dy * dy) || 1;
    const f = (d - 120) * 0.012;
    dx /= d;
    dy /= d;
    e.s.vx! += dx * f * d * 0.02;
    e.s.vy! += dy * f * d * 0.02;
    e.t.vx! -= dx * f * d * 0.02;
    e.t.vy! -= dy * f * d * 0.02;
  }
  for (const nd of nodes) {
    const a = anchor?.(nd);
    if (a) {
      nd.vx! += (a.x - nd.x) * 0.004;
      nd.vy! += (a.y - nd.y) * 0.004;
    }
    nd.vx! += (width / 2 - nd.x) * 0.0012;
    nd.vy! += (height / 2 - nd.y) * 0.0012;
    nd.x += nd.vx! * alpha;
    nd.y += nd.vy! * alpha;
    nd.vx! *= 0.6;
    nd.vy! *= 0.6;
  }
}

export interface LayoutResult {
  classification: Classification;
  resolved: Exclude<LayoutMode, 'auto'>;
  crossings: number;
}

/**
 * Top-level convenience: classify, resolve the mode (auto → the rule in auto()), run the
 * matching pipeline, and return the classification plus the crossings MEASURED on the
 * result. This is the whole skill ledger, minus the human-declared priority, in one call.
 */
export function layout<N extends GraphNode>(
  nodes: N[],
  edges: GraphEdge<N>[],
  mode: LayoutMode = 'auto',
  opts: { width?: number; height?: number; groupOf?: (n: N) => string } = {},
): LayoutResult {
  const { width = 900, height = 600, groupOf } = opts;
  const classification = classify(nodes, edges);
  const resolved = mode === 'auto' ? auto(classification) : mode;
  if (resolved === 'layered') layered(nodes, edges, { cx: width / 2 });
  else if (resolved === 'radial') radial(nodes, edges, groupOf ?? ((n) => n.group ?? '_'), { cx: width / 2, cy: height / 2 });
  else force(nodes, edges, { width, height });
  return { classification, resolved, crossings: countCrossings(edges) };
}
