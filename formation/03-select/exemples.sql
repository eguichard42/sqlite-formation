SELECT id, date_commande FROM commandes WHERE date_commande >= '2025-01-01' AND date_commande < '2025-02-01' ORDER BY date_commande DESC, id DESC LIMIT 5;
