---
name: complex-analysis
description: "Use whenever a result rests on a function of a complex variable — evaluating a real or contour integral by residues, classifying a singularity, counting zeros or poles, building a Laurent series, or continuing a function analytically. Enforces analyticity as a checked hypothesis (Cauchy–Riemann with continuous partials), residue bookkeeping tied to an enclosed-pole count, and an explicit arc-vanishing bound before any contour is closed. The discipline that refuses to integrate a function it hasn't proved holomorphic."
---

# Complex Analysis

The theory of holomorphic functions is powerful precisely because its theorems have sharp
hypotheses — and it punishes anyone who assumes them. Here **analyticity is something you
check, never something you presume**, and a contour integral is only "evaluated" once the
poles enclosed are counted exactly and the closing arc is *bounded* to zero. This skill is
that bookkeeping made executable.

## Method

1. **Check holomorphy, don't assume it.** For $f=u+iv$, verify the Cauchy–Riemann equations
   $u_x=v_y,\ u_y=-v_x$ at the point. They are *necessary*; they are **sufficient only when
   $u,v$ have continuous first partials** on a neighborhood. State where $f$ fails to be
   holomorphic — those points are the whole game. Cross-check differentiability with
   [[skills/calculus-and-analysis/SKILL|calculus-and-analysis]].
2. **Name the domain before invoking Cauchy.** Cauchy's theorem $\oint_\gamma f\,dz=0$ needs
   $f$ holomorphic on and inside a closed contour in a **simply connected** region; the
   integral formula $f(a)=\frac{1}{2\pi i}\oint_\gamma\frac{f(z)}{z-a}\,dz$ needs $a$ *inside*
   $\gamma$. A hole in the domain, or a pole on the contour, voids both.
3. **Classify every singularity.** From the Laurent expansion about $z_0$: no principal part
   $\Rightarrow$ **removable**; finitely many terms down to $(z-z_0)^{-m}$ $\Rightarrow$
   **pole of order $m$**; infinitely many $\Rightarrow$ **essential** (Casorati–Weierstrass:
   the image is dense). Misclassifying $m$ corrupts the residue.
4. **Compute residues by the matching rule.** Simple pole: $\operatorname{Res}_{z_0}f=\lim_{z\to z_0}(z-z_0)f(z)$, or $\frac{p(z_0)}{q'(z_0)}$ for $f=p/q$. Order $m$:
   $\operatorname{Res}_{z_0}f=\frac{1}{(m-1)!}\lim_{z\to z_0}\frac{d^{m-1}}{dz^{m-1}}\big[(z-z_0)^m f(z)\big]$.
   For an essential singularity, read the residue off the $c_{-1}$ Laurent coefficient directly.
5. **Apply the residue theorem only with the enclosure fixed.** $\oint_\gamma f\,dz=2\pi i\sum_k \operatorname{Res}_{z_k}f$ counts **exactly** the poles interior to $\gamma$ — choose the
   upper (or lower) half-plane deliberately and list which poles that half encloses. A pole
   sitting on the real axis needs a semicircular indentation and a principal-value argument,
   not a shrug.
6. **Bound the closing arc to zero — always show it.** Closing a real integral over a
   semicircle $\Gamma_R$ is illegitimate until $\int_{\Gamma_R}f\to0$ is *proved*: either an
   explicit ML-bound $\left|\int_{\Gamma_R} f\right|\le M\cdot L$ with $M=\max_{\Gamma_R}|f|$
   and $L=\pi R$ (e.g. $M\sim R^{-2}$, $L=\pi R\Rightarrow$ bound $\sim R^{-1}\to0$), or
   **Jordan's lemma** for $f(z)e^{iaz}$, $a>0$, where the oscillatory factor rescues a merely
   $o(1)$ decay. No arc bound $\Rightarrow$ no answer.
7. **Count zeros and poles by the argument principle.** $\frac{1}{2\pi i}\oint_\gamma\frac{f'}{f}\,dz=Z-P$ (with multiplicity). **Rouché**: if $|g|<|f|$ on $\gamma$, then $f$ and $f+g$
   have the same zero count inside — the standard tool for locating roots.
8. **Continue analytically with the identity theorem as guardrail.** A holomorphic function
   agreeing with another on a set with a limit point in the domain agrees everywhere they
   overlap, so an analytic continuation is *unique*. Conformal maps (angle-preserving where
   $f'\neq0$) transport problems to tractable domains; record the map and its inverse.

## The rigor standard

- **Holomorphy is asserted only after Cauchy–Riemann + continuous partials are checked**, and
  the non-holomorphic points are listed by name.
- **Every theorem invocation names its satisfied hypothesis** — simply connected, pole-free
  contour, $a$ strictly inside — per [[skills/mathematical-rigor/SKILL|mathematical-rigor]].
- **The residue sum matches the enclosed-pole count**, and the chosen half-plane is stated.
- **The arc contribution is bounded to zero in writing** (ML or Jordan), never waved away.
- **A real integral returns a real answer** (imaginary part cancels, sign and positivity plausible) — the sanity gate shared with [[skills/dimensional-analysis/SKILL|dimensional-analysis]].

## Checkable output

Close a contour evaluation with a **contour-evaluation ledger**: each row names the integral,
the holomorphy/singularity structure, the residues, the arc-vanishing argument, and the
resulting real value — so a reviewer can audit the enclosure and the bound, not just the number.

```
INTEGRAL / CLAIM                        HOLOMORPHY & SINGULARITIES        RESIDUES              ARC-VANISHING (ML / Jordan)          REAL-AXIS VALUE
∫_{-∞}^{∞} dx/(1+x²)                     pole at z=i (order 1) in UHP      Res_i = 1/(2i)        semicircle→0 by ML, M~1/R², L=πR      = π   (real, >0 ✓)
∫_{-∞}^{∞} cos x/(x²+1) dx               use e^{iz}/(z²+1), pole z=i       Res_i = e^{-1}/(2i)   Γ_R→0 by Jordan (a=1>0)              = π/e (real, >0 ✓)
∮_{|z|=2} dz/(z²(z-1))                   poles z=0 (ord 2), z=1 enclosed   Res_0=-1, Res_1=1     closed contour — no arc needed        = 2πi·(0) = 0
# zeros of z⁴+z+1 in |z|<1               f=z⁴? no: dominant term on |z|=1  Rouché with g=z⁴      |z⁴|=1 vs |z+1|≤2 — pick f=z+1        Z = 1
```

Under the `pure` profile this ledger is **mandatory** and its enclosure/arc columns are
proof obligations discharged in the text; under `applied` it backs any real integral or
transform the derivation consumes, with values reported to `config.sig_figs`. Symbolic
residues and series may be produced or checked with the configured CAS (`config.cas`:
sympy|sage|none); with `none`, every residue and bound is derived by hand and shown.

## Anti-patterns

- Assuming $f$ is holomorphic because it "looks smooth" — Cauchy–Riemann can hold at a point
  yet fail to give differentiability without continuous partials (e.g. contrived $u,v$).
- Applying Cauchy's theorem across a domain with a hole, or the integral formula for a point
  *on* or *outside* the contour.
- Summing residues for poles the contour doesn't actually enclose, or double-counting a pole
  on the axis instead of indenting and taking a principal value.
- Closing the contour and dropping the arc "because it's far away" — with no ML or Jordan
  bound the semicircle contribution is unproven, so the answer is unproven.
- Reading a pole order off the wrong Laurent term, then propagating the wrong derivative order
  in the residue formula.
- A "real" integral that returns a stubbornly complex value — a signal that a residue sign,
  the enclosed set, or the arc argument is wrong.
