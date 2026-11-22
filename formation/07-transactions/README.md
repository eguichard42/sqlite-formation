# Écritures et transactions


Chaque instruction autonome s’exécute dans une transaction implicite. `BEGIN IMMEDIATE` réserve le droit d’écriture dès le début. `SAVEPOINT` et `ROLLBACK TO` permettent une annulation partielle. Après `ROLLBACK TO`, libérez le point avec `RELEASE`. SQLite propose `ON CONFLICT … DO UPDATE` pour l’upsert, à distinguer de `MERGE`. Les corrigés des modules 7 à 10 sont destinés à un fichier jetable. Utilisez le CLI pour conserver une même connexion sur toutes les instructions.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Insérer un client et récupérer sa clé, puis annuler.
2. Désactiver les produits de la catégorie 2, afficher le nombre modifié, puis annuler.
3. Supprimer les lignes d’une commande annulée via cascade, contrôler puis annuler.
4. Simuler une hausse de prix puis annuler uniquement une seconde hausse.
5. Simuler un upsert du SKU PR-001 puis annuler.
