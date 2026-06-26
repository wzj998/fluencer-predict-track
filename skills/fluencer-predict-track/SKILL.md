---
name: fluencer-predict-track
description: Audit public investment-influencer forecasts from Zhihu answer pages or similar public answer lists by using a configurable local Chrome CDP endpoint, selecting prediction-like posts across time, checking that the post was last edited before the predicted event, validating outcomes with external data, and producing a cited Markdown report. Use when the user asks for 投资大V合订本, prediction tracking, forecast verification, or an investment influencer track-record report.
---

# Fluencer Predict Track

## Core Contract

Use a local Chrome/Chromium CDP endpoint to access public pages and interactive login sessions.

Default endpoint:

```text
http://127.0.0.1:15166
```

Override options:

- Environment variable: `FLUENCER_CDP_ENDPOINT`
- Script parameter: `-Endpoint`
- User-provided endpoint in the task

Run the helper script before browsing:

```powershell
.\skills\fluencer-predict-track\scripts\ensure-chrome-cdp.ps1
```

Do not read, export, print, or upload cookies, localStorage, browser profile files, passwords, or storage-state JSON. If a site requires login, ask the user to complete login in the browser window, then continue.

## Workflow

1. Confirm the target page and validation cutoff date. Use the task date unless the user provides another cutoff.
2. Ensure CDP is reachable with `scripts/ensure-chrome-cdp.ps1`.
3. Connect browser automation to the CDP endpoint.
4. Open the target user's public answers page.
5. Prefer first-party page APIs from inside the browser context over scroll scraping. For Zhihu, a typical endpoint is:

   ```text
   https://www.zhihu.com/api/v4/members/<url-token>/answers?offset=0&limit=20&sort_by=created&include=data[*].content,voteup_count,comment_count,created_time,updated_time,question
   ```

6. Collect answer/post URL, title, created time, final updated time, and plain text.
7. Build a candidate pool of prediction-like content. Prefer items with:
   - Explicit future windows: dates, years, quarters, "next year", "by year end", "within months".
   - Verifiable outcomes: prices, index levels, policy events, macro data, company or industry events.
   - Clear direction or threshold: rise/fall, break/not break, happen/not happen, outperform/underperform.
8. Exclude items where:
   - The final edit time is after the predicted event or validation window.
   - The prediction is too vague to verify without inventing criteria.
   - The claim depends mainly on unreadable images.
   - The predicted event is after the cutoff date, unless the user wants `尚未到期` items listed.
9. Select at least 10 verifiable items unless fewer exist. Spread the sample across time instead of taking only recent posts.
10. Validate each selected prediction with external sources. Prefer official or primary data first:
    - Official statistics, central banks, regulators, exchanges, company filings.
    - FRED, BIS, World Bank, IMF, NBS, Federal Reserve, CSRC/CFFEX.
    - Yahoo Finance, Stooq, Trading Economics, or other cited market data when official data is unavailable.
11. Save a Markdown report under:

    ```text
    reports/fluencer-predict-track-<yyyy-mm-dd>-<target>.md
    ```

12. Summarize the result in the final response and link the saved report path.

## Judgment Rubric

- `准确`: Direction and timing are materially correct.
- `部分准确`: Direction is right but timing, magnitude, or scope is meaningfully off.
- `不准确`: Direction, threshold, or event call is materially wrong.
- `无法验证`: Public data is insufficient or the claim lacks measurable criteria.
- `尚未到期`: The prediction target date is after the validation cutoff.

State clearly that sample scores are not statistically valid hit rates unless the user asks for a full audit and the full corpus is actually processed.

## Report Shape

Include:

- Scope, target URL, collection date, validation cutoff date.
- Collection method, CDP endpoint, answer count, and limitations.
- Selection and exclusion rules.
- Table: answer date, final edit date, answer link, prediction paraphrase, validation evidence, sources, and judgment.
- Synthesis: strengths, weaknesses, recurring error modes, and caveats.

Paraphrase answer text. Do not quote long passages from Zhihu or other copyrighted pages.
