#!/usr/bin/env bash
set -euo pipefail

# 使い方チェック
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 step5.txt" >&2
  exit 1
fi

IN="$1"
BASENAME="$(basename "$IN" .txt)"
WORKDIR="$(dirname "$IN")"

OUT="${WORKDIR}/${BASENAME}_cleaned.txt"

TMP1="$(mktemp)"
TMP2="$(mktemp)"
TMP3="$(mktemp)"
TMP4="$(mktemp)"

cleanup() {
  rm -f "$TMP1" "$TMP2" "$TMP3"
}
trap cleanup EXIT

########################################
# ① 行番号を振る
#   例: ID \t (元の内容)
########################################
awk '{print NR "\t" $0}' "$IN" > "$TMP1"

########################################
# ② 本文の長さとアルファベット順で並べ替え
#   前提: 最後のフィールド($NF)が本文
########################################
LC_ALL=C.UTF-8 \
awk -F'\t' '{
  text = $NF;                            # 本文
  print length(text) "\t" text "\t" $0;  # 長さ \t 本文 \t 元行
}' "$TMP1" \
  | sort -n -k1,1 -k2,2 \
  | cut -f3- \
  > "$TMP2"

########################################
# ③ 本文が同じ行は最初の1行だけ残す
#   ※同じ本文は②で隣接しているので、隣と比較でOK
########################################
awk -F'\t' '
{
  text = $NF;              # 本文（最後のフィールド）
  if (text != last_text) { # 前の行と本文が違うときだけ出力
    print;
    last_text = text;
  }
}' "$TMP2" > "$TMP3"

########################################
# ④ 本文に "http" を含む行を削除
########################################
awk -F'\t' '$NF !~ /http/ {print}' "$TMP3" > "$TMP4"

########################################
# ⑤ 本文に "www." を含む行を削除（追加）
########################################
awk -F'\t' '$NF !~ /www\./ {print}' "$TMP4" > "$OUT"

echo "Done."
echo "入力:  $IN"
echo "出力:  $OUT"
