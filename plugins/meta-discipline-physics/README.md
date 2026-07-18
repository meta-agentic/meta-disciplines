# meta-discipline-physics

A first-party [meta-os](https://github.com/meta-aos/meta-os) **skill pack** codifying the
**physics discipline** — not a pile of physics facts, but a *method + a standard of rigor*
that turns an agent into a competent physical reasoner (per `meta-os/systems/pack-strategy.md`,
the *Quantitative rigor* wedge). Companion to the [`advanced-math`](https://github.com/meta-aos/meta-discipline-math)
pack, whose `dimensional-analysis` it reuses.

> A pack = a codified discipline: a repeatable **method** + a **standard of rigor** +
> **portability** across estates.

Coverage is anchored on the **MIT OpenCourseWare Course 8 (Physics)** curriculum — used
purely as a *map of which areas of physics to cover*. No OCW or third-party course text,
figures, or problem sets are copied or vendored; every skill is original prose over standard
physics.

## Skills

Five **method-spine** skills (cross-cutting physical reasoning) + six **branch** skills
(coverage anchored on MIT OCW Course 8) + five **advanced / high-energy** skills (coverage
anchored on the PDG *Review of Particle Physics* and the CERN Yellow Reports / Accelerator
School).

| Skill | Discipline it codifies | Checkable output |
|-------|------------------------|------------------|
| [`symmetry-and-conservation-laws`](skills/symmetry-and-conservation-laws/SKILL.md) | Identify the symmetry, get the conserved quantity (Noether), use it to shortcut and verify. | A conserved-quantity ledger tying each symmetry to its invariant and cross-check. |
| [`limiting-cases-and-asymptotics`](skills/limiting-cases-and-asymptotics/SKILL.md) | Every result must recover the known limit — non-relativistic, classical, weak-field, thermodynamic. | A limit-check ledger: each limit taken and the known result it reproduces. |
| [`order-of-magnitude-estimation`](skills/order-of-magnitude-estimation/SKILL.md) | Characteristic scales, natural units, nondimensionalization, Fermi estimates. | An estimation ledger + a table of characteristic scales/dimensionless numbers. |
| [`model-building-and-approximation`](skills/model-building-and-approximation/SKILL.md) | Idealize deliberately; control the approximation; state the regime where the model breaks. | An assumptions & regime-of-validity ledger with the neglected terms named. |
| [`experimental-method-and-error-analysis`](skills/experimental-method-and-error-analysis/SKILL.md) | Measurement model, statistical vs systematic error, propagation, fitting, theory–data agreement. | A measurement & error ledger with statistical/systematic split and a fit's goodness. |
| [`classical-mechanics`](skills/classical-mechanics/SKILL.md) | Newton → Lagrange → Hamilton; pick the formalism; constraints, generalized coordinates, conserved quantities. | A setup + conserved-quantity + limit ledger; equations of motion verified. |
| [`electromagnetism`](skills/electromagnetism/SKILL.md) | Maxwell's equations, boundary/gauge conditions, symmetry & multipole methods. | A field-solution verification ledger (Maxwell satisfied, BCs, limits, units). |
| [`waves-and-oscillations`](skills/waves-and-oscillations/SKILL.md) | Oscillators, normal modes, superposition, dispersion, resonance, Fourier decomposition. | A mode/dispersion verification ledger with energy and limit checks. |
| [`quantum-mechanics`](skills/quantum-mechanics/SKILL.md) | State/operator formalism, observables & eigenvalues, symmetry, correspondence principle. | A normalization/Hermiticity/classical-limit ledger. |
| [`statistical-mechanics-and-thermodynamics`](skills/statistical-mechanics-and-thermodynamics/SKILL.md) | Ensembles, partition functions, the thermodynamic laws, micro↔macro. | A micro↔macro consistency ledger with limit and extensivity checks. |
| [`special-and-general-relativity`](skills/special-and-general-relativity/SKILL.md) | Invariance, four-vectors, Lorentz transforms, intervals, the equivalence principle, tensors. | An invariant + Newtonian/c→∞-limit ledger. |

**Advanced / high-energy tier** (anchored on the PDG *Review of Particle Physics* and CERN Yellow Reports):

| Skill | Discipline it codifies | Checkable output |
|-------|------------------------|------------------|
| [`quantum-field-theory`](skills/quantum-field-theory/SKILL.md) | Lagrangian densities, path integral, Feynman diagrams, renormalization & running couplings, gauge/Ward identities. | An amplitude & renormalization ledger (dimensions, symmetry factors, Ward/gauge, divergence). |
| [`particle-physics-and-the-standard-model`](skills/particle-physics-and-the-standard-model/SKILL.md) | SM gauge group & quantum numbers, conservation/selection rules, decay rates & branching ratios. | A process ledger (quantum-number balance, allowed?/force, rate, PDG cross-check). |
| [`relativistic-kinematics-and-collisions`](skills/relativistic-kinematics-and-collisions/SKILL.md) | Four-momentum conservation, invariant mass, Mandelstam s/t/u, thresholds, phase space. | A kinematics ledger (invariants, s+t+u=Σm², threshold, units). |
| [`accelerator-physics`](skills/accelerator-physics/SKILL.md) | Beam optics, Twiss/emittance & Liouville, tune, RF/synchrotron, luminosity, synchrotron radiation. | A beam-parameter ledger (emittance invariance, γβ−α²=1, tune, units). |
| [`cosmology-and-astroparticle-physics`](skills/cosmology-and-astroparticle-physics/SKILL.md) | FLRW & Friedmann equations, density parameters, thermal history, BBN, CMB, dark matter/energy. | A cosmology ledger (Friedmann/scaling, ΣΩ=1, era limits, data check). |

## The three-part test (why this is a pack)

1. **Recognizable** — a working physicist would call it "how we actually work" (find the
   symmetry, check the limit, estimate the scale, build the model, verify against data).
2. **Portable** — parameterized by `pack.yaml` config (units, notation, CAS, sig-figs,
   profile); welded to no single estate.
3. **Checkable** — every skill produces an output verifiable against the discipline's own
   standard (a conserved quantity is conserved; a limit recovers the known case; units balance).

## Configure

Set the pack's knobs in the instance's `.packs.yaml` `config:` block (see
`config.example.yaml`). Also add the `advanced-math` pack — physics reuses its
`dimensional-analysis`. Skills read config-first and fall back to documented defaults.

```yaml
packs:
  advanced-math: {}
  physics:
    config:
      profile: applied      # pure | applied
      units: SI             # SI | gaussian | natural
      notation: latex       # latex | unicode | ascii
      cas: sympy            # sympy | sage | none
      sig_figs: 3
```

Profiles (`profiles/*.md`) are named rigor bundles: **pure** (first-principles/derivation)
vs **applied** (computation + sanity-checking emphasis).

## Install

```bash
# in a meta-os instance (e.g. mova-os)
scripts/packs.sh add advanced-math https://github.com/meta-aos/meta-discipline-math
scripts/packs.sh add physics       https://github.com/meta-aos/meta-discipline-physics
scripts/packs.sh config physics    # resolve/validate config
```

## Provenance & license

First-party (mova77). MIT — see `LICENSE` and `PROVENANCE.md`. Public-safe by construction:
no instance data. Coverage anchored on the MIT OCW Course 8 taxonomy as a breadth map only;
no third-party content vendored.

## Registry entry (add to `meta-os/systems/packs.yaml`)

```yaml
  physics:
    repo: https://github.com/meta-aos/meta-discipline-physics
    ref: main
    description: "Physics discipline (16 skills): a method spine (symmetry & conservation, limiting cases, order-of-magnitude, model-building, experimental error), branch disciplines (classical mechanics, electromagnetism, waves & oscillations, quantum mechanics, statistical mechanics & thermodynamics, relativity), and an advanced high-energy tier (quantum field theory, particle physics & the Standard Model, relativistic kinematics & collisions, accelerator physics, cosmology & astroparticle). First-party; reuses advanced-math/dimensional-analysis. Coverage anchored on MIT OCW Course 8, the PDG Review of Particle Physics, and the CERN Yellow Reports."
    provenance: first-party
    license: MIT
    depends: [advanced-math]
    status: planned   # first-party; lands when the pack repo publishes
```
