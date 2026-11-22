# Modèle relationnel et types


SQLite distingue cinq classes de stockage (`NULL`, `INTEGER`, `REAL`, `TEXT`, `BLOB`). `typeof()` inspecte la valeur. Les affinités contrôlent les conversions. Les tables `STRICT` acceptent les conversions sans perte vers le type déclaré et les contraintes `CHECK` contrôlent le domaine.

Le modèle relie clients et commandes, catégories et produits, commandes et paiements. Les lignes modélisent la relation N:N entre commandes et produits et mémorisent le prix historique. `INTEGER PRIMARY KEY` alias du rowid remplace ici les identités ou séquences. La table des lignes utilise la clé composite comme clé physique avec `WITHOUT ROWID`. Les dates ISO se trient lexicalement et les centimes entiers conservent l’exactitude de calcul offerte par `NUMBER` ou `DECIMAL` dans les autres moteurs.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Identifier les types stockés d’une date et d’un prix.
2. Comparer division entière et réelle sur le prix du premier produit.
3. Lister les composantes de la clé primaire des lignes dans leur ordre.
4. Observer l’affinité INTEGER en insérant le texte 0042 puis une valeur invalide ignorée.
5. Vérifier le contrôle des dates civiles à partir de deux fins de février.
