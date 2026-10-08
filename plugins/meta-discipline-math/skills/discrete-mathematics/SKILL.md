---
name: discrete-mathematics
description: "Use when a claim reduces to counting or finite structure — 'how many', a binomial or Stirling identity, a recurrence or closed form, or a statement about graphs, trees, matchings, colorings, or planarity — and the discipline required is that the method of counting is itself the proof; a bijection to a known set, a double count, inclusion–exclusion, or pigeonhole is the argument, not an illustration of one."
---

# Discrete Mathematics

Counting is proof. A closed form is not established by pattern-matching small cases but by exhibiting *why* it counts what it claims — a bijection to a set of known size, an object counted two ways, a sieve, or a pigeon forced into a hole. This skill governs any finite-enumeration or graph-structure claim; the count and the argument for it are one object.

## Method

1. **State the counting problem as a set, exactly.** Name the finite set $S$ whose cardinality you want and pin its membership predicate. "$k$-subsets of $[n]$", "labelled trees on $n$ vertices", "surjections $[n]\to[k]$". Ambiguity here (ordered? distinct? empty allowed?) is the source of most wrong counts — resolve it before any arithmetic.
2. **Apply the sum and product rules deliberately.** Disjoint cases add; independent sequential choices multiply. A permutation count $n!/(n-k)!$ *is* the product rule over $k$ shrinking choices; $\binom{n}{k}=\frac{n!}{k!(n-k)!}$ divides it by the $k!$ orderings you overcounted. Track every overcount and quotient it out explicitly.
3. **Choose a counting strategy and justify why it proves.** Pick one: **bijection** (exhibit $f:S\to T$ invertible, $|T|$ known — then $|S|=|T|$ *as a theorem*), **double counting** (count one set two ways, equate), **inclusion–exclusion** ($|\bigcup A_i|=\sum(-1)^{|I|+1}|\bigcap_{i\in I}A_i|$), or **pigeonhole** ($n$ items in $m<n$ boxes force a collision). A bijection to a known set is a proof of equinumerosity, never an analogy.
4. **Prove identities bijectively before resorting to algebra.** $\binom{n}{k}=\binom{n}{n-k}$ is the complement map $A\mapsto[n]\setminus A$, an involution — this *is* the proof. $\sum_{k}\binom{n}{k}=2^n$ double-counts subsets of $[n]$. Reach for algebraic manipulation only when no structural argument is available, and flag it as weaker evidence of *why*.
5. **Set up recurrences, then extract closed forms via generating functions.** From a combinatorial decomposition derive $a_n$'s recurrence; encode it as an ordinary GF $A(x)=\sum a_n x^n$ (unlabelled) or exponential GF $\sum a_n x^n/n!$ (labelled). Solve for $A(x)$, then read coefficients. E.g. Catalan: $C(x)=1+xC(x)^2\Rightarrow C_n=\frac{1}{n+1}\binom{2n}{n}$.
6. **Reason about graphs through their invariants.** Handshake lemma: $\sum_v \deg(v)=2|E|$ (so odd-degree vertices are even in number). A tree on $n$ vertices is any-two-of: connected, acyclic, $n-1$ edges — the equivalences are the theorem. Euler's formula $V-E+F=2$ for connected planar graphs bounds $E\le 3V-6$, forcing non-planarity of $K_5$; coloring bounds ($\chi\le\Delta+1$, four-color for planar) follow structurally.
7. **Give asymptotics with named growth.** Report counts as $\Theta(\cdot)$ and use Stirling $n!\sim\sqrt{2\pi n}\,(n/e)^n$ for factorial-scale quantities. $\binom{2n}{n}\sim 4^n/\sqrt{\pi n}$. Under `config.profile=applied` an asymptotic to `config.sig_figs` may substitute for a closed form; under `pure` the closed form and its proof are mandatory.
8. **Verify every count two independent ways.** Check the closed form against small-$n$ direct enumeration via the configured CAS (`config.cas`: sympy|sage|none) — enumerate $S$ for $n=0,1,2,3,4$ and confirm the formula reproduces each. A closed form that has never been cross-checked against enumeration is a conjecture. If `config.cas=none`, enumerate by hand for at least three small $n$.

## The rigor standard

- A bijection claim carries its inverse explicitly, or it is not a bijection — "the map is clearly onto" is not a proof.
- Inclusion–exclusion terms are enumerated in full; a sieve with an unstated or truncated alternating sum is wrong.
- Every closed-form count is confirmed against direct enumeration for small $n$; disagreement means the formula is wrong, not the enumeration.
- Cited results (Cayley's $n^{n-2}$, four-color theorem) are named and attributed, never silently reused as if derived here — see [[skills/mathematical-rigor/SKILL|mathematical-rigor]].
- Asymptotic claims state the growth class ($\Theta$, $\sim$) and the regime; a bare "grows fast" is not a claim.

## Checkable output

Emit a **counting-verification ledger**: every quantity or identity, the method that establishes it, and the independent cross-check that confirms it. Each closed-form count must carry a small-$n$ enumeration check. Under `config.profile=pure` the ledger is mandatory for every enumerative claim; under `applied` it is mandatory for any count feeding a downstream numeric result.

```
QUANTITY / IDENTITY                METHOD                        CROSS-CHECK
$\binom{n}{k}=\binom{n}{n-k}$      bijection (complement map)    involution $A\mapsto[n]\setminus A$; CAS n=5 all k ✓
$\sum_k\binom{n}{k}=2^n$           double count (subsets of [n]) enumerate $2^{[4]}$: 16 = $\sum_k\binom{4}{k}$ ✓
labelled trees on $n$ = $n^{n-2}$ cited Cayley, not derived     enumerate n=3→3, n=4→16 by CAS ✓
derangements $D_n$                 inclusion–exclusion sieve     $D_4=9$: closed form vs. hand enumeration ✓
Catalan $C_n$                      gen-func $C=1+xC^2$           $C_{0..4}=1,1,2,5,14$ vs. Dyck-path count ✓
$\binom{2n}{n}\sim 4^n/\sqrt{\pi n}$  Stirling asymptotic        $\Theta$; ratio→1 at $n=50$, sig_figs=4 ✓
```

## Anti-patterns

- Declaring a bijection without exhibiting the inverse, or asserting $|S|=|T|$ because both are "counted the same way" — that is the claim, not its proof.
- Verifying a formula on $n=1,2,3$ and calling the pattern proven; extrapolation from small cases is conjecture, never a theorem.
- Proving an identity by algebra when a one-line bijective argument exists, thereby hiding *why* it holds.
- Writing an inclusion–exclusion or a recurrence-to-closed-form step but never cross-checking the result against direct enumeration via the configured CAS.
- Reusing $n^{n-2}$, the four-color theorem, or Euler's formula as if self-evident, without naming them as cited results with stated hypotheses (connected, planar, simple).
- Reporting a growth rate with no $\Theta$/$\sim$ and no regime, or substituting an asymptotic for a required closed form under `config.profile=pure` — generating-function convergence questions belong to [[skills/calculus-and-analysis/SKILL|calculus-and-analysis]], integer-structure ones to [[skills/number-theory/SKILL|number-theory]].
