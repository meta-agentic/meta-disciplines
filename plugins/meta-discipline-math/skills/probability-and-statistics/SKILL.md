---
name: probability-and-statistics
description: "Use whenever a conclusion is drawn from data — estimating a quantity, comparing groups, fitting a model, running or reviewing a hypothesis test, or reporting a confidence/credible interval. Enforces a named probability space, explicit distributional assumptions, correct estimator and interval semantics, honest testing (H₀, power, effect size, multiplicity), and an assumptions-&-validity ledger. The inferential rigor layer: no statistic ships without its assumptions checked."
---

# Probability & Statistics

The discipline of inference whose conclusions are only as valid as their stated assumptions.
Most statistical errors are not arithmetic — the number is computed correctly on data that
violate the method's premises. This skill makes the premises explicit and checkable, turning
"the difference is significant" into an auditable claim.

## Method

1. **Name the probability space $(\Omega,\mathcal F,P)$.** Before computing anything, fix the
   sample space $\Omega$ (what outcomes are possible), the events $\mathcal F$, and the measure
   $P$. Most "paradoxes" (Bertrand, Monty Hall, base-rate) are ambiguity about *which* $P$ —
   naming it dissolves them. State how the data were generated and sampled.
2. **Declare random variables and their distributions.** For each $X:\Omega\to\mathbb R$, state
   its law and the moments you rely on: $\mathbb E[X]=\int x\,dP$, $\operatorname{Var}(X)=\mathbb
   E[X^2]-\mathbb E[X]^2$. A method assuming finite variance is void for heavy-tailed $X$ (e.g.
   Cauchy has no mean) — check the moment exists before invoking it.
3. **Separate independence, correlation, and causation.** Independence: $P(A\cap
   B)=P(A)P(B)$. Zero correlation $\rho=0$ does **not** imply independence (only no *linear*
   relation). Correlation does not imply causation — a confounder or selection can produce
   $\rho\neq 0$ with no causal link. State which you have evidence for; never upgrade one to
   another silently.
4. **Invoke a limit theorem only with its conditions met.** LLN ($\bar X_n\to\mu$) and CLT
   ($\sqrt n(\bar X_n-\mu)\xrightarrow{d}\mathcal N(0,\sigma^2)$) require **iid** draws with
   **finite variance**. For dependent, non-identical, or heavy-tailed data the normal
   approximation fails — state $n$, the iid claim, and whether $n$ is large enough for the CLT
   to justify normality here.
5. **Judge estimators by bias, consistency, efficiency.** Bias $=\mathbb E[\hat\theta]-\theta$;
   consistent if $\hat\theta_n\xrightarrow{P}\theta$; efficient if it attains the
   Cramér–Rao bound. Name the estimator, its assumed model, and which property you claim (e.g.
   the sample variance with $1/(n-1)$ is unbiased; with $1/n$ it is not).
6. **Interpret intervals honestly.** A 95% **confidence** interval means the *procedure* covers
   the true $\theta$ in 95% of repeated samples — not "95% probability $\theta$ is in this
   interval" (that is a Bayesian **credible** interval, which requires a prior). State
   coverage, method, and the interval alongside every point estimate.
7. **Test honestly.** State $H_0$ and $H_1$; state the test's distributional assumptions (e.g.
   $t$-test: iid, approximately normal or $n$ large via CLT, and for pooled variance, equal
   variances); report the **effect size** and its CI, not just $p$; report **power** $1-\beta$
   and the effect it was powered to detect. A non-significant result under low power is *no
   evidence*, not evidence of no effect.
8. **Control multiplicity; refuse p-hacking.** Testing $m$ hypotheses at $\alpha$ inflates the
   family-wise error to $\approx 1-(1-\alpha)^m$; correct it (Bonferroni $\alpha/m$, or FDR).
   Pre-register the hypothesis or flag the analysis as exploratory. Report *how many*
   comparisons were run and whether the outcome guided the test choice.

## The rigor standard

- **Every inference states its probability model and sampling scheme** — an estimate on
  unnamed $(\Omega,\mathcal F,P)$ is uninterpretable.
- **Every method's assumptions are listed and each marked checked/violated**, with *how* it was
  checked (normality via QQ-plot, independence via design, variance via Levene).
- **Every point estimate carries an uncertainty** — an interval with its correct
  frequentist-or-Bayesian reading, and units/sig-figs per [[skills/dimensional-analysis/SKILL|dimensional-analysis]].
- **Every test reports effect size, power, and comparison count**, not $p$ alone.
- **Prior-driven conclusions are flagged** — under a Bayesian frame, say what the prior
  contributes versus the likelihood.

## Checkable output

End with an **assumptions & validity ledger** the reviewer can audit — every claim traces to
the assumptions it rests on, each marked ✓/✗ with how checked:

```
CLAIM / ESTIMATE            METHOD            ASSUMPTIONS CHECKED                    VALIDITY
μ_A − μ_B = 2.4 [0.6, 4.2]  Welch t-test      iid ✓(randomized)  normal ✓(QQ, n=48)  VALID —
  (95% CI, frequentist)     two-sided         equal-var ✗→Welch used  power 0.8@d=0.5  effect d=0.41
θ̂ = 0.37 ± 0.05 (3 s.f.)   MLE, logistic     iid ✓  model-fit ✓(deviance)            VALID
comparisons run: 1 of 1 pre-registered        multiplicity: none (single primary)
ρ(x,y)=0.62                 Pearson           linearity ✓  causation ✗ (confounder z)  ASSOCIATION ONLY
```

Mandatory under **both** profiles: an unstated or violated assumption invalidates the result
regardless of `config.profile`. Under `pure`, pair it with the derivation ledger of
[[skills/mathematical-rigor/SKILL|mathematical-rigor]]; under `applied`, sanity-check every
estimate against a limiting or order-of-magnitude expectation before shipping. Compute via the
configured CAS (`config.cas`: sympy|sage|none); when `none`, show the closed form and round to
`config.sig_figs`.

## Anti-patterns (reject in review)

- Reporting a $p$-value with no effect size, no CI, and no statement of power.
- "95% probability the parameter is in $[a,b]$" for a frequentist CI (that is a credible
  interval and needs a prior).
- Invoking the CLT/LLN on non-iid, dependent, or infinite-variance data.
- Reading correlation (or a fitted coefficient) as causation with no design or confounder control.
- Running many tests and reporting only the significant one, or choosing the test after seeing
  the data, with no multiplicity correction or exploratory flag.
- "Not significant, therefore no effect" from an underpowered study.
