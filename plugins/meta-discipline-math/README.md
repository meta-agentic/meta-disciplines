# meta-discipline-math

A first-party [meta-os](https://github.com/meta-aos/meta-os) **skill pack** codifying the
**advanced-mathematics discipline** — not a pile of math facts, but a *method + a standard
of rigor* per branch that turns an agent into a competent mathematical practitioner (per
`meta-os/systems/pack-strategy.md`, the *Quantitative rigor* wedge).

> A pack = a codified discipline: a repeatable **method** + a **standard of rigor** +
> **portability** across estates.

## Skills

| Skill | Discipline it codifies | Checkable output |
|-------|------------------------|------------------|
| [`mathematical-rigor`](skills/mathematical-rigor/SKILL.md) | Proof & definitional discipline — definitions-first, explicit quantifiers/assumptions, proof strategy selection, counterexample hunting, a claims ledger. | A proof a reviewer can verify line-by-line + a proved/cited/conjectured ledger. |
| [`dimensional-analysis`](skills/dimensional-analysis/SKILL.md) | Quantitative rigor — dimensional homogeneity, Buckingham π, Fermi estimation, uncertainty propagation, limiting-case checks. | A units-balanced derivation + order-of-magnitude cross-check + uncertainty budget. |
| [`hypercomplex-and-geometric-algebra`](skills/hypercomplex-and-geometric-algebra/SKILL.md) | Algebra selection & modeling — pick ℝ/ℂ/ℍ/𝕆/Clifford for a problem, quaternion rotations, geometric algebra, respecting Frobenius/Hurwitz constraints. | A justified algebra choice + a construction verified numerically (e.g. rotation vs. matrix). |
| [`calculus-and-analysis`](skills/calculus-and-analysis/SKILL.md) | Real/multivariable analysis — ε–δ limits, Taylor-with-remainder, series-convergence tests, uniform vs pointwise, and the legitimacy of interchanging limit operations. | A convergence & limit-interchange ledger (each operation justified by a named test/theorem). |
| [`linear-algebra`](skills/linear-algebra/SKILL.md) | Linear systems — subspaces & rank–nullity, factorization selection (LU/QR/Cholesky/eigen/SVD), invariants, conditioning & numerical stability. | A verification ledger: invariant/residual cross-checks + reported condition number. |
| [`probability-and-statistics`](skills/probability-and-statistics/SKILL.md) | Inference — probability space, distributions/moments, LLN/CLT conditions, estimator properties, honest hypothesis testing (power, effect size, multiplicity). | An assumptions & validity ledger — every conclusion tied to the assumptions it needs. |
| [`number-theory`](skills/number-theory/SKILL.md) | Integer claims — divisibility/Bézout, modular arithmetic/CRT, probable-vs-proved primality, continued-fraction approximation. | A claim + certificate ledger (proved / cited / witnessed / conjectured). |
| [`discrete-mathematics`](skills/discrete-mathematics/SKILL.md) | Counting & finite structure — bijection/double-count/incl–excl/pigeonhole, generating functions, graph theory. | A counting-verification ledger with a small-n enumeration cross-check on every closed form. |
| [`differential-equations`](skills/differential-equations/SKILL.md) | ODE/PDE — classify-first, existence/uniqueness, exact & numerical methods, stability/qualitative analysis. | A solution-verification ledger: back-substitution + qualitative/limit checks + uniqueness verdict. |
| [`abstract-algebra`](skills/abstract-algebra/SKILL.md) | Structure identification — recognize group/ring/field/module, verify axioms, use homomorphisms/quotients & classification theorems. | A structure & axiom ledger (axioms checked → consequences unlocked). |
| [`complex-analysis`](skills/complex-analysis/SKILL.md) | Holomorphic functions — Cauchy–Riemann, contour integration, residues, argument principle, conformal maps. | A contour-evaluation ledger with explicit arc-vanishing (ML/Jordan) justification. |
| [`geometry-and-trigonometry`](skills/geometry-and-trigonometry/SKILL.md) | Method & frame choice — synthetic/analytic/vector/transformational, trig toolkit, transformation invariants. | An invariant-check ledger (result confirmed by a coordinate-independent invariant + degenerate case). |

## The three-part test (why this is a pack)

1. **Recognizable** — a working mathematician/physicist/engineer would call it "how we
   actually work" (define, prove or cite, sanity-check, choose the right structure).
2. **Portable** — parameterized by `pack.yaml` config (notation, CAS, sig-figs, profile);
   welded to no single estate.
3. **Checkable** — every skill produces an output verifiable against the discipline's own
   standard (a proof checks; units balance; a rotation composes correctly).

## Configure

Set the pack's knobs in the instance's `.packs.yaml` `config:` block (see
`config.example.yaml`). Skills read config-first and fall back to documented defaults.

```yaml
packs:
  advanced-math:
    config:
      profile: applied      # pure | applied
      notation: latex       # latex | unicode | ascii
      cas: sympy            # sympy | sage | none
      sig_figs: 3
```

Profiles (`profiles/*.md`) are named rigor bundles: **pure** (proof-first) vs **applied**
(computation + sanity-checking emphasis).

## Install

```bash
# in a meta-os instance (e.g. mova-os)
scripts/packs.sh add advanced-math https://github.com/meta-aos/meta-discipline-math
scripts/packs.sh config advanced-math      # resolve/validate config
```

## Provenance & license

First-party (mova77). MIT — see `LICENSE` and `PROVENANCE.md`. Public-safe by construction:
no instance data.

## Registry entry (add to `meta-os/systems/packs.yaml`)

This pack registers as a first-party entry, exactly like the agile pack did in meta-os
commit `6c0411c`. Add under `packs:` (the local `meta-os` checkout must be synced to
`origin/main`, which carries the packs system):

```yaml
  advanced-math:
    repo: https://github.com/meta-aos/meta-discipline-math
    ref: main
    description: "Advanced-mathematics discipline (12 skills): the rigor spine (mathematical-rigor, dimensional-analysis, hypercomplex-and-geometric-algebra) plus per-branch disciplines — calculus-and-analysis, linear-algebra, probability-and-statistics, number-theory, discrete-mathematics, differential-equations, abstract-algebra, complex-analysis, geometry-and-trigonometry. First-party — the quantitative-rigor wedge from pack-strategy."
    provenance: first-party
    license: MIT
    status: planned   # first-party; lands when the pack repo publishes
```
