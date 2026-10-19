#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! "$1" =~ ^[1-7]$ ]]; then
  echo "Uso: $0 <número del 1 al 7>" >&2
  exit 2
fi

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
query="$(awk -v section="-- $1." '
  index($0, section) == 1 { selected = 1; next }
  selected && /^-- [1-7]\./ { exit }
  selected { print }
' "$project_dir/sql/consultas.sql")"

if [[ -z "$query" ]]; then
  echo "No se encontró la consulta $1." >&2
  exit 1
fi

printf 'Fecha y hora: %s\n' "$(date '+%d/%m/%Y %H:%M:%S %Z')"
printf 'Consulta %s:\n%s\n' "$1" "$query"
if ! docker exec li16-hiveserver2 beeline \
  -u 'jdbc:hive2://localhost:10000/default' \
  --silent=true --outputformat=table -e "$query" 2>/dev/null; then
  echo 'La consulta falló. Revise el estado de Hive con: docker compose ps' >&2
  exit 1
fi
