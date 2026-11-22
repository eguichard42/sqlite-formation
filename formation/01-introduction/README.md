# SQLite embarqué


SQLite s’exécute dans le processus du client. Le fichier contient le schéma et les données. Les verrous passent par le VFS et le système de fichiers. Oracle et SQL Server arbitrent les sessions et autorisations au niveau du serveur. Ici, les permissions du système de fichiers protègent la base, et chaque connexion possède ses propres réglages, dont `foreign_keys` et `busy_timeout`.

Le shell `sqlite3` fournit des commandes comme `.tables` et `.schema`. En SQL, utilisez `sqlite_schema`, qui joue ici une partie du rôle de `USER_OBJECTS` et `sys.objects`. Le schéma principal s’appelle `main`.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Relever la version du moteur.
2. Afficher les bases attachées et le chemin de main.
3. Compter les tables applicatives.
4. Récupérer le DDL de commandes.
5. Inventorier les clés étrangères sortant de chaque table.
