---
type: index
tags: [os, skills, pack, physics]
---
# physics pack — skills

Each skill is an *executable discipline*: a method + a standard of rigor + a checkable
artifact. The first five are the **method spine** — the cross-cutting reasoning a physicist
applies in every branch; the next six are **branch disciplines** that invoke the spine within
an area of physics (coverage anchored on the MIT OCW Course 8 curriculum); the last five are
the **advanced / high-energy tier** (coverage anchored on the PDG *Review of Particle Physics*
and the CERN Yellow Reports / Accelerator School). The pack reuses the `advanced-math` pack's
`dimensional-analysis` (units, Buckingham π, uncertainty) rather than duplicating it.

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
| [[skills/quantum-field-theory/SKILL\|quantum-field-theory]] | Fields, diagrams, renormalization, gauge | amplitude & renormalization ledger |
| [[skills/particle-physics-and-the-standard-model/SKILL\|particle-physics-and-the-standard-model]] | Quantum numbers, selection rules, SM | process ledger (allowed? + data check) |
| [[skills/relativistic-kinematics-and-collisions/SKILL\|relativistic-kinematics-and-collisions]] | Four-momenta, Mandelstam, thresholds | kinematics ledger (invariants) |
| [[skills/accelerator-physics/SKILL\|accelerator-physics]] | Beam optics, emittance, luminosity | beam-parameter ledger |
| [[skills/cosmology-and-astroparticle-physics/SKILL\|cosmology-and-astroparticle-physics]] | FLRW, Friedmann, thermal history | cosmology ledger (Friedmann + Ω) |

Config knobs in `pack.yaml`; profiles in `profiles/` (pure / applied). See `README.md`.
