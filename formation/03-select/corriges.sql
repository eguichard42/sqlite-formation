-- 1. DISTINCT élimine les doublons avant le tri.
SELECT DISTINCT ville FROM clients ORDER BY ville;

-- 2. BETWEEN inclut ses deux bornes.
SELECT sku, nom, prix_centimes FROM produits WHERE actif=1 AND prix_centimes BETWEEN 2000 AND 5000 ORDER BY prix_centimes, id;

-- 3. Une plage ISO semi-ouverte couvre le trimestre.
SELECT id, date_commande FROM commandes WHERE statut='livree' AND date_commande>='2025-01-01' AND date_commande<'2025-04-01' ORDER BY date_commande,id;

-- 4. OFFSET 10 saute la première page.
SELECT id, nom FROM clients WHERE ville='Lyon' ORDER BY nom,id LIMIT 10 OFFSET 10;

-- 5. La comparaison de tuples permet la pagination par curseur.
SELECT id,date_commande FROM commandes WHERE (date_commande,id)>('2025-03-01',4000) ORDER BY date_commande,id LIMIT 10;
