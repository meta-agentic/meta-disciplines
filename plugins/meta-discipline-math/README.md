# meta-os-advanced-math-pack

A first-party [meta-os](https://github.com/mova77/meta-os) **skill pack** codifying the
**advanced-mathematics discipline** — not a pile of math facts, but a *method + a standard
of rigor* that turns an agent into a competent mathematical practitioner (per
`meta-os/systems/pack-strategy.md`, the *Quantitative rigor* wedge).

> A pack = a codified discipline: a repeatable **method** + a **standard of rigor** +
> **portability** across estates.

## Skills

| Skill | Discipline it codifies | Checkable output |
|-------|------------------------|------------------|
| [`mathematical-rigor`](skills/mathematical-rigor/SKILL.md) | Proof & definitional discipline — definitions-first, explicit quantifiers/assumptions, proof strategy selection, counterexample hunting, a claims ledger. | A proof a reviewer can verify line-by-line + a proved/cited/conjectured ledger. |
| [`dimensional-analysis`](skills/dimensional-analysis/SKILL.md) | Quantitative rigor — dimensional homogeneity, Buckingham π, Fermi estimation, uncertainty propagation, limiting-case checks. | A units-balanced derivation + order-of-magnitude cross-check + uncertainty budget. |
| [`hypercomplex-and-geometric-algebra`](skills/hypercomplex-and-geometric-algebra/SKILL.md) | Algebra selection & modeling — pick ℝ/ℂ/ℍ/𝕆/Clifford for a problem, quaternion rotations, geometric algebra, respecting Frobenius/Hurwitz constraints. | A justified algebra choice + a construction verified numerically (e.g. rotation vs. matrix). |

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
scripts/packs.sh add advanced-math https://github.com/mova77/meta-os-advanced-math-pack
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
    repo: https://github.com/mova77/meta-os-advanced-math-pack
    ref: main
    description: "Advanced-mathematics discipline: proof rigor (mathematical-rigor), quantitative sanity-checking / dimensional analysis, and hypercomplex & geometric-algebra modeling. First-party — the quantitative-rigor wedge from pack-strategy."
    provenance: first-party
    license: MIT
    status: planned   # first-party; lands when the pack repo publishes
```
