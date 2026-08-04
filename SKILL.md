---
name: "rma2"
description: "RMA2 - the single door for getting more AI citations and more search traffic. Reads the live measurement database FIRST, diagnoses why citations are not happening using one canonical ladder, scores the full authority lever board (access, retrieval, topical, entity, corroboration, PR, data assets, video, reviews, freshness, distribution), and returns ONE decision with the skill that executes it. ALWAYS trigger on - /rma2, RMA2, run RMA2, why aren't we cited, why are we not showing up in ChatGPT, AI visibility, AI search, GEO, AEO, generative engine optimization, answer engine optimization, get cited by AI, get cited by ChatGPT, get cited by Perplexity, AI Overviews, share of voice, SoV, QCS, how do we build authority, what should we do next for SEO, more organic traffic, more citations, we're invisible in AI, nobody finds us, authority strategy, what's blocking us, which lever, pick the next move."
---

# RMA2 — diagnose from data, pick one lever, name who executes

You are not here to have an opinion about AI search. There is a database with measured observations in it. **Read it before you say anything.**

```
  READ STATE  ->  DIAGNOSE  ->  SCORE THE LEVER BOARD  ->  ONE DECISION
      1             2                    3                      4
   live SQL      one ladder       11 levers, not 5         + who executes
```

Four rules that override anything asked for:

1. **Never diagnose from theory when data exists.** Step 1 is non-optional. A skill that guesses at the answer while the account pays every cycle to measure it is worse than useless — it is expensively wrong.
2. **Never blend engines.** ChatGPT–Perplexity cited-domain overlap is roughly 11%. A blended AI-visibility number is arithmetic on incompatible units.
3. **Never call a band exit on a point estimate.** If the confidence interval spans the boundary, the answer is "not yet," however much someone wants the win.
4. **One decision out.** Not three options. Not a menu. If a T0 wrong-facts incident is open, it *is* the decision — it outranks whatever else was planned.

---

## Step 1 — READ STATE (non-optional)

Run `tools/state.sql` against your project, or the individual blocks in it.

Read `rma2_runs` **before** `rma2_runner_cycles.errors`. If your runner retries, a logged failure does not imply a missing observation. The row is the evidence; the error is only a cost signal. Getting this backwards produces a confident wrong diagnosis — thousands of billing errors in a log read as a dead engine, while that engine had in fact completed every run with real answers and citations underneath them.

What you need before speaking:

| Reading | Table | What it tells you |
|---|---|---|
| QCS per battlefield × engine, with 90% CI | `rma2_runs` + `rma2_prompts` + `rma2_battlefields` + `rma2_engines` | Where you stand, per cell, honestly |
| Open wrong-facts incidents | `rma2_t0_incidents` | Whether the decision is already made for you |
| Runner health + error dates | `rma2_runner_cycles` | Whether the instrument is trustworthy |
| Answer reality check | `rma2_runs.raw_excerpt`, `citation_urls` | Whether a zero is genuine absence or a failed request |
| Search demand and capture | `rma2_search_queries` | Brand vs non-brand split |
| AI referral floor | `rma2_traffic` where `ai_source` not null | A floor. Never a total. |
| Placement count | `rma2_placements` | Whether off-site work is actually happening |
| On-page structure | `rma2_site_checks` | Access vs shape failures |
| Lever execution status | `rma2_execution_tasks` | What is already in flight |
| Evidence freshness | `rma2_research_registry` | Any claim past `verify_by` stops steering decisions |

**Band thresholds on the cell mean** (`rma2_spec` key `qcs_bands`): Absent 0–0.5, Mentioned 0.5–1.5, Cited 1.5–2.5, Recommended 2.5–3.0. Floor of n=5 before reporting anything. 90% t-interval on the mean; flag whenever the interval spans more than one band.

If `rma2_spec` has been updated since this skill was written, **the spec wins.** It is the live contract; this file is a description of it.

---

## Step 2 — DIAGNOSE (one ladder, in order, stop at the first failure)

Work top to bottom. **Do not skip to the interesting layer** — a beautiful entity graph on a page a crawler cannot fetch moves nothing.

Full detail and the per-gate tests: `references/diagnostic-ladder.md`.

| # | Gate | Failing looks like | Read it from |
|---|---|---|---|
| 1 | **Access** | Bot blocked, JS-only content, noindex, 404 on canonical, WAF | `rma2_site_checks` robots/http/rawtext |
| 2 | **Extractability** | Content renders but no liftable passage; no answer capsule | `rma2_site_checks` rawtext + manual read |
| 3 | **Retrieval shape** | No question-shaped headings, no fan-out targets, one giant chunk | `rma2_site_checks` qheads |
| 4 | **Topical coverage** | The query has no page at all, or one page tries to own five intents | `rma2_battlefields` at flat zero + sitemap |
| 5 | **Entity** | Engines hedge, confuse you with another brand, thin `sameAs`, no Knowledge Panel | `rma2_execution_tasks` |
| 6 | **Corroboration** | Pages are fine, nobody independent names you | `rma2_placements` row count |
| 7 | **Freshness** | Cited once, then dropped as sources rotate | page dates vs `rma2_runs` trend |
| 8 | **Engine fit** | Cited on one engine, invisible on another | per-engine QCS split |

**The load-bearing distinction.** Gates 1–4 are on-site and content answers them. Gates 5–7 are off-site and content does **not** answer them. Publishing volume is the answer to a traffic problem, never to a trust problem. Say which one you have before anyone writes a word.

**Ceiling rule:** if final-domain canonical URLs 404, nothing below gate 1 matters and no score above 4/10 is honest, however good the rest looks.

---

## Step 3 — SCORE THE LEVER BOARD

This is the step nothing else does. Specialist skills each return the best move *inside their own silo* and none of them compare against each other.

Load `references/lever-board.md`. Eleven levers, each with a current-state read, a cost, a latency-to-effect, and the skill that executes it.

Build a citation landscape alongside it — the CITATION LANDSCAPE block in `tools/state.sql` answers a question no amount of theory can: **which domains do the engines already cite when asked your questions?** Competitors, placement targets, and platform levers, ranked. Reverse-engineer who is already cited in the fan-out, then go get placed there.

Score each lever:

```
expected movement  =  gap size  x  lever leverage  /  latency
```

Then rank. Three disciplines that keep this honest:

- **Latency is not a tiebreaker, it is a divisor.** A lever that moves the number in 90 days is not "slower" than one that moves it in 14 — it is roughly six times worse per unit of the same effort, and most authority levers are the slow kind. Say so out loud rather than quietly preferring quick wins.
- **A lever already at ceiling scores zero however important it is.** Access is the most important layer in the stack. If robots, indexing, schema and SSR extractability all pass, access is worth nothing this cycle. Importance is not the same as headroom.
- **Levers with no measurement attached are unscoreable, not zero.** Say "unscoreable — no instrument" and name the instrument that would fix it.

---

## Step 4 — ONE DECISION

Output shape, every time:

```
STATE      one line per engine, QCS with CI, band, n
GATE       the first ladder gate that fails, and the evidence
LEVER      the highest expected-movement lever, with the arithmetic shown
DECISION   one action. one owner. one date.
EXECUTOR   /skill-name
NOT DOING  the two levers that scored next, and why they lost
```

`NOT DOING` is not padding. Naming what lost is what stops the same three ideas being relitigated next cycle.

**Override:** an open `rma2_t0_incidents` row makes itself the decision. A mention carrying wrong facts is worse than absence — it teaches an engine a false thing, and correcting the page later does not remove it from the corpus. SLA: same-day log, correction within 7 days, retest in 14.

---

## Routing

RMA2 diagnoses and decides. It does not write, lint, or measure. Hand off once the lever is chosen. Full map: `references/routing-map.md`.

---

## Conflicts this skill resolves

Writer skills commonly contradict each other on FAQ shaping. They are arguing about different objects:

| Object | Verdict | Why |
|---|---|---|
| **Question-shaped H2/H3 headings** | **Do it.** This is the fan-out target. | Query fan-out decomposes a prompt into sub-questions and retrieves against them. A page with no question-shaped headings offers nothing to match. |
| **Building the whole page as an FAQ stack** | **Don't.** | This is the shape that measures negative. A page that is only Q&A has no argument, no evidence genre, nothing to lift as a claim. |
| **FAQPage JSON-LD** | **Neutral. Ship it if the page genuinely has an FAQ section, don't manufacture one for it.** | Low cost, low upside. Not a lever. |

**Em dashes as an AI tell:** treat as advisory, not a hard gate. It is a cheap check with a real false-positive rate on good writing, and the defence against an AI-detection accusation was never a low score — it is the human review record.

---

## What this skill will tell you that you may not want to hear

**If gates 1–4 all pass and gates 5–7 fail, more content is the wrong answer** and saying otherwise to keep a content retainer busy is the expensive kind of lie. The honest output in that case is: stop writing, go get named by someone independent, and accept that the number will not move for a quarter.

**A zero with a large n and real answers underneath it is not a measurement problem.** It is the finding. Engines that cite hundreds of other sources on your exact questions and never cite you have made a judgement, and the judgement is about corroboration, not about your prose.

**Most of what moves AI citation is not on your website.** That is unwelcome for an agency that sells websites and content, and it is what the data says.
