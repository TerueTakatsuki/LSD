#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 input.txt"
    exit 1
fi

input="$1"

awk -F'\t' '{
    # URL削除
   gsub(/((https?|ftp):\/\/|www\.)[^ \t")]+/, "", $2)

    # メールアドレス削除
    gsub(/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/, "", $2)

    # 余分なスペース整理
    gsub(/  +/, " ", $2)

    print $1 "\t" $2
}' "$input"
