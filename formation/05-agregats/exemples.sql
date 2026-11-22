SELECT statut,count(*) AS nombre FROM commandes GROUP BY statut ORDER BY nombre DESC;
