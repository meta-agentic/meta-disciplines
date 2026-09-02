---
name: multivariate-analysis
description: "Use when the object of analysis is a matrix or a correlated block — the interaction of two classifications, performance across contexts, repeated measures on the same units, spatial surfaces — anywhere structure spanning many dimensions must be decomposed, drawn, and trusted. Enforces declared centering and scaling for decompositions and biplots, out-of-sample rank selection, stability geometry with joint level-and-stability selection, latent-factor covariance for unbalanced data, and structured within-unit correlation. The standard that keeps a low-rank picture honest."
---

# Multivariate Analysis

The discipline of decomposing matrix-valued structure without over-reading it. A
two-way interaction, a treatment × context table, a set of repeated measures — these
live in matrices, and the natural machinery is the singular value decomposition, its
biplots, and its random-effects generalizations. Every one of those tools produces a
*picture that looks meaningful by construction*; competence here is the set of
declarations and checks that make the picture mean what it seems to.

## Method

1. **Pose the matrix, and let the centering define the estimand.** State what the rows
   and columns are and which centering isolates the question: double-centering leaves
   the pure interaction; centering by columns only keeps row main effects *plus*
   interaction (the relevant quantity when choosing a winner per context). The
   centering choice is not preprocessing — it decides what the axes will mean.
2. **Decompose by SVD** — the Eckart–Young-optimal low-rank approximation at every
   rank. Report the singular-value spectrum and the share of matrix SS per component
   *before* any picture is drawn.
3. **Retain rank by prediction, never by fit.** In-sample fit always improves with
   rank, and estimated singular values are ordered — naive tests on early components
   are biased liberal. Choose the retained rank by cross-validation on held-out
   replicates, or by information criteria on the latent-factor formulation. Truncation
   is a bias-variance trade: the denoised low-rank cell estimate can beat the raw cell
   mean, which is the same logic as low-rank matrix completion.
4. **Draw biplots with declared scaling.** Factorize
   $M_2 \approx (U_2\Lambda_2^{\,c})(\Lambda_2^{\,1-c}V_2^\top)$: c = 1 preserves
   row-metric distances, c = 0 makes column angles read as correlations, c = ½ is the
   symmetric compromise — distances, angles, and projections are interpretable *only
   under the matching scaling*, so the caption states it, along with the two axes'
   percentage of SS. A biplot whose plane carries little of the SS over-reads by
   construction.
5. **Use the geometry of stability.** A row's interaction profile is its row of the
   decomposed matrix; its squared norm is its total interaction (instability), and
   distance from the origin in the retained subspace is the workhorse stability index.
   Before any pooled ranking, check for rank-crossing across columns/contexts; under
   crossover, "best" is conditional on the context segment, and recommendations are
   per-segment. Selection under interaction is *joint* on level and stability with the
   trade-off weight explicit — stability alone selects stable mediocrity.
6. **When the data are unbalanced or variances heterogeneous, move the bilinear
   structure into the covariance**: model row effects across columns as random with a
   factor-analytic covariance $G = \Lambda\Lambda^\top + \Psi$ — the random-effects
   analogue of the truncated SVD (each retained axis ↔ one factor), identified up to
   rotation. It tolerates missing cells fatal to a plain SVD, allows per-column
   variances, composes with unit-level error models, and its loadings *name latent
   context gradients* without observing them. Choose the number of factors as in
   step 3.
7. **Structure within-unit correlation explicitly.** Repeated measures on one unit are
   a short correlated series: model R = cov(within unit) on the ladder compound
   symmetry (2 parameters) → AR(1)/continuous-AR(1) (2) → Toeplitz (t) →
   unstructured (t(t+1)/2), selected by information criteria among REML fits sharing
   the same mean model (REML likelihoods are only comparable at fixed mean structure).
   Sphericity corrections are the legacy patch; modeling R directly dominates them.
8. **Treat convenient structure as an assumption, not a default.** Separable
   (Kronecker) covariances need axis-aligned justification or a 2-D empirical check —
   not just marginals. And any parameter estimated at the boundary of its space
   (correlation → 0 or 1, a variance → 0) is evidence of mis-specification, not a
   finding: refit the alternative and report both.

The same machinery carries many names — interaction decomposition, biplot analysis,
matrix factorization in recommender systems, factor-analytic covariance modelling —
one decomposition; recognizing the identity is part of the discipline.

Route computation through the configured `cas`/software; report to `config.sig_figs`;
under `pure`, the optimality and identifiability claims used are proved or cited per
[[skills/mathematical-rigor/SKILL|mathematical-rigor]].

## The rigor standard (what "done right" means)

- **Every decomposition declares its centering** — the estimand — and shows its
  spectrum before its picture.
- **Rank is an out-of-sample decision**, with the criterion named.
- **Every biplot is readable**: scaling declared, axis percentages shown, reading rule
  (distance / angle / projection) matched to the scaling.
- **Rankings survive a crossover check**, or become conditional.
- **Correlation structures are chosen, not defaulted** — ladder compared at fixed mean
  structure, boundaries treated as alarms.

## Checkable output

End with a **decomposition ledger** the reviewer can audit:

```
ITEM                DECLARED                                   CHECK
matrix + centering  treatment × context, double-centered       estimand: pure interaction
spectrum            SS share per component: 61 / 23 / 9 / 7 %  shown before any biplot
rank retained       K = 2                                      cross-validated RMSPD curve
biplot              c = 0 (column-metric), axes carry 84% SS   angle≈correlation rule stated
stability           row norms + crossover check                crossover: yes → per-segment
within-unit R       AR(1), ρ̂ = 0.62                            IC table vs CS/UN, same mean, REML
boundary scan       no parameter at its edge                   ρ's and variances listed
```

An analysis ships only when every applicable row has its check; "n/a" rows say why.

## Anti-patterns (reject these in review)

- A biplot with no axis percentages, or interpreted under the wrong scaling (distances
  read from a column-metric plot).
- Components retained because in-sample fit improved.
- A pooled "best row" ranking reported despite rank-crossing across contexts.
- Selection on stability alone — the stable-but-poor row wins.
- Repeated measures entered as independent rows (each unit's series multiplying n).
- A sphericity correction where the correlation structure could be modeled.
- Kronecker/separable covariance assumed silently.
- A boundary estimate (ρ ≈ 1, variance ≈ 0) reported as a substantive finding.
