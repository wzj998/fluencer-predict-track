# 投资大V合订本

`fluencer-predict-track` 是一个 Codex skill，用于回看投资/财经大 V 的公开历史发言，筛选其中可验证的预测内容，并用公开数据验证预测准确性。

它适合用来做“合订本”式复盘：不是摘录观点，而是检查这些观点在当时是否早于事件发生、是否可量化验证、最终是否被数据支持。

## 功能

- 通过本机 Chrome/Chromium CDP 访问可能需要交互式登录的公开页面。
- 支持从知乎回答页、类似公开回答列表，或用户提供的用户名开始采集。
- 如果用户只提供用户名，会以搜索结果最靠前且确实发表过投资/财经观点的账号为准。
- 提取回答元数据：链接、标题、创建时间、最后编辑时间和正文。
- 优先为每个目标筛选至少 20 条预测性内容；多目标任务按目标分别计数，并尽量覆盖不同时间跨度。
- 排除最后编辑时间晚于预测事件的内容。
- 使用公开数据源验证结果，例如央行、监管机构、交易所、官方统计、FRED、BIS、World Bank、Yahoo Finance、Stooq、Trading Economics 等。
- 输出带来源、带判定的 Markdown 报告。

## 目录结构

```text
skills/
  fluencer-predict-track/
    SKILL.md
    agents/
      openai.yaml
    scripts/
      ensure-chrome-cdp.ps1
```

## 安装

把 `skills/fluencer-predict-track` 复制到 Codex skills 目录，或让 Agent 能访问本仓库。

### Codex

使用：

```text
skills/fluencer-predict-track/
```

### Claude Code

使用：

```text
.claude/skills/fluencer-predict-track/
```

### Cursor

使用：

```text
.cursor/rules/fluencer-predict-track.mdc
```

## Chrome CDP

本 skill 需要一个本机 Chrome/Chromium CDP endpoint。

默认地址：

```text
http://127.0.0.1:15166
```

可以通过环境变量覆盖：

```powershell
$env:FLUENCER_CDP_ENDPOINT = "http://127.0.0.1:9222"
```

也可以运行脚本时传入 `-Endpoint`：

```powershell
.\skills\fluencer-predict-track\scripts\ensure-chrome-cdp.ps1 -Endpoint "http://127.0.0.1:9222"
```

辅助脚本只检查 endpoint 是否可用，并在端口被占用时报告占用进程。它不会读取 cookie、localStorage、浏览器 profile、密码或 storage-state JSON。

## 示例请求

```text
使用 fluencer-predict-track 分析 https://www.zhihu.com/people/<user-token>/answers。
为每个目标筛选至少 20 条不同时间跨度的预测性回答，验证准确性，并保存带来源的 Markdown 报告。
```

## 报告输出

报告默认保存到：

```text
reports/fluencer-predict-track-<yyyy-mm-dd>-<target>.md
```

## Topics

`codex-skill`, `forecast-audit`, `finfluencer`, `investment-research`, `zhihu`, `prediction-tracking`, `market-analysis`, `chrome-cdp`, `open-source-ai-tools`

## License

MIT
