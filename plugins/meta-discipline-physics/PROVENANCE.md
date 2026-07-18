# Provenance

| Skill | Origin | License |
|-------|--------|---------|
| `symmetry-and-conservation-laws` | first-party (mova77), authored for this pack | MIT |
| `limiting-cases-and-asymptotics` | first-party (mova77), authored for this pack | MIT |
| `order-of-magnitude-estimation` | first-party (mova77), authored for this pack | MIT |
| `model-building-and-approximation` | first-party (mova77), authored for this pack | MIT |
| `experimental-method-and-error-analysis` | first-party (mova77), authored for this pack | MIT |
| `classical-mechanics` | first-party (mova77), authored for this pack | MIT |
| `electromagnetism` | first-party (mova77), authored for this pack | MIT |
| `waves-and-oscillations` | first-party (mova77), authored for this pack | MIT |
| `quantum-mechanics` | first-party (mova77), authored for this pack | MIT |
| `statistical-mechanics-and-thermodynamics` | first-party (mova77), authored for this pack | MIT |
| `special-and-general-relativity` | first-party (mova77), authored for this pack | MIT |

All content is original and **public-safe by construction** — no instance data (repo
names, trackers, paths, promoted knowledge). The discipline draws on standard physics
practice; no third-party code or text is vendored.

## Selection of coverage

The *breadth* of branches covered was chosen by anchoring on the **MIT OpenCourseWare
Course 8 (Physics)** curriculum (classical mechanics, electromagnetism, waves & vibrations,
quantum mechanics, statistical mechanics & thermodynamics, relativity, and their graduate
extensions) — used purely as a **map of which areas of physics to cover**. No OCW course
text, lecture notes, figures, problem sets, or any MIT- or third-party-specific material is
copied, quoted, or vendored. Every skill is original prose over standard, textbook physics,
and is deliberately unit-system- and CAS-agnostic (`config.units`, `config.cas`). The
method-spine skills encode cross-cutting physical reasoning (symmetry, limits, estimation,
modeling, error analysis) that the standard training canon treats as core method.

## Dependency

This pack reuses the `advanced-math` pack's `dimensional-analysis` skill (dimensional
homogeneity, Buckingham π, uncertainty propagation) rather than redefining it, and—under the
`pure` profile—its `mathematical-rigor`. See `pack.yaml` `depends:`.
