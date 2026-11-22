#!/bin/sh
set -eu

racine=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
temp=$(mktemp -d)
trap 'rm -rf -- "$temp"' EXIT
trap 'exit 1' HUP INT TERM
cd "$temp"
db="$temp/formation.db"
export FORMATION_DB="$db" FORMATION_SAUVEGARDES="$temp/sauvegardes"

cli() {
    sqlite3 -batch -bail -init /dev/null -cmd 'PRAGMA foreign_keys=ON;' "$db" "$@"
}
admin() {
    "$racine/scripts/admin.sh" "$@"
}

"$racine/scripts/init.sh" "$db"
[ "$(admin journal)" = wal ]
[ "$(cli 'SELECT count(*) FROM commandes;')" = 12000 ]
[ "$(cli 'SELECT count(*) FROM lignes_commandes;')" = 30000 ]
admin integrite
if cli "INSERT INTO commandes VALUES (-1,-1,'2025-01-01','livree');" > erreur.log 2>&1; then
    printf 'Une référence invalide a été acceptée\n' >&2
    exit 1
fi
grep -q 'FOREIGN KEY constraint failed' erreur.log
for module in "$racine"/formation/*/; do
    for fichier in exemples corriges; do
        cli ".read \"$module$fichier.sql\"" > "$fichier.log"
    done
    printf 'SQL exécuté : %s\n' "$(basename "$module")"
done

admin sauvegarde validation.db
prix=$(cli 'SELECT prix_centimes FROM produits WHERE id=1;')
cli 'UPDATE produits SET prix_centimes=prix_centimes+100 WHERE id=1;'
"$racine/scripts/init.sh" "$db"
[ "$(cli 'SELECT prix_centimes FROM produits WHERE id=1;')" = "$((prix+100))" ]
admin restaure validation.db
[ "$(cli 'SELECT prix_centimes FROM produits WHERE id=1;')" = "$prix" ]
admin analyse
admin vacuum
admin schema
admin plans
admin integrite
