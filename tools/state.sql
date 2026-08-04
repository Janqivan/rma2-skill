-- RMA2 state.sql — Step 1 of the skill. Run this BEFORE saying anything.
-- Target: set your own Postgres/Supabase project reference before running.
--
-- Order matters. Block 0 checks the instrument. If the instrument is broken,
-- everything below it is confident nonsense.

-- ============================================================
-- BLOCK 0 — INSTRUMENT INTEGRITY (run first, always)
-- A zero is only a finding if the run actually happened.
-- ============================================================
select e.code as engine,
       r.run_at::date as run_date,
       count(*) as runs,
       count(*) filter (where r.raw_excerpt is null or length(r.raw_excerpt) = 0) as empty_answers,
       round(avg(length(r.raw_excerpt)), 0) as avg_answer_chars,
       count(*) filter (where array_length(r.citation_urls, 1) > 0) as runs_with_citations,
       round(100.0 * count(*) filter (where array_length(r.citation_urls,1) > 0) / count(*), 0) as pct_cited,
       min(r.model_string) as model_pin
from rma2_runs r
join rma2_engines e on e.id = r.engine_id
where not r.is_demo
group by e.code, r.run_at::date
order by run_date desc, engine;

-- Runner errors BY DATE. Old errors are history, not a current fault.
-- Do not read this before the block above.
select date_trunc('day', c.started_at)::date as day,
       count(*) filter (where e::text ilike '%credit balance%') as credit_errors,
       count(*) filter (where e::text ilike '%429%')            as quota_429,
       count(*) filter (where e::text ilike '%judge%')          as judge_errors,
       count(*)                                                 as total_errors
from rma2_runner_cycles c, lateral jsonb_array_elements(c.errors) e
where jsonb_typeof(c.errors) = 'array'
group by 1 order by 1 desc;

-- Evidence freshness. An expired claim stops steering decisions.
select id, evidence_grade, verify_by,
       case when verify_by < current_date then 'EXPIRED — do not steer by this'
            when verify_by < current_date + interval '30 days' then 'expiring <30d'
            else 'current' end as status,
       left(claim, 100) as claim
from rma2_research_registry
order by verify_by;

-- ============================================================
-- BLOCK 1 — T0 OVERRIDE (if this returns rows, it IS the decision)
-- ============================================================
select * from rma2_t0_incidents order by 1 desc;

-- ============================================================
-- BLOCK 2 — WHERE WE STAND (QCS cells with 90% CI + band verdict)
-- Bands from rma2_spec key qcs_bands: Absent 0–0.5, Mentioned 0.5–1.5,
-- Cited 1.5–2.5, Recommended 2.5–3.0. Hard floor n=5.
-- ============================================================
with cell as (
  select b.code as bf, e.code as eng,
         count(*)::numeric as n,
         avg(r.qcs_score::numeric) as m,
         stddev_samp(r.qcs_score::numeric) as sd
  from rma2_runs r
  join rma2_prompts p       on p.id = r.prompt_id
  join rma2_battlefields b  on b.id = p.battlefield_id
  join rma2_engines e       on e.id = r.engine_id
  where not r.is_demo
  group by b.code, e.code
),
ci as (select *, (1.685 * sd / sqrt(n))::numeric as hw from cell where n >= 5)
select bf, eng, n::int,
       round(m, 3) as mean_qcs,
       round(greatest(m - hw, 0), 3) as ci_lo_90,
       round(m + hw, 3)              as ci_hi_90,
       case when greatest(m - hw, 0) >= 0.5 then 'CONFIRMED out of Absent'
            when m + hw > 0.5              then 'CI SPANS BANDS — not a confirmed exit'
            else                                'Absent' end as verdict
from ci
order by m desc;

-- Per-engine and per-battlefield rollups
select e.code as engine, count(*) n,
       round(avg(r.qcs_score)::numeric, 2) mean_qcs,
       count(*) filter (where r.qcs_score > 0) hits
from rma2_runs r join rma2_engines e on e.id = r.engine_id
where not r.is_demo group by e.code order by mean_qcs desc;

select b.code, b.name, count(*) n,
       round(avg(r.qcs_score)::numeric, 3) mean_qcs,
       count(*) filter (where r.qcs_score > 0) hits
from rma2_runs r
join rma2_prompts p      on p.id = r.prompt_id
join rma2_battlefields b on b.id = p.battlefield_id
where not r.is_demo group by b.id, b.code, b.name order by mean_qcs desc;

-- ============================================================
-- BLOCK 3 — CITATION LANDSCAPE (feeds levers 6, 8 and 11)
-- This is the act-factor instrument: find who is already cited
-- in the fan-out, then go get placed there.
--
-- EXCLUDE gemini-api: all its citation URLs resolve to
-- vertexaisearch.cloud.google.com, a grounding proxy, not a source.
-- ============================================================
with u as (
  select b.code as bf, e.code as eng,
         lower(regexp_replace(regexp_replace(unnest(r.citation_urls), '^https?://(www\.)?', ''), '/.*$', '')) as dom
  from rma2_runs r
  join rma2_prompts p      on p.id = r.prompt_id
  join rma2_battlefields b on b.id = p.battlefield_id
  join rma2_engines e      on e.id = r.engine_id
  where not r.is_demo
    and array_length(r.citation_urls, 1) > 0
    and e.code <> 'gemini-api'          -- proxy URLs, unusable
)
select dom,
       count(*) as citations,
       count(distinct bf) as battlefields,
       count(distinct eng) as engines,
       string_agg(distinct bf, ',' order by bf) as which_battlefields
from u
where dom not in ('google.com','vertexaisearch.cloud.google.com','bing.com')
group by dom
order by citations desc
limit 60;

-- Our own share of voice in the citation set
with u as (
  select lower(regexp_replace(regexp_replace(unnest(r.citation_urls), '^https?://(www\.)?', ''), '/.*$','')) as dom
  from rma2_runs r join rma2_engines e on e.id = r.engine_id
  where not r.is_demo and array_length(r.citation_urls,1) > 0 and e.code <> 'gemini-api'
)
select count(*) filter (where dom like '%digitalrocket%') as our_citations,
       count(*) as total_citations,
       round(100.0 * count(*) filter (where dom like '%digitalrocket%') / count(*), 3) as share_of_voice_pct,
       count(distinct dom) as distinct_domains
from u;

-- Where we get cited, and at what quality
with u as (
  select e.code eng, b.code bf, r.qcs_score,
         lower(regexp_replace(regexp_replace(unnest(r.citation_urls), '^https?://(www\.)?',''), '/.*$','')) dom
  from rma2_runs r
  join rma2_engines e      on e.id = r.engine_id
  join rma2_prompts p      on p.id = r.prompt_id
  join rma2_battlefields b on b.id = p.battlefield_id
  where not r.is_demo and array_length(r.citation_urls,1) > 0
)
select eng, bf, count(*) as our_citations, string_agg(distinct qcs_score::text, ',') as qcs_values
from u where dom like '%digitalrocket%'
group by eng, bf order by our_citations desc;

-- Platform domains — read as levers, not competitors
with u as (
  select b.code bf, lower(regexp_replace(regexp_replace(unnest(r.citation_urls),'^https?://(www\.)?',''),'/.*$','')) dom
  from rma2_runs r
  join rma2_prompts p on p.id = r.prompt_id
  join rma2_battlefields b on b.id = p.battlefield_id
  join rma2_engines e on e.id = r.engine_id
  where not r.is_demo and array_length(r.citation_urls,1) > 0 and e.code <> 'gemini-api'
)
select dom, count(*) citations, count(distinct bf) battlefields
from u
where dom in ('youtube.com','linkedin.com','reddit.com','x.com','twitter.com',
              'medium.com','substack.com','quora.com','facebook.com')
group by dom order by citations desc;

-- ============================================================
-- BLOCK 4 — LEVER STATE
-- ============================================================
-- Gate 6 corroboration: the binding constraint check
select (select count(*) from rma2_placements)          as placements,
       (select count(*) from rma2_placement_outcomes)  as outcomes,
       (select count(*) from rma2_calibration_reviews) as calibration_reviews,
       case when (select count(*) from rma2_placements) >= 10
            then 'calibration can run'
            else 'BLOCKED — model weights are unvalidated priors' end as model_status;

-- Execution tasks by status
select status, count(*) n, string_agg(code, ', ' order by code) tasks
from rma2_execution_tasks group by status order by status;

-- Gates 1–3: latest site check per URL, non-passing items only
select distinct on (url)
       url, checked_at::date, pass_count, warn_count, fail_count,
       (select string_agg(x->>'name' || ': ' || (x->>'detail'), ' | ')
        from jsonb_array_elements(results) x where x->>'status' <> 'pass') as non_passing
from rma2_site_checks
order by url, checked_at desc;

-- ============================================================
-- BLOCK 5 — DEMAND AND CAPTURE
-- ============================================================
select min(date) from_date, max(date) to_date,
       sum(clicks) clicks, sum(impressions) impressions
from rma2_search_queries;

-- Brand vs non-brand split. If nearly all clicks are navigational,
-- there is no non-brand acquisition happening.
select case when query ilike '%digital rocket%' or query ilike '%digitalrocket%'
            then 'brand' else 'non-brand' end as query_type,
       sum(clicks) clicks, sum(impressions) impressions, count(distinct query) queries
from rma2_search_queries group by 1;

-- AI referrals. A FLOOR. Many AI answers produce no click at all.
select ai_source, sum(sessions) sessions, sum(engaged_sessions) engaged
from rma2_traffic where ai_source is not null
group by ai_source order by sessions desc;

-- ============================================================
-- BLOCK 6 — THE LIVE CONTRACT
-- If rma2_spec disagrees with the skill files, the spec wins.
-- ============================================================
select key, rationale, updated_at from rma2_spec order by key;
select version, status, effective_date, rationale from rma2_model_versions order by effective_date desc;
