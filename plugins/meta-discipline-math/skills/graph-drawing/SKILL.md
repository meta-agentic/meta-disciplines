---
name: graph-drawing
description: "Use whenever a graph must be drawn, laid out, diagrammed, or animated — choosing a layout convention for a network, tree, DAG, or knowledge graph; computing or reviewing node positions; labeling a drawing; or morphing between drawings of an evolving graph. Enforces the discipline of graph drawing: classify the graph first (planarity, direction, degree, density), let the data's semantics pick the convention, declare the aesthetic priority order (criteria provably conflict), run the matching pipeline (topology–shape–metrics, Sugiyama, multilevel force/stress), promise only what the bounds allow, and preserve the mental map when animating. Emits a layout ledger with measured drawing metrics."
---

# Graph Drawing

The discipline of turning an abstract graph into a picture whose geometry can be trusted.
A layout algorithm is really a priority ordering over conflicting criteria — fewest
crossings can fight bends, area, symmetry, and uniform edge lengths all at once — so a
good drawing is a *chosen trade*, not a found optimum. The field's structure is stark:
testing or realizing a given structure (planarity, an embedding, a valid symmetry) is
almost always linear-time, while optimizing over structures (fewest crossings, largest
symmetry, minimum bends over all embeddings) is almost always NP-hard. Practical drawing
therefore pairs cheap structural cores with declared heuristics, and says which is which.

Sits with [[skills/discrete-mathematics/SKILL|discrete-mathematics]] (the combinatorial
substrate) and [[skills/geometry-and-trigonometry/SKILL|geometry-and-trigonometry]]
(the geometric one); future topology and graph-theory-and-algorithms disciplines slot in
below it, with this skill as their rendering layer.

## Method

1. **Classify the graph before drawing anything.** The gating statistics: directed or
   undirected; tree / planar / near-planar / dense (planarity tests in O(n), and
   m > 3n−6 rejects instantly); max degree (orthogonal point-drawings need Δ≤4, strong
   proximity caps at ~5); size (classic force-directed degrades past a few hundred
   vertices; multilevel methods reach 10⁵–10⁶); connectivity (blocks, and whether the
   pieces are biconnected/triconnected — a triconnected planar graph has one embedding
   up to reflection); cluster or layer structure the reader should see.

2. **Let the semantics pick the convention.** Direction that means something (dependency,
   causality, time) → layered/Sugiyama, upward. Faces or adjacency as the payload
   (floorplans, tilings) → rectangular/box-rectangular. Distances that must mean
   something → proximity-style (weak or ε-approximate — strong proximity is a
   reconstruction guarantee and brutally restrictive). Cluster membership as the message
   → circular per group, or a cluster-separating energy (LinLog). Semantic layers or
   rings → spine/radial (circles strictly dominate lines: every planar graph fits one
   circle with 1 bend/edge). Trees → a dedicated tree algorithm, never a general one.
   Structure-unknown undirected data → force-directed/stress as the default. Drawing a
   convention against the semantics — leveling a non-hierarchical digraph fabricates
   rank; force-directing a dependency graph hides its flow.

3. **Declare the aesthetic priority order.** Crossings dominate human readability, then
   bends, angular resolution, area, edge-length uniformity, symmetry — but they trade
   against each other, and the price list is known: crossings grow as m³/n² (crossing
   lemma), exact symmetry and strong proximity can force exponential area, straight-line
   planar drawings need Θ(n²) grid area in the worst case. Users even prefer a
   symmetric drawing *with* crossings. Write the ordering down; it is the spec the
   drawing is checked against.

4. **Run the pipeline that matches the class, as swappable phases.**
   - *Planar / near-planar diagram work*: topology–shape–metrics — planarize (planar
     subgraph + edge reinsertion; variable-embedding insertion over the SPQR-tree beats
     fixed-embedding), fix the shape (Tamassia's min-cost-flow bend minimization within
     the embedding), then compact for coordinates.
   - *DAG / hierarchy*: Sugiyama's four phases — cycle removal (greedy, ≤|E|/2
     reversed), layering (network simplex for compactness; longest-path for speed;
     Coffman–Graham for width caps), per-layer crossing minimization (iterated
     barycenter sweeps; median for its 3-approx guarantee), coordinates (Brandes–Köpf,
     linear time, ≤2 bends per long edge).
   - *Large undirected*: multilevel coarsening + fast repulsion (Barnes–Hut / FM³), or
     PivotMDS-initialized sparse stress majorization — monotone convergence, robust
     where per-vertex Newton steps stall in local minima.
   - *Trees*: pick by constraint — level-based (Reingold–Tilford) for small readable
     hierarchies, separation/path-based for near-linear area with controlled aspect
     ratio, radial for high-degree hubs. Decide upfront whether upwardness and child
     order must be preserved: they change the achievable area class.
   Keep phases swappable and constraints first-class (uncrossable edges, same-face
   groups, bend budgets) — the architecture of every serious layout library.

5. **Promise only what the bounds allow.** Know the map: minimum crossings, minimum
   FAS, layered crossing minimization, bend minimization over all embeddings, label
   placement — all NP-hard; planarity, a given embedding, Kuratowski certificates,
   tree drawings, symmetric drawings of planar graphs — linear. Quote the guarantee of
   the algorithm actually used (approximation ratio, bend bound, area bound), not the
   optimum of the problem it approximates. Watch the exponential-area traps: Tutte's
   barycentric method, exact symmetry, strong proximity.

6. **Exploit the decomposition toolkit.** BC-trees and SPQR-trees encode all planar
   embeddings of a biconnected graph in linear space; they power planarity testing,
   optimal edge insertion, and symmetric-embedding search alike. Optimize over
   embeddings implicitly through the decomposition, never by enumerating drawings.

7. **Separate structure, attributes, and geometry.** The graph's structure is fixed;
   typed attributes are declared; positions and bends are just more attributes computed
   late (the GraphML lesson). Layout computes coordinates; rendering is someone else's
   phase — welding them together is what makes layout code unreusable.

8. **Label as part of layout, not after it.** Label placement is NP-hard; practical
   placement is candidate-position matching with small candidate sets. When labels are
   large or many, they drive the choice of convention (layered and orthogonal styles
   leave strips to label into); a dense drawing labeled as an afterthought either drops
   labels or lies about what they name.

9. **Animate without breaking the mental map.** For evolving or multi-view graphs the
   theory bounds the promise: shared straight-line simultaneous drawings are almost
   never possible (SGE is NP-hard, two trees can fail), curves with shared edges often
   are (SEFE), shared positions alone always are (with bends). So animation settles for
   approximate stability: keep persistent vertices near their old places, move clusters
   coherently, or plan a foresighted layout over all frames — and morph planar drawings
   through planar intermediates (polynomially many linear steps suffice). Empirically,
   half-hearted position-pinning reads worse than either full stability or a clean
   relayout: commit to one.

## The rigor standard

- **No layout before classification** — the ledger opens with the graph's statistics
  (n, m, directedness, planarity, Δ, components), each obtained by an actual test, not
  assumption.
- **The convention is justified by semantics**, and the aesthetic priority order is
  written down before tuning begins.
- **Every claimed property is measured on the output** — crossings counted, bends
  counted, area/resolution computed, planarity of the drawn result re-verified —
  never inferred from the algorithm's reputation.
- **Heuristic vs guaranteed is labeled** on every phase, with the guarantee quoted
  where one exists (approximation ratio, bend/area bound).
- **Animated or multi-view drawings state their stability policy** (what is preserved:
  positions, orderings, topology — and for which elements).
- **Layout output is geometry, not pixels** — coordinates/bends handed to a separate
  renderer, structure/attributes/geometry kept distinct.

## Checkable output

End with a **layout ledger** — classification, chosen trade, pipeline, and measured
results a reviewer can re-verify:

```
GRAPH           n=48 m=44 · undirected · planar ✓(tested) · Δ=9 · 1 component
SEMANTICS       typed knowledge graph; clusters (node types) are the message
CONVENTION      force-directed with type anchors; rejected layered (no direction)
PRIORITY        cluster separation > crossings > edge-length uniformity > area
PIPELINE        spring-repulsion w/ collision floor [heuristic, no crossing bound]
                + type-anchor forces [constraint] + viewport auto-fit [exact]
MEASURED        crossings 11 · min vertex sep 26px · drawing 720×540 · labels 48/48
ANIMATION       interactive drag only; positions stable across filter toggles ✓
VERDICT         fit for purpose — crossings acceptable under declared priority
```

Under `pure`, pair structural claims (planarity, embedding validity) with the ledger of
[[skills/mathematical-rigor/SKILL|mathematical-rigor]]; under `applied`, sanity-check
measured metrics against the known bounds (a straight-line planar drawing claiming
o(n²) worst-case area, or a crossing count below m−3n+6, is wrong before you look).

## Anti-patterns (reject in review)

- Laying out before classifying — running a default force-directed layout on a DAG, a
  tree, or a graph whose planarity was never tested.
- Imposing hierarchy on a non-hierarchical digraph: leveling fabricates rank the data
  does not contain.
- Claiming "no crossings" or "minimal crossings" from a heuristic with no count on the
  actual output; treating a spring-energy minimum as a crossing minimum (it is not).
- Promising area, bend, or crossing numbers below the known lower bounds, or optimum
  quality from an approximation (the planarization pipeline can be arbitrarily far from
  the true crossing number and must be reported as a heuristic).
- Chasing exact symmetry or strong proximity without noticing the exponential-area /
  degree-cap price; using Tutte's barycentric method beyond toy sizes.
- Labels placed after the fact on a drawing that left no room, or dropped silently.
- Welding layout to rendering, or emitting geometry with no separable structure and
  attributes.
- Animating with timid position-pinning that neither preserves the mental map nor
  cleanly relayouts — the empirically worst option; or morphing planar drawings through
  crossing intermediate frames.
