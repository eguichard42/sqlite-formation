-- 1. substr extrait une année ISO directement du texte.
SELECT substr(date_commande,1,4) AS annee,count(*) FROM commandes GROUP BY annee ORDER BY annee;

-- 2. HAVING applique le seuil au compteur du groupe.
SELECT client_id,count(*) AS nombre FROM commandes GROUP BY client_id HAVING count(*)>=25 ORDER BY nombre DESC,client_id;

-- 3. FILTER isole les lignes de chaque agrégat.
SELECT substr(date_commande,1,7) AS mois,
       count(*) FILTER (WHERE statut='livree') AS livrees,
       count(*) FILTER (WHERE statut='annulee') AS annulees
FROM commandes GROUP BY mois ORDER BY mois;

-- 4. COUNT(c.id) ignore les lignes nulles de la jointure externe.
SELECT cl.ville,count(c.id) AS commandes FROM clients cl LEFT JOIN commandes c ON c.client_id=cl.id GROUP BY cl.ville ORDER BY cl.ville;

-- 5. Les deux agrégats ont chacun une ligne par commande avant la jointure.
WITH facture AS (
    SELECT commande_id,sum(quantite*prix_centimes) total FROM lignes_commandes GROUP BY commande_id
), reglement AS (
    SELECT commande_id,sum(montant_centimes) total FROM paiements GROUP BY commande_id
)
SELECT c.statut,sum(f.total-coalesce(r.total,0)) AS reste_centimes
FROM commandes c JOIN facture f ON f.commande_id=c.id
LEFT JOIN reglement r ON r.commande_id=c.id
WHERE c.statut<>'annulee' GROUP BY c.statut ORDER BY c.statut;
