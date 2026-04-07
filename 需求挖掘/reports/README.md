# reports 目录说明

这个目录用于存放每日自动生成的需求挖掘文档。

## 目录结构
- `更宽方向_iOS原生AI工具需求/`
- `翻新计划_传统工具机会/`
- `赚钱方向_高付费机会/`
- `最终建议汇总/`
- `四周滚动复盘/`
- `今日生成索引_YYYY-MM-DD.md`

## 文件约定
- 每个方向目录下都会生成：
  - `需求挖掘日报_YYYY-MM-DD.md`
  - `需求挖掘运行摘要_YYYY-MM-DD.txt`
- `最终建议汇总/` 下会生成：
  - `最终建议_YYYY-MM-DD.md`
- `四周滚动复盘/` 下会生成：
  - `四周复盘_YYYY-MM-DD.md`

## 手动运行

在项目根目录执行：

```bash
zsh scripts/run_daily_need_mining.sh
```

如果你今天还想额外叠加一个全局关注点，可以带一个参数：

```bash
zsh scripts/run_daily_need_mining.sh "更关注中国大陆可用性和低后端实现"
```

手动生成当天最终建议：

```bash
zsh scripts/run_final_recommendation.sh
```

手动生成当天四周滚动复盘：

```bash
zsh scripts/run_four_week_review.sh
```

默认使用最强模型 `gpt-5.4`。

如果你想临时切换成更省成本的模型，可以这样跑：

```bash
CODEX_MODEL=gpt-5.4-mini zsh scripts/run_daily_need_mining.sh
```

## 说明
- 报告由 Codex CLI 联网搜索后生成。
- 每次运行会同时产出 3 条研究线的日报和摘要。
- 会额外生成一份总索引，方便你快速进入当天三条线的结果。
- `prompts/` 目录下还提供了“最终建议汇总”和“四周滚动复盘”的固定模板，便于自动任务输出结构一致。
- `scripts/` 目录下还提供了手动重跑最终建议和四周复盘的入口。
- 如果当前磁盘不允许直接执行脚本，使用 `zsh scripts/run_daily_need_mining.sh` 最稳。
- 脚本默认最多自动重试 3 次；如果想改重试次数，可设置 `MAX_ATTEMPTS`。
