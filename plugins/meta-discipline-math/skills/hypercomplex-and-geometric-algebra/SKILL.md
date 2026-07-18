---
name: hypercomplex-and-geometric-algebra
description: "Use when modeling rotations, orientation, spinors, or multi-dimensional structure and deciding which algebra fits — real, complex, quaternion, octonion, Clifford/geometric algebra, or plain matrices. Provides a selection procedure honoring the Frobenius/Hurwitz constraints, quaternion-rotation and geometric-algebra recipes, and a numerical verification standard. Judgment, not just facts: pick the right structure and prove it works."
---

# Hypercomplex & Geometric Algebra

Choosing the algebra is a design decision with hard mathematical constraints. This skill
codifies the choice and the verification, so the answer is *justified and checked*, not
defaulted to matrices out of habit.

## The selection procedure

Ask, in order:

1. **What operation dominates?** 2D rotation/scaling → **$\mathbb{C}$**. 3D rotation /
   orientation → **unit quaternions $\mathbb{H}$**. Rigid motion (rotation *and*
   translation), or lines/planes/spheres as first-class objects → **geometric algebra**
   (PGA $C\ell_{3,0,1}$ for rigid motion; CGA $C\ell_{4,1}$ for conformal). Spin / Dirac
   theory → the Clifford algebra of the metric ($C\ell_{1,3}$).
2. **Which algebraic properties must hold?** Need division (invertibility of every nonzero
   element)? **Frobenius:** only $\mathbb{R},\mathbb{C},\mathbb{H}$ are associative division
   algebras; **Hurwitz:** only dims $1,2,4,8$ carry a multiplicative norm. So there is **no
   clean 3-component division algebra** — reach for $\mathbb{H}$ (dim 4), not a triplet.
3. **What are you willing to give up?** Each step up the tower costs a property:
   $\mathbb{C}$ loses ordering, $\mathbb{H}$ loses commutativity ($ij=-ji$), $\mathbb{O}$
   loses associativity, sedenions lose division (zero divisors). Choose the *lowest*
   structure that supports the operation — extra structure you don't need is a liability.
4. **Would a matrix representation be simpler to ship?** Sometimes yes — but quaternions
   beat rotation matrices for *composition stability, storage, and interpolation* (SLERP,
   no gimbal lock), and geometric algebra beats $4\times4$ homogeneous matrices for
   singular-free handling of points at infinity. Justify the choice; don't default.

## Core recipes

- **Quaternion rotation.** Unit $q$, $|q|=1$, rotates $\mathbf{p}$ by
  $\mathbf{p}' = q\,\mathbf{p}\,q^{-1}$ (with $\mathbf{p}$ a pure quaternion). Compose
  rotations by multiplying quaternions (order matters: $q_2 q_1$ applies $q_1$ first).
  Interpolate with SLERP. Re-normalize periodically to fight drift.
- **Axis–angle ↔ quaternion.** Angle $\theta$ about unit axis $\hat{\mathbf n}$:
  $q = \cos(\theta/2) + \sin(\theta/2)\,(\hat n_x i + \hat n_y j + \hat n_z k)$. The
  half-angle is the usual bug source — verify it.
- **Geometric algebra rotor.** $R = e^{-B\theta/2}$ for a unit bivector $B$; apply by the
  sandwich $x' = R\,x\,\tilde{R}$. Same shape as quaternions (which are exactly the even
  subalgebra $C\ell_{3,0}^+$), generalized to any grade/dimension.

## The rigor standard

- **State and verify the properties you rely on.** If a step assumes associativity, confirm
  the algebra has it (octonions don't). If it assumes division, confirm dimension $\in
  \{1,2,4,8\}$ and the structure is a division algebra.
- **Rotations are validated numerically**, not asserted: check $|q|=1$, that $q\mathbf p
  q^{-1}$ preserves norm ($|\mathbf p'|=|\mathbf p|$), and that composing then decomposing
  recovers the input. Cross-check one case against the equivalent rotation matrix (this is
  where the `dimensional-analysis`/`cas` verification habit applies).
- **Respect the half-angle and the non-commutativity** — the two classic quaternion bugs.

## Checkable output

```
PROBLEM        3D rigid-body orientation tracking from IMU
CHOICE         unit quaternions ℍ   (dim 4; division ✓ via Frobenius; SLERP + no gimbal lock)
REJECTED       Euler angles (gimbal lock);  3-triplet (no normed division algebra — Hurwitz)
VERIFY         |q|=1 ✓   |q p q⁻¹| = |p| ✓   compose q₂q₁ vs. R₂R₁ agree to 1e-12 ✓
```

Ship only when the algebra choice names the property that forced it (a theorem, not a
preference) and the construction is numerically verified. Ties into the estate's knowledge
graph: see the `knowledge-base` vault's `memory/wiki/mathematics/` notes on hypercomplex
numbers for the underlying theory.
