SELECT c.id, cl.nom, c.date_commande
FROM commandes AS c JOIN clients AS cl ON cl.id=c.client_id
ORDER BY c.id LIMIT 5;
