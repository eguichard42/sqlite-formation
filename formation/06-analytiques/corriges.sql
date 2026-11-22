-- 1. DENSE_RANK conserve des rangs consécutifs.
SELECT sku,categorie_id,dense_rank() OVER (PARTITION BY categorie_id ORDER BY prix_centimes DESC) AS rang FROM produits ORDER BY categorie_id,rang,sku;

-- 2. LAG lit la date précédente et julianday permet la soustraction.
SELECT id,date_commande,julianday(date_commande)-julianday(lag(date_commande) OVER (ORDER BY date_commande,id)) AS ecart FROM commandes WHERE client_id=1 ORDER BY date_commande,id;

-- 3. Calculez le rang dans une CTE avant de filtrer.
WITH rangs AS (
    SELECT id,client_id,date_commande,row_number() OVER (
        PARTITION BY client_id ORDER BY date_commande DESC,id DESC
    ) AS rang FROM commandes
)
SELECT * FROM rangs WHERE rang<=3 ORDER BY client_id,rang;

-- 4. Agrégat quotidien, puis fenêtre ROWS sur cette granularité.
WITH jours AS (
    SELECT paye_le,sum(montant_centimes) AS total FROM paiements
    WHERE paye_le>='2025-01-01' AND paye_le<'2026-01-01' GROUP BY paye_le
)
SELECT paye_le,total,sum(total) OVER (ORDER BY paye_le ROWS UNBOUNDED PRECEDING) AS cumul
FROM jours ORDER BY paye_le;

-- 5. La condition borne la récursion et LEFT JOIN conserve le calendrier.
WITH RECURSIVE calendrier(jour) AS (
    VALUES('2025-01-01')
    UNION ALL SELECT date(jour,'+1 day') FROM calendrier WHERE jour<'2025-01-31'
)
SELECT jour,count(c.id) FROM calendrier LEFT JOIN commandes c ON c.date_commande=jour
GROUP BY jour ORDER BY jour;
