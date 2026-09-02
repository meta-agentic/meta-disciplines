---
type: index
tags: [os, skills, pack, advanced-math]
---
# advanced-math pack — skills

Each skill is an *executable discipline*: a method + a standard of rigor + a checkable
artifact. The first three are the rigor spine; the next nine are domain disciplines that invoke
the spine (define/prove/cite, then sanity-check) within a branch of mathematics. After them:
the empirical-statistics wing (designing, analyzing, and decomposing real studies), the
validation discipline for data-driven claims, and the graph-drawing discipline for layout —
each closing on its own ledger.

| Skill | Discipline | Checkable output |
|-------|------------|------------------|
| [[skills/mathematical-rigor/SKILL\|mathematical-rigor]] | Proof & definitional discipline | a line-checkable proof + claims ledger |
| [[skills/dimensional-analysis/SKILL\|dimensional-analysis]] | Quantitative rigor / sanity-checking | units-balanced derivation + uncertainty budget |
| [[skills/hypercomplex-and-geometric-algebra/SKILL\|hypercomplex-and-geometric-algebra]] | Algebra selection & modeling | justified algebra choice + numeric verification |
| [[skills/calculus-and-analysis/SKILL\|calculus-and-analysis]] | Real/multivariable analysis & convergence | convergence & limit-interchange ledger |
| [[skills/linear-algebra/SKILL\|linear-algebra]] | Linear systems, factorizations, conditioning | invariant/residual + conditioning ledger |
| [[skills/probability-and-statistics/SKILL\|probability-and-statistics]] | Inference under stated assumptions | assumptions & validity ledger |
| [[skills/number-theory/SKILL\|number-theory]] | Integer claims backed by certificates | claim + certificate ledger |
| [[skills/discrete-mathematics/SKILL\|discrete-mathematics]] | Counting & finite structure (graphs) | counting-verification ledger |
| [[skills/differential-equations/SKILL\|differential-equations]] | ODE/PDE: existence, method, stability | solution-verification ledger |
| [[skills/abstract-algebra/SKILL\|abstract-algebra]] | Structure identification & axioms | structure & axiom ledger |
| [[skills/complex-analysis/SKILL\|complex-analysis]] | Holomorphic functions & residues | contour-evaluation ledger |
| [[skills/geometry-and-trigonometry/SKILL\|geometry-and-trigonometry]] | Method/frame choice & invariants | invariant-check ledger |
| [[skills/experimental-design/SKILL\|experimental-design]] | Comparative studies designed before data | design ledger (unit, strata/df, randomization receipt, sizing) |
| [[skills/statistical-inference/SKILL\|statistical-inference]] | Sample → defensible claim | inference ledger (stratum, assumptions, effect + CI, multiplicity) |
| [[skills/multivariate-analysis/SKILL\|multivariate-analysis]] | Honest low-rank / correlated structure | decomposition ledger (centering, rank, scaling, boundary scan) |
| [[skills/scientific-validation/SKILL\|scientific-validation]] | Design-to-inference validation of scientific claims | validation ledger + typed claim graph |
| [[skills/graph-drawing/SKILL\|graph-drawing]] | Graph layout: convention choice, pipelines, bounds, animation | layout ledger with measured drawing metrics |

Config knobs in `pack.yaml`; profiles in `profiles/` (pure / applied). See `README.md`.
