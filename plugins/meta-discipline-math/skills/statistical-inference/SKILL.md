---
name: statistical-inference
description: "Use when analyzing data and defending the conclusion — ANOVA, regression, GLM, mixed models, categorical tables, time-to-event, nonparametric tests, or synthesis across studies. Enforces model-mirrors-design, distribution-matched likelihoods with dispersion gates, ranked assumption checks on residuals, the remedies hierarchy, estimation beside testing, declared multiplicity control, and ML/REML hygiene — every conclusion carried by an inference ledger. The standard that turns a p-value into a defensible claim."
---

# Statistical Inference

The discipline of moving from sample to claim without fooling yourself. A p-value is not
a conclusion: a conclusion names its model, the error stratum it was tested in, the
assumptions it checked, the size of the effect with its uncertainty, and how many other
comparisons were in the family. Competence here is refusing to report any of those
pieces alone.

## Method

1. **Write the model from the design.** The fixed part encodes the questions; the
   random part is a *transcription* of the randomization strata — each `(1|...)` term
   derivable line-by-line from the design's stratum table, each effect tested against
   its own stratum's error. Collapsing a multi-stratum design onto one residual MSE is
   the classic, consequential error. ANOVA, regression, and the t-test are one linear
   model $y = X\beta + \varepsilon$; think in models, not in named tests.
2. **Declare fixed vs random by the replication question**: "if I repeated the study,
   would I use these same levels?" Same levels → fixed (interest in the level means);
   sampled levels → random (interest in the variance; needs ~5+ levels for a stable
   estimate). The declaration determines F-denominators and how far conclusions
   generalize — decide it before analysis and write it down. Variance-component ratios
   (heritability, ICC, repeatability, reliability) are properties of design + sampled
   population, reported with the decomposition, the per-stratum n, and the estimator.
3. **Match the likelihood to the data.** Continuous responses → linear model. Counts
   and proportions → GLM, where choosing the family *is* choosing the mean-variance
   contract $V(\mu)$; compute the dispersion $\hat\varphi = \chi^2_{Pearson}/(n-p)$
   before any GLM inference, and above ~1.5 refit (quasi-likelihood with F tests, or a
   richer likelihood — negative binomial, beta-binomial — with valid AIC; never AIC on
   quasi). Judge count/binary model adequacy on simulated quantile residuals, not raw
   Pearson plots. Time-to-event → censored observations carry information and are
   modeled, never dropped or recoded; no hazard ratio without a proportional-hazards
   check, and the censoring type in the model matches the observation scheme.
4. **Check assumptions ranked, on residuals, graphics first.** Independence comes from
   the design (randomization, strata, correlation structure) and cannot be rescued by
   testing; then variance homogeneity; then normality. Residuals-vs-fitted and QQ plots
   show the kind and severity of a violation; formal tests document, they do not decide
   (large n flags trivia, small n detects nothing). Any check on raw data instead of
   residuals is void.
5. **Escalate remedies in order** — transformation (with back-transformed summaries
   labeled by estimand: geometric mean, median, ratio — never bare "means") → variance
   modelling → GLM → a *design-matched* nonparametric test last (blocks → within-block
   ranks or restricted permutation; a k-group rank test on a blocked design is wrong).
   Each rung dispositioned in writing before descending. Rank-test conclusions name
   their estimand — stochastic dominance by default, medians only with an equal-shape
   argument. Permutation tests permute only within exchangeable units defined by the
   randomization.
6. **Estimate, don't just test.** No p travels alone: report the estimate in domain
   units, its confidence interval, and a standardized effect size, judged against a
   minimum difference of practical interest fixed a priori. Significance ≠ relevance in
   both directions; equivalence is shown by TOST against a pre-specified margin, never
   by a non-significant difference. The p-value is P(data at least this extreme | H₀)
   — never the probability of the hypothesis. Test–interval duality holds: rejected at
   α ⇔ outside the (1−α) interval.
7. **Plan comparisons; declare the multiplicity criterion.** Few planned contrasts
   ($\sum c_i = 0$, stated before data; polynomial decomposition for ordered
   quantitative factors — shape, not letters) beat any blind battery. When a family is
   unavoidable, match procedure to family — all pairs → Tukey; many-to-one → Dunnett;
   post-hoc contrasts → Scheffé; generic → Holm — and state FWER or FDR and why;
   FDR discoveries are screening until confirmed. Multiple-range tests
   (Duncan, SNK) are read-only: understand them in the literature, never produce them
   for confirmatory claims. **Interaction gate**: while A×B is significant, marginal
   means of A are not compared — profile plot first, crossover verdict recorded,
   crossover ⇒ simple effects or interaction contrasts only.
8. **Model-selection hygiene.** ML compares fixed parts; REML estimates and compares
   random parts; never across that line, and the final fit is REML. Information
   criteria choose only among design-admissible candidates (every design-mandated
   stratum present). A singular or non-converging fit is a complexity signal —
   simplify the random part (correlations, then slopes — never design strata).
9. **Synthesize with the same machinery.** Combining studies is a mixed model with
   known residual variances: one shared estimand, inverse-total-variance weights, τ² by
   REML with t-based (Hartung-Knapp) intervals, heterogeneity reported three-part
   (I², τ², prediction interval), the missing-study process interrogated (funnel,
   small-study tests), and the study — not the effect size — as the independence unit.

Route computation through the configured `cas`/software and report to `config.sig_figs`;
under the `pure` profile every distributional claim is proved or cited per
[[skills/mathematical-rigor/SKILL|mathematical-rigor]], under `applied` the ledger below
is the deliverable.

## The rigor standard (what "done right" means)

- **Every effect names its denominator** — the stratum, its df, and (when synthetic)
  the approximation used.
- **Every distributional choice names its contract** — $V(\mu)$ and $\hat\varphi$ for
  GLMs, the censoring scheme for survival, the estimand for ranks.
- **Every p is accompanied** by estimate, interval, effect size, and its multiplicity
  family.
- **Every remedy is justified by the rung above it** having been tried or ruled out.
- **Every model comparison states its estimation method** (ML vs REML) and its
  candidate set.

## Checkable output

End with an **inference ledger** the reviewer can audit:

```
CLAIM                     MODEL TERM / STRATUM              ASSUMPTIONS            EFFECT + CI               MULTIPLICITY
treatment raises yield    trt on (1|block) stratum, df=15   resid QQ+spread ok     +0.62 u [0.21,1.03] d=.9  Dunnett vs control
counts differ by type     Poisson→NB (φ̂ 2.3→1.05)          quantile resid ok      rate ratio 1.8 [1.3,2.5]  Holm, m=3
A ≈ B (equivalence)       TOST, margin ±0.4 u               —                      [−0.18, 0.22]             both one-sided p<.05
pooled effect (7 studies) RE meta, REML τ², HK interval     I²=41%, PI [−0.1,0.9]  +0.4 u [0.1,0.7]          —
```

A conclusion ships only when its row is complete; an empty cell is an unproved step.

## Anti-patterns (reject these in review)

- One residual MSE across a multi-stratum design; a random factor invented or omitted
  relative to the randomization.
- A bare p — no estimate, no interval, no effect size, no family.
- "No significant difference" read as equivalence; p read as P(H₀).
- Assumption tests on raw data; formal tests overriding the plots.
- A rank test that ignores blocks; naive rank transforms for interactions.
- Range-test letters (Duncan/SNK) as the inferential content of a confirmatory table.
- GLM inference with $\hat\varphi$ unexamined; censored units dropped; HR without a PH
  check.
- REML likelihoods compared across different fixed parts; AIC on quasi-likelihoods.
- Marginal-mean comparisons reported while their interaction is significant and
  unexamined.
