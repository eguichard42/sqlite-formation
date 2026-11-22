# Jointures et sous-requêtes


Le moteur exécute les jointures par boucles imbriquées. Les index sur les clés de jointure et les statistiques orientent leur ordre. Un prédicat placé dans `ON` préserve le côté gauche d’une jointure externe. Placez-le dans `WHERE` pour filtrer le résultat. `NOT EXISTS` exprime une anti-jointure indépendante de la présence de valeurs NULL côté droit.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Associer chaque produit à sa catégorie.
2. Afficher toutes les commandes 1 à 20 et leurs paiements éventuels.
3. Lister les clients sans aucune commande.
4. Lister les produits plus chers que la moyenne de leur catégorie.
5. Retourner le dernier achat non annulé de chaque client, y compris les clients sans achat.
