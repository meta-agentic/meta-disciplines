---
name: differential-equations
description: "Use whenever a problem is governed by an ODE or PDE — solving an IVP/BVP, fitting a dynamical model, checking someone's closed form, or reasoning about long-term behavior. Enforces classify-first, existence-and-uniqueness before 'the' solution, back-substitution of every closed form into the equation AND its data, and a qualitative/limit check that the answer's behavior is physically sane. No solution ships unverified."
---

# Differential Equations

Differential equations are trusted only after two independent proofs: the closed form is
substituted back into the equation and its initial/boundary data, and the solution's
*behavior* is checked against fixed points, limits, and units. A formula that satisfies the
algebra but drifts to the wrong steady state is still wrong.

## Method

1. **Classify before solving.** Fix order; linear vs nonlinear; ODE vs PDE; autonomous;
   homogeneous vs forced. Classification dictates the method and what "solution" even
   means — a linear constant-coefficient ODE has a superposition basis; a nonlinear one
   generally does not. For PDEs, classify $Au_{xx}+2Bu_{xy}+Cu_{yy}$ by $B^2-AC$:
   elliptic ($<0$, e.g. Laplace), parabolic ($=0$, heat), hyperbolic ($>0$, wave).
2. **Existence & uniqueness — before naming "the" solution.** For an IVP $y'=f(t,y)$,
   Picard–Lindelöf gives a unique local solution when $f$ is continuous and Lipschitz in
   $y$. If the Lipschitz condition fails, expect trouble: $y'=\sqrt{y},\,y(0)=0$ admits both
   $y\equiv 0$ and $y=t^2/4$ (non-unique). Also test for finite-time blow-up ($y'=y^2$
   escapes at $t=1/y_0$). Record a uniqueness verdict; never present one curve as the answer
   when the field permits many.
3. **Apply the exact method the class licenses.** Separable: $\int dy/g(y)=\int f(t)\,dt$.
   First-order linear $y'+p(t)y=q(t)$: integrating factor $\mu=e^{\int p\,dt}$. Constant-
   coefficient linear: characteristic equation, roots give $e^{\lambda t}$ / resonant
   $t\,e^{\lambda t}$ modes. Inhomogeneous: variation of parameters or an integral transform
   (Laplace for IVPs, Fourier for whole-line/periodic BVPs). Delegate the integrals/roots to
   the configured CAS (`config.cas`: sympy|sage|none); if `none`, keep the closed form
   symbolic and verify by hand.
4. **Back-substitute — the non-negotiable check.** Plug the closed form into the original
   equation: every derivative term must cancel to an identity. Then substitute the
   initial/boundary conditions: $y(0)$, $y'(0)$, boundary values must match to
   `config.sig_figs`. Both the equation AND the data, separately. A "solution" that fails
   either is discarded, not patched.
5. **Qualitative & stability analysis.** Find fixed points $f(y^*)=0$; linearize and read
   stability from the Jacobian eigenvalues — $\mathrm{Re}\,\lambda<0$ attracting,
   $>0$ repelling, complex ⇒ spirals/oscillation. Sketch the phase portrait; for
   conservative/gradient systems build a Lyapunov function $V$ with $\dot V\le 0$. The exact
   solution's trajectory must land on the fixed point the qualitative analysis predicts.
6. **PDE well-posedness.** Demand Hadamard's three: existence, uniqueness, and continuous
   dependence on data. Match data to type — elliptic wants boundary data (Dirichlet/Neumann
   on a closed domain), parabolic and hyperbolic want initial data plus boundary conditions.
   The wrong pairing (e.g. Cauchy data for Laplace) is ill-posed and blows up under
   perturbation, however clean the formula looks.
7. **Numerical schemes when no closed form exists.** State the scheme (explicit Euler/RK4 vs
   implicit/backward for stiff systems) and honor the Lax equivalence principle:
   **consistency + stability ⇒ convergence**. Check the stability constraint explicitly —
   CFL $\Delta t \le C\,\Delta x$ for explicit hyperbolic schemes; use implicit methods when
   the Jacobian's eigenvalue spread makes the problem stiff.
8. **Cross-check units and limits.** Every term shares dimensions (see
   [[skills/dimensional-analysis/SKILL|dimensional-analysis]]); the $t\to\infty$ limit hits
   the steady state; a rate constant $k$ sets a timescale $1/k$ that matches the transient.

## The rigor standard

- **No solution ships without back-substitution** into the equation *and* its data (step 4).
- **Existence/uniqueness is decided, not assumed** — a Lipschitz/well-posedness verdict is a
  required column, and non-uniqueness or blow-up is flagged loudly.
- **Behavior must match the algebra:** the closed form's asymptotics and fixed points agree
  with the qualitative analysis (step 5). Two independent confirmations, not one.
- **Numerical answers state their stability condition** (CFL/stiffness) and scheme; an
  unstable scheme's output is noise, not an approximation.
- **The right data for the type:** PDE boundary/initial conditions match elliptic/parabolic/
  hyperbolic classification, or the problem is declared ill-posed.

## Checkable output

Emit a **solution-verification ledger** — one row per solution, columns
`CLASSIFICATION | METHOD | BACK-SUBSTITUTION | QUALITATIVE/LIMIT CHECK`, with the
existence/uniqueness verdict noted in the row. Eigenvalues/stability lean on
[[skills/linear-algebra/SKILL|linear-algebra]]; the symbolic steps on
[[skills/calculus-and-analysis/SKILL|calculus-and-analysis]].

```
CLASSIFICATION            METHOD               BACK-SUBSTITUTION                 QUALITATIVE / LIMIT CHECK
1st-order linear IVP      integrating factor   y'+py=q satisfied ✓, y(0)=y₀ ✓    t→∞ → steady state q/p ✓, units ✓
  y'+py=q, p>0            μ=e^{pt}             [E&U] f Lipschitz ⇒ unique ✓      1/p timescale matches transient ✓
2nd-order const-coeff     char. equation       both ICs y(0),y'(0) matched ✓     λ=−γ±iω ⇒ damped oscillation ✓
  ÿ+2γẏ+ω₀²y=0            λ roots (via CAS)    ODE identity ✓                    Re λ<0 ⇒ decays to 0 ✓
nonlinear autonomous      separable            y=t²/4 AND y≡0 satisfy ✓          [E&U] √y not Lipschitz ⇒ NON-UNIQUE ⚠
  y'=√y, y(0)=0                                                                  both branches reported ✓
1D heat (parabolic)       Fourier/separation   PDE + BCs + IC(x) matched ✓       [WP] IC+Dirichlet ⇒ well-posed ✓; smooths ✓
```

Under the `applied` profile the ledger is mandatory — every model row carries back-sub and a
limit check. Under `pure` it is the concrete companion to the existence/uniqueness proof,
which [[skills/mathematical-rigor/SKILL|mathematical-rigor]] owns. Notation follows
`config.notation`; `config.profile` selects emphasis (proof vs prediction).

## Anti-patterns

- Presenting "the" solution without an existence/uniqueness check — silently missing a second
  branch ($y'=\sqrt{y}$) or a finite-time blow-up.
- Reporting a closed form never substituted back into the equation, or matched to the
  equation but not to its initial/boundary conditions.
- Trusting a formula whose $t\to\infty$ limit contradicts the fixed-point/stability analysis —
  right algebra, wrong behavior.
- Pairing PDE data with the wrong type (Cauchy data for an elliptic problem) and calling the
  result a solution — it is ill-posed.
- Running an explicit scheme past its CFL/stability limit, or an explicit method on a stiff
  system, and mistaking the resulting oscillation for the answer.
- Applying superposition or a characteristic-equation basis to a nonlinear equation where it
  does not hold.
