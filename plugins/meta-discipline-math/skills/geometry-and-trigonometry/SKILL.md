---
name: geometry-and-trigonometry
description: "Use whenever a problem is spatial — a triangle, angle, length, area, volume, rotation, or projection — and the method or coordinate frame is up to you. Enforces choosing synthetic/analytic/vector/transformational deliberately, placing the origin and axes to kill terms, deriving with the trig toolkit under radian/quadrant discipline, and verifying every result by a coordinate-independent invariant and a degenerate limiting case. Nothing ships without an invariant check."
---

# Geometry & Trigonometry

Most geometry pain comes from the *wrong frame*: the answer is easy in coordinates chosen to
respect the symmetry, and brutal otherwise. This skill makes method-and-frame a deliberate
first move, then forces the answer through a coordinate-independent invariant so a frame
mistake cannot survive to the page. Cross-links: [[skills/linear-algebra/SKILL|linear-algebra]]
(transforms, determinants), [[skills/hypercomplex-and-geometric-algebra/SKILL|hypercomplex-and-geometric-algebra]] (rotations/GA).

## Method

1. **Pick the method for this problem.** Weigh **synthetic** (theorems, congruence — short
   when a classical fact applies), **analytic** (coordinates — brute but always available),
   **vector** (angles/areas via dot & cross — no coordinates needed), and **transformational**
   (map the figure, reason about the map's invariants). Incidence/ratio problems love vectors;
   locus problems love coordinates.
2. **Place the frame to kill terms.** You get to choose the origin and axes for free — spend it.
   Put a vertex at the origin, an edge on the $x$-axis, a center of symmetry at $0$. A right
   triangle with legs on the axes turns most identities into arithmetic. Under `config.notation`,
   state the frame explicitly.
3. **Work the trig toolkit in radians.** Anchor to the unit circle; derive, don't memorize, from
   $\sin^2\theta+\cos^2\theta=1$ and the addition formulas $\sin(\alpha\pm\beta)=\sin\alpha\cos\beta\pm\cos\alpha\sin\beta$.
   For general triangles use the law of sines $\tfrac{a}{\sin A}=2R$ and law of cosines
   $c^2=a^2+b^2-2ab\cos C$. Keep quadrant/sign discipline: $\arcsin$/$\arccos$ return one branch — fix the sign from the geometry.
4. **Compute lengths, angles, areas, volumes with vectors.** Angle from $\cos\theta=\tfrac{\mathbf a\cdot\mathbf b}{\|\mathbf a\|\|\mathbf b\|}$;
   projection $\tfrac{\mathbf a\cdot\mathbf b}{\|\mathbf b\|^2}\mathbf b$; triangle area $\tfrac12\|\mathbf a\times\mathbf b\|$;
   tetrahedron/parallelepiped volume from the scalar triple product $\tfrac16|\,\mathbf a\cdot(\mathbf b\times\mathbf c)|$.
5. **Treat transformations as maps and name their invariants.** Isometries (rotation, reflection,
   translation) preserve distance; similarities preserve angles and ratios; affine maps preserve
   parallelism and ratios along a line. The matrix determinant gives the **area/volume factor** and,
   by its sign, orientation ($\det=+1$ proper rotation, $\det=-1$ reflection). Compose by multiplying matrices.
6. **Check classical-theorem hypotheses before using them.** Pythagoras $a^2+b^2=c^2$ needs a
   *right* angle; SAS/ASA/SSS congruence each need their specific data; the inscribed-angle and
   power-of-a-point facts need a genuine circle. State the hypothesis you are relying on.
7. **Know when Euclid fails.** On a sphere the angle sum of a triangle exceeds $\pi$ (excess $=$ area/$R^2$);
   in the hyperbolic plane it falls short, and the parallel postulate does not hold. If the surface is
   curved, switch to the spherical/hyperbolic law of cosines rather than the flat one.
8. **Verify by an invariant and a degenerate case.** Recompute one scalar that no frame can change
   (length, angle, area, cross-ratio) and confirm it agrees; then push to a limit (collinear points
   $\Rightarrow$ area $0$; $\theta\to0\Rightarrow$ identity map). Two independent confirmations, not one.

## The rigor standard

- **Every angle states its unit** — radians by default, degrees only when flagged — and its quadrant
  is pinned by the geometry, not by a calculator's principal branch.
- **Every result is confirmed by a coordinate-independent invariant.** If it changes when the frame
  changes, it is not the answer.
- **Every transformation reports its determinant and preserved quantity** (distance / angle / ratio /
  parallelism), so the class of map is explicit.
- **Classical theorems cite the hypothesis they need**; a right-angle-free "Pythagoras" is rejected.
- **Curvature is declared:** Euclidean unless stated, and the angle-sum test flags a non-flat surface.

## Checkable output

Each result names the frame it was computed in, the invariant that confirms it, and the degenerate
case that bounds it. Angles carry radians/degrees explicitly; areas and lengths carry units (see
[[skills/dimensional-analysis/SKILL|dimensional-analysis]]). Round to `config.sig_figs` (default 3).

```
RESULT            METHOD / FRAME                INVARIANT CHECK                          DEGENERATE / LIMIT CHECK
triangle area     shoelace, vertex at origin    = ½‖a×b‖ = 6.00 (frame-independent) ✓    collinear ⇒ area 0 ✓
angle A           law of cosines, rad           = arccos(a·b/‖a‖‖b‖) = 1.05 rad ✓        a=b ⇒ isosceles, A=B ✓
rotation by θ     2×2 matrix, standard axes      det = 1, ‖Rv‖ = ‖v‖ preserved ✓          θ = 0 ⇒ R = I ✓
tetra. volume     scalar triple product         = ⅙|a·(b×c)| = 0.500 (coord-free) ✓      coplanar ⇒ volume 0 ✓
```

Under the `applied` profile this ledger is mandatory — no spatial number ships without it. Under
`pure` it backs the synthetic argument produced by [[skills/mathematical-rigor/SKILL|mathematical-rigor]].
Symbolic invariants (e.g. confirming $\det R=1$ identically) go through the configured CAS
(`config.cas`: sympy|sage|none); with `none`, verify by hand and mark the check `[manual]`.

## Anti-patterns

- Grinding coordinates with the origin at an arbitrary point when a vertex or center of symmetry was
  free — the frame was the whole problem.
- Reading an angle off $\arcsin$/$\arccos$ without fixing the quadrant, so the sign is silently wrong.
- Mixing radians and degrees in one derivation, or feeding degrees to a series/derivative that assumes radians.
- Invoking Pythagoras, an SAS congruence, or an inscribed-angle fact without checking the right angle / the given data / the circle.
- Reporting a "result" that depends on the chosen frame, with no cross-check against a length, angle, or area invariant.
- Assuming the angle sum is $\pi$ on a curved surface, or using the flat law of cosines where the geometry is spherical/hyperbolic.
