---
name: mathematical-rigor
description: "Use when constructing, checking, or reviewing a mathematical argument, proof, definition, or claim — anywhere correctness must be established rather than asserted. Enforces definitions-first, explicit quantifiers and assumptions, deliberate proof-strategy selection, counterexample hunting, and a proved/cited/conjectured claims ledger. The rigor standard that turns step-following into a checkable proof."
---

# Mathematical Rigor

The discipline of *establishing* truth, not asserting it. A mathematician's competence is
not knowing more theorems — it is refusing to advance a claim that isn't proved, cited, or
flagged. This skill is that standard, made executable.

## Method

1. **Define first.** Before any claim, pin every object: its type, domain, and the
   structure assumed (a group? a metric space? a $C^1$ function?). An argument over an
   undefined object is void. State the ambient assumptions explicitly.
2. **Make quantifiers explicit.** "$f$ is bounded" is ambiguous; "$\exists M\,\forall x\in D:\ |f(x)|\le M$"
   is not. Order matters: $\forall x\,\exists y$ is not $\exists y\,\forall x$. Never leave
   a quantifier to the reader.
3. **Choose a proof strategy deliberately**, and name it: direct, contrapositive,
   contradiction, induction (state the hypothesis + base case + step), construction,
   or exhaustion. If none fits, the claim may be false — go to step 5.
4. **Decompose into lemmas.** A proof longer than a screen is usually several results;
   isolate them so each is independently checkable.
5. **Hunt a counterexample before every "always/never".** Test boundary and degenerate
   cases: empty set, zero, one, negative, equality vs. strict, non-generic position,
   $n=0/1$. A claim that survives an honest counterexample search earns a proof attempt;
   one that doesn't is a conjecture at best.
6. **Cite with hypotheses checked.** Invoking a named theorem means verifying *its*
   premises hold here (continuity, compactness, independence…). An uncited hypothesis is
   an unproved step.
7. **Necessary vs. sufficient; "iff" needs both directions.** Prove $\Rightarrow$ and
   $\Leftarrow$ separately; never let one direction smuggle the other.

## The rigor standard (what "done right" means)

- **Every claim resolves to exactly one of: proved, cited, or conjectured.** No fourth
  category ("clearly", "obviously", "it can be shown") is allowed to carry weight.
- **The proof is checkable line-by-line** — each step follows from stated prior steps,
  definitions, or cited results, with no leap a reviewer must fill in.
- **Assumptions are surfaced, not buried.** If a step needs $x\neq 0$, that hypothesis is
  stated where it's used.
- **Edge cases are dispatched, not ignored.** The degenerate inputs from step 5 each get a
  sentence.

## Checkable output

End with a **claims ledger** the reviewer can audit:

```
CLAIM                                    STATUS      BASIS
∀ nonzero q∈ℍ, q⁻¹ exists                proved      q̄/|q|² ; |q|²>0 for q≠0
The only normed division algebras over ℝ cited        Hurwitz (1898)
  have dim 1,2,4,8
No 3-dim normed division algebra exists  proved      corollary of the above
<any remaining gap>                      conjectured open lemma L2
```

A result ships only when the ledger has **no unproved, uncited rows** left unlabelled. If
the `pure` profile is active, the ledger is mandatory; under `applied`, it backs each
derivation `dimensional-analysis` produces.

## Anti-patterns (reject these in review)

- Quantifier drift ("for some" used where "for all" is needed, or vice versa).
- Proof by example (one case ≠ a universal claim).
- Circular citation (using the corollary to prove the theorem).
- "WLOG" that isn't (asserting symmetry that doesn't hold).
- Dividing by a possibly-zero quantity; taking roots/logs outside their domain.
