# 投资大V合订本 / Fluencer Predict Track

A Codex skill for auditing public forecasts made by investment influencers.

It collects historical public answers or posts, filters verifiable predictions, checks whether the content was last edited before the predicted event, validates outcomes with external data, and produces a cited Markdown report.

## What It Does

- Uses a local Chrome/Chromium CDP endpoint to access pages that may require an interactive login.
- Starts from a Zhihu answers page or a similar public answer list.
- Extracts answer metadata: URL, title, creation time, last edit time, and text.
- Selects at least 10 prediction-like answers when available, spread across different time periods.
- Excludes predictions edited after the predicted event.
- Verifies outcomes with public data sources such as central banks, regulators, exchanges, official statistics, FRED, BIS, World Bank, Yahoo Finance, Stooq, or Trading Economics.
- Saves a Markdown report with sources and a judgment for each prediction.

## Skill Layout

```text
skills/
  fluencer-predict-track/
    SKILL.md
    agents/
      openai.yaml
    scripts/
      ensure-chrome-cdp.ps1
```

## Install

Copy `skills/fluencer-predict-track` into a Codex skills directory or keep this repository available to your agent.

## Chrome CDP

The skill expects a local Chrome/Chromium CDP endpoint.

Default:

```text
http://127.0.0.1:15166
```

You can override it with:

```powershell
$env:FLUENCER_CDP_ENDPOINT = "http://127.0.0.1:9222"
```

or by passing `-Endpoint` to the helper script:

```powershell
.\skills\fluencer-predict-track\scripts\ensure-chrome-cdp.ps1 -Endpoint "http://127.0.0.1:9222"
```

The helper script only checks whether the endpoint is reachable and reports the owner process when the port is occupied. It does not read cookies, localStorage, browser profile files, passwords, or storage-state JSON.

## Example Prompt

```text
Use fluencer-predict-track to analyze https://www.zhihu.com/people/<user-token>/answers.
Select at least 10 predictive answers across time, verify whether each prediction was accurate, and save a cited Markdown report.
```

## Report Output

Reports should be saved under:

```text
reports/fluencer-predict-track-<yyyy-mm-dd>-<target>.md
```

## Topics

`codex-skill`, `forecast-audit`, `finfluencer`, `investment-research`, `zhihu`, `prediction-tracking`, `market-analysis`, `chrome-cdp`, `open-source-ai-tools`

## License

MIT
