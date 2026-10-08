---
name: dimensional-analysis
description: "Use whenever a physical or engineering result carries units or a numeric answer needs sanity-checking — deriving a formula, estimating a quantity, propagating uncertainty, or reviewing someone's number. Enforces dimensional homogeneity, Buckingham π, Fermi/order-of-magnitude cross-checks, limiting-case tests, and units+uncertainty+sig-figs on every answer. The quantitative rigor layer: no equation ships without a units check."
---

# Dimensional Analysis & Quantitative Rigor

The cheapest error-detector in science: most wrong formulas are wrong *dimensionally*, and
most wrong numbers fail an order-of-magnitude glance. This skill makes those checks
non-optional.

## Method

1. **Dimensional homogeneity.** Every additive term in an equation must share the same
   dimensions; both sides must match. Track base dimensions (M, L, T, Θ, I, N, J) through
   every step. A term that doesn't balance is a bug, full stop.
2. **Buckingham π theorem.** With $n$ variables in $k$ independent dimensions, the physics
   reduces to $n-k$ dimensionless groups. Form the $\pi$ groups first — they constrain the
   answer's *form* before any solving, and expose missing variables.
3. **Fermi / order-of-magnitude estimation.** Bound the answer independently by
   decomposing into factors you can estimate to within $10^{\pm1}$ and multiplying. The
   estimate and the derived number must agree in magnitude; if not, one of them is wrong.
4. **Limiting & asymptotic checks.** Push parameters to $0$, $\infty$, and equality: does
   the formula reduce to a known/trivial case ($v\to 0$ recovers the classical limit,
   $R\to\infty$ kills a curvature term)? Check symmetry (swapping identical bodies must
   leave the result invariant).
5. **Uncertainty propagation.** For $f(x_i)$ with independent errors, add in quadrature:
   $$\sigma_f = \sqrt{\textstyle\sum_i \left(\frac{\partial f}{\partial x_i}\right)^2 \sigma_{x_i}^2}.$$
   For products/quotients, **relative** errors add in quadrature. Correlated inputs need
   the covariance terms — don't assume independence.
6. **Significant figures.** The result carries no more precision than its least-precise
   input. Round only at the end; report to `config.sig_figs` (default 3).

## The rigor standard

- **No equation ships without a units check** (step 1) — stated, not implied.
- **Every numeric answer carries three things:** a **unit**, an **uncertainty**, and the
  correct **sig-figs**. A bare number is incomplete.
- **Every result survives two independent checks:** one limiting-case (step 4) and one
  order-of-magnitude (step 3). One check can be a coincidence; two rarely are.
- **The chosen unit system is explicit** (SI unless stated); conversions are shown.

## Checkable output

```
QUANTITY        VALUE ± σ (units, sig-figs)     CHECKS
drag force F    12.3 ± 0.8 N (3 s.f.)           [dim] MLT⁻² ✓  [π] Re-scaling ✓
                                                [limit] v→0 ⇒ F→0 ✓  [Fermi] ~10 N ✓
UNCERTAINTY BUDGET
  ρ  ±2%   v ±3% (dominant)   Cd ±5%   A ±1%   →  σ_F/F ≈ 6%
```

Ship only when the units balance, both cross-checks pass, and the uncertainty budget names
the dominant term. Under the `applied` profile this block is mandatory; under `pure` it
supports the argument produced by `mathematical-rigor`.

## Anti-patterns (reject in review)

- A transcendental function of a dimensioned quantity ($\sin(x)$, $e^{x}$, $\ln x$ with $x$
  carrying units) — the argument must be dimensionless.
- Reporting 8 digits from 2-digit inputs (false precision).
- Adding independent errors linearly instead of in quadrature (over-estimates), or ignoring
  a dominant/correlated term (under-estimates).
- "It's about right" with no order-of-magnitude anchor.
