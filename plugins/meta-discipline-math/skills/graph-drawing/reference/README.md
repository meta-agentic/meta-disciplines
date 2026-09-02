# graph-layout — reference implementation

A dependency-free, framework-agnostic layout engine that makes the
[`graph-drawing`](../SKILL.md) skill's method executable. It is the portable core the
skill describes: **classify → pick the convention → run the matching pipeline → measure the
result**, as plain functions over `{nodes, edges}` data with no DOM, React, or canvas
coupling.

## What it is

`graph-layout.ts` exports:

| Export | Skill step | Notes |
|--------|-----------|-------|
| `classify(nodes, edges)` | 1 — classify first | components, acyclicity, max degree, planar edge-bound flag — all measured |
| `auto(cls)` | 2 — semantics pick the convention | directed + acyclic ⇒ `layered`, else `force` |
| `layered(nodes, edges)` | 4 — pipeline | Sugiyama-style: longest-path layering + barycenter sweeps `[heuristic]` |
| `radial(nodes, edges, groupOf)` | 4 — pipeline | concentric rings by group key `[heuristic]` |
| `force(nodes, edges)` / `forceStep(...)` | 4 — pipeline | spring + repulsion + collision floor `[heuristic]`; `forceStep` for per-frame animation |
| `countCrossings(edges)` | 5 — measure on the output | proper segment intersections; the number you report |
| `layout(nodes, edges, mode)` | whole ledger | one call returning classification + resolved mode + measured crossings |

Every optimization step is labeled `[heuristic]` in the source with what it does and does
not guarantee — the skill forbids passing a heuristic off as optimal.

## Reuse in a React / Vite / Zustand frontend (e.g. isohub)

The module is pure and side-effect-free except for mutating `x/y` (and `vx/vy` for the
force step) on the node objects you pass in, so it composes with any renderer. It
type-checks clean under `--strict` with isohub's own `tsc` (React 18 + Vite + TypeScript).

```ts
// store.ts (Zustand) — layout is just a state transition over your node data
import { layout, forceStep, type GraphNode, type GraphEdge } from './graph-layout';

const { resolved, crossings } = layout(nodes, edges, 'auto', { width, height });
// render `nodes` with react (SVG/canvas) or react-three-fiber; `resolved` and
// `crossings` are the ledger fields the skill wants surfaced to the reader.
```

For an interactive/animated view, drive `forceStep(nodes, edges, opts, alpha)` from a
`requestAnimationFrame` loop (or an r3f `useFrame`) with a cooling `alpha`, and pass an
`anchor` callback for a type-anchored layout that keeps groups in stable regions —
the mental-map-preservation the skill's step 9 calls for.

## Provenance

Written for this skill as an original reference implementation; verified by `tsc --strict`
and a functional smoke test (a diamond DAG classifies acyclic, auto-selects `layered`, and
draws with zero crossings; its cyclic variant falls through to `force`). Public-safe: no
instance data. The `Methodology Claim Graph` artifact uses the same engine inline.
