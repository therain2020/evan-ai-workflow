# Evan's AI Workflow

> 我是怎么用 AI 写代码的。原则、流水线、配置文件——按这个顺序。这里面的东西我每天都在跑。
>
> [English Version](README.md)

## 适合谁

已经在用 AI 写代码，想要完整工作流而不仅是零散技巧的开发者。写给问我"你到底怎么用 Claude Code"的同事。

## 章节

| # | 章节 | 一句话 |
|---|------|--------|
| 1 | [快速起步](01-quickstart.md) | 5 分钟拿到一个能跑的 AI 开发环境 |
| 2 | [核心 MCP 服务器](02-core-mcp.md) | 我实际在用的 8 个 MCP 服务器，为什么选它，怎么配 |
| 3 | [日常流水线](03-daily-pipeline.md) | simplify → review → health → qa → ship，一天跑 20 遍的循环 |
| 4 | [调试](04-debugging.md) | 先找根因再写 fix，5 阶段调试循环 |
| 5 | [Agent 编排](05-agent-orchestration.md) | 单 agent 还是多 agent，什么时候拆，怎么协调 |
| 6 | [退化感知](06-degradation.md) | 静默降级比直接炸掉更危险，每个回退都要有信号 |
| 7 | [Skill 设计](07-skill-design.md) | 什么时候值得写个自定义 skill，好的 skill 长什么样 |
| 8 | [构建者心态](08-builders-mindset.md) | AI 心智模型、煮海原则、沟通即技能 |
| 9 | [MCP 基础设施](09-mcp-infrastructure.md) | MCP 作为架构思维——服务器选型与配置原则 |
| 10 | [行为规则](10-behavioral-rules.md) | 我的 AI 在所有项目中遵守的全局规则 |

## 阅读顺序

只想搭环境：第 1 章，然后第 2 章。已经搭好了：第 3 章，然后第 4 章。后面 5-10 章按需跳着读，写 skill 看第 7 章，配规则看第 10 章。

## 配套文件

```
scripts/         install-custom-skills.sh — 一键安装所有自定义 skill
templates/       CLAUDE.md.tmpl, mcp.json.tmpl — 改了就能用的模板
```

## 这些是什么

不是教科书。我对这些东西的看法经常变。变了就跑一遍 `/update-workflow`，仓库自动更新。当活的工作日志读就好。
