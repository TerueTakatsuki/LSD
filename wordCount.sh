#!/usr/bin/env bash
set -euo pipefail

# 引数チェック
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 filename" >&2
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

# 全単語数
TOTAL_WORDS=$(wc -w < "$FILE")

# 行数（= PMID数）
LINE_COUNT=$(wc -l < "$FILE")

# PMIDを除いた単語数
TEXT_WORDS=$((TOTAL_WORDS - LINE_COUNT))

echo "Total words: $TOTAL_WORDS"
echo "PMID count (lines): $LINE_COUNT"
echo "Text word count: $TEXT_WORDS"