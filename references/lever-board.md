# The Authority Lever Board

Eleven levers. Every way authority gets built, on one page, so they can be compared against each other instead of nine specialists each returning the best move inside its own silo.

**Scoring:** `expected movement = gap size × lever leverage / latency`

- **Gap size** — how far the current state is from ceiling, read from live data. Not vibes.
- **Leverage** — how much this lever moves AI citation specifically. HIGH / MED / LOW.
- **Latency** — weeks until the number can move. A divisor, not a tiebreaker.

**Headroom, not importance.** Access is the most important layer in the stack and scores zero when it already passes. A lever at ceiling is worth nothing this cycle no matter how load-bearing it is.

Fill the STATE column from your own data before scoring. An unfilled board is a guess.

---

## 1. Access & crawl infrastructure

**Moves:** whether an engine can fetch you at all. Binary gate under everything else.
**Read from:** `rma2_site_checks` → `robots`, `http`, `noindex`, `sitemap`, `canonical`.
**Check:** all ten AI crawlers allowed (GPTBot, OAI-SearchBot, ChatGPT-User, PerplexityBot, Perplexity-User, ClaudeBot, Claude-SearchBot, Google-Extended, Bingbot, Googlebot). HTTP 200 to those user-agents specifically. IndexNow live.

| Leverage | Latency | Cost |
|---|---|---|
| HIGH (as a gate) | 1 week | Low |

**Executor:** `ai-search-backend-readiness`
**Ceiling rule:** if final-domain canonical URLs 404, nothing below matters and no honest grade exceeds 4/10.
**Trap:** this is usually already solved. Solved means it scores zero. Re-check quarterly, not weekly.

---

## 2. Retrieval shape

**Moves:** whether a fetched page yields a *liftable passage*. A passage that only makes sense in context cannot be cited.
**Components:** raw-HTML extractability · 40–60 word self-contained answer capsule under the H1 · question-shaped H2/H3 headings as fan-out targets · chunk boundaries that survive splitting · evidence genres that measure positive lift (comparisons, definitions, numbers, code).
**Read from:** `rma2_site_checks` → `rawtext`, `qheads`. Then read the page.

| Leverage | Latency | Cost |
|---|---|---|
| HIGH | 2–4 weeks | Low |

**Executor:** `ai-seo-retrieval-king` for mechanism, `geo-linter` for the gate, `rma` to write the changes.
**Why it usually ranks high:** cheap, fast, entirely within your control, and commonly the only on-site lever with real headroom. It will not on its own fix a corroboration problem. Do it anyway, because it costs a week and stops being an excuse.

---

## 3. Topical coverage & architecture

**Moves:** whether a page exists for the query at all, and whether one page is trying to own five intents.
**Read from:** battlefields at flat zero cross-referenced against the sitemap.

| Leverage | Latency | Cost |
|---|---|---|
| MED | 6–12 weeks | High |

**Executor:** `rma` for individual pieces, `soro-system` for volume.
**Trap:** the instinct on a zero battlefield is always "write more about it." A battlefield with zero mentions *and* no dedicated page is a coverage gap. A battlefield with a good page and still zero is **not** — that is a trust problem wearing a content costume. Check which before commissioning anything.

---

## 4. Entity graph

**Moves:** whether engines know *who you are* with enough confidence to name you. Understandability → Credibility → Deliverability.
**Components:** stable `Organization`/`Person` `@id` · `sameAs` breadth · Wikidata presence · consistent description everywhere · Knowledge Panel · disambiguation from similarly-named entities.
**Read from:** `rma2_execution_tasks` + a Brand SERP read.
**Benchmark:** `sameAs` is thin below roughly 8–10 independent profiles.

| Leverage | Latency | Cost |
|---|---|---|
| HIGH | 8–16 weeks | Medium |

**Executor:** `ai-seo-entity-barnard`
**Note:** entity and corroboration are the same fight from two sides. `sameAs` breadth *is* corroboration expressed as schema. Work them together or neither moves.
**Local-search caveat:** a Google Business Profile is a local-search tool. If you are a global or remote business, a location-verified profile signals the wrong market, and virtual addresses get suspended. Decide once, record the reasoning, do not relitigate.

---

## 5. Third-party corroboration

**Moves:** whether anyone independent names you. The layer that decides whether an engine treats you as a real entity or as a self-description nobody has corroborated.
**Read from:** `rma2_placements` row count.

| Leverage | Latency | Cost |
|---|---|---|
| **HIGHEST** | 8–20 weeks | Medium (time, not money) |

**Second-order cost of zero:** a placement scoring model cannot calibrate below ~10 placements. Its factor weights stay unvalidated priors. You end up steering by a model nobody has checked.

**The uncomfortable part:** this is the lever the data usually points at hardest and the one nobody enjoys. It is outreach. It is slow, it is refused often, and it produces nothing visible at the end of the week.

---

## 6. Digital PR & editorial placements

**Moves:** high-authority independent mentions in sources engines already cite. Distinct from lever 5 in that it targets *specific* publications known to appear in the fan-out.
**Read from:** run the CITATION LANDSCAPE block in `tools/state.sql`. Harvest `citation_urls`, group by domain and battlefield, rank by frequency. Then target those domains.

| Leverage | Latency | Cost |
|---|---|---|
| HIGH | 12–24 weeks | High |

**Do not score this lever before running the instrument.** "Reverse-engineer who is already cited in the fan-out, then get placed there" only works once you have looked. The data is usually already collected and never queried.

**Target triage:** vertical trade publications rank highest (narrow, credible, and they accept contributed articles). Category SaaS blogs rank next (they publish constantly and need practitioner content). Government and competitor domains are not placeable — exclude them from the target list even when they dominate the citation count.

---

## 7. Original data assets

**Moves:** gives engines something only you can be the source for. Benchmarks answering a buying comparison outperform "we published original data."
**Read from:** does `Dataset` schema exist, and does it point at something real?

| Leverage | Latency | Cost |
|---|---|---|
| HIGH | 12–20 weeks | High |

**Compounding property worth naming:** a benchmark is simultaneously a citable asset (lever 7), a PR hook (lever 6), and a corroboration magnet (lever 5). It is the only lever on this board that pays into three others. That is usually enough to beat a higher raw score.

---

## 8. Video

**Moves:** video transcripts are indexed text that engines retrieve. A video whose transcript contains a clean citable passage competes in the same retrieval as a page — from a domain with authority you do not have to build.
**Read from:** `citation_urls` frequency for `youtube.com` on your battlefields. Check before dismissing it.

| Leverage | Latency | Cost |
|---|---|---|
| MED-HIGH to HIGH | 8–16 weeks | Medium |

**Executor:** `dr-youtube-geo`
**Why it gets missed:** video sits outside most AI-SEO skill sets, so it never enters the comparison. That is a structural blind spot, not a judgement that video does not work. Query the citation landscape before assuming.

---

## 9. Reviews & directories

**Moves:** third-party profile pages are corroboration you control the existence of but not the content of — which is exactly what editorial independence means. Cheapest genuine corroboration available.

| Leverage | Latency | Cost |
|---|---|---|
| MED | 4–10 weeks | **Low** |

**Sequencing note:** review schema is blocked by having reviews, not by anything technical. Marking up reviews that do not exist is fabrication and is a bright line. Get the reviews first.

---

## 10. Freshness

**Moves:** recency weighting. Engines rotate cited sources aggressively — published figures put weekly source replacement in the 56–74% range depending on the engine. A page cited once and never updated falls out.

| Leverage | Latency | Cost |
|---|---|---|
| MED | Ongoing | Low |

**Rule:** an update to an existing URL beats a new URL answering the same intent. URL stability is itself a citation asset.
**Timing:** on a new site this scores low today and high in three quarters. It is a decay lever, not a gap lever. Schedule it before it becomes a gap.

---

## 11. Distribution & seeding

**Moves:** where the corpus that engines retrieve from gets fed. Publishing to your own domain and stopping is the narrowest possible distribution.
**Components:** syndication, long-form social, newsletter, podcast guesting, community answers, partner co-publication.
**Read from:** `citation_urls` frequency for platform domains — check which platforms the engines actually pull from on your battlefields before choosing where to seed.

| Leverage | Latency | Cost |
|---|---|---|
| MED-HIGH | 8–16 weeks | Medium |

**Honest caveat:** referral counts undercount AI impact by design — many AI answers produce no click at all. Treat referral data as a floor. Never as a total, and never as proof a distribution channel failed.

---

## Reading the board

Fill in STATE and SCORE from your own data, then rank. Two patterns worth knowing before you start:

**The concentration read.** Levers 4, 5, 6, 8 and 9 are usually the same underlying problem — somebody other than you saying your name somewhere an engine already trusts. They are not five independent bets. Sequenced properly, one outreach motion feeds placements, `sameAs`, reviews and PR simultaneously. Treating them as separate quarterly initiatives is how a site stays invisible.

**The on-site ceiling.** If gates 1–4 pass and gates 5–7 fail, the board will rank off-site levers top and that answer will be unwelcome. It is still the answer. The one on-site exception worth doing anyway is retrieval shape, because it costs a week and removes the last on-site excuse.
