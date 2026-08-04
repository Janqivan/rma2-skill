# RMA2

A Claude skill for getting cited by AI answer engines and found in search.

RMA2 reads your live measurement data **first**, diagnoses which gate is actually blocking citation, scores every authority lever against each other, and returns **one decision** with the skill that executes it.

---

## The problem it solves

Most AI-SEO tooling diagnoses from theory. You end up with nine specialists each returning the best move *inside their own silo* — the entity coach says fix the entity graph, the retrieval coach says fix the passages, the PR system says get placements — and nothing ever compares those against each other on expected impact.

Meanwhile the measurement data that would answer the question sits unqueried.

RMA2 is the router that sits above the specialists.

```
READ STATE  ->  DIAGNOSE  ->  SCORE THE LEVER BOARD  ->  ONE DECISION
    1             2                   3                     4
 live SQL      one ladder      11 levers, not 5        + who executes
```

---

## Four rules that override anything asked for

1. **Never diagnose from theory when data exists.** Step 1 is non-optional.
2. **Never blend engines.** ChatGPT-Perplexity cited-domain overlap is roughly 11%. A blended AI-visibility score is arithmetic on incompatible units.
3. **Never call a band exit on a point estimate.** If the confidence interval spans the boundary, the answer is "not yet" — however much someone wants the win.
4. **One decision out.** Not three options. An open wrong-facts incident *is* the decision.

---

## The eight-gate ladder

Work top to bottom. Stop at the first gate that fails. A beautiful entity graph on a page a crawler cannot fetch moves nothing.

| # | Gate | Fails when |
|---|---|---|
| 1 | Access | Bot blocked, JS-only content, noindex, canonical 404, WAF |
| 2 | Extractability | Renders in a browser, empty shell to a crawler |
| 3 | Retrieval shape | No answer capsule, no question-shaped headings, no liftable passage |
| 4 | Topical coverage | No page for the query, or one page owning five intents |
| 5 | Entity | Engines hedge, thin `sameAs`, no Knowledge Panel, wrong-entity confusion |
| 6 | Corroboration | Pages are fine, nobody independent names you |
| 7 | Freshness | Cited once, then dropped as sources rotate |
| 8 | Engine fit | Cited on one engine, invisible on another |

**The load-bearing distinction:** gates 1-4 are on-site and content answers them. Gates 5-7 are off-site and content does **not**. Publishing volume is the answer to a traffic problem, never to a trust problem. Name which one you have before anyone writes a word.

---

## The lever board

Eleven levers, scored against each other rather than in isolation:

access · retrieval shape · topical coverage · entity graph · third-party corroboration · digital PR · original data assets · video · reviews and directories · freshness · distribution

```
expected movement  =  gap size  x  lever leverage  /  latency
```

Three disciplines that keep the scoring honest:

- **Latency is a divisor, not a tiebreaker.** A lever that moves the number in 90 days is roughly six times worse per unit of effort than one that moves it in 14 — and most authority levers are the slow kind. Say so out loud rather than quietly preferring quick wins.
- **A lever at ceiling scores zero however important it is.** Access is the most important layer in the stack and is worth nothing this cycle if it already passes. Importance is not headroom.
- **Levers with no instrument are unscoreable, not zero.** Name the instrument that would fix it.

---

## Install

```
skills/rma2/
├── SKILL.md
├── references/
│   ├── lever-board.md
│   ├── diagnostic-ladder.md
│   └── routing-map.md
└── tools/
    └── state.sql
```

---

## Data model

RMA2 expects a Postgres/Supabase schema with these tables:

| Table | Holds |
|---|---|
| `rma2_runs` | One row per prompt x engine x repetition. QCS score, sentiment, wrong-facts flag, citation URLs, raw answer excerpt, model string. |
| `rma2_prompts` | The prompt bank, mapped to battlefields and journey stages. |
| `rma2_battlefields` | The topics you are trying to win. |
| `rma2_engines` | Engines tracked separately, including reasoning tiers as distinct engines. |
| `rma2_spec` | The live contract: sampling, CI method, bands, judge config, retention. |
| `rma2_placements` | Third-party placements. Gate 6 evidence. |
| `rma2_site_checks` | Access and on-page structure per URL. |
| `rma2_execution_tasks` | Lever work in flight. |
| `rma2_research_registry` | Evidence with `verify_by` expiry dates. |

Set your project reference in `tools/state.sql`. **If `rma2_spec` disagrees with these files, the spec wins** — it is the live contract; these files describe it.

---

## Scoring

QCS is a 0-3 ordinal scored per run, averaged per cell (one battlefield x one engine), never blended across engines.

| Band | Cell mean |
|---|---|
| Absent | 0 - 0.5 |
| Mentioned | 0.5 - 1.5 |
| Cited | 1.5 - 2.5 |
| Recommended | 2.5 - 3.0 |

Minimum n=5 per cell before reporting anything. 90% t-interval on the mean. Flag whenever the interval spans more than one band — a point estimate crossing a threshold is not a result.

Reliability comes from spreading across paraphrases, not repeating one prompt. Single-answer brand-ranking reliability measures around 0.01; even a large multi-language multi-model design reaches only about 0.36.

---

## Standing method note

**Read `rma2_runs` before `rma2_runner_cycles.errors`.** If your runner retries, a logged failure does not imply a missing observation. The row is the evidence; the error is only a cost signal.

This is not hypothetical. Reversing that order once produced a confident, wrong diagnosis: thousands of billing errors in a log were read as a dead engine, while that engine had in fact completed every run with real answers and citations underneath them.

---

## What it will tell you that you may not want to hear

If gates 1-4 pass and gates 5-7 fail, **more content is the wrong answer.** The honest output is: stop writing, go get named by someone independent, and accept the number will not move for a quarter.

A zero with a large n and real answers underneath it is not a measurement problem. It is the finding. Engines that cite hundreds of other sources on your exact questions and never cite you have made a judgement, and the judgement is about corroboration, not about your prose.

Most of what moves AI citation is not on your website.
