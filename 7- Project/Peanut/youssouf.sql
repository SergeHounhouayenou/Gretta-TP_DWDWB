DROP DATABASE IF EXISTS peanut;

CREATE DATABASE IF NOT EXISTS peanut;
USE peanut;

CREATE TABLE client (
    client_id INT(6) NOT NULL AUTO_INCREMENT,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    date_naissance DATE NULL,
    email VARCHAR(50) NOT NULL,
    mot_de_passe VARCHAR(30) NOT NULL,
    numero_telephone VARCHAR(15) NOT NULL,
    adresse VARCHAR(50) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    ville VARCHAR(50) NOT NULL,
    pays VARCHAR(30) NOT NULL,
    date_inscription DATE NULL,
    PRIMARY KEY (client_id),
    INDEX nom_ix_client (nom)
) ENGINE=InnoDB;

CREATE TABLE peanut (
    id_utilisateur VARCHAR(30) NOT NULL,
    nom VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    mot_de_passe VARCHAR(30) NOT NULL,
    date_inscription DATE NULL,
    date_connexion DATE NULL,
    type_abonnement VARCHAR(20) NOT NULL,
    debut_abonnement DATE NULL,
    fin_abonnement DATE NULL,
    id_film VARCHAR(30) NULL,
    id_serie VARCHAR(30) NULL,
    id_evenement VARCHAR(30) NULL,
    PRIMARY KEY (id_utilisateur)
) ENGINE=InnoDB;

CREATE TABLE films (
    identifiant_film VARCHAR(30) NOT NULL,
    titre VARCHAR(100) NOT NULL,
    categorie VARCHAR(30) NOT NULL,
    date_sortie DATE NULL,
    note_moyenne DECIMAL(10, 2) NULL,
    exclusivite VARCHAR(50) NULL,
    description VARCHAR(500) NULL,
    ia_recommandation VARCHAR(200) NULL,
    chance VARCHAR(200) NULL,
    barre_recherche VARCHAR(200) NULL,
    genre VARCHAR(50) NULL,
    acteurs VARCHAR(200) NULL,
    PRIMARY KEY (identifiant_film)
) ENGINE=InnoDB;

CREATE TABLE series (
    identifiant_serie VARCHAR(30) NOT NULL,
    titre VARCHAR(100) NOT NULL,
    categorie VARCHAR(30) NOT NULL,
    date_sortie DATE NULL,
    note_moyenne DECIMAL(10, 2) NULL,
    exclusivite VARCHAR(50) NULL,
    description VARCHAR(500) NULL,
    ia_recommandation VARCHAR(200) NULL,
    chance VARCHAR(200) NULL,
    barre_recherche VARCHAR(200) NULL,
    genre VARCHAR(50) NULL,
    acteurs VARCHAR(200) NULL,
    PRIMARY KEY (identifiant_serie)
) ENGINE=InnoDB;

CREATE TABLE evenements (
    id_evenement INT(10) NOT NULL,
    nom_evenement VARCHAR(200) NOT NULL,
    categorie VARCHAR(50) NOT NULL,
    date_debut DATE NULL,
    date_fin DATE NULL,
    duree INT(30) NULL,
    description VARCHAR(500) NULL,
    nb_participants INT(200) NULL,
    tarif DECIMAL(50, 2) NULL,
    PRIMARY KEY (id_evenement)
) ENGINE=InnoDB;

CREATE TABLE genres (
    nom_genre VARCHAR(30) NOT NULL,
    description VARCHAR(200) NULL,
    date_creation DATE NULL,
    nombre_videos INT(50) NULL,
    action VARCHAR(30) NULL,
    comedie VARCHAR(30) NULL,
    drame VARCHAR(30) NULL,
    science_fiction VARCHAR(30) NULL,
    horreur VARCHAR(30) NULL,
    PRIMARY KEY (nom_genre)
) ENGINE=InnoDB;

CREATE TABLE mentions_legales (
    titre VARCHAR(30) NOT NULL,
    texte VARCHAR(200) NOT NULL,
    date_creation DATE NULL,
    date_mise_a_jour DATE NULL,
    version INT(15) NULL,
    PRIMARY KEY (titre)
) ENGINE=InnoDB;

CREATE TABLE acteurs (
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    date_naissance DATE NULL,
    nationalite VARCHAR(20) NULL,
    biographie VARCHAR(500) NULL,
    PRIMARY KEY (nom, prenom)
) ENGINE=InnoDB;

CREATE TABLE realisateurs (
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    date_naissance DATE NULL,
    nationalite VARCHAR(20) NULL,
    biographie VARCHAR(500) NULL,
    PRIMARY KEY (nom, prenom)
) ENGINE=InnoDB;

CREATE TABLE abonnements (
    type VARCHAR(30) NOT NULL,
    prix DECIMAL(10, 2) NOT NULL,
    duree INT(10) NOT NULL,
    description VARCHAR(200) NULL,
    PRIMARY KEY (type)
) ENGINE=InnoDB;

CREATE TABLE banque (
    nom_banque VARCHAR(30) NOT NULL,
    utilisateur VARCHAR(30) NOT NULL,
    iban VARCHAR(20) NOT NULL,
    bic_swift VARCHAR(15) NOT NULL,
    adresse VARCHAR(200) NOT NULL,
    pays VARCHAR(50) NOT NULL,
    date_ajout DATE NULL,
    PRIMARY KEY (nom_banque)
) ENGINE=InnoDB;

CREATE TABLE serveurs (
    nom_serveur VARCHAR(30) NOT NULL,
    adresse_ip VARCHAR(15) NOT NULL,
    type VARCHAR(50) NOT NULL,
    capacite_stockage INT(10) NOT NULL,
    date_installation DATE NULL,
    maintenance DATE NULL,
    PRIMARY KEY (nom_serveur)
) ENGINE=InnoDB;

CREATE TABLE stockage (
    nom_fichier VARCHAR(50) NOT NULL,
    taille INT(15) NOT NULL,
    format VARCHAR(50) NOT NULL,
    date_upload DATE NULL,
    PRIMARY KEY (nom_fichier)
) ENGINE=InnoDB;

CREATE TABLE support_client (
    ticket VARCHAR(30) NOT NULL,
    utilisateur VARCHAR(30) NOT NULL,
    sujet VARCHAR(200) NOT NULL,
    description VARCHAR(500) NOT NULL,
    date_creation DATE NULL,
    date_resolution DATE NULL,
    PRIMARY KEY (ticket)
) ENGINE=InnoDB;

-- Insertion de données
INSERT INTO client (nom, prenom, date_naissance, email, mot_de_passe, numero_telephone, adresse, code_postal, ville, pays, date_inscription)
VALUES
('Youssouf', 'Bathily', '2006-02-14', 'youssoufbathily624@gmail.com', 'password123', '0753780232', '128 Avenue de la Redoute', '92600', 'Asnières-sur-Seine', 'France', '2025-01-01'),
('Tiguidé', 'Bathily', '2003-04-15', 'tbathily987@gmail.com', 'password456', '0612345678', '128 Avenue de la Redoute', '92600', 'Asnières-sur-Seine', 'France', '2024-01-01');

INSERT INTO peanut (id_utilisateur, nom, email, mot_de_passe, date_inscription, date_connexion, type_abonnement, debut_abonnement, fin_abonnement, id_film, id_serie, id_evenement) 
VALUES ('xebec', 'DupYoussoufont', 'peanut@gmail.com', 'password123', '2025-01-01', '2025-01-02', 'Premium', '2025-01-01', '2026-01-01', 'film123', 'serie123', 'event123');

INSERT INTO films (identifiant_film, titre, categorie, date_sortie, note_moyenne, exclusivite, description, ia_recommandation, chance, barre_recherche, genre, acteurs) 
VALUES
('film123', 'One Piece', 'Anime', '2010-07-16', 8.8, 'Oui', 'Luffy, le roi des pirates', 'Recommandé pour vous', 'Oui', 'Recherche One Piece', 'Film', 'Adultes, Luffy'),
('film456', 'Dragon Ball Z', 'Anime', '2014-08-02', 10.0, 'Non', 'Vegeta, le prince', 'Recommandé pour vous', 'Oui', 'Recherche Dragon Ball Z', 'Film', 'Adultes, Goku');

INSERT INTO series (identifiant_serie, titre, categorie, date_sortie, note_moyenne, exclusivite, description, ia_recommandation, chance, barre_recherche, genre, acteurs) 
VALUES
('serie123', 'Breaking Bad', 'Drame', '2008-01-20', 9.5, 'Non', 'Un professeur de chimie devient un baron de la drogue', 'Recommandé pour vous', 'Oui', 'Recherche Breaking Bad', 'Drame', 'Cranston, Paul'),
('serie456', 'Stranger Things', 'Science-fiction', '2016-07-15', 8.7, 'Oui', 'Des enfants luttent contre des forces surnaturelles', 'Recommandé pour vous', 'Oui', 'Recherche Stranger Things', 'Drame', 'Brown, Ryder');

INSERT INTO evenements (id_evenement, nom_evenement, categorie, date_debut, date_fin, duree, description, nb_participants, tarif) 
VALUES (1, 'Concert de Rock', 'Musique', '2025-06-01', '2026-06-01', 120, 'Concert de rock avec plusieurs artistes', 500, 50.00);

INSERT INTO genres (nom_genre, description, date_creation, nombre_videos, action, comedie, drame, science_fiction, horreur) 
VALUES ('Action', 'Films daction', '2025-01-01', 100, 'Oui', 'Non', 'Non', 'Non', 'Non');

INSERT INTO mentions_legales (titre, texte, date_creation, date_mise_a_jour, version) 
VALUES ('Conditions dutilisation', 'Conditions dutilisation de notre service', '2025-01-01', '2025-01-01', 1);

INSERT INTO acteurs (nom, prenom, date_naissance, nationalite, biographie) 
VALUES ('Brad', 'Pitt', '1974-11 -11', 'Américain', 'Acteur et producteur américain.');

INSERT INTO realisateurs (nom, prenom, date_naissance, nationalite, biographie) 
VALUES ('Nolan', 'Christopher', '1970-07-30', 'Britannique', 'Réalisateur, scénariste et producteur.');

INSERT INTO abonnements (type, prix, duree, description) 
VALUES ('Premium', 9.99, 30, 'Accès illimité à tous les films et séries.');

INSERT INTO banque (nom_banque, utilisateur, iban, bic_swift, adresse, pays, date_ajout) 
VALUES ('Revolut', 'Youssouf Bathily', 'FR7612345678901234567890123', 'BPPIFRPPXXX', '1 rue de la Banque', 'France', '2025-01-01');

INSERT INTO serveurs (nom_serveur, adresse_ip, type, capacite_stockage, date_installation, maintenance) 
VALUES ('Serveur 1', '192.168.1.1', 'Web', 1000, '2025-01-01', '2025-12-01');

INSERT INTO stockage (nom_fichier, taille, format, date_upload) 
VALUES ('one_piece.mp4', 2048, 'mp4', '2025-01-01');

INSERT INTO support_client (ticket, utilisateur, sujet, description, date_creation, date_resolution) 
VALUES ('TICKET123', 'Youssouf Bathily', 'Problème de connexion', 'Je ne peux pas me connecter à mon compte.', '2025-01-01');