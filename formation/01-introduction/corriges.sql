-- 1. La version est celle de la bibliothèque utilisée par la connexion.
SELECT sqlite_version();

-- 2. La table virtuelle expose les mêmes informations que PRAGMA database_list.
SELECT * FROM pragma_database_list;

-- 3. Le catalogue contient aussi les objets internes préfixés sqlite_.
SELECT count(*) FROM sqlite_schema WHERE type='table' AND name NOT GLOB 'sqlite_*';

-- 4. La colonne sql contient le texte de création.
SELECT sql FROM sqlite_schema WHERE type='table' AND name='commandes';

-- 5. Les PRAGMA tabulaires se joignent au catalogue.
SELECT s.name AS enfant, f."from" AS colonne, f."table" AS parent, f."to" AS cible
FROM sqlite_schema AS s JOIN pragma_foreign_key_list(s.name) AS f
WHERE s.type='table' ORDER BY enfant, f.id, f.seq;
