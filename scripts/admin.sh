#!/bin/sh
set -eu

db=${FORMATION_DB:-/data/formation.db}
dossier=${FORMATION_SAUVEGARDES:-/data/sauvegardes}
racine=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)

cli() {
    sqlite3 -batch -bail -init "$racine/scripts/sqlite.rc" "$@"
}
erreur() {
    printf '%s\n' "$*" >&2
    exit 1
}
verifier() {
    [ "$(cli -readonly "$1" 'PRAGMA integrity_check;')" = ok ] ||
        erreur "Échec de integrity_check pour $1"
    [ -z "$(cli -readonly "$1" 'PRAGMA foreign_key_check;')" ] ||
        erreur "Clés étrangères invalides dans $1"
    printf 'Intégrité et clés étrangères OK\n'
}

[ -s "$db" ] || erreur "Base absente ou vide : $db"
case "${1:-}" in
    sauvegarde|restaure)
        [ "$#" -eq 2 ] || erreur 'Indiquer un nom de sauvegarde *.db'
        case "$2" in
            *[!A-Za-z0-9._-]*|.*) erreur 'Nom de sauvegarde invalide' ;;
            *.db) ;;
            *) erreur 'Extension .db requise' ;;
        esac
        fichier="$dossier/$2"
        if [ "$1" = sauvegarde ]; then
            mkdir -p "$dossier"
            temp=$(mktemp -d "$dossier/.sauvegarde.XXXXXX")
            trap 'rm -rf -- "$temp"' EXIT
            trap 'exit 1' HUP INT TERM
            cli -readonly "$db" ".backup \"$temp/copie.db\""
            verifier "$temp/copie.db"
            ln "$temp/copie.db" "$fichier"
            printf '%s\n' "$fichier"
        else
            [ -s "$fichier" ] || erreur "Sauvegarde absente ou vide : $fichier"
            verifier "$fichier"
            [ "$(cli -readonly "$fichier" "SELECT count(*) FROM sqlite_schema WHERE type='table' AND name IN ('clients','produits','categories','commandes','lignes_commandes','paiements');")" = 6 ] ||
                erreur 'Schéma de formation absent'
            cli "$db" ".restore \"$fichier\""
            verifier "$db"
        fi
        ;;
    integrite) verifier "$db" ;;
    schema) cli -readonly "$db" '.tables' '.indexes' ;;
    journal) cli -readonly "$db" 'PRAGMA journal_mode;' ;;
    analyse) cli "$db" 'ANALYZE;' ;;
    vacuum) cli "$db" 'VACUUM;' ;;
    plans) cli -readonly "$db" ".read \"$racine/formation/08-index/exemples.sql\"" ;;
    *) erreur 'Usage : admin.sh sauvegarde NOM.db | restaure NOM.db | integrite | schema | journal | analyse | vacuum | plans' ;;
esac
