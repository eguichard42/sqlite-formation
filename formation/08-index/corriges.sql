-- 1. UNIQUE crée un index même sans CREATE INDEX explicite.
EXPLAIN QUERY PLAN SELECT nom FROM produits WHERE sku='PR-001';

-- 2. La plage permet une recherche bornée sur idx_commandes_date.
EXPLAIN QUERY PLAN SELECT id FROM commandes WHERE substr(date_commande,1,7)='2025-01';
EXPLAIN QUERY PLAN SELECT id FROM commandes WHERE date_commande>='2025-01-01' AND date_commande<'2025-02-01';

-- 3. Le préfixe client_id est fixé et la plage peut être parcourue en sens inverse.
EXPLAIN QUERY PLAN SELECT id,date_commande FROM commandes WHERE client_id=1 ORDER BY date_commande DESC,id DESC LIMIT 1;

-- 4. La requête reprend l’expression indexée. Le ROLLBACK retire l’index.
BEGIN;
CREATE INDEX idx_demo_mois ON commandes(substr(date_commande,1,7));
EXPLAIN QUERY PLAN SELECT id FROM commandes WHERE substr(date_commande,1,7)='2025-01';
ROLLBACK;

-- 5. Le prédicat de la requête implique celui de l’index partiel.
BEGIN;
CREATE INDEX idx_demo_attente ON commandes(date_commande) WHERE statut='en_attente';
EXPLAIN QUERY PLAN SELECT id,date_commande FROM commandes
WHERE statut='en_attente' AND date_commande>='2025-01-01' ORDER BY date_commande,id;
ROLLBACK;
