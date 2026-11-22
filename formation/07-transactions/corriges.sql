-- 1. RETURNING renvoie la clé générée dans la même instruction.
BEGIN;
INSERT INTO clients(nom,email,ville,inscrit_le)
VALUES('Sophie Test','sophie@example.test','Lille','2025-01-15') RETURNING id;
ROLLBACK;

-- 2. changes() porte sur la dernière instruction d’écriture de la connexion.
BEGIN;
UPDATE produits SET actif=0 WHERE categorie_id=2 AND actif=1;
SELECT changes();
ROLLBACK;

-- 3. La cascade est activée quand foreign_keys vaut 1 avant BEGIN.
PRAGMA foreign_keys=ON;
BEGIN;
DELETE FROM commandes WHERE id=13 AND statut='annulee';
SELECT count(*) FROM lignes_commandes WHERE commande_id=13;
ROLLBACK;

-- 4. Le premier UPDATE reste visible après ROLLBACK TO.
BEGIN IMMEDIATE;
UPDATE produits SET prix_centimes=prix_centimes+100 WHERE id=1;
SAVEPOINT seconde_hausse;
UPDATE produits SET prix_centimes=prix_centimes+200 WHERE id=1;
ROLLBACK TO seconde_hausse;
RELEASE seconde_hausse;
SELECT prix_centimes FROM produits WHERE id=1;
ROLLBACK;

-- 5. excluded indique la valeur de la tentative d’insertion.
BEGIN;
INSERT INTO produits(categorie_id,sku,nom,prix_centimes)
VALUES(1,'PR-001','Clavier test',9999)
ON CONFLICT(sku) DO UPDATE SET prix_centimes=excluded.prix_centimes
RETURNING id,sku,prix_centimes;
ROLLBACK;
