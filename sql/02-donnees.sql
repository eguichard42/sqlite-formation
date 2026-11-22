-- Jeu déterministe, fictif et distribué sur deux années.
INSERT INTO categories VALUES
(1, 'Informatique'), (2, 'Papeterie'), (3, 'Mobilier'),
(4, 'Éclairage'), (5, 'Rangement'), (6, 'Accessoires');

WITH RECURSIVE n(i) AS (VALUES(1) UNION ALL SELECT i+1 FROM n WHERE i<600)
INSERT INTO clients
SELECT i,
       CASE i%5 WHEN 0 THEN 'Camille' WHEN 1 THEN 'Nora' WHEN 2 THEN 'Alex'
                WHEN 3 THEN 'Inès' ELSE 'Lou' END || ' ' ||
       CASE (i/5)%5 WHEN 0 THEN 'Martin' WHEN 1 THEN 'Bernard' WHEN 2 THEN 'Petit'
                    WHEN 3 THEN 'Robert' ELSE 'Richard' END,
       printf('client%04d@example.test', i),
       CASE i%7 WHEN 0 THEN 'Paris' WHEN 1 THEN 'Lyon' WHEN 2 THEN 'Nantes'
                WHEN 3 THEN 'Lille' WHEN 4 THEN 'Bordeaux' WHEN 5 THEN 'Toulouse'
                ELSE 'Marseille' END,
       date('2022-01-01', printf('+%d days', (i*13)%730))
FROM n;

WITH RECURSIVE n(i) AS (VALUES(1) UNION ALL SELECT i+1 FROM n WHERE i<120)
INSERT INTO produits
SELECT i, 1+(i-1)%6, printf('PR-%03d', i),
       CASE (i-1)%6 WHEN 0 THEN 'Clavier' WHEN 1 THEN 'Carnet' WHEN 2 THEN 'Bureau'
                    WHEN 3 THEN 'Lampe' WHEN 4 THEN 'Boîte' ELSE 'Support' END
       || ' modèle ' || printf('%02d', 1+(i-1)/6),
       499+(i*977)%39000, i%17<>0
FROM n;

WITH RECURSIVE n(i) AS (VALUES(1) UNION ALL SELECT i+1 FROM n WHERE i<12000)
INSERT INTO commandes
SELECT i, 1+(i*137+i/521)%520, date('2024-01-01', printf('+%d days', (i*37)%731)),
       CASE i%13 WHEN 0 THEN 'annulee' WHEN 1 THEN 'en_attente' WHEN 2 THEN 'expediee'
                 ELSE 'livree' END
FROM n;

INSERT INTO lignes_commandes
SELECT c.id, p.id, 1+(c.id+k.n)%4, p.prix_centimes
FROM commandes AS c CROSS JOIN (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) AS k
JOIN produits AS p ON p.id=1+(c.id*19+k.n*31)%116
WHERE k.n <= c.id%4;

WITH totaux AS (
    SELECT commande_id, sum(quantite*prix_centimes) AS total
    FROM lignes_commandes GROUP BY commande_id
)
INSERT INTO paiements (commande_id, paye_le, mode, montant_centimes)
SELECT c.id, c.date_commande, CASE c.id%3 WHEN 0 THEN 'carte' WHEN 1 THEN 'virement' ELSE 'paypal' END,
       CASE WHEN c.id%10=0 THEN t.total/2 ELSE t.total END
FROM commandes AS c JOIN totaux AS t ON t.commande_id=c.id
WHERE c.statut IN ('livree', 'expediee')
UNION ALL
SELECT c.id, c.date_commande, 'carte', t.total-t.total/2
FROM commandes AS c JOIN totaux AS t ON t.commande_id=c.id
WHERE c.statut IN ('livree', 'expediee') AND c.id%10=0;
