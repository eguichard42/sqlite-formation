-- 1. journal_mode est une propriété persistante quand le fichier est passé en WAL.
PRAGMA journal_mode;

-- 2. Le réglage concerne uniquement la connexion courante.
PRAGMA busy_timeout=250;
PRAGMA busy_timeout;

-- 3. Un seuil nul désactive le déclenchement automatique.
PRAGMA wal_autocheckpoint=0;
PRAGMA wal_autocheckpoint=1000;

-- 4. Les colonnes indiquent le résultat, les pages WAL et les pages reportées. PASSIVE évite d’attendre les lecteurs.
PRAGMA wal_checkpoint(PASSIVE);

-- 5. Exécuter BEGIN dans A, essayer BEGIN dans B comme indiqué au cours, puis libérer A avant TRUNCATE.
BEGIN IMMEDIATE;
UPDATE produits SET actif=0 WHERE id=1;
-- Tester B avant de poursuivre dans A.
ROLLBACK;
PRAGMA wal_checkpoint(TRUNCATE);
