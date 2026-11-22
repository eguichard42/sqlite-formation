SELECT id,client_id,date_commande,
       row_number() OVER (PARTITION BY client_id ORDER BY date_commande,id) AS rang
FROM commandes WHERE client_id IN (1,2) ORDER BY client_id,rang;
