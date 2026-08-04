# Routing Map

RMA2 diagnoses and decides. It does not write, lint, or measure. Once the lever is chosen, hand off.

---

## By gate

| Failing gate | Route to | What they do |
|---|---|---|
| 1 Access | `ai-search-backend-readiness` | robots, sitemap, IndexNow, canonical, noindex, JSON-LD graph. Ships `scripts/ai_search_backend_audit.py`. Hard rule: canonical 404 caps the grade at 4/10. |
| 2 Extractability | `ai-seo-retrieval-king` | raw-HTML availability, JS trapping |
| 3 Retrieval shape | `ai-seo-retrieval-king` → then `geo-linter` | fan-out coverage, chunking, capsule, information gain. Then gate the page. |
| 4 Topical coverage | `rma` (pieces) / `soro-system` (volume) | **No specialist — Topical Architect was never built.** RMA2 handles inline. |
| 5 Entity | `ai-seo-entity-barnard` | Entity Home, `@id`, `sameAs`, Wikidata, Knowledge Panel, Brand SERP, corroboration threshold |
| 6 Corroboration | `dr-ai-seo-war-room` reference files | `pr-backlink-authority-system.md` (4 placement tiers), `ai-citation-acceleration-system.md`, `data-proof-asset-system.md` |
| 7 Freshness | `rma` | update the existing URL, never a duplicate |
| 8 Engine fit | `ai-sov-tracker` | measurement run, T0–T3 escalation |

## By lever

| Lever | Executor |
|---|---|
| 1 Access | `ai-search-backend-readiness` |
| 2 Retrieval shape | `ai-seo-retrieval-king` + `geo-linter` + `rma` |
| 3 Topical coverage | `rma`, `soro-system` |
| 4 Entity graph | `ai-seo-entity-barnard` |
| 5 Corroboration | `dr-ai-seo-war-room` refs, `dr-outreach` |
| 6 Digital PR | `dr-ai-seo-war-room/references/pr-backlink-authority-system.md` |
| 7 Data assets | `dr-mid-market-offer:authority-builder`, `dr-ai-seo-war-room/references/data-proof-asset-system.md` |
| 8 Video | `dr-youtube-geo` |
| 9 Reviews & directories | manual, tracked in `rma2_execution_tasks`; feeds `ai-seo-entity-barnard` |
| 10 Freshness | `rma` |
| 11 Distribution | `linkedin`, `dr-youtube-geo`, `dr-outreach` |

## Supporting

| Need | Route to |
|---|---|
| "Am I on track / is this noise / should I panic" | `authority-expectations-coach` |
| Run the measurement cycle | `ai-sov-tracker` |
| Write a page end to end with gates | `rma` (brief → write → overlap → gate → schedule → record → submit) |
| Voice on any DR-authored copy | `ai-ivan` |
| DR offer, proof, guarantee facts | `dr-context` |

---

## Do not route here

**`ai-seo-war-room` — replaced by RMA2. Retire it.**
Its three dispatch targets do not exist on disk:

```
../retrieval-engineer/SKILL.md          -> missing
../topical-architect/SKILL.md           -> missing (never built)
../entity-authority-strategist/SKILL.md -> missing
```

The two coaches that do exist are `ai-seo-retrieval-king` and `ai-seo-entity-barnard`. The war room also opens by requiring `_canon/ai-search-mechanism-2026-06.md`, which does not exist, making its prime directive unsatisfiable as installed. Its useful content — the symptom→coach table and the diagnostic order — is absorbed into RMA2's ladder. Keeping two war rooms competing on identical triggers is the worst pathology in the skill set.

**`dr-ai-seo-war-room` — demoted to reference library and script host, not a front door.**
Its PR, citation-acceleration and data-asset references are the best material in the estate and should not be rewritten. But it is DR-only, it is a linear 13-step procedure rather than a diagnose-then-choose router, it dispatches to zero external skills by design, and it hard-codes a bottleneck snapshot dated 2026-07-06 as if current. Call its files. Do not call it as an orchestrator.

---

## Known broken references — fix or work around explicitly

| Missing file | Declared mandatory by |
|---|---|
| `_canon/ai-search-mechanism-2026-06.md` | `ai-seo-war-room`, `ai-seo-retrieval-king`, `ai-seo-entity-barnard` |
| `corpus/ipullrank-king-and-indig-method.md` | `ai-seo-retrieval-king` |
| `corpus/kalicube-barnard-and-graphite-smith-method.md` | `ai-seo-entity-barnard` |
| `github.com/Janqivan/ai-seo-pack` → `overlap.py`, `gate.py`, `schedule.py` | `rma` |

Both persona coaches run without their canon. Their mechanism claims are unsourced until it is written. Use them for structure and judgement, not as citable authority.

---

## Gate consolidation — three gates, one function

| Gate | Threshold | Status |
|---|---|---|
| `geo-linter/scripts/lint.py` | 9/9 binary | **Keep as the page gate** |
| `dr-ai-seo-war-room/scripts/dr_geo_audit.py` | all required checks | Duplicate. Has page-type awareness + `--json`; merge those into `lint.py` |
| `rma` → `tools/gate.py` | zero blockers + 90 | Not present locally, cannot be inspected |

Same check list, three thresholds, two copies of `verified-numbers.md`. Pick one gate. Until that consolidation happens, `geo-linter` is the one RMA2 calls.

---

## Writer conflict — resolved, both ship

| Object | Verdict |
|---|---|
| Question-shaped H2/H3 headings | **Do it.** Fan-out targets. `rma2_site_checks` flags `qheads: 0` on every DR page. |
| Whole page built as an FAQ stack | **Don't.** This is what measured −5.74%. |
| FAQPage JSON-LD | Neutral. Ship if the page genuinely has an FAQ. Do not manufacture one for the schema. |

`rma` was right about the page shape. `soro-system` and `ai-seo-writer` were right about the headings. They were arguing about different objects.

**Em dashes:** `geo-linter` treats any em dash as a hard FAIL, `rma` calls the check obsolete. Treat as advisory — real false-positive rate on good writing, and the defence against an AI-detection accusation was never a low score. It is the human review record from `rma` step 6.
