# Provenance

| Skill | Origin | License |
|-------|--------|---------|
| `symmetry-and-conservation-laws` | first-party, authored for this pack | MIT |
| `limiting-cases-and-asymptotics` | first-party, authored for this pack | MIT |
| `order-of-magnitude-estimation` | first-party, authored for this pack | MIT |
| `model-building-and-approximation` | first-party, authored for this pack | MIT |
| `experimental-method-and-error-analysis` | first-party, authored for this pack | MIT |
| `classical-mechanics` | first-party, authored for this pack | MIT |
| `electromagnetism` | first-party, authored for this pack | MIT |
| `waves-and-oscillations` | first-party, authored for this pack | MIT |
| `quantum-mechanics` | first-party, authored for this pack | MIT |
| `statistical-mechanics-and-thermodynamics` | first-party, authored for this pack | MIT |
| `special-and-general-relativity` | first-party, authored for this pack | MIT |
| `quantum-field-theory` | first-party, authored for this pack | MIT |
| `particle-physics-and-the-standard-model` | first-party, authored for this pack | MIT |
| `relativistic-kinematics-and-collisions` | first-party, authored for this pack | MIT |
| `accelerator-physics` | first-party, authored for this pack | MIT |
| `cosmology-and-astroparticle-physics` | first-party, authored for this pack | MIT |

All content is original and **public-safe by construction** — no instance data (repo
names, trackers, paths, promoted knowledge). The discipline draws on standard physics
practice; no third-party code or text is vendored.

## Selection of coverage

The *breadth* of branches covered was chosen by anchoring on two authoritative reference
taxonomies, each used purely as a **map of which areas of physics to cover**:

- The **method spine + branch skills** (11) are anchored on the **MIT OpenCourseWare
  Course 8 (Physics)** curriculum (classical mechanics, electromagnetism, waves & vibrations,
  quantum mechanics, statistical mechanics & thermodynamics, relativity, and their graduate
  extensions).
- The **advanced / high-energy tier** (5: quantum field theory, particle physics & the
  Standard Model, relativistic kinematics & collisions, accelerator physics, cosmology &
  astroparticle physics) is anchored on the **PDG *Review of Particle Physics*** (its review
  structure as the field taxonomy) and the **CERN Yellow Reports / CERN Accelerator School**.
  These are named in the relevant skills as authoritative *references* (e.g. checking a
  branching ratio against the current PDG world-average) — legitimate citation of a reference
  work, not vendored content.

No OCW/PDG/CERN course text, lecture notes, figures, data tables, problem sets, or any
third-party-specific material is copied, quoted, or vendored; no specific measured data
values are hardcoded as if quoting a table. Every skill is original prose over standard,
textbook physics, and is deliberately unit-system- and CAS-agnostic (`config.units`,
`config.cas`). The method-spine skills encode cross-cutting physical reasoning (symmetry,
limits, estimation, modeling, error analysis) that the standard training canon treats as
core method.

## Dependency

This pack reuses the `meta-discipline-math` pack's `dimensional-analysis` skill (dimensional
homogeneity, Buckingham π, uncertainty propagation) rather than redefining it, and—under the
`pure` profile—its `mathematical-rigor`. See `pack.yaml` `depends:`.
