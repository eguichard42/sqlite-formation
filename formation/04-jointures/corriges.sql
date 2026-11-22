-- 1. Joindre la clé étrangère à la clé primaire.
SELECT p.sku,p.nom,c.nom AS categorie FROM produits p JOIN categories c ON c.id=p.categorie_id ORDER BY p.id;

-- 2. Une commande peut produire plusieurs lignes si elle possède plusieurs paiements.
SELECT c.id,p.id AS paiement,p.montant_centimes FROM commandes c LEFT JOIN paiements p ON p.commande_id=c.id WHERE c.id BETWEEN 1 AND 20 ORDER BY c.id,p.id;

-- 3. NOT EXISTS arrête la recherche au premier résultat.
SELECT id,nom FROM clients cl WHERE NOT EXISTS (SELECT 1 FROM commandes c WHERE c.client_id=cl.id) ORDER BY id;

-- 4. La sous-requête corrélée utilise la catégorie de la ligne externe.
SELECT id,nom,prix_centimes FROM produits p WHERE prix_centimes>(SELECT avg(q.prix_centimes) FROM produits q WHERE q.categorie_id=p.categorie_id) ORDER BY id;

-- 5. La sous-requête scalaire résout les ex æquo par id et renvoie NULL sans achat.
SELECT cl.id,c.id AS commande,c.date_commande
FROM clients cl LEFT JOIN commandes c ON c.id=(
    SELECT x.id FROM commandes x WHERE x.client_id=cl.id AND x.statut<>'annulee'
    ORDER BY x.date_commande DESC,x.id DESC LIMIT 1
) ORDER BY cl.id;
