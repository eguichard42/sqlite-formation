-- 1. Le produit donne la taille logique du fichier principal, hors journal.
SELECT page_size,page_count,page_size*page_count AS octets FROM pragma_page_size CROSS JOIN pragma_page_count;

-- 2. On attend ok, puis aucune ligne.
PRAGMA integrity_check;
PRAGMA foreign_key_check;

-- 3. La première valeur de stat correspond au nombre de lignes de l’index.
ANALYZE;
SELECT idx,stat FROM sqlite_stat1 WHERE tbl='commandes' ORDER BY idx;

-- 4. VACUUM ne s’exécute pas dans un BEGIN explicite.
PRAGMA freelist_count;
VACUUM;
PRAGMA freelist_count;

-- 5. Les lignes préfixées par un point sont des commandes du CLI. La restauration ramène le prix initial.
SELECT prix_centimes FROM produits WHERE id=1;
.backup ./instantane-exercice-10.db
UPDATE produits SET prix_centimes=prix_centimes+100 WHERE id=1;
SELECT prix_centimes FROM produits WHERE id=1;
.restore ./instantane-exercice-10.db
SELECT prix_centimes FROM produits WHERE id=1;
PRAGMA integrity_check;
