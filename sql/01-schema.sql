CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    nom TEXT NOT NULL UNIQUE
) STRICT;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    nom TEXT NOT NULL,
    email TEXT NOT NULL COLLATE NOCASE UNIQUE,
    ville TEXT NOT NULL,
    inscrit_le TEXT NOT NULL CHECK (date(inscrit_le, '+0 days') IS inscrit_le)
) STRICT;

CREATE TABLE produits (
    id INTEGER PRIMARY KEY,
    categorie_id INTEGER NOT NULL REFERENCES categories(id),
    sku TEXT NOT NULL UNIQUE,
    nom TEXT NOT NULL,
    prix_centimes INTEGER NOT NULL CHECK (prix_centimes > 0),
    actif INTEGER NOT NULL DEFAULT 1 CHECK (actif IN (0, 1))
) STRICT;

CREATE TABLE commandes (
    id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id),
    date_commande TEXT NOT NULL CHECK (date(date_commande, '+0 days') IS date_commande),
    statut TEXT NOT NULL CHECK (statut IN ('en_attente', 'expediee', 'livree', 'annulee'))
) STRICT;

CREATE TABLE lignes_commandes (
    commande_id INTEGER NOT NULL REFERENCES commandes(id) ON DELETE CASCADE,
    produit_id INTEGER NOT NULL REFERENCES produits(id),
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    prix_centimes INTEGER NOT NULL CHECK (prix_centimes > 0),
    PRIMARY KEY (commande_id, produit_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE paiements (
    id INTEGER PRIMARY KEY,
    commande_id INTEGER NOT NULL REFERENCES commandes(id),
    paye_le TEXT NOT NULL CHECK (date(paye_le, '+0 days') IS paye_le),
    mode TEXT NOT NULL CHECK (mode IN ('carte', 'virement', 'paypal')),
    montant_centimes INTEGER NOT NULL CHECK (montant_centimes > 0)
) STRICT;

CREATE INDEX idx_clients_ville ON clients(ville);
CREATE INDEX idx_produits_categorie ON produits(categorie_id);
CREATE INDEX idx_commandes_client_date ON commandes(client_id, date_commande);
CREATE INDEX idx_commandes_date ON commandes(date_commande);
CREATE INDEX idx_lignes_produit ON lignes_commandes(produit_id);
CREATE INDEX idx_paiements_commande ON paiements(commande_id);
