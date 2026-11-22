-- 1. La date est du texte ISO et le prix un entier.
SELECT typeof(date_commande), typeof(prix_centimes) FROM commandes CROSS JOIN produits LIMIT 1;

-- 2. Le littéral 100.0 entraîne un calcul REAL, adapté à un affichage.
SELECT prix_centimes/100 AS entier, prix_centimes/100.0 AS euros FROM produits WHERE id=1;

-- 3. pk est la position dans la clé composite et zéro pour les autres colonnes.
SELECT name, pk FROM pragma_table_info('lignes_commandes') WHERE pk>0 ORDER BY pk;

-- 4. STRICT convertit 0042 en entier. Le CHECK filtre zéro avec OR IGNORE.
CREATE TEMP TABLE demo_type(valeur INTEGER CHECK(valeur>0)) STRICT;
INSERT INTO demo_type VALUES ('0042');
INSERT OR IGNORE INTO demo_type VALUES (0);
SELECT valeur, typeof(valeur) FROM demo_type;
DROP TABLE demo_type;

-- 5. Le modificateur normalise la date. IS compare aussi correctement un NULL éventuel.
WITH dates(jour) AS (VALUES ('2024-02-29'), ('2025-02-29'))
SELECT jour, date(jour, '+0 days') IS jour AS valide FROM dates;
