---
name: zhihu-report-polisher
description: Convert an internal influencer prediction report Markdown into a Zhihu-ready public article draft. Use when the user wants to publish or prepare a consolidated report for Zhihu, especially when the source report contains local paths, Chrome CDP details, report file names, iteration wording, or engineering notes that should not appear in a public article.
---

# Zhihu Report Polisher

Use this skill to turn a local investment-prediction report Markdown into a reader-facing Zhihu article draft. Do not log in to Zhihu or publish anything unless the user explicitly asks in a separate step.

## Output

- Write the public draft under `zhihu/`.
- Name it from the source file stem, ending in `-zhihu.md`.
- `zhihu/` is ignored by git; do not force-add generated drafts unless the user explicitly asks.

## Required Opening

Put `分析对象` immediately after the article title. Then add a short project introduction in the style of:

```markdown
本文由开源项目 `fluencer-predict-track` 辅助生成和整理。项目地址：

https://github.com/wzj998/fluencer-predict-track

这个项目用于采集公开投资/财经账号的历史预测，结合公开数据做复盘，并在可映射到交易标的时生成回测结果。本文不构成投资建议。
```

Then continue with method notes and the main content.

## Rewrite Rules

The Zhihu draft is a polished public article, not an engineering report.

- Keep the useful reader-facing content: headline, target account, sample size, verification cutoff, qualitative conclusions, backtest result, backtest assumptions, limitations, tables needed to understand the backtest, and external sources.
- If backtest metrics are included, preserve position usage information such as average exposure, maximum exposure, average cash ratio, and cash drag. State clearly that annualized return and Sharpe are affected by position usage: accounts with more frequent tradable signals may become more fully invested, while sparse-signal accounts may keep more cash.
- Remove or rewrite implementation details: local file paths, candidate-pool file names, internal report paths, exact CDP endpoint URLs, cookies, browser state, script names, zip/package names, and workspace-specific paths.
- It is acceptable to say "通过本地 Chrome CDP 采集知乎公开回答页", but do not include a concrete local URL such as `127.0.0.1:15166`.
- Do not expose iteration wording such as "上一版", "旧版", "新版", "重新跑", "rerun", or "candidate file". Use "本次样本", "定性复盘", "回测结果", and "预测样本".
- If the source report contains a net-value/equity-curve image, copy the image into `zhihu/assets/` and reference it with Markdown image syntax, for example `![净值曲线](assets/<chart>.png)`. Do not replace generated charts with vague placeholders such as "此处插入".
- Keep public URLs that support verification, including the GitHub project URL, Zhihu answer links, and external data/source URLs.
- Keep financial disclaimers concise: include that the article is a sample review and not investment advice.

## Recommended Article Structure

Use this order unless the user gives a different structure:

1. Article title.
2. Analysis object.
3. Project introduction and GitHub link.
4. `结论先行`.
5. Backtest result, if present.
6. Qualitative review: which areas were more accurate, which were weaker, common error patterns, traceability risk, and pre/post-event caveats.
7. Backtest assumptions and limitations.
8. Backtest tables or compact signal tables, if present.
9. External sources.

Do not include a full prediction-review table when the user has asked not to include it. Prefer compact tables that support the public article's argument.

## Public Draft Checklist

Before finishing, search the generated Markdown for these forbidden patterns:

- `127.0.0.1`
- `localhost`
- `C:\`
- `F:\`
- `reports/`
- `.json`
- `上一版`
- `旧版`
- `新版`
- `rerun`
- `candidate`

If any appear, rewrite or remove them before sending the draft.
