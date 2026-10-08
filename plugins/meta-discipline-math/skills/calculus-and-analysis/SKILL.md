---
name: calculus-and-analysis
description: "Use whenever a result rests on a limit, a derivative, an integral, an infinite series, or an interchange of two limit operations — deriving a Taylor expansion, testing a series, differentiating under an integral, or reviewing a passage-to-the-limit. Enforces ε–δ discipline, named convergence tests, the pointwise-vs-uniform distinction, and dominated/monotone justification for every swap. Emits a convergence & interchange ledger certifying each operation converges or is legal."
---

# Calculus & Analysis

The discipline that separates a formula that *looks* right from a limiting process that is
*licensed*. Most analysis errors are not arithmetic — they are an unjustified swap of two
limits, a series summed outside its radius, or a derivative assumed to exist. This skill
makes every passage to the limit a checkable act, not a reflex.

## Method

1. **Pin limits and continuity with ε–δ.** $\lim_{x\to a}f(x)=L$ means
   $\forall\varepsilon>0\,\exists\delta>0:\ 0<|x-a|<\delta\Rightarrow|f(x)-L|<\varepsilon$;
   continuity at $a$ additionally requires $L=f(a)$. Name the mode: pointwise, uniform, or
   (for integrals) in $L^1$. Distinguish continuity from *uniform* continuity — the $\delta$
   must not depend on $x$ — before invoking either.
2. **Differentiate with existence conditions stated.** Differentiability implies continuity,
   not conversely. Deploy the mean value theorem ($\exists c\in(a,b):\ f'(c)=\frac{f(b)-f(a)}{b-a}$,
   requires continuity on $[a,b]$ and differentiability on $(a,b)$) and Taylor with explicit
   remainder: $f(x)=\sum_{k=0}^{n}\frac{f^{(k)}(a)}{k!}(x-a)^k+R_n$, with
   $R_n=\frac{f^{(n+1)}(\xi)}{(n+1)!}(x-a)^{n+1}$ (Lagrange). A truncated series without a
   bounded remainder is an approximation of unknown quality.
3. **Choose the integral for the job.** Riemann integration suffices for a bounded function
   with a measure-zero discontinuity set on a compact interval; reach for Lebesgue when
   integrating limits of functions, handling unbounded/oscillatory integrands, or needing the
   convergence theorems of step 6. State which, and why it applies here.
4. **Test series with a named test, absolute vs. conditional.** Comparison, ratio
   ($\lim|a_{n+1}/a_n|=L$: $L<1$ converges, $L>1$ diverges, $L=1$ inconclusive), root
   ($\limsup|a_n|^{1/n}$), integral (for positive decreasing $a_n=f(n)$), and alternating
   (Leibniz: terms $\downarrow 0$). Absolute convergence ($\sum|a_n|<\infty$) permits
   rearrangement; conditional does not (Riemann rearrangement theorem — the sum can be made
   anything).
5. **Bound power/Taylor series by radius of convergence.** $R=1/\limsup|a_n|^{1/n}$; the
   series converges absolutely for $|x-a|<R$, diverges for $>R$, and the endpoints need
   separate tests. Never evaluate or differentiate a series termwise outside $R$.
6. **License every interchange — this is the heart.** $\lim$ and $\int$, $\lim$ and $\frac{d}{dx}$,
   or $\sum$ and $\int$ may be swapped only under a stated theorem:
   **uniform convergence** ($f_n\to f$ uniformly $\Rightarrow \int\lim=\lim\int$ on a compact
   set; termwise differentiation needs $f_n'$ uniformly convergent);
   **dominated convergence** ($|f_n|\le g$, $\int g<\infty\Rightarrow\int\lim=\lim\int$);
   **monotone convergence** ($0\le f_n\uparrow f\Rightarrow\int f_n\uparrow\int f$). Name the
   dominating function $g$ or exhibit the uniform bound. No named justification, no swap.
7. **For multivariable objects, verify before you use.** Existence of partials does not imply
   differentiability; a sufficient condition is *continuous* partials ($C^1$). The gradient
   $\nabla f$, Jacobian $J$, and Hessian $H$ presuppose the relevant derivatives exist and
   (for the second-order Taylor form and symmetry of $H$ via Clairaut) are continuous. State
   the smoothness class before writing $f(\mathbf{x})\approx f(\mathbf{a})+\nabla f\cdot(\mathbf{x}-\mathbf{a})+\tfrac12(\mathbf{x}-\mathbf{a})^\top H(\mathbf{x}-\mathbf{a})$.

## The rigor standard

- **Every limit declares its mode** (pointwise / uniform / $L^1$); a bare "converges" is
  incomplete.
- **Every interchange of limit operations cites a theorem with its hypothesis discharged** —
  the dominating function or uniform bound is exhibited, not asserted.
- **Every series verdict names the test** that produced it, and states absolute vs.
  conditional.
- **Every derivative/integral used has its existence condition on the record** (differentiability,
  $C^1$, integrability), not assumed.
- Under `config.profile: pure` the convergence & interchange ledger below is **mandatory** and
  its proofs meet [[skills/mathematical-rigor/SKILL|mathematical-rigor]]; under `applied` it
  backs each numeric limit or truncation, with error bounds to `config.sig_figs`. Symbolic
  radius/remainder work may be delegated to the configured CAS (`config.cas`: sympy | sage | none);
  when `none`, derive by hand and show the bound.

## Checkable output

End with a **convergence & interchange ledger** the reviewer can audit — one row per
limit/series/integral operation:

```
STATEMENT                                  TEST / JUSTIFICATION                      VERDICT
∑ 1/n²  (n≥1)                              integral test: ∫₁^∞ x⁻² dx = 1 < ∞        converges (abs)
∑ (−1)ⁿ/n                                  Leibniz: 1/n ↓ 0                          converges (cond.)
∑ (−1)ⁿ/n  rearranged                      conditional ⇒ Riemann rearrangement       verdict not preserved
lim_{n} ∫₀¹ n·x^n dx  vs ∫ lim             no uniform bound; f_n(1)=n ↛              interchange INVALID
∫₀^∞ lim_n  x/(1+x²)·e^{−x/n} → x/(1+x²)   dominated: g=x/(1+x²)∈L¹? no → refine g   interchange pending g
∫ lim_n  sin(x/n)/(1+x²) = lim ∫           DCT, g(x)=1/(1+x²), ∫g=π/2<∞              interchange VALID
Taylor eˣ at 0, |x|≤1, n=4                 R₄=e^ξx⁵/120, |R₄|≤e/120≈0.0227           converges; err ≤ 2.27e−2
power series ∑ xⁿ/n                         R=1/limsup(1/n)^{1/n}=1; x=−1 conv, x=1 div   |x|<1 abs, x=−1 cond
```

Ship only when the ledger has **no operation whose mode is undeclared and no swap without a
discharged hypothesis**. A row marked INVALID or pending blocks the result until resolved or
re-derived.

## Anti-patterns (reject in review)

- **Interchanging $\lim$ and $\int$ (or $\sum$ and $\int$) with no dominating function or
  uniform bound named** — the single most common analysis error; $\int_0^1 n x^n\,dx\to1$ while
  $\int_0^1\lim=0$.
- Termwise differentiation or integration of a series outside its radius, or at an untested
  endpoint.
- Reading off convergence from the ratio/root test when $L=1$ (inconclusive) as if decided.
- Rearranging a conditionally convergent series and trusting the sum.
- Assuming partials existing $\Rightarrow$ differentiable, or symmetric Hessian without
  continuous second partials (Clairaut's hypothesis).
- Applying the mean value theorem or Taylor's remainder across a point of non-differentiability,
  or an improper/oscillatory integral treated as ordinary Riemann. For results feeding a
  [[skills/differential-equations/SKILL|differential-equations]] existence argument or a
  [[skills/complex-analysis/SKILL|complex-analysis]] contour/series manipulation, the same
  interchange license is required there — do not launder it across the boundary.
