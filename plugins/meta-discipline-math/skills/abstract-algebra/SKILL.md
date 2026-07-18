---
name: abstract-algebra
description: "Use whenever a set-with-operation is treated as a group, ring, field, module, or vector space — before any structural theorem is applied. Enforces identifying which structure is actually in play, verifying its axioms explicitly (closure and inverses are the usual failures), and checking a theorem's hypotheses before citing it. A set with an operation is not a group until the axiom ledger says so."
---

# Abstract Algebra

The discipline of *earning* a structure's name before spending its theorems. "$X$ is a
group" / "$K$ is a field" is a claim, not a label: each axiom you add — associativity,
identity, inverses, distributivity — unlocks specific tools, and skipping the check imports
a theorem whose hypotheses never held. This skill makes the axiom check executable.

## Method

1. **Name the structure, minimally.** Climb only as far as the axioms justify:
   magma $\subset$ semigroup (assoc) $\subset$ monoid (identity) $\subset$ group (inverses)
   $\subset$ abelian (commutative); and ring $\subset$ integral domain (no zero divisors)
   $\subset$ field (all nonzero units). Claiming "group" when only a monoid is proved is the
   root error. See [[skills/hypercomplex-and-geometric-algebra/SKILL|hypercomplex-and-geometric-algebra]] for concrete algebra choices.
2. **Verify axioms explicitly, in order.** Closure first ($a\ast b\in G$), then
   associativity, identity, inverses; for rings add distributivity. Closure and inverses are
   where candidates die: $(\mathbb Z,\times)$ is a monoid, not a group ($2$ has no inverse);
   the odd integers aren't closed under $+$. Never assume an axiom that "looks obvious."
3. **Check subobjects satisfy the same axioms.** A subgroup must be closed and contain
   inverses ($H\le G$: nonempty, $ab^{-1}\in H$). To *quotient*, the subobject must be
   normal ($gNg^{-1}=N$) — otherwise $G/N$ has no well-defined operation. For rings the
   quotienting object is a two-sided ideal, not merely a subring.
4. **Route structure through homomorphisms.** A map $\varphi$ preserving the operation has a
   kernel and image; the first isomorphism theorem gives $G/\ker\varphi\cong\operatorname{im}\varphi$.
   These theorems are the workhorses — but each needs $\varphi$ to actually be a homomorphism,
   verified, and (for the quotient) $\ker\varphi$ normal, automatic here.
5. **Use actions and counting to constrain.** A group action gives orbits and stabilizers with
   $|G|=|\mathrm{Orb}(x)|\cdot|\mathrm{Stab}(x)|$ (orbit–stabilizer). Lagrange: for finite $G$,
   $|H|\mid|G|$, so element orders divide $|G|$ — a hard constraint on what can exist.
6. **Classify with the finite-group toolkit.** Order, generators/relations, and the Sylow
   theorems (a Sylow $p$-subgroup exists; $n_p\equiv1\pmod p$, $n_p\mid|G|$) pin down structure;
   $\gcd$-cyclic facts govern $\mathbb Z/n\mathbb Z$ — see [[skills/number-theory/SKILL|number-theory]].
   For vector spaces and modules, dimension/basis arguments live in [[skills/linear-algebra/SKILL|linear-algebra]].
7. **Cite only with hypotheses discharged.** "By Lagrange" requires $G$ finite ✓; "it's a
   field, so nonzero elements are invertible" requires the field axioms already checked. An
   uncited premise is an unproved step — the standard of [[skills/mathematical-rigor/SKILL|mathematical-rigor]].

## The rigor standard

- Every "$X$ is a [structure]" resolves to a checked axiom list, not an assertion.
- Closure and inverses are checked explicitly for every group claim; distributivity and
  zero-divisors for every ring/field claim.
- Quotients cite the normality (groups) or ideal (rings) condition that makes them well-defined.
- Every theorem invocation records the hypothesis it required (finiteness, $p$-power order,
  no zero divisors) and confirms it holds here.
- Isomorphism/homomorphism claims verify operation-preservation before using kernel/image results.

## Checkable output

Emit a **structure & axiom ledger**: for each object, the claimed structure, the axioms
actually checked, and the consequences that unlock. Theorem citations get their own rows
recording the hypothesis discharged.

```
OBJECT                     CLAIMED STRUCTURE   AXIOMS CHECKED                                   CONSEQUENCES UNLOCKED
(ℤ/nℤ, +)                  abelian group       closure ✓, assoc ✓, id 0 ✓, inv −a ✓, comm ✓    order n, cyclic ⟨1⟩
(ℤ/nℤ, ×)                  monoid; group on units  closure ✓, assoc ✓, id 1 ✓, inv ⇔ gcd(a,n)=1  unit group (ℤ/nℤ)ˣ, |·|=φ(n)
(ℤ/pℤ, +, ×)               field (p prime)     ring ✓, every a≠0 invertible ✓ (gcd=1)          division ✓, char p, Frobenius
Lagrange ⇒ |H| ∣ |G|       theorem citation    requires G finite ✓                              element orders ∣ |G|
Sylow ⇒ ∃ p-subgroup       theorem citation    requires |G|<∞ ✓, p ∣ |G| ✓                      n_p ≡ 1 (mod p), n_p ∣ |G|
```

A row may not claim a consequence whose axioms are unchecked. Under the `pure` profile the
ledger is mandatory; under `applied` it backs any computation the configured CAS
(`config.cas`: sympy|sage|none) performs — a CAS reporting "this is a field" is a claim to
audit, not a proof. Notation follows `config.notation`.

## Anti-patterns

- Calling a set-with-operation a "group" with closure or inverses unchecked (the two silent failures).
- Quotienting by a non-normal subgroup, or a ring by a mere subring instead of an ideal.
- Invoking Lagrange, Sylow, or Cauchy on an infinite (or unverified-finite) group.
- Assuming commutativity — using $ab=ba$ in a nonabelian group or noncommutative ring.
- Treating "has an identity and is associative" (a monoid) as sufficient for group theorems.
- Citing a field property (invertibility, no zero divisors) for a ring not shown to be a field.
