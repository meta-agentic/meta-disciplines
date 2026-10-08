---
type: index
tags: [os, skills, pack, meta-discipline-math]
---
# meta-discipline-math pack — skills

Each skill is an *executable discipline*: a method + a standard of rigor + a checkable
artifact. The first three are the rigor spine; the next nine are domain disciplines that invoke
the spine (define/prove/cite, then sanity-check) within a branch of mathematics. After them:
the empirical-statistics wing (designing, analyzing, and decomposing real studies), the
validation discipline for data-driven claims, and the graph-drawing discipline for layout —
each closing on its own ledger.

| Skill | Discipline | Checkable output |
|-------|------------|------------------|
| [mathematical-rigor](mathematical-rigor/SKILL.md) | Proof & definitional discipline | a line-checkable proof + claims ledger |
| [dimensional-analysis](dimensional-analysis/SKILL.md) | Quantitative rigor / sanity-checking | units-balanced derivation + uncertainty budget |
| [hypercomplex-and-geometric-algebra](hypercomplex-and-geometric-algebra/SKILL.md) | Algebra selection & modeling | justified algebra choice + numeric verification |
| [calculus-and-analysis](calculus-and-analysis/SKILL.md) | Real/multivariable analysis & convergence | convergence & limit-interchange ledger |
| [linear-algebra](linear-algebra/SKILL.md) | Linear systems, factorizations, conditioning | invariant/residual + conditioning ledger |
| [probability-and-statistics](probability-and-statistics/SKILL.md) | Inference under stated assumptions | assumptions & validity ledger |
| [number-theory](number-theory/SKILL.md) | Integer claims backed by certificates | claim + certificate ledger |
| [discrete-mathematics](discrete-mathematics/SKILL.md) | Counting & finite structure (graphs) | counting-verification ledger |
| [differential-equations](differential-equations/SKILL.md) | ODE/PDE: existence, method, stability | solution-verification ledger |
| [abstract-algebra](abstract-algebra/SKILL.md) | Structure identification & axioms | structure & axiom ledger |
| [complex-analysis](complex-analysis/SKILL.md) | Holomorphic functions & residues | contour-evaluation ledger |
| [geometry-and-trigonometry](geometry-and-trigonometry/SKILL.md) | Method/frame choice & invariants | invariant-check ledger |
| [experimental-design](experimental-design/SKILL.md) | Comparative studies designed before data | design ledger (unit, strata/df, randomization receipt, sizing) |
| [statistical-inference](statistical-inference/SKILL.md) | Sample → defensible claim | inference ledger (stratum, assumptions, effect + CI, multiplicity) |
| [multivariate-analysis](multivariate-analysis/SKILL.md) | Honest low-rank / correlated structure | decomposition ledger (centering, rank, scaling, boundary scan) |
| [scientific-validation](scientific-validation/SKILL.md) | Design-to-inference validation of scientific claims | validation ledger + typed claim graph |
| [graph-drawing](graph-drawing/SKILL.md) | Graph layout: convention choice, pipelines, bounds, animation | layout ledger with measured drawing metrics |

Config knobs in `pack.yaml`; profiles in `profiles/` (pure / applied). See `README.md`.

To find which skill covers an engineering or physics topic — or, where none does, which authoritative source to fetch from — see [the curriculum routing map](../reference/curriculum-routing-map.md).
