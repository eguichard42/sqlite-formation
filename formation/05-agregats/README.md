# Agrégations et granularité


`WHERE` filtre les lignes et `HAVING` les groupes. `COUNT(x)` ignore les NULL. `SUM` retourne NULL sur un ensemble vide, et `total()` retourne 0.0 en REAL. SQLite permet des colonnes non agrégées hors du `GROUP BY`, avec un choix généralement arbitraire de ligne. Écrivez un regroupement explicite pour obtenir des résultats déterministes et portables. Agrégez les lignes et les paiements séparément pour éviter de multiplier les deux ensembles enfants.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Compter les commandes par année.
2. Trouver les clients ayant au moins 25 commandes.
3. Ventiler les commandes livrées et annulées par mois.
4. Compter les commandes par ville y compris les clients sans achat.
5. Calculer le reste à payer par statut pour toutes les commandes non annulées.
