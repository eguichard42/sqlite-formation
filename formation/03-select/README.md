# Filtres, tri et pagination


SQLite utilise `LIMIT` avec `OFFSET` là où Oracle et SQL Server proposent `OFFSET … FETCH`. Ajoutez une clé unique au tri pour paginer avec un ordre total. La collation `NOCASE` native plie uniquement les majuscules ASCII. Les dates normalisées permettent des filtres par plage avec bornes semi-ouvertes, qui restent exploitables par un index simple.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Lister les sept villes par ordre alphabétique.
2. Lister les produits actifs entre 20 et 50 euros inclus.
3. Extraire les commandes livrées du premier trimestre 2025.
4. Afficher la deuxième page de dix clients lyonnais par nom puis id.
5. Lire la page qui suit la clé (2025-03-01, 4000) dans le tri date puis id.
