#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROMPT_TEMPLATE="$ROOT_DIR/prompts/final_recommendation_prompt.md"
OUTPUT_DIR="$ROOT_DIR/reports/最终建议汇总"
TMP_DIR="$(mktemp -d)"

TZ_REGION="Asia/Shanghai"
CODEX_MODEL="${CODEX_MODEL:-gpt-5.4}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-3}"
RUN_DATE="${RUN_DATE:-$(TZ="$TZ_REGION" date +%F)}"
OUTPUT_PATH="$OUTPUT_DIR/最终建议_${RUN_DATE}.md"
LAST_OUTPUT_TMP="$TMP_DIR/final_recommendation_last_output.md"
REPORT_TMP="$TMP_DIR/final_recommendation_report.md"
PROMPT_FILE="$TMP_DIR/final_recommendation_prompt.txt"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

if [[ "${1:-}" == "--dry-run" ]]; then
  echo "ROOT_DIR=$ROOT_DIR"
  echo "PROMPT_TEMPLATE=$PROMPT_TEMPLATE"
  echo "OUTPUT_PATH=$OUTPUT_PATH"
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

mkdir -p "$OUTPUT_DIR"

cat > "$PROMPT_FILE" <<EOF
请在当前工作区生成今天的“最终建议”文档。

必须完成的执行要求：
1. 读取文件 \`$PROMPT_TEMPLATE\` 并严格遵循其中的输入范围、分析目标、输出格式和写作要求。
2. 读取 reports 下三条研究线当天最新的日报与摘要，以及最新的今日生成索引。
3. 分析时必须保留国内与国外两个视角，不能只基于单一地域证据下结论；若某一侧证据明显不足，必须明确标注。
4. 不要创建或修改任何本地文件；请把完整的最终 Markdown 文档直接作为最后一条消息输出。
5. 最终输出只能是文档正文本身，不要加额外前言、解释或致谢。
EOF

echo "开始生成最终建议：$OUTPUT_PATH"

attempt=1
success=0

while [[ $attempt -le $MAX_ATTEMPTS ]]; do
  echo "第 ${attempt}/${MAX_ATTEMPTS} 次尝试..."

  if codex \
    --search \
    exec \
    -m "$CODEX_MODEL" \
    --skip-git-repo-check \
    --full-auto \
    --color never \
    -C "$ROOT_DIR" \
    -o "$LAST_OUTPUT_TMP" \
    - < "$PROMPT_FILE"; then
    if [[ -s "$LAST_OUTPUT_TMP" ]]; then
      mv "$LAST_OUTPUT_TMP" "$REPORT_TMP"
      success=1
      break
    fi
  fi

  echo "第 ${attempt} 次失败，准备重试..."
  attempt=$((attempt + 1))
  sleep 5
done

if [[ $success -ne 1 ]]; then
  echo "最终建议生成失败：连续 ${MAX_ATTEMPTS} 次调用 Codex 未成功完成。"
  exit 1
fi

mv "$REPORT_TMP" "$OUTPUT_PATH"

echo "最终建议完成：$OUTPUT_PATH"
