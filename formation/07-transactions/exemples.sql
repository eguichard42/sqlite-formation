BEGIN IMMEDIATE;
UPDATE produits SET prix_centimes=prix_centimes+100 WHERE id=1 RETURNING id,prix_centimes;
ROLLBACK;
