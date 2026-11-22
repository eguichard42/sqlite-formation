# Fenêtres et CTE


Une fenêtre conserve les lignes et calcule une valeur dans chaque partition. Le cadre implicite d’une fenêtre ordonnée est `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, incluant les ex æquo. Spécifiez `ROWS` pour un cumul ligne par ligne. Une CTE peut être intégrée ou matérialisée par le planificateur. SQLite écrit `WITH RECURSIVE`, tandis que SQL Server omet `RECURSIVE` et Oracle exige notamment les alias de colonnes pour sa factorisation récursive.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Classer les produits selon leur prix dans chaque catégorie, avec ex æquo.
2. Comparer chaque achat du client 1 au précédent en jours.
3. Afficher les trois derniers achats de chaque client.
4. Calculer le cumul des montants encaissés jour par jour en 2025.
5. Générer les 31 dates de janvier 2025 et compter les commandes, zéros compris.
