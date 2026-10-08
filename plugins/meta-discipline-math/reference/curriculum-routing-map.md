---
type: reference
domain: mathematics
tags: [reference, math/curriculum, routing]
---
# Engineering & physics mathematics — curriculum routing map

A coverage map of the mathematics in a typical engineering degree and a typical physics degree, from the pre-university bridge to graduate methods, with one extra job: for every topic it says **which skill covers it**, and where no skill does, **which authoritative source to fetch from** instead of answering from memory or running an open web search.

**Emphasis** — ● core/required · ○ common but discipline-dependent or elective · *rare* = not standard. **Eng** = engineering, **Phys** = physics. Coverage varies by specialization; markers show typical emphasis.

**Covered by** — skills of this pack by name; skills of the companion physics pack as `physics/<skill>`. *(partial)* means the skill applies its discipline to the topic but does not teach the topic itself. *baseline* means pre-university material no skill needs to add.

## How to use this map

1. Find the topic. Load the skill in **Covered by** and follow its method and ledger.
2. If the row says *(partial)* or names no skill, use the skill for the checking discipline (rigor, units, limits) and take the *content* from the source in **Fetch from** — cite the section you used.
3. Never state from memory what a pinned source exists for: special-function identities and asymptotics (NIST DLMF), physical constants (NIST CODATA values), tabulated material or property data. Fetch and cite.
4. When a fetched source uses a different convention from the skill (Fourier normalization, metric signature, unit system, sign of a thermodynamic term), say which one you are using and convert explicitly.

## 1. Foundations & pre-university bridge

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Algebra, functions & inequalities | ● | ● | *baseline*; mathematical-rigor for proofs | — |
| Trigonometry & identities | ● | ● | geometry-and-trigonometry | — |
| Analytic / coordinate geometry | ● | ● | geometry-and-trigonometry | — |
| Complex number basics ($a+ib$) | ● | ● | complex-analysis | — |
| Vectors & geometry in $\mathbb{R}^2,\mathbb{R}^3$ | ● | ● | linear-algebra, geometry-and-trigonometry | — |
| Mathematical logic, sets & proof | ○ | ○ | mathematical-rigor, discrete-mathematics | — |

## 2. Calculus & real analysis

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Limits & continuity | ● | ● | calculus-and-analysis | — |
| Differential calculus (single variable) | ● | ● | calculus-and-analysis | — |
| Integral calculus & techniques | ● | ● | calculus-and-analysis | — |
| Sequences, series, Taylor/power series | ● | ● | calculus-and-analysis | — |
| Multivariable calculus | ● | ● | calculus-and-analysis | — |
| Rigorous real analysis ($\varepsilon$–$\delta$) | ○ | ○ | calculus-and-analysis, mathematical-rigor | — |
| Calculus of variations | ○ | ● | physics/classical-mechanics *(partial)* | Gelfand & Fomin, *Calculus of Variations* |
| Functional analysis (Hilbert/Banach) | ○ | ● | physics/quantum-mechanics *(partial)* | Kreyszig, *Introductory Functional Analysis with Applications* |

## 3. Linear algebra

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Matrices, determinants, linear systems | ● | ● | linear-algebra | — |
| Vector spaces, basis & dimension | ● | ● | linear-algebra, abstract-algebra | — |
| Linear transformations | ● | ● | linear-algebra | — |
| Eigenvalues/eigenvectors, diagonalization | ● | ● | linear-algebra | — |
| Inner product spaces & orthogonality | ● | ● | linear-algebra | — |
| Matrix decompositions (LU, QR, SVD) | ● | ○ | linear-algebra | — |
| Tensor algebra & index notation | ○ | ● | linear-algebra *(partial)*, physics/special-and-general-relativity | — |

## 4. Differential equations

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| First-order ODEs | ● | ● | differential-equations | — |
| Higher-order linear ODEs | ● | ● | differential-equations | — |
| Systems of ODEs & phase-plane | ● | ● | differential-equations | — |
| Series solutions & special functions | ○ | ● | differential-equations *(partial)* | NIST DLMF (dlmf.nist.gov) |
| Sturm–Liouville & eigenfunction expansions | ○ | ● | differential-equations | NIST DLMF for the eigenfunction families |
| PDEs (heat, wave, Laplace) | ● | ● | differential-equations, physics/waves-and-oscillations | — |
| Boundary/initial value problems | ● | ● | differential-equations | — |
| Green's functions | ○ | ● | differential-equations *(partial)*, physics/electromagnetism *(partial)* | — |
| Nonlinear dynamics & chaos | ○ | ○ | differential-equations *(partial: stability)* | Strogatz, *Nonlinear Dynamics and Chaos* |

## 5. Complex analysis

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Complex functions & analyticity | ○ | ● | complex-analysis | — |
| Cauchy–Riemann & contour integration | ○ | ● | complex-analysis | — |
| Laurent series | ○ | ● | complex-analysis | — |
| Residue theorem | ○ | ● | complex-analysis | — |
| Conformal mapping | ○ | ○ | complex-analysis *(partial)* | — |

## 6. Vector & tensor calculus

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Gradient, divergence & curl | ● | ● | calculus-and-analysis, physics/electromagnetism | — |
| Line & surface integrals | ● | ● | calculus-and-analysis | — |
| Green's / Stokes' / divergence theorems | ● | ● | calculus-and-analysis, physics/electromagnetism | — |
| Curvilinear coordinates | ● | ● | calculus-and-analysis, geometry-and-trigonometry | — |
| Tensor calculus & covariant indices | ○ | ● | physics/special-and-general-relativity | — |
| Differential forms & exterior calculus | ○ | ○ | hypercomplex-and-geometric-algebra *(partial)* | Flanders, *Differential Forms with Applications to the Physical Sciences* |

## 7. Probability, statistics & stochastics

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Probability theory & combinatorics | ● | ● | probability-and-statistics, discrete-mathematics | — |
| Random variables & distributions | ● | ● | probability-and-statistics | — |
| Descriptive & inferential statistics | ● | ● | probability-and-statistics, statistical-inference | — |
| Error analysis & uncertainty propagation | ● | ● | physics/experimental-method-and-error-analysis, dimensional-analysis | JCGM 100 (GUM) |
| Regression & data analysis | ● | ○ | statistical-inference, multivariate-analysis | — |
| Stochastic processes & Markov chains | ○ | ○ | probability-and-statistics *(partial)* | Grimmett & Stirzaker, *Probability and Random Processes* |
| Bayesian methods | ○ | ○ | statistical-inference *(partial)* | Gelman et al., *Bayesian Data Analysis* |
| Statistical-mechanics foundations | ○ | ● | physics/statistical-mechanics-and-thermodynamics | — |

## 8. Discrete mathematics & abstract algebra

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Set theory & combinatorics | ○ | ○ | discrete-mathematics | — |
| Boolean algebra & digital logic | ● | ○ | — | Any digital-design text; verify by truth table or a logic simulator |
| Graph theory & networks | ○ | ○ | discrete-mathematics, graph-drawing | — |
| Group theory & symmetry | ○ | ● | abstract-algebra, physics/symmetry-and-conservation-laws | — |
| Rings, fields & algebras | ○ | ○ | abstract-algebra, hypercomplex-and-geometric-algebra | — |
| Lie groups & Lie algebras | *rare* | ● | abstract-algebra *(partial)*, physics/symmetry-and-conservation-laws, physics/particle-physics-and-the-standard-model | — |
| Number theory (crypto/coding) | ○ | *rare* | number-theory | — |

## 9. Geometry & topology

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Euclidean & analytic geometry | ● | ● | geometry-and-trigonometry | — |
| Differential geometry of curves/surfaces | ○ | ● | geometry-and-trigonometry *(partial)* | do Carmo, *Differential Geometry of Curves and Surfaces* |
| Riemannian geometry & manifolds (GR) | *rare* | ● | physics/special-and-general-relativity | — |
| Point-set topology | ○ | ○ | — | Munkres, *Topology* |

## 10. Integral transforms & Fourier analysis

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Fourier series | ● | ● | calculus-and-analysis *(partial)*, physics/waves-and-oscillations | NIST DLMF §1.8 |
| Fourier transform & spectral methods | ● | ● | physics/waves-and-oscillations *(partial)* | NIST DLMF §1.14; state the normalization convention |
| Laplace transform | ● | ○ | differential-equations | NIST DLMF §1.14 |
| Z-transform (discrete systems, EE) | ● | *rare* | — | Oppenheim & Schafer, *Discrete-Time Signal Processing* |
| Convolution & impulse response | ● | ● | differential-equations *(partial)*, physics/waves-and-oscillations *(partial)* | — |
| Wavelet transforms | ○ | ○ | — | Mallat, *A Wavelet Tour of Signal Processing* |

## 11. Numerical & computational mathematics

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Root finding & interpolation | ● | ● | calculus-and-analysis *(partial)* | NIST DLMF ch. 3; the library's own documentation |
| Numerical integration/differentiation | ● | ● | calculus-and-analysis *(partial)* | NIST DLMF ch. 3 |
| Numerical linear algebra | ● | ○ | linear-algebra | — |
| Finite-difference methods | ● | ● | differential-equations *(partial)* | LeVeque, *Finite Difference Methods for Ordinary and Partial Differential Equations* |
| Finite-element methods | ● | ○ | — | The solver's documentation; Strang & Fix, *An Analysis of the Finite Element Method* |
| Numerical ODE/PDE solvers | ● | ● | differential-equations *(partial)* | The solver's documentation (tolerances, stiffness) |
| Monte Carlo methods | ○ | ● | probability-and-statistics *(partial)* | — |
| Scientific computing & simulation | ● | ● | physics/model-building-and-approximation *(partial)* | — |

## 12. Optimization & operations research

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Calculus-based optimization & Lagrange multipliers | ● | ● | calculus-and-analysis | — |
| Linear programming | ● | ○ | — | Boyd & Vandenberghe, *Convex Optimization* |
| Nonlinear & convex optimization | ● | ○ | — | Boyd & Vandenberghe, *Convex Optimization*; Nocedal & Wright, *Numerical Optimization* |
| Variational optimization (least action) | ○ | ● | physics/classical-mechanics | — |
| Operations research & queueing | ○ | *rare* | probability-and-statistics *(partial)* | Kleinrock, *Queueing Systems* |

## 13. Engineering-specific mathematics

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Control theory (transfer functions, state-space) | ● | ○ | — | Åström & Murray, *Feedback Systems* |
| Signals & systems analysis | ● | ○ | — | Oppenheim & Willsky, *Signals and Systems* |
| Information & coding theory | ○ | *rare* | number-theory *(partial: coding)* | MacKay, *Information Theory, Inference, and Learning Algorithms* |
| Electromagnetic field theory (Maxwell) | ● | ● | physics/electromagnetism | — |
| Continuum / fluid mechanics mathematics | ● | ○ | — | Batchelor, *An Introduction to Fluid Dynamics* |
| Circuit analysis (phasors, networks) | ● | ○ | physics/waves-and-oscillations *(partial: driven circuits)* | Any circuit-analysis text; verify with a circuit simulator |

## 14. Physics-specific mathematical methods

| Topic | Eng | Phys | Covered by | Fetch from |
|-------|:---:|:----:|------------|------------|
| Lagrangian & Hamiltonian formalism | ○ | ● | physics/classical-mechanics | — |
| Special functions (Bessel, Legendre, Hermite, harmonics) | ○ | ● | — | NIST DLMF |
| Group & representation theory | *rare* | ● | abstract-algebra, physics/symmetry-and-conservation-laws | — |
| Tensor calculus & differential geometry (GR) | *rare* | ● | physics/special-and-general-relativity | — |
| Hilbert spaces & operators (QM) | *rare* | ● | physics/quantum-mechanics | — |
| Perturbation theory & asymptotics | ○ | ● | physics/limiting-cases-and-asymptotics | NIST DLMF ch. 2 |
| Path integrals | *rare* | ○ | physics/quantum-field-theory *(partial)* | — |
| Clifford algebras & spinors | *rare* | ○ | hypercomplex-and-geometric-algebra | — |

## Gaps this map exposes

Topics with no covering skill, where the agent must fetch: Boolean algebra and digital logic, point-set topology, Z-transform, wavelets, finite-element methods, linear and convex programming, control theory, signals and systems, continuum and fluid mechanics, special functions. Most of section 13 is uncovered: an engineering pack would close it.
