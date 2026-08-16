---
name: design-review
description: "Use when judging a DESIGN rather than a diff — a proposed structure, a module boundary, a class or service split, an interface, a refactoring plan, or an 'is this over-engineered / under-engineered' question. Applies coupling and cohesion, SOLID and GRASP as diagnostics against the change pattern the system actually has, weighs the cost of each added indirection, and separates blocking findings from suggestions. Sits above code review: that judges the code written, this judges the shape proposed. Use before the code exists, or when a change keeps touching the same scattered set of files."
---

# Design Review

A design review is not a style opinion and not a principles quiz. It asks one question:
**will this structure absorb the changes this system will actually receive?** Principles
are the diagnostic instruments for answering it — never the thing being graded. This skill
sits *above* code review: that one judges the code as written; this one judges the shape
proposed, usually before the code exists.

## Method

1. **Establish the change pattern first — before looking at the structure.** What has
   changed together historically, and what is expected to change next? Where a repository
   is available, read it: files that repeatedly appear in the same commits are the real
   cohesion boundary, whatever the folder layout claims. Where it is not, elicit the two
   or three changes the team expects within the year. **Every later finding must point at
   a change from this step** — a design flaw with no future change behind it is a taste
   claim.
2. **Map the seams and the direction of dependencies.** Name the modules, what each one
   knows about the others, and which way each arrow points. Mark the stable pieces
   (policy, domain rules) and the volatile ones (I/O, formats, vendors, UI). The single
   most common structural defect is a stable thing depending on a volatile one.
3. **Apply the principles as diagnostics, not goals.** SRP asks *what reason to change*
   this unit has — answered from step 1, not from intuition. OCP and DIP ask whether the
   volatile side can move without the stable side recompiling. GRASP asks who *should*
   own a responsibility: information expert (the holder of the data), creator, controller.
   LSP asks whether every subtype is honestly substitutable, including in failure and
   performance. ISP asks whether any client is forced to know things it never uses.
   Record which diagnostic fired and on what evidence.
4. **Price the indirection.** Every abstraction buys flexibility with comprehension.
   For each proposed seam ask: how many implementations exist or are genuinely coming;
   what test becomes possible that was not; how many files a reader must now open to
   follow one behaviour. **One implementation and no test seam is not a justified
   abstraction** — it is speculation with a maintenance bill.
5. **Test the simpler alternative.** State the smallest structure that would still absorb
   the step-1 changes, and say why the proposal beats it — or accept it. A review that
   never considers doing less is an argument for complexity by default.
6. **Rule and separate.** Each finding gets a verdict: **blocking** (the design fails a
   named change), **recommended** (works, but a cheaper or clearer structure exists), or
   **note** (observation, no action). Emit the ledger. Blocking findings must name the
   change they protect and the smallest edit that resolves them.

## The rigor standard

- **Every finding names a concrete future change.** "Violates SRP" is not a finding;
  "adding a second payment provider forces edits in these four unrelated files" is.
- **Principles are evidence, not verdicts.** Citing a principle without the change it
  protects is an appeal to authority. No finding rests on "the book says".
- **Abstractions justify themselves.** A seam with one implementation and no test benefit
  is rejected, however elegant. Symmetrically, a missing seam is only a defect if a named
  change has to cross it.
- **The simpler alternative is always stated.** Explicitly, in the ledger — including when
  it loses.
- **Blocking is scarce and specific.** If everything is blocking, nothing is; if a finding
  cannot name the failing change, it is at most *recommended*.
- **Design altitude only.** Naming, formatting, and line-level defects belong to code
  review; if the `mattpocock` or `superpowers` packs are mounted, hand those to
  `code-review` rather than restating them here.
- **Domain modelling is cited, not redone.** Where a mounted pack owns `domain-modeling`,
  this skill consumes its model and reviews the structure around it.

## Checkable output

A **design-review ledger**: the change pattern that grounds the review, then one row per
finding with the diagnostic that fired, the concrete change it endangers, the verdict, and
the simpler alternative that was considered.

```
CHANGE PATTERN (from 18 months of history + team's next-12-months list)
  co-change clusters   pricing/* + tax/*  (37 commits)   ·   notify/* + templates/*  (21)
  expected next        2nd payment provider · VAT per-region · replace email vendor

FINDING                          DIAGNOSTIC        ENDANGERED CHANGE              VERDICT      SIMPLER ALTERNATIVE
PricingEngine reads SMTP config  stable→volatile   replace email vendor touches   BLOCKING     move notify behind existing
                                 dependency (DIP)  pricing rules                                port; 1 file, no new type
TaxPolicy split across 4 pkgs    cohesion vs       VAT per-region edits 4 pkgs     BLOCKING     merge into tax/; delete 2
                                 co-change data                                                 indirection layers
IPaymentProvider, 1 impl         indirection cost  2nd provider IS coming (Q3)     NOTE         keep — named change exists
IReportRenderer, 1 impl          indirection cost  none named                      RECOMMENDED  inline it; re-extract when
                                                                                                a second renderer appears
Repository<T> generic base       speculative       none named                      RECOMMENDED  two concrete repos read easier
```

Ship only when every row cites a change from the CHANGE PATTERN block and every blocking
row names the smallest edit that clears it. **A review with no NOTE or accepted row is
suspect** — a design in which nothing is right was not read carefully. A review that
cannot name the change pattern at all is not a design review; it is an opinion, and should
say so.

## Anti-patterns

- Running SOLID as a checklist and reporting the count of violations, with no future
  change attached to any of them.
- Requiring an interface for a single implementation "to be safe" — speculative
  generality, paid for by every subsequent reader.
- Reviewing the design by reviewing its naming and formatting; that is code review wearing
  a costume.
- Deferring to an author or a book instead of to the system's own change history, which is
  the only evidence that outranks both.
- Marking everything blocking, which converts a review into a veto and teaches authors to
  route around it.
- Proposing a restructure without stating what it costs to read, test, and onboard against.
- Reviewing a design whose change pattern nobody could name, and pretending the verdicts
  are grounded anyway.
