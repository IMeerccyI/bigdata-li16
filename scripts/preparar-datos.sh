#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dataset_dir="$project_dir/datasets"
source_file="$dataset_dir/pseudo_facebook_original.tsv"
target_file="$dataset_dir/pseudo_facebook_nelson.csv"
source_url="https://s3.amazonaws.com/udacity-hosted-downloads/ud651/pseudo_facebook.tsv"

mkdir -p "$dataset_dir"
if [[ ! -s "$source_file" ]]; then
  curl --fail --location --silent --show-error "$source_url" --output "$source_file"
fi

expected_header=$'userid\tage\tdob_day\tdob_year\tdob_month\tgender\ttenure\tfriend_count\tfriendships_initiated\tlikes\tlikes_received\tmobile_likes\tmobile_likes_received\twww_likes\twww_likes_received'
actual_header="$(head -n 1 "$source_file")"
if [[ "$actual_header" != "$expected_header" ]]; then
  echo 'El dataset no tiene las 15 columnas esperadas.' >&2
  exit 1
fi

awk -F '\t' 'NR > 1 && NF != 15 { print "Fila inválida: " NR > "/dev/stderr"; exit 1 }' "$source_file"
tail -n +2 "$source_file" | tr '\t' ',' > "$target_file"

rows="$(wc -l < "$target_file")"
echo "CSV preparado: $target_file ($rows registros, sin encabezado)"
echo "Origen: $source_url"
