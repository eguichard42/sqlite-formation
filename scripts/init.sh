#!/bin/sh
set -eu

db=${1:-/data/formation.db}
case "$db" in /*) ;; *) db="$PWD/$db" ;; esac
racine=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
[ ! -e "$db" ] || exit 0
temp=$(mktemp -d "${db%/*}/.initialisation.XXXXXX")
trap 'rm -rf -- "$temp"' EXIT
trap 'exit 1' HUP INT TERM

sqlite3 -batch -bail -init /dev/null "$temp/formation.db" <<SQL
PRAGMA foreign_keys = ON;
BEGIN;
.read "$racine/sql/01-schema.sql"
.read "$racine/sql/02-donnees.sql"
COMMIT;
PRAGMA journal_mode = WAL;
SQL
# Le lien publie le fichier complet sans écraser une initialisation concurrente.
if ! ln "$temp/formation.db" "$db"; then
    [ -f "$db" ]
fi
