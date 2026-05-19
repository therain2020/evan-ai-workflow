# Evan's AI Workflow

> 我是怎么用 AI 写代码的。原则、流水线、配置文件——按这个顺序。这里面的东西我每天都在跑。
>
> [English Version](README.md)

## 适合谁

已经在用 AI 写代码，想要完整工作流而不仅是零散技巧的开发者。写给问我"你到底怎么用 Claude Code"的同事。

## 章节

| # | 章节 | 内容 |
|---|------|------|
| 1 | [快速起步](01-quickstart.md) | 5 分钟搭一个能跑的 AI 开发环境。DeepSeek V4 Pro、Claude Code、MCP 服务器 |
| 2 | [核心 MCP 服务器](02-core-mcp.md) | 我每天在用的 8 个 MCP 服务器：Tavily、MySQL、Playwright、Semantic Scholar 等 |
| 3 | [日常流水线](03-daily-pipeline.md) | simplify → review → health → qa → ship，一天跑 20 遍的循环 |
| 4 | [调试](04-debugging.md) | 先找根因再写修复。5 阶段循环，3 次机会规则 |
| 5 | [Agent 编排](05-agent-orchestration.md) | 单 agent 还是多 agent，什么时候拆，怎么协调，上下文预算 |
| 6 | [退化感知](06-degradation.md) | 静默降级比直接炸掉更危险。每个回退都要有信号、有展示、有日志 |
| 7 | [Skill 设计](07-skill-design.md) | 自定义 skill 长什么样。什么时候值得写，什么时候不用 |
| 8 | [构建者心态](08-builders-mindset.md) | 煮海原则、AI 是无限知识但零常识的初级开发者、CLAUDE.md 是上下文压缩 |
| 9 | [MCP 基础设施](09-mcp-infrastructure.md) | MCP 作为架构思维。服务器选型、配置原则、上架检查清单 |
| 10 | [行为规则](10-behavioral-rules.md) | 我的 AI 在所有项目中遵守的全局 CLAUDE.md |

## 阅读顺序

**只想搭环境：** 第 1 章，然后第 2 章。跑起来再说。

**已经搭好了：** 第 3 章，然后第 4 章。日常循环和出问题怎么办。

后面 5 到 10 章按需跳着读。写 skill 看第 7 章，配规则看第 10 章。不讲究顺序。

## 配套文件

```
scripts/        install-custom-skills.sh — 一键安装我用的自定义 skill
templates/      CLAUDE.md.tmpl、CLAUDE.md.global.tmpl、mcp.json.tmpl — 复制改改就能用
```

## 这个仓库怎么工作的

我用 AI 有自己的一套。什么时候这套东西变了——换了 MCP 服务器、换了模型、某个工作流不再用了——跑一遍 `/update-workflow`。skill 会去读我实际的配置文件，对比这些文档写了什么，然后把不一致的地方修掉。实际行为是真相，文档只是镜像。

不是教科书。一本活的工作日志，追着我实际做的事跑。
