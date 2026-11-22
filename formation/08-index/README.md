# Index et plans d’exécution


`EXPLAIN QUERY PLAN` décrit les accès et l’ordre des boucles. `SEARCH` signale une recherche bornée. `SCAN` indique un parcours, éventuellement via index. `COVERING INDEX` évite de relire la table si l’index contient les colonnes demandées. `USE TEMP B-TREE` indique une structure de tri ou de regroupement. Comme dans Oracle ou SQL Server, la sélectivité compte. Ici, `ANALYZE` renseigne `sqlite_stat1` et le détail textuel du plan peut évoluer entre versions.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Identifier l’accès utilisé pour un SKU exact.
2. Comparer substr et une plage de dates pour janvier 2025.
3. Vérifier si le dernier achat d’un client nécessite un tri.
4. Construire et essayer un index d’expression pour le mois.
5. Essayer un index partiel pour les commandes en attente triées par date.
