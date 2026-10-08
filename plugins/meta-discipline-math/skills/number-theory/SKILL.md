---
name: number-theory
description: "Use whenever an integer claim must be settled — divisibility, gcd/Bézout, modular solvability, primality, quadratic residues, or best rational approximation — and the standard is a *certificate* you can recheck, never 'verified up to a million'. Emits a claim + certificate ledger separating witnessed (probabilistic) rows from proved ones."
---

# Number Theory

The discipline of integer claims backed by *certificates*, not by exhaustive spot-checks. "It
holds for every $n$ I tried" is not a theorem; a Bézout pair, a Miller–Rabin witness, or a
continued-fraction convergent is — because each is a short object a reviewer recomputes in
seconds. This skill makes the gap between "checked" and "certified" the thing you track.

## Method

1. **Reduce divisibility to gcd, and compute it with the extended Euclidean algorithm.** Do not
   just return $d=\gcd(a,b)$; return the Bézout coefficients $u,v$ with $ua+vb=d$. That triple
   *is* the certificate: substitute and confirm. For $a=240,b=46$: $\gcd=2$ with $u=-9,v=47$
   since $-9\cdot240+47\cdot46=2$.
2. **Decide linear congruences by the gcd condition, stated explicitly.** $ax\equiv b\ (\mathrm{mod}\ m)$
   is solvable **iff** $\gcd(a,m)\mid b$; then there are exactly $\gcd(a,m)$ solutions mod $m$.
   Existence and count are *decided*, never assumed. The inverse $a^{-1}\bmod m$ exists iff
   $\gcd(a,m)=1$, and step 1's $u$ supplies it.
3. **Combine coprime moduli with the Chinese Remainder Theorem.** A system $x\equiv r_i\ (\mathrm{mod}\ m_i)$
   with pairwise-coprime $m_i$ has a unique solution mod $\prod m_i$; emit the explicit residue,
   not just "a solution exists". Under the configured CAS (`config.cas`: sympy|sage|none) this is a
   routine reconstruction; with `none`, do it by hand via the $u$'s of step 1.
4. **Exploit structure with Fermat/Euler.** $a^{p-1}\equiv 1\ (\mathrm{mod}\ p)$ for prime $p\nmid a$;
   more generally $a^{\varphi(m)}\equiv 1\ (\mathrm{mod}\ m)$ when $\gcd(a,m)=1$. Use these to collapse
   exponents ($a^k\bmod m$ via $k\bmod\varphi(m)$) — and note the converse fails, which is exactly why
   Fermat gives a *probable* prime, not a proof.
5. **Separate probable-prime from proved-prime — this is the crux.** A passed Fermat or Miller–Rabin
   round leaves $n$ a *probable prime*: witnessed, not proved. Compositeness, by contrast, is
   *certifiable*: a Miller–Rabin **witness** $a$ (or an explicit factor) proves $n$ composite and a
   reviewer rechecks it in one modular exponentiation. Primality itself needs more — a Pratt
   certificate (a primitive root plus the factorization of $n-1$) or an elliptic-curve certificate.
   Never label a witnessed row `proved`.
6. **Handle quadratic residues via reciprocity.** Decide solvability of $x^2\equiv a\ (\mathrm{mod}\ p)$
   with the Legendre symbol $\left(\tfrac{a}{p}\right)$, computed through quadratic reciprocity
   $\left(\tfrac{p}{q}\right)\left(\tfrac{q}{p}\right)=(-1)^{\frac{p-1}{2}\frac{q-1}{2}}$; Euler's
   criterion $a^{(p-1)/2}\equiv\left(\tfrac{a}{p}\right)$ is the recheckable certificate.
7. **Approximate reals by continued fractions, with a certified error bound.** The convergents $p_k/q_k$
   of $x$ are its *best* rational approximations, and each satisfies $\left|x-\tfrac{p_k}{q_k}\right|<\tfrac{1}{q_k^2}$.
   For $\pi$: $\tfrac{22}{7}$ gives $|\pi-22/7|\approx1.3\times10^{-3}<1/49$. This same machinery solves
   Pell $x^2-Dy^2=1$ (fundamental solution from the periodic expansion of $\sqrt D$) and linear
   Diophantine $ax+by=c$ (solvable iff $\gcd(a,b)\mid c$, general solution from one Bézout pair).
8. **Round only at the boundary.** Integer results are exact; report any decimal approximation to
   `config.sig_figs` and mark it as an approximation, never as the integer fact it stands in for.

## The rigor standard

- **Every integer claim resolves to proved, cited, witnessed, or conjectured** — and `witnessed`
  (a passed probabilistic round) is never silently promoted to `proved`.
- **Solvability is decided by an explicit gcd/divisibility condition**, stated where used
  ($\gcd(a,m)\mid b$ for $ax\equiv b$; $\gcd(a,m)=1$ for an inverse), with the solution *count* given.
- **Each row carries a recomputable certificate** — a Bézout triple, a witness $a$, a factor, a CRT
  residue, a Legendre-symbol computation, or a convergent with its $1/q^2$ bound.
- **Compositeness is certified, primality is proved separately.** A witness settles composite; a bare
  probable-prime is reported as such until a Pratt/ECPP certificate upgrades it.

## Checkable output

Emit a **claim + certificate ledger** the reviewer audits by recomputation. Under `config.profile: pure`
the ledger is mandatory and every row needs a certificate; under `applied` it backs the numeric
results but a `witnessed` primality row may ship if the risk is stated.

```
CLAIM                                  STATUS       CERTIFICATE
gcd(240,46)=2                          proved       Bézout: -9·240 + 47·46 = 2
17⁻¹ ≡ 11 (mod 43)                     proved       gcd(17,43)=1; 17·11 = 187 = 4·43+11 ≡ 1
x≡2(3),3(5),2(7) → x≡23 (mod 105)      proved       CRT residue 23; checks all three
2¹⁰⁰ ≡ 976 (mod 1000)                  proved       Euler: 100 ≡ 100 (mod φ(1000)=400), square-multiply
561 is composite                       witnessed    Miller–Rabin witness a=2 (Carmichael; Fermat fails)
2⁶⁷−1 composite                        proved       factor 193707721 (exhibited divisor)
2⁸⁹−1 is prime                         cited        Pratt certificate; not reproved here
(3/7) = 1, x²≡3 (mod 7) solvable       proved       reciprocity + Euler: 3³ ≡ 1 (mod 7)
|π − 22/7| < 1/7²                      proved       continued-fraction convergent, bound 1/q²
x²−2y²=1 → (3,2)                        proved       fundamental Pell soln from √2 = [1;2̄]
```

A result ships only when no `witnessed` row is mislabeled `proved` and every row's certificate
recomputes.

## Anti-patterns

- Reporting a probable prime as prime — a passed Miller–Rabin round is a `witnessed` row, not a proof.
- Returning $\gcd(a,b)=d$ without the Bézout pair, or an inverse without checking $\gcd(a,m)=1$.
- Asserting a congruence is solvable without stating the $\gcd\mid b$ condition, or giving one solution
  when there are $\gcd(a,m)$ of them.
- Applying CRT to non-coprime moduli, or Euler's theorem when $\gcd(a,m)\neq1$.
- Rounding a continued-fraction convergent and dropping the $|x-p/q|<1/q^2$ bound that made it a certificate.
- "Verified for all $n$ up to $N$" offered as proof of a universal statement.

Cross-links: [[skills/mathematical-rigor/SKILL|mathematical-rigor]] (the proved/cited/conjectured
standard this ledger specializes), [[skills/abstract-algebra/SKILL|abstract-algebra]] (the ring
$\mathbb{Z}/n\mathbb{Z}$, units, and fields $\mathbb{F}_p$ underlying every congruence here),
[[skills/discrete-mathematics/SKILL|discrete-mathematics]].
