# Verrouillage et journal WAL


En WAL, les transactions écrivent des pages dans le journal à côté du fichier principal. Les lecteurs gardent leur instantané et SQLite sérialise les écrivains. Un lecteur prolongé peut retarder la réutilisation du journal. SQL Server avec RCSI et Oracle fournissent aussi des lectures cohérentes, avec des mécanismes distincts de versions de lignes ou d’undo. `busy_timeout` définit l’attente par connexion. Une promotion d’un instantané devenu obsolète peut donner `SQLITE_BUSY_SNAPSHOT` et imposer de recommencer la transaction.

Pour le TP à deux sessions, ouvrez deux terminaux sur la **même copie** en WAL. Dans A, exécutez `BEGIN IMMEDIATE; UPDATE produits SET actif=0 WHERE id=1;`. Dans B, lisez `SELECT actif FROM produits WHERE id=1;`, puis réglez `PRAGMA busy_timeout=100;` et essayez `BEGIN IMMEDIATE;` (erreur attendue). Exécutez `ROLLBACK;` dans A, puis retentez dans B et terminez par `ROLLBACK;`. Pour tester l’instantané, démarrez une transaction différée avec un SELECT dans A, validez un UPDATE dans B, puis relisez dans A avant et après ROLLBACK.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Lire le mode du fichier.
2. Régler puis relire un délai de 250 ms.
3. Désactiver l’auto-checkpoint sur cette connexion puis rétablir 1 000 pages.
4. Exécuter et interpréter le bilan d’un checkpoint passif.
5. Sur la copie du TP, reproduire la concurrence entre deux écrivains puis tronquer le WAL à libération des verrous.
