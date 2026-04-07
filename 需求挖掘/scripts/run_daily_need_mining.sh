#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROMPT_TEMPLATE="$ROOT_DIR/prompts/daily_need_mining_prompt.md"
REPORTS_DIR="$ROOT_DIR/reports"
TMP_DIR="$(mktemp -d)"

TZ_REGION="Asia/Shanghai"
CODEX_MODEL="${CODEX_MODEL:-gpt-5.4}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-3}"
RUN_DATE="${RUN_DATE:-$(TZ="$TZ_REGION" date +%F)}"
GLOBAL_EXTRA_FOCUS="${*:-}"
ONLY_TRACK="${ONLY_TRACK:-}"
INDEX_PATH="$REPORTS_DIR/今日生成索引_${RUN_DATE}.md"

TRACK_LABELS=(
  "更宽方向"
  "翻新计划"
  "赚钱方向"
)

TRACK_FOLDERS=(
  "更宽方向_iOS原生AI工具需求"
  "翻新计划_传统工具机会"
  "赚钱方向_高付费机会"
)

TRACK_FOCUSES=(
  "优先挖掘 iOS 原生 AI 工具类 App 需求，重点关注主动搜索需求明确、低后端依赖、1-2 人可做的方向，并生成当天的需求挖掘日报与摘要"
  "优先挖掘适合 iOS 原生 AI 翻新计划的传统工具类机会，重点关注可被本地智能重做的高频工作流，并生成当天的需求挖掘日报与摘要"
  "优先挖掘付费链路清晰、能靠搜索分发启动、4-8 周可做 MVP 的 iOS 原生 AI 工具方向，并生成当天的需求挖掘日报与摘要"
)

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

if [[ "${1:-}" == "--dry-run" ]]; then
  echo "ROOT_DIR=$ROOT_DIR"
  echo "PROMPT_TEMPLATE=$PROMPT_TEMPLATE"
  echo "INDEX_PATH=$INDEX_PATH"
  integer i=1
  while [[ $i -le ${#TRACK_LABELS[@]} ]]; do
    folder="$REPORTS_DIR/${TRACK_FOLDERS[$i]}"
    echo "TRACK_LABEL=${TRACK_LABELS[$i]}"
    echo "TRACK_FOLDER=$folder"
    echo "REPORT_PATH=$folder/需求挖掘日报_${RUN_DATE}.md"
    echo "SUMMARY_PATH=$folder/需求挖掘运行摘要_${RUN_DATE}.txt"
    i=$((i + 1))
  done
  exit 0
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "未找到 codex 命令，请先安装或确认 Codex app/CLI 可用。"
  exit 1
fi

if [[ ! -f "$PROMPT_TEMPLATE" ]]; then
  echo "提示词模板不存在：$PROMPT_TEMPLATE"
  exit 1
fi

mkdir -p "$REPORTS_DIR"

run_track() {
  local track_label="$1"
  local track_folder="$2"
  local track_focus="$3"
  local folder_path="$REPORTS_DIR/$track_folder"
  local report_path="$folder_path/需求挖掘日报_${RUN_DATE}.md"
  local summary_path="$folder_path/需求挖掘运行摘要_${RUN_DATE}.txt"
  local prompt_file="$TMP_DIR/${track_label}_prompt.txt"
  local report_tmp="$TMP_DIR/${track_label}_report.md"
  local last_output_tmp="$TMP_DIR/${track_label}_last_output.md"
  local attempt=1
  local success=0

  mkdir -p "$folder_path"

  cat > "$prompt_file" <<EOF
请在当前工作区完成今天的 iOS 原生 AI App 需求挖掘。

必须完成的执行要求：
1. 读取文件 \`$PROMPT_TEMPLATE\` 并严格遵循其中的研究方向、输出结构和写作要求。
2. 使用联网搜索核实最新信息，优先使用官方来源、App Store 页面、公开报告和公司公告。
3. 研究证据必须优先采用“国内 + 国外组合”，尽量同时覆盖中国大陆与海外市场；如果某个方向只能找到单边证据，必须在报告里明确指出。
4. 不要创建或修改任何本地文件；请把完整的最终 Markdown 报告直接作为最后一条消息输出。
5. 最终输出只能是报告正文本身，不要加额外前言、解释或致谢。
6. 报告中所有关键判断都要带出处链接。

今天的研究线：
- $track_focus
EOF

  if [[ -n "$GLOBAL_EXTRA_FOCUS" ]]; then
    cat >> "$prompt_file" <<EOF

全局额外关注点：
- $GLOBAL_EXTRA_FOCUS
EOF
  fi

  echo "开始生成：$track_label"
  echo "输出目录：$folder_path"

  while [[ $attempt -le $MAX_ATTEMPTS ]]; do
    echo "[$track_label] 第 ${attempt}/${MAX_ATTEMPTS} 次尝试..."

    if codex \
      --search \
      exec \
      -m "$CODEX_MODEL" \
      --skip-git-repo-check \
      --full-auto \
      --color never \
      -C "$ROOT_DIR" \
      -o "$last_output_tmp" \
      - < "$prompt_file"; then
      if [[ -s "$last_output_tmp" ]]; then
        mv "$last_output_tmp" "$report_tmp"
        success=1
        break
      fi
    fi

    echo "[$track_label] 第 ${attempt} 次失败，准备重试..."
    attempt=$((attempt + 1))
    sleep 5
  done

  if [[ $success -ne 1 ]]; then
    echo "[$track_label] 生成失败：连续 ${MAX_ATTEMPTS} 次调用 Codex 未成功完成。"
    return 1
  fi

  mv "$report_tmp" "$report_path"

  awk '
    /^## 今日结论摘要/ {capture=1; print; next}
    capture && /^## / {exit}
    capture {print}
  ' "$report_path" > "$summary_path"

  echo "[$track_label] 日报完成：$report_path"
  echo "[$track_label] 摘要完成：$summary_path"
}

echo "# 今日生成索引 - $RUN_DATE" > "$INDEX_PATH"
echo "" >> "$INDEX_PATH"
echo "- 模型：$CODEX_MODEL" >> "$INDEX_PATH"
echo "- 最大重试次数：$MAX_ATTEMPTS" >> "$INDEX_PATH"
if [[ -n "$GLOBAL_EXTRA_FOCUS" ]]; then
  echo "- 全局额外关注点：$GLOBAL_EXTRA_FOCUS" >> "$INDEX_PATH"
fi
echo "" >> "$INDEX_PATH"

typeset -a GENERATED_TRACKS
typeset -a FAILED_TRACKS

integer i=1
while [[ $i -le ${#TRACK_LABELS[@]} ]]; do
  if [[ -n "$ONLY_TRACK" && "${TRACK_LABELS[$i]}" != "$ONLY_TRACK" && "${TRACK_FOLDERS[$i]}" != "$ONLY_TRACK" ]]; then
    i=$((i + 1))
    continue
  fi

  if run_track "${TRACK_LABELS[$i]}" "${TRACK_FOLDERS[$i]}" "${TRACK_FOCUSES[$i]}"; then
    GENERATED_TRACKS+=("${TRACK_LABELS[$i]}")
    echo "## ${TRACK_LABELS[$i]}" >> "$INDEX_PATH"
    echo "" >> "$INDEX_PATH"
    echo "- 状态：成功" >> "$INDEX_PATH"
    echo "- 目录：\`${REPORTS_DIR}/${TRACK_FOLDERS[$i]}\`" >> "$INDEX_PATH"
    echo "- 日报：\`${REPORTS_DIR}/${TRACK_FOLDERS[$i]}/需求挖掘日报_${RUN_DATE}.md\`" >> "$INDEX_PATH"
    echo "- 摘要：\`${REPORTS_DIR}/${TRACK_FOLDERS[$i]}/需求挖掘运行摘要_${RUN_DATE}.txt\`" >> "$INDEX_PATH"
    echo "" >> "$INDEX_PATH"
  else
    FAILED_TRACKS+=("${TRACK_LABELS[$i]}")
    echo "## ${TRACK_LABELS[$i]}" >> "$INDEX_PATH"
    echo "" >> "$INDEX_PATH"
    echo "- 状态：失败" >> "$INDEX_PATH"
    echo "- 目录：\`${REPORTS_DIR}/${TRACK_FOLDERS[$i]}\`" >> "$INDEX_PATH"
    echo "" >> "$INDEX_PATH"
  fi

  i=$((i + 1))
done

echo "全部完成。索引文件：$INDEX_PATH"

if [[ ${#FAILED_TRACKS[@]} -gt 0 ]]; then
  echo "以下研究线生成失败：${(j:, :)FAILED_TRACKS}"
  exit 1
fi
