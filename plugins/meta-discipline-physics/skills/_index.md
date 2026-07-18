---
type: index
tags: [os, skills, pack, physics]
---
# physics pack — skills

Each skill is an *executable discipline*: a method + a standard of rigor + a checkable
artifact. The first five are the **method spine** — the cross-cutting reasoning a physicist
applies in every branch; the rest are **branch disciplines** that invoke the spine within an
area of physics. Coverage is anchored on the MIT OCW Course 8 curriculum. The pack reuses
the `advanced-math` pack's `dimensional-analysis` (units, Buckingham π, uncertainty) rather
than duplicating it.

| Skill | Discipline | Checkable output |
|-------|------------|------------------|
| [[skills/symmetry-and-conservation-laws/SKILL\|symmetry-and-conservation-laws]] | Symmetry → conserved quantities (Noether) | conserved-quantity ledger |
| [[skills/limiting-cases-and-asymptotics/SKILL\|limiting-cases-and-asymptotics]] | Check results against known limits | limit-check ledger |
| [[skills/order-of-magnitude-estimation/SKILL\|order-of-magnitude-estimation]] | Scales, natural units, Fermi estimates | estimation ledger + scale table |
| [[skills/model-building-and-approximation/SKILL\|model-building-and-approximation]] | Idealization & controlled approximation | assumptions & regime-of-validity ledger |
| [[skills/experimental-method-and-error-analysis/SKILL\|experimental-method-and-error-analysis]] | Measurement, systematic vs statistical error, fits | measurement & error ledger |
| [[skills/classical-mechanics/SKILL\|classical-mechanics]] | Newton → Lagrange → Hamilton | setup + conserved-quantity + limit ledger |
| [[skills/electromagnetism/SKILL\|electromagnetism]] | Maxwell, boundary conditions, gauge | field-solution verification ledger |
| [[skills/waves-and-oscillations/SKILL\|waves-and-oscillations]] | Oscillators, normal modes, dispersion | mode/dispersion verification ledger |
| [[skills/quantum-mechanics/SKILL\|quantum-mechanics]] | State/operator formalism, observables | normalization/Hermiticity/limit ledger |
| [[skills/statistical-mechanics-and-thermodynamics/SKILL\|statistical-mechanics-and-thermodynamics]] | Ensembles, partition functions, laws | micro↔macro consistency ledger |
| [[skills/special-and-general-relativity/SKILL\|special-and-general-relativity]] | Invariance, four-vectors, spacetime | invariant + Newtonian-limit ledger |

Config knobs in `pack.yaml`; profiles in `profiles/` (pure / applied). See `README.md`.
