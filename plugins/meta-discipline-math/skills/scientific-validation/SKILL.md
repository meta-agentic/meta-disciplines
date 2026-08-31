---
name: scientific-validation
description: "Use whenever a scientific claim built on experimental or observational data must be validated or reviewed — a paper, a trial report, a dataset-plus-conclusion, a model comparison — or when validated claims must be distilled into a knowledge graph. Enforces the design-to-inference chain: reconstruct the design first (true replicates, randomization, error strata), require the model to mirror the design, check assumptions on residuals, bound the inference domain, and verify reproducibility. Emits a validation ledger plus a typed claim graph — nodes and edges carrying verdicts — portable into any knowledge-graph store."
---

# Scientific Validation

The discipline of judging a data-driven scientific claim by the whole chain that produced
it — design → data → model → inference → domain — not by its final p-value. Most invalid
results are not arithmetic errors: the statistic is computed correctly on a design it does
not fit (pseudoreplication, collapsed error strata, a model that ignores how treatments
were actually assigned). Errors made at the design stage propagate through the entire
analysis and cannot be repaired downstream. This skill generalizes the validation practice
of experimental statistics (Fisher's principles through mixed models and multi-environment
trials) into a domain-agnostic method, and turns what it validates into a **knowledge
graph**: claims, methods, assumptions, and evidence as typed nodes and edges, each edge
carrying its verdict.

Builds on [[skills/probability-and-statistics/SKILL|probability-and-statistics]] (the
inferential layer: estimator/interval/test semantics) and
[[skills/dimensional-analysis/SKILL|dimensional-analysis]] (units and sanity checks on
every reported quantity).

## Method

1. **Reconstruct the design before touching the analysis.** Identify what a good design
   exists to do: separate the treatment signal from structured background variability
   (fertility gradients, batch effects, operator drift — variability is *structured*, not
   random noise). Check Fisher's three principles: **replication** (supplies the error
   variance and the test denominator), **randomization** (makes errors independent and
   justifies the inference), **local control / blocking** (removes known variability from
   the error). A design that is undeclared or unreconstructable invalidates the work
   upstream of any analysis.

2. **Find the experimental unit and count the true replicates.** The experimental unit is
   the smallest entity to which a treatment is assigned *independently and at random*; the
   observational unit is where measurement happens. When they differ and the analysis runs
   at the wrong level, the result is **pseudoreplication**: inflated degrees of freedom,
   understated standard errors, falsely significant p-values. Sub-samples are never
   replicates — average within the unit or nest them as an error stratum. The same trap has
   a temporal form: repeated measures on the same unit are correlated, not independent.
   The power of a study is set by the number of *independent* units, not the number of
   measurements.

3. **Map every randomization level to an error stratum.** Each level at which treatments
   were (or could not be) independently randomized contributes its own error term
   (split-plot: two strata; strip-plot: three). Every test statistic must use the
   denominator from *its* stratum — a single pooled error where the design has several is
   the classic collapsed-strata error. Classify each factor **fixed** (levels chosen
   deliberately and exhaustively; interest in the level means) or **random** (levels
   sampled from a population; interest in the variance) by the test *"if I reran the
   study, would I use these exact levels again?"* — the classification determines the test
   denominators and how far conclusions generalize. Where no exact denominator exists,
   synthetic combinations with approximate degrees of freedom (Satterthwaite,
   Kenward–Roger) are required, not optional.

4. **Require the model to mirror the design.** Design and model are the same object seen
   from two sides: blocks, nesting, and error strata in the design must appear as the
   corresponding (random-effect) terms in the model. A model term with no design
   counterpart, or a design stratum with no model term, is a finding to flag. Adjusted
   (not raw) means are reported wherever the design implies adjustment (incomplete blocks,
   covariates, spatial correction). Structured residual correlation — spatial or temporal —
   is modeled explicitly (neighbor covariates, autoregressive residuals, smooth surfaces;
   covariance structures for repeated measures), chosen by information criteria; the
   design remains the first defense, and residual modeling corrects what randomization and
   blocking did not remove — it never substitutes for them.

5. **Check assumptions on residuals, graphics first.** Assumptions rank: independence
   (most important, guaranteed only by design, unverifiable after the fact), then
   normality, homoscedasticity, additivity — diagnosed on the **residuals of the model**,
   never the raw data, with plots first (residuals-vs-fitted, QQ) and formal tests only to
   document. On violation, escalate in order: transformation → variance modeling → a GLM
   whose mean-variance family matches the data (counts, proportions, times-to-event —
   checking overdispersion, excess zeros, censoring) → nonparametric methods matched to
   the *design structure* as the last resort, never the first. Censored or missing data
   are information, not gaps: model censoring; distinguish random loss from loss caused by
   the treatment (which is a result, not a hole to impute).

6. **Judge the inference honestly.** Per
   [[skills/probability-and-statistics/SKILL|probability-and-statistics]]: correct p-value
   and interval semantics, effect size with its CI alongside every p, power planned
   *before* the study against a minimum effect of practical relevance (post-hoc power on
   the observed effect is a tautology), multiplicity controlled, planned contrasts
   preferred over all-pairs dredging, and liberal sequential range tests (Duncan-style)
   confined to exploratory screening. Statistical significance ≠ practical relevance, in
   both directions; equivalence requires an equivalence test, not a non-significant p.

7. **Bound the domain of inference.** A single study estimates the effect *in those
   conditions*; generalizing requires the conditions (sites, years, batches, populations)
   treated as random samples of a stated domain. Test whether the treatment effect
   *interacts* with the conditions: scale (non-crossover) interaction weakens
   generalization, rank-reversing (crossover) interaction breaks it — then the answer is
   conditional ("which wins where"), not global. Watch for **aliasing**: a design flaw can
   make two explanations formally inseparable (effect confounded with phase, cohort with
   period), and no analysis, however sophisticated, can answer a question the design
   confounded. Aggregating across studies is inverse-variance weighting with heterogeneity
   quantified and publication bias probed — a synthesis is only as good as the studies and
   their comparability.

8. **Verify reproducibility.** A result is worth what its reproduction costs: protocol or
   pre-registration (hypotheses and analysis fixed before the data — against HARKing and
   p-hacking), raw data with metadata, the analysis as versioned code with recorded seeds
   (point-and-click chains are not reconstructable), tidy data whose structure was decided
   before collection. The operational test: a colleague, given the data and the code,
   obtains the identical numbers.

9. **Determine the knowledge graph.** Distill the validated work into typed **nodes** —
   `Claim`, `Design`, `Method`, `Assumption`, `Evidence`, `Domain` — and typed **edges**:
   `supports` / `contradicts` (Evidence→Claim), `assumes` (Method→Assumption),
   `tested-by` (Claim→Method), `derived-from` (Claim→Evidence/Design),
   `confounded-with` (aliased factors), `generalizes-to` (Claim→Domain),
   `superseded-by` (Method→Method). Every edge carries the ledger verdict of the check
   that licensed it (✓ / ✗ / unverified) — an edge without a verdict is an assertion, not
   knowledge. The graph is the portable artifact: it composes across studies (shared
   Assumption and Domain nodes are where independent works reinforce or contradict each
   other) and imports into any knowledge-graph store as a plain node/edge list.

## The rigor standard

- **No analysis is validated without its design reconstructed** — experimental unit named,
  true replicate count stated, randomization and blocking described or flagged absent.
- **Every test names its error stratum** and every factor is classified fixed/random with
  the resampling test applied; collapsed strata are an automatic ✗.
- **Every assumption is listed and marked checked/violated with how** (plot, test, or
  design guarantee), on residuals, not raw data.
- **Every claim states its domain of inference** and whether condition-interaction was
  scale-type or rank-reversing.
- **Every reported quantity carries units, uncertainty, and effect size** per
  [[skills/dimensional-analysis/SKILL|dimensional-analysis]] and
  [[skills/probability-and-statistics/SKILL|probability-and-statistics]].
- **Reproducibility is scored, not presumed** — data, code, seed, protocol each
  present/absent.
- **Every graph edge traces to a ledger row** — the graph asserts nothing the ledger did
  not check.

## Checkable output

End with a **validation ledger** followed by its **claim graph**. The ledger walks the
chain; the graph is the distilled, portable result:

```
CHAIN LINK      FINDING                                                      VERDICT
Design          RCBD, 4 blocks ⊥ gradient; exp.unit = plot (n=24 true reps)  ✓
Replication     3 sub-samples/plot averaged before analysis                  ✓ (no pseudorep)
Error strata    split-plot: irrigation tested on main-plot error             ✓
Fixed/random    variety fixed (chosen), site random (sampled) — declared     ✓
Model≡design    y ~ irr*var + (1|site/block/main)  mirrors randomization     ✓
Assumptions     resid QQ ✓ · homosced ✓(plot) · independence ✓(by design)    ✓
Inference       Δ=0.9 t/ha [0.3,1.5], d=0.6, power 0.8@Δ=0.8, Tukey-adj      ✓
Domain          site×treatment scale-type only → generalizes to region       ✓ (bounded)
Reproducibility protocol ✓ · data+code ✓ · seed ✓                            ✓
OVERALL: VALID within stated domain

NODES  c1:Claim "irrigation ↑ yield 0.9 t/ha"   m1:Method "mixed model, 3 strata"
       d1:Design "RCBD split-plot"  a1:Assumption "resid. independence"
       e1:Evidence "trial 2025, 24 plots"       dom1:Domain "region X, loam soils"
EDGES  e1 -supports(✓)→ c1      c1 -tested-by(✓)→ m1     m1 -assumes(✓ by design)→ a1
       c1 -derived-from(✓)→ d1  c1 -generalizes-to(✓ scale-interaction only)→ dom1
```

Mandatory under **both** profiles: a collapsed error stratum, pseudoreplication, or an
undeclared design invalidates the result regardless of `config.profile`. Under `pure`,
pair with the claims ledger of [[skills/mathematical-rigor/SKILL|mathematical-rigor]]
(each inferential step proved or cited); under `applied`, sanity-check every effect
against an order-of-magnitude expectation before shipping. Render math per
`config.notation`; round per `config.sig_figs`.

## Anti-patterns (reject in review)

- Validating an analysis whose design was never reconstructed — auditing the statistics
  while the treatment assignment is unknown.
- Sub-samples or repeated measures counted as replicates (spatial or temporal
  pseudoreplication); power claimed from measurement count instead of independent units.
- A multi-stratum design tested against one pooled error; a fixed/random classification
  chosen for convenience (or to make an effect significant) rather than by the resampling
  test.
- Assumption tests run on raw data instead of residuals, or a rank-based test that ignores
  the design's blocking structure applied because "the data weren't normal".
- Nonparametric or transformed analysis as the first resort, before matching a GLM family
  to the data's mean-variance relation.
- p-value-only reporting; post-hoc power; all-pairs comparisons without correction where a
  handful of planned contrasts answer the actual question; equivalence claimed from a
  non-significant difference.
- Generalizing a single-condition result to a domain, or averaging over a rank-reversing
  interaction; answering a question the design aliased.
- Censored subjects dropped as missing; treatment-caused loss imputed as if random.
- A knowledge-graph edge asserted with no ledger verdict behind it, or a claim node added
  to the graph whose validation failed (a ✗ claim enters only with its `contradicts` /
  invalidation edge, never as accepted knowledge).
