---
name: linear-algebra
description: "Use when solving, decomposing, or trusting a linear-algebraic result — linear systems, least squares, eigenproblems, or any matrix computation where a plausible-looking answer may be numerically worthless. Enforces basis/rank–nullity accounting, deliberate factorization choice, invariant cross-checks (rank, det, trace, spectrum), residual verification, and honest conditioning reporting. The standard that turns a returned vector into a trusted result."
---

# Linear Algebra

The discipline of solving linear systems *and knowing whether to believe the answer*. A
returned $x$ is not a result — a residual $\|Ax-b\|$ that is small and a condition number
that bounds the error make it one. Competence here is choosing the right factorization and
refusing to trust output whose conditioning it never reported.

## Method

1. **Fix the spaces first.** For $A\in\mathbb{R}^{m\times n}$, pin domain $\mathbb{R}^n$
   and codomain $\mathbb{R}^m$, and account dimensions via rank–nullity:
   $\operatorname{rank}(A)+\dim\ker(A)=n$. Existence lives in $\operatorname{col}(A)$,
   uniqueness in $\ker(A)$.
2. **Name the four fundamental subspaces.** $\operatorname{col}(A)\perp\ker(A^\top)$ and
   $\operatorname{row}(A)\perp\ker(A)$. A system $Ax=b$ is solvable iff $b\perp\ker(A^\top)$.
3. **Choose a factorization deliberately**, and name it: $LU$ with partial pivoting (general
   square solve), $QR$ (least squares, rank checks), Cholesky $A=LL^\top$ (SPD, twice as
   fast), eigen/spectral $A=Q\Lambda Q^\top$ (symmetric), Jordan (defective, exact only),
   and SVD $A=U\Sigma V^\top$ as the universal tool (rank, pseudoinverse, conditioning).
4. **Solve least squares by $QR$ or SVD, never the normal equations.** $A^\top Ax=A^\top b$
   squares the condition number, $\kappa(A^\top A)=\kappa(A)^2$; minimize $\|Ax-b\|_2$ via
   the thin $QR$ instead. Never form $A^{-1}$ to solve $Ax=b$.
5. **Cross-check with invariants.** After an eigendecomposition verify
   $\operatorname{tr}(A)=\sum_i\lambda_i$ and $\det(A)=\prod_i\lambda_i$; rank must equal
   the count of nonzero singular values. Disagreement means the computation is wrong.
6. **Report conditioning, and read it correctly.** $\kappa(A)=\|A\|\,\|A^{-1}\|=\sigma_{\max}/\sigma_{\min}$
   predicts $\approx\log_{10}\kappa$ lost significant digits. A near-zero $\det$ does **not**
   mean ill-conditioned (scale $0.1\,I$: $\det=10^{-n}$, $\kappa=1$); only $\sigma_{\min}/\sigma_{\max}$ does.
7. **Verify by residual.** Trust $x$ when the relative residual $\|Ax-b\|/(\|A\|\|x\|)$ is at
   the level of $\kappa(A)\cdot\varepsilon_{\text{machine}}$ (backward error), not merely when
   $\|Ax-b\|$ looks small; forward error $\|x-x^\ast\|/\|x^\ast\|\lesssim\kappa(A)\cdot(\text{backward})$.
8. **Route computation through the configured CAS** (`config.cas`: sympy | sage | none) for
   symbolic exactness under `pure`; under `applied`, prefer numeric factorizations and report
   values to `config.sig_figs` (default 3). With `none`, verify invariants by hand.

## The rigor standard (what "done right" means)

- **Every result carries a residual or an invariant check** — never a bare returned vector.
- **The factorization is named and justified** by the matrix's structure (SPD? symmetric? rectangular?).
- **$\kappa(A)$ is reported** and its digit-loss consequence stated; small $\det$ is never conflated with it.
- **No $A^{-1}$, no normal equations** where $LU$/$QR$/SVD serve — stability over convenience.
- **Backward and forward error are distinguished**, not merged into "the error looks small".

## Checkable output

End with a **verification ledger** the reviewer can audit: each result paired with its method,
an invariant or residual check, and its conditioning. Under `pure` the invariant column is
mandatory (proof ledger discipline; see [[skills/mathematical-rigor/SKILL|mathematical-rigor]]);
under `applied` the residual and $\kappa$ columns are mandatory.

```
RESULT                         METHOD          INVARIANT / RESIDUAL         CONDITIONING
x solving Ax=b                 QR (thin)       ‖Ax-b‖/‖b‖ ≈ 2e-15           κ(A)≈40  (~2 digits lost)
A=QΛQᵀ, spectrum {λ_i}         symmetric eig   tr A=Σλ=7.00 ; det A=Πλ=12.0 κ=λ_max/λ_min≈6e2 (~3 lost)
x̂ = argmin‖Ax-b‖ (rank-def)    SVD, tol σ      r=Σσ_i>tol ; ‖Ax̂-b‖ minimal κ=σ_max/σ_min → rank drop
A=LLᵀ (SPD)                    Cholesky        L real ⇔ A≻0 confirmed        κ(A)=κ(L)²
```

A result ships only when its row has a passed check and a reported $\kappa$ — an unverified,
unconditioned row does not count as solved.

## Anti-patterns (reject these in review)

- Forming $A^{-1}$ or solving normal equations when $QR$/SVD applies — squared conditioning.
- Reading $\det\approx 0$ as "ill-conditioned", or $\det\ne 0$ as "safe" — use $\sigma_{\min}/\sigma_{\max}$.
- Reporting $x$ with no residual, or a small $\|Ax-b\|$ with no $\kappa$ to interpret it.
- Trusting eigenvalues without the $\operatorname{tr}=\sum\lambda$, $\det=\prod\lambda$ cross-check.
- Cholesky on a non-SPD matrix, or Jordan form computed numerically (it is discontinuous).
- Confusing basis dimension with rank, or ignoring [[skills/dimensional-analysis/SKILL|dimensional-analysis]] unit sanity on the assembled entries; vector-space axioms per [[skills/abstract-algebra/SKILL|abstract-algebra]].
