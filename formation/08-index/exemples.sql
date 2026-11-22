EXPLAIN QUERY PLAN SELECT id FROM commandes WHERE date_commande='2025-01-04';
EXPLAIN QUERY PLAN SELECT id FROM commandes WHERE substr(date_commande,1,7)='2025-01';
