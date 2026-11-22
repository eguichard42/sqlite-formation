# Formation SQLite avec Docker

Un laboratoire SQLite pour DBA Oracle et SQL Server. Une seule image fournit le CLI `sqlite3` et l’interface [sqlite-web](https://pypi.org/project/sqlite-web/). Le moteur [SQLite 3.54.1](https://www.sqlite.org/download.html) est commun aux deux outils.

## Prérequis et démarrage

Installez Docker avec le plugin Compose v2, puis démarrez Docker. Le port local 8080 doit être libre. Depuis la racine du dépôt, lancez :

```sh
docker compose up -d --build
docker compose ps
```

Ouvrez [http://localhost:8080](http://localhost:8080). Dans sqlite-web, sélectionnez une table pour consulter ses données ou sa structure. Utilisez l’onglet **Query** pour exécuter du SQL. L’interface permet aussi des écritures. Gardez le port publié sur la boucle locale. Le CLI prend en charge les commandes commençant par un point et permet de garder une connexion ouverte pour les TP.

```sh
docker compose exec sqlite sqlite3 /data/formation.db
```

Dans le CLI, essayez `.headers on`, `.mode box`, `.tables` et `SELECT sqlite_version();`. Tapez `.quit` pour sortir.

`docker compose stop` arrête le service et `docker compose start` le relance. `docker compose down` retire le conteneur et son réseau. Le volume nommé reste en place.

## Structure et données

| Chemin | Contenu |
| --- | --- |
| `Dockerfile`, `docker-compose.yml` | Image, interface web, stockage et contrôle de disponibilité |
| `sql/01-schema.sql`, `sql/02-donnees.sql` | DDL et chargement déterministe |
| `formation/` | Cours, exemples et corrigés commentés |
| `scripts/` | Initialisation, administration et validation |
| `.github/workflows/ghcr.yml` | Validation Docker et publication GHCR |

Le jeu fictif couvre 600 clients, 120 produits, 6 catégories, 12 000 commandes et 30 000 lignes, avec des paiements fractionnés et des clients sans commande. Les prix sont en centimes et les dates en texte ISO. Les connexions de sqlite-web et la configuration du CLI activent les clés étrangères. Pour un client externe, exécutez `PRAGMA foreign_keys=ON;` avant de commencer une transaction.

## Progression pédagogique

| Module | Sujet |
| --- | --- |
| [01](formation/01-introduction/) | Moteur embarqué et catalogue |
| [02](formation/02-types/) | Modèle, types et affinités |
| [03](formation/03-select/) | Filtres, tris et pagination |
| [04](formation/04-jointures/) | Jointures et sous-requêtes |
| [05](formation/05-agregats/) | Agrégations et granularité |
| [06](formation/06-analytiques/) | Fonctions de fenêtre et CTE |
| [07](formation/07-transactions/) | Écritures et transactions |
| [08](formation/08-index/) | Index et plans d’exécution |
| [09](formation/09-wal/) | Verrouillage et WAL |
| [10](formation/10-administration/) | Sauvegarde et maintenance |

Lisez le cours, lancez les exemples et résolvez les cinq exercices avant de consulter le corrigé. Les modules 7 à 10 utilisent une base jetable. Initialisez une copie dans le conteneur et ouvrez-la ainsi :

```sh
docker compose exec sqlite /app/scripts/init.sh /tmp/tp.db
docker compose exec -w /tmp sqlite sqlite3 /tmp/tp.db
```

Dans le CLI, exécutez `.read /app/formation/07-transactions/exemples.sql` puis, pour vérifier vos réponses, `.read /app/formation/07-transactions/corriges.sql`. Le répertoire courant `/tmp` reçoit le fichier créé par le corrigé du module 10. Pour le TP WAL, répétez uniquement la commande qui ouvre le CLI dans le second terminal.

## Persistance et réinitialisation

Le volume `donnees` monte `/data` et contient la base, ses fichiers WAL éventuels et le dossier des sauvegardes. Le premier démarrage charge le schéma et les données et active WAL. Les démarrages suivants réutilisent la base existante.

Pour repartir du jeu initial, exportez d’abord les sauvegardes à conserver selon la procédure ci-dessous. `down --volumes` supprime définitivement la base et les sauvegardes présentes dans ce volume.

```sh
docker compose down --volumes
docker compose up -d --build
```

## Maintenance

```sh
docker compose exec sqlite /app/scripts/admin.sh integrite
docker compose exec sqlite /app/scripts/admin.sh schema
docker compose exec sqlite /app/scripts/admin.sh journal
docker compose exec sqlite /app/scripts/admin.sh analyse
docker compose exec sqlite /app/scripts/admin.sh vacuum
docker compose exec sqlite /app/scripts/admin.sh plans
```

`integrite` vérifie les structures et les références. `schema` liste tables et index. `plans` compare la recherche sur une date avec un filtre qui applique une fonction à la colonne. Planifiez `VACUUM` pendant une période calme, avec suffisamment d’espace libre.

### Sauvegarde et restauration

La commande de sauvegarde utilise `.backup`. Choisissez un nouveau nom à chaque sauvegarde. Exportez la copie hors du volume :

```sh
docker compose exec sqlite /app/scripts/admin.sh sauvegarde formation-01.db
docker compose cp sqlite:/data/sauvegardes/formation-01.db ./formation-01.db
```

La restauration remplace le contenu de la base. Fermez les sessions qui utilisent le fichier, sauvegardez les modifications à conserver, puis arrêtez l’interface avant `.restore` :

```sh
docker compose stop sqlite
docker compose run --rm sqlite /app/scripts/admin.sh restaure formation-01.db
docker compose up -d
docker compose exec sqlite /app/scripts/admin.sh integrite
```

Pour réimporter un fichier exporté, copiez-le dans le dossier des sauvegardes avec `docker compose cp ./formation-01.db sqlite:/data/sauvegardes/formation-01.db` après avoir démarré ou créé le service, puis appliquez la procédure de restauration.

## GitHub Packages

Le workflow vérifie Docker et les scripts sur les pull requests vers `main` et sur les push de publication. Il publie `ghcr.io/<owner>/sqlite-formation:latest` sur `main` et `ghcr.io/<owner>/sqlite-formation:v1.0.0` pour le tag Git `v1.0.0`. Les tags de version laissent `latest` suivre `main`. Le job de publication utilise `GITHUB_TOKEN` avec `contents: read` et `packages: write`. Le package peut être privé et son accès se gère dans les paramètres GitHub Packages. Consultez la [documentation GitHub sur la publication d’images](https://docs.github.com/en/actions/tutorials/publish-packages/publish-docker-images).

```sh
git tag v1.0.0
git push origin v1.0.0
```

Pour utiliser l’image publiée directement, remplacez `mon-compte` par le compte ou l’organisation en minuscules. Le workflow construit l’image sur le runner Linux x86-64. Sur un Mac Apple Silicon, privilégiez le build Compose natif ou ajoutez `--platform linux/amd64` à `docker run`.

```sh
docker run --rm -p 127.0.0.1:8080:8080 -v sqlite-formation-ghcr:/data ghcr.io/mon-compte/sqlite-formation:latest
```

## Validation locale

```sh
docker compose config --quiet
docker compose up -d --build --wait
docker compose exec -T sqlite /app/scripts/validation.sh
```

Le script utilise un répertoire temporaire et vérifie notamment le chargement, le rejet d’une clé étrangère invalide, les 20 fichiers d’exemples et de corrigés, la sauvegarde, la restauration et la conservation d’une modification au second appel de l’initialisation.
