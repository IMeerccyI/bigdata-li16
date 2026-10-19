#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"

if [[ ! -s datasets/pseudo_facebook_nelson.csv ]]; then
  ./scripts/preparar-datos.sh
fi

operation_log="$(mktemp)"
trap 'rm -f "$operation_log"' EXIT
quiet() {
  if ! "$@" >"$operation_log" 2>&1; then
    tail -n 30 "$operation_log" >&2
    return 1
  fi
}

printf '1/4 Iniciando HDFS y Hive...\n'
quiet docker compose up -d --wait
printf '2/4 Copiando CSV al NameNode y a HDFS...\n'
quiet docker cp datasets/pseudo_facebook_nelson.csv li16-namenode:/tmp/pseudo_facebook_nelson.csv
quiet docker exec li16-namenode hdfs dfs -mkdir -p /user/hive/warehouse
quiet docker exec li16-namenode hdfs dfs -put -f /tmp/pseudo_facebook_nelson.csv /user/hive/warehouse/
printf 'Archivo: /user/hive/warehouse/pseudo_facebook_nelson.csv\n'
printf '3/4 Creando la tabla y cargando el CSV en Hive...\n'
if ! docker exec li16-hiveserver2 beeline \
  -u 'jdbc:hive2://localhost:10000/default' \
  --silent=true -f /opt/hive/queries/crear-tabla.sql >"$operation_log" 2>&1; then
  tail -n 30 "$operation_log" >&2
  exit 1
fi
printf '4/4 Comprobando el total de filas...\n'
docker exec li16-hiveserver2 beeline \
  -u 'jdbc:hive2://localhost:10000/default' \
  --silent=true -e 'SELECT COUNT(*) AS total_usuarios FROM db_nelson.fb_nelson;' 2>/dev/null
