---
type: index
tags: [os, skills, pack, meta-discipline-physics]
---
# meta-discipline-physics pack — skills

Each skill is an *executable discipline*: a method + a standard of rigor + a checkable
artifact. The first five are the **method spine** — the cross-cutting reasoning a physicist
applies in every branch; the next six are **branch disciplines** that invoke the spine within
an area of physics (coverage anchored on the MIT OCW Course 8 curriculum); the last five are
the **advanced / high-energy tier** (coverage anchored on the PDG *Review of Particle Physics*
and the CERN Yellow Reports / Accelerator School). The pack reuses the `meta-discipline-math` pack's
`dimensional-analysis` (units, Buckingham π, uncertainty) rather than duplicating it.

| Skill | Discipline | Checkable output |
|-------|------------|------------------|
| [symmetry-and-conservation-laws](symmetry-and-conservation-laws/SKILL.md) | Symmetry → conserved quantities (Noether) | conserved-quantity ledger |
| [limiting-cases-and-asymptotics](limiting-cases-and-asymptotics/SKILL.md) | Check results against known limits | limit-check ledger |
| [order-of-magnitude-estimation](order-of-magnitude-estimation/SKILL.md) | Scales, natural units, Fermi estimates | estimation ledger + scale table |
| [model-building-and-approximation](model-building-and-approximation/SKILL.md) | Idealization & controlled approximation | assumptions & regime-of-validity ledger |
| [experimental-method-and-error-analysis](experimental-method-and-error-analysis/SKILL.md) | Measurement, systematic vs statistical error, fits | measurement & error ledger |
| [classical-mechanics](classical-mechanics/SKILL.md) | Newton → Lagrange → Hamilton | setup + conserved-quantity + limit ledger |
| [electromagnetism](electromagnetism/SKILL.md) | Maxwell, boundary conditions, gauge | field-solution verification ledger |
| [waves-and-oscillations](waves-and-oscillations/SKILL.md) | Oscillators, normal modes, dispersion | mode/dispersion verification ledger |
| [quantum-mechanics](quantum-mechanics/SKILL.md) | State/operator formalism, observables | normalization/Hermiticity/limit ledger |
| [statistical-mechanics-and-thermodynamics](statistical-mechanics-and-thermodynamics/SKILL.md) | Ensembles, partition functions, laws | micro↔macro consistency ledger |
| [special-and-general-relativity](special-and-general-relativity/SKILL.md) | Invariance, four-vectors, spacetime | invariant + Newtonian-limit ledger |
| [quantum-field-theory](quantum-field-theory/SKILL.md) | Fields, diagrams, renormalization, gauge | amplitude & renormalization ledger |
| [particle-physics-and-the-standard-model](particle-physics-and-the-standard-model/SKILL.md) | Quantum numbers, selection rules, SM | process ledger (allowed? + data check) |
| [relativistic-kinematics-and-collisions](relativistic-kinematics-and-collisions/SKILL.md) | Four-momenta, Mandelstam, thresholds | kinematics ledger (invariants) |
| [accelerator-physics](accelerator-physics/SKILL.md) | Beam optics, emittance, luminosity | beam-parameter ledger |
| [cosmology-and-astroparticle-physics](cosmology-and-astroparticle-physics/SKILL.md) | FLRW, Friedmann, thermal history | cosmology ledger (Friedmann + Ω) |

Config knobs in `pack.yaml`; profiles in `profiles/` (pure / applied). See `README.md`.
