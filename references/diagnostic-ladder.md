# The Diagnostic Ladder

One ladder, reconciling four that competed across the old skills: Module-03 (`ai-seo-war-room`), the 13-step order (`dr-ai-seo-war-room`), T1's five steps (`ai-sov-tracker`), and the four-link causal chain (`authority-expectations-coach`).

**Work top to bottom. Stop at the first gate that fails. Fix that.** A beautiful entity graph on a page a crawler cannot fetch moves nothing, and the instinct to skip to the interesting layer is the most common way this goes wrong.

---

## Gate 1 — ACCESS

*Can the engine fetch the page at all?*

| Test | Pass | Read from |
|---|---|---|
| robots.txt permits GPTBot, OAI-SearchBot, ChatGPT-User, PerplexityBot, Perplexity-User, ClaudeBot, Claude-SearchBot, Google-Extended, Bingbot, Googlebot | all allowed | `rma2_site_checks` → `robots` |
| Page returns 200 to those user-agents specifically, not just to a browser | 200 | `rma2_site_checks` → `http` |
| No noindex, no X-Robots-Tag blocking | clean | → `noindex` |
| Canonical resolves to a live final-domain URL | 200 | → `canonical` |
| In sitemap, sitemap returns 200 | yes | → `sitemap` |
| WAF not challenging bots | not blocking | manual — check the firewall's learning/blocking mode |

**Ceiling rule:** if final-domain canonical URLs 404, no honest grade exceeds 4/10 regardless of how good everything below looks. Stop and fix.


**Executor:** `ai-search-backend-readiness`

---

## Gate 2 — EXTRACTABILITY

*Is the content there when JavaScript does not run?*

AI crawlers mostly do not execute JS. A React page that renders beautifully in a browser and returns an empty shell to `curl` is invisible.

| Test | Pass |
|---|---|
| Substantial visible text in raw HTML | several hundred words minimum |
| Main content is not injected client-side | SSR or static |
| Text is not locked in images or unlabelled iframes | readable |


---

## Gate 3 — RETRIEVAL SHAPE

*Does the page yield a liftable passage?*

This is where most technically-clean sites fail. The page is fetchable and readable, and still gives the retriever nothing it can quote.

| Test | Pass | Why |
|---|---|---|
| 40–60 word self-contained answer capsule directly under the H1 | present | A passage that only makes sense in surrounding context cannot be lifted, and a passage that cannot be lifted cannot be cited. Not a bio, not a hook, not context-setting — the answer. |
| Question-shaped H2/H3 headings | **≥60% of subheads** | Query fan-out decomposes a prompt into sub-questions and retrieves against them. No question-shaped headings means no fan-out targets. |
| Chunk boundaries survive splitting | each section standalone | Retrievers chunk. A section that depends on the previous one loses meaning when split. |
| Evidence genres present | comparisons, definitions, numbers, code | These are the genres that measure positive citation lift. Comparison pages have the highest citation rate of any format and are the least produced. |
| Named-source stat density | ~1 per 150–200 words | Attributed figures are liftable claims. Unattributed ones are opinion. |
| One intent per URL | yes | Two URLs answering one intent split the signal and both lose. |


**Do not confuse this gate with building the page as an FAQ stack.** Question-shaped *headings* on a substantive page: yes. A page that is *only* Q&A: no — that shape measured −5.74%, because it has no argument and no evidence genre to lift. See the conflict resolution in SKILL.md.

**Executor:** `ai-seo-retrieval-king` for mechanism, `geo-linter` for the gate, `rma` to write it.

---

## Gate 4 — TOPICAL COVERAGE

*Does a page even exist for this query, and does it own one intent?*

| Test | Pass |
|---|---|
| A dedicated page exists for the battlefield | yes |
| It is not one page trying to own five intents | one intent |
| Cluster architecture is coherent, not a pile | hub + spokes |
| No two URLs competing for the same intent | no cannibalization |

**The diagnostic trap.** A battlefield at zero citations feels like a content gap. Check whether a good page already exists before writing another one.


**Executor:** `rma` for pieces, `soro-system` for volume. No specialist — the Topical Architect coach was never built.

---

## Gate 5 — ENTITY

*Do the engines know who you are with enough confidence to name you?*

Understandability → Credibility → Deliverability. An engine that is unsure who you are hedges, and hedging reads as absence.

| Test | Pass | Read from |
|---|---|---|
| Stable `Organization` / `Person` `@id`, reused across pages | consistent | schema audit |
| `sameAs` breadth — independent profiles | **thin below ~8–10** | `rma2_execution_tasks` → `SAMEAS_EXPAND` |
| Wikidata entry exists | yes | → `WIKIDATA` |
| Identical description everywhere, on and off site | yes | → `CONSISTENCY` |
| Knowledge Panel present | yes | → `KNOWLEDGE_PANEL` |
| Not confused with a similarly-named entity | disambiguated | Brand SERP read |


Lock the canonical identity once and do not relitigate it: legal name, jurisdiction, markets served, and whether a local-search profile is appropriate for your market shape.

**Executor:** `ai-seo-entity-barnard`

---

## Gate 6 — CORROBORATION

*Does anyone independent name you?*

The gate that decides whether an engine treats you as a real entity or an uncorroborated self-description.

| Test | Pass | Read from |
|---|---|---|
| Independent third-party mentions exist | **>0, ideally 10+** | `rma2_placements` |
| They sit on domains the engines already cite | yes | `references/citation-landscape.md` |
| Editorial independence — a third party controls acceptance and wording | yes | placement type |
| Reviews on independent platforms | yes | `rma2_execution_tasks` → `REVIEWS_UP` |


**Second-order cost:** placement model v1.1 cannot calibrate below 10 placements. Its eight factor weights, including `act` at weight 15, stay unvalidated priors. You are steering by an unchecked model.

**For most sites that pass gates 1-4, this is the binding constraint.** Engines that cite hundreds of distinct domains on your questions and never cite you have made a judgement about corroboration, not about prose.

**Executor:** `dr-ai-seo-war-room/references/pr-backlink-authority-system.md` + `ai-citation-acceleration-system.md`

---

## Gate 7 — FRESHNESS

*Cited once, then dropped?*

Engines rotate aggressively — Google AI Mode replaces 56% of cited sources weekly, ChatGPT 74%. A page cited in March and untouched since falls out of the set.

| Test | Pass |
|---|---|
| Visible date matches schema `dateModified` | parity |
| Key pages refreshed within ~2 quarters | yes |
| Stats re-verified, not just date-bumped | substantive |


**Rule:** update the existing URL. Never publish a second URL answering the same intent. URL stability is itself a citation asset.

---

## Gate 8 — ENGINE FIT

*Cited on one engine, invisible on another?*

Run this last, and only when at least one engine shows signal. Per-engine divergence is a real finding, not noise — cited-domain overlap between ChatGPT and Perplexity is roughly 11%.

| Pattern | Reading |
|---|---|
| Perplexity yes, ChatGPT no | Perplexity indexes fresher and more broadly. Normal early state. |
| Google surfaces yes, others no | Traditional SEO authority carrying; the AI-native engines are unconvinced. |
| All engines no, competitors yes on all | Gate 6. It is always gate 6. |
| High-reasoning tier yes, standard no | Deeper fan-out is finding you; shallow retrieval is not. Retrieval shape problem, gate 3. |


---

## The load-bearing distinction

**Gates 1–4 are on-site. Content answers them.**
**Gates 5–7 are off-site. Content does not answer them.**

Publishing volume is the answer to a traffic problem, never to a trust problem. Name which one you have before anyone writes a word. Telling a client to publish more when their binding constraint is gate 6 is the expensive kind of wrong — it burns a quarter and the number does not move.

---

## Instrument-integrity check — run before trusting any of the above

A ladder run against a broken instrument produces confident nonsense.

1. **Read `rma2_runs` before `rma2_runner_cycles.errors`.** The drain retries. A logged failure does not imply a missing observation. Reversing this on 2026-08-04 produced a wrong diagnosis: 2,613 "credit balance too low" errors were read as a dead engine, while that engine had completed 205 runs with real answers and 142 citations.
2. **Check `raw_excerpt` is non-empty** before treating a zero as genuine absence.
3. **Check n ≥ 5** per cell. Below that, report nothing.
4. **Check the CI does not span a band boundary** before declaring movement.
5. **Check `rma2_research_registry` for claims past `verify_by`.** An expired claim stops steering decisions until re-verified.
6. **Check the model pin.** `chatgpt-api` runs `gpt-4o-mini-2024-07-18` and returned a citation on only 32% of runs, against 68% for Claude and 100% for Perplexity. A cheap model with weak search grounding under-reports citation behaviour relative to the front end a buyer actually uses. Treat that engine's zero as the least representative number in the set.
