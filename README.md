# 投资大V合订本

`fluencer-predict-track` 是一个可供 Codex、Claude Code 和 Cursor 使用的投资预测复盘 skill/rule，用于回看投资/财经大 V 的公开历史发言，筛选其中可验证的预测内容，并用公开数据验证预测准确性。

它适合用来做“合订本”式复盘：不是摘录观点，而是检查这些观点在当时是否早于事件发生、是否可量化验证、最终是否被数据支持。

## 功能

- 通过本机 Chrome/Chromium CDP 访问可能需要交互式登录的公开页面。
- 支持从知乎回答页、类似公开回答列表，或用户提供的用户名开始采集。
- 如果用户只提供用户名，会以搜索结果最靠前且确实发表过投资/财经观点的账号为准。
- 提取回答元数据：链接、标题、创建时间、最后编辑时间和正文。
- 优先为每个目标筛选至少 20 条预测性内容；多目标任务按目标分别计数，并尽量覆盖不同时间跨度。
- 排除最后编辑时间晚于预测事件的内容。
- 使用公开数据源验证结果，例如央行、监管机构、交易所、官方统计、FRED、BIS、World Bank、Yahoo Finance、Stooq、Trading Economics 等。
- 输出带来源、带判定、且包含充分结果总结的 Markdown 报告；总结应覆盖判定分布、强弱项、误判模式、可追溯性风险和尚未到期样本影响。
- 支持把可交易预测转换为回测信号：默认初始本金 1,000,000，按语气强弱分配仓位，尽量获取标的历史数据，输出复利年化收益，并使用默认年化无风险利率 2.8% 计算夏普，绘制净值曲线并嵌入 Markdown 报告。报告会说明是否强制满仓、现金闲置、现金不足缩仓和再平衡规则；若基于定性复盘追加回测，会合并为一个 Markdown，并保留领域强弱、误判模式和马前炮/马后炮风险等定性分析，但不输出预测复盘表，也不出现“上一版/旧版/新版”等迭代措辞。

## 目录结构

```text
.claude/
  skills/
    fluencer-predict-track/
      SKILL.md
.cursor/
  rules/
    fluencer-predict-track.mdc
skills/
  fluencer-predict-track/
    SKILL.md
    agents/
      openai.yaml
    scripts/
      ensure-chrome-cdp.ps1
```

## 安装

仓库内已经同步维护三种 Agent 入口：

### Codex

使用 Codex skill：

```text
skills/fluencer-predict-track/
```

### Claude Code

使用 Claude Code skill：

```text
.claude/skills/fluencer-predict-track/
```

### Cursor

使用 Cursor rule：

```text
.cursor/rules/fluencer-predict-track.mdc
```

三份入口应保持同一套核心规则：每个目标至少 20 条预测样本、多目标分别计数、最后编辑时间检查、外部数据验证、可选回测净值曲线、复利年化收益与夏普指标，以及 Markdown 报告中的充分结果总结。

如果是在已有定性复盘基础上追加回测，最终报告应合并成一个 Markdown 文件：先写回测结果，再写定性复盘结论，然后写回测表格和主要外部来源；不要输出预测复盘表，也不要出现“上一版/旧版/新版”等迭代措辞。

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
