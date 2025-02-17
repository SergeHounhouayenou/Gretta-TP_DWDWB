-- Création de la base de données
DROP DATABASE IF EXISTS aston_martin;
CREATE DATABASE IF NOT EXISTS aston_martin;
USE aston_martin;

-- Création de la table offre_achat
CREATE TABLE offre_achat (
    Id_offre INT PRIMARY KEY,
    Id_client INT,
    Id_voiture INT,
    Id_proprietaire INT,
    Id_apparitions_films INT,
    Id_apparition_acteur INT
); ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';


-- Création de la table films_this 
CREATE TABLE films_this (
    id INT PRIMARY KEY,
    titre VARCHAR(255),
    date_sortie DATE,
    realisateur VARCHAR(255),
    Premier_role VARCHAR(255)
);  ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';


-- Insertion des enregistrements dans la table films_this
INSERT INTO films_this (id, titre, date_sortie, realisateur, Premier_role) VALUES
(1, 'Goldfinger', '1964-09-17', 'Guy Hamilton', 'Sean Connery'),
(2, 'Opération Tonnerre', '1965-12-17', 'Terence Young', 'Sean Connery'),
(3, 'GoldenEye', '1995-12-20', 'Martin Campbell', 'Pierce Brosnan'),
(4, 'Demain ne meurt jamais', '1997-12-17', 'Roger Spottiswoode', 'Pierce Brosnan'),
(5, 'Meurs un autre jour', '2002-11-20', 'Lee Tamahori', 'Pierce Brosnan'),
(6, 'Casino Royale', '2006-11-16', 'Martin Campbell', 'Daniel Craig'),
(7, 'Quantum of Solace', '2008-10-31', 'Marc Forster', 'Daniel Craig'),
(8, 'Skyfall', '2012-10-26', 'Sam Mendes', 'Daniel Craig'),
(9, 'Spectre', '2015-11-11', 'Sam Mendes', 'Daniel Craig'),
(10, 'Mourir peut attendre', '2021-10-06', 'Cary Joji Fukunaga', 'Daniel Craig');



-- Création de la table voitures_apparitions
CREATE TABLE voitures_apparitions (
    id INT PRIMARY KEY,
    nom_première_scène VARCHAR(255),
    rôle_voiture VARCHAR(255),
    description TEXT,
    id_film INT,
    id_voiture INT
);  ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';

-- Insertion des enregistrements dans la table voitures_apparitions
INSERT INTO voitures_apparitions (id, nom_première_scène, rôle_voiture, description, id_film, id_voiture) VALUES
(1, 'La poursuite dorée', 'Elle est équipée de gadgets comme des mitrailleuses et un siège éjectable.', 'Contexte: James Bond utilise la DB5 pour suivre Auric Goldfinger et découvrir ses plans.', 1, 1),
(2, 'Évasion aquatique', 'Elle est équipée de gadgets sous-marins.', 'Contexte: Bond utilise la DB5 pour échapper aux sbires de SPECTRE.', 2, 1),
(3, 'Course fatale', 'Principalement pour des scènes de poursuite.', 'Contexte: Bond conduit la DB5 dans une course contre Xenia Onatopp.', 3, 1),
(4, 'Infiltration nocturne', 'Équipée de gadgets pour l_infiltration.', 'Contexte: Bond utilise la DB5 pour infiltrer une base ennemie.', 4, 1),
(5, 'Camouflage glacial', 'Équipée de camouflage optique.', 'Contexte: Bond utilise la Vanquish pour une mission en Islande.', 5, 2),
(6, 'Sauvetage à grande vitesse', 'Utilisée dans une scène de poursuite intense.', 'Contexte: Bond utilise la DBS pour sauver Vesper Lynd.', 6, 3),
(7, 'Évasion explosive', 'Scènes de poursuite et d_évasion.', 'Contexte: Bond utilise la DBS pour échapper à des assassins.', 7, 3),
(8, 'Retour aux sources', 'Transport et défense.', 'Contexte: Bond utilise la DB5 pour se rendre à Skyfall, sa maison d_enfance.', 8, 1),
(9, 'Poursuite romaine', 'Équipée de gadgets pour la poursuite.', 'Contexte: Bond utilise la DB10 pour une mission à Rome.', 9, 1),
(10, 'Reconnaissance nordique', 'Équipée de gadgets pour la surveillance.', 'Contexte: James Bond utilise la V8 pour une mission de reconnaissance en Norvège.', 10, 5),
(11, 'Poursuite londonienne', 'Utilisée pour des scènes de poursuite intense.', 'Contexte: Bond utilise la DBS pour une poursuite à grande vitesse à travers Londres.', 10, 6),
(12, 'Infiltration italienne', 'Équipée de gadgets pour l_infiltration et l_évasion.', 'Contexte: Bond utilise la Valhalla pour infiltrer une base ennemie en Italie.', 10, 7);


-- Création de la table acteurs_this
CREATE TABLE acteurs_this (
    id INT PRIMARY KEY,
    prenom_acteur VARCHAR(255),
    nom_acteur VARCHAR(255),
    date_naissance DATE,
    date_deces DATE
); ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';

-- Insertion des enregistrements dans la table acteurs_this
INSERT INTO acteurs_this (id, prenom_acteur, nom_acteur, date_naissance, date_deces) VALUES
(1, 'Mathieu', 'Amalric', '1965-10-25', NULL),
(2, 'Gemma', 'Arterton', '1986-02-02', NULL),
(3, 'Claudine', 'Auger', '1941-04-26', '2019-12-18'),
(4, 'Javier', 'Bardem', '1969-03-01', NULL),
(5, 'Sean', 'Bean', '1959-04-17', NULL),
(6, 'Monica', 'Bellucci', '1964-09-30', NULL),
(7, 'Halle', 'Berry', '1966-08-14', NULL),
(8, 'Honor', 'Blackman', '1925-08-22', '2020-04-05'),
(9, 'Pierce', 'Brosnan', '1953-05-16', NULL),
(10, 'Adolfo', 'Celi', '1922-07-27', '1986-02-19'),
(11, 'Sean', 'Connery', '1930-08-25', '2020-10-31'),
(12, 'Daniel', 'Craig', '1968-03-02', NULL),
(13, 'Judi', 'Dench', '1934-12-09', NULL),
(14, 'Joe', 'Don Baker', '1936-02-12', NULL),
(15, 'Shirley', 'Eaton', '1937-01-12', NULL),
(16, 'Ralph', 'Fiennes', '1962-12-22', NULL),
(17, 'Gert', 'Fröbe', '1913-02-25', '1988-09-05'),
(18, 'Giancarlo', 'Giannini', '1942-08-01', NULL),
(19, 'Eva', 'Green', '1980-07-06', NULL),
(20, 'Naomie', 'Harris', '1976-09-06', NULL),
(21, 'Teri', 'Hatcher', '1964-12-08', NULL),
(22, 'Famke', 'Janssen', '1964-11-05', NULL),
(23, 'Olga', 'Kurylenko', '1979-11-14', NULL),
(24, 'Tania', 'Mallet', '1941-05-19', '2019-03-30'),
(25, 'Bérénice', 'Marlohe', '1979-05-19', NULL),
(26, 'Mads', 'Mikkelsen', '1965-11-22', NULL),
(27, 'Luciana', 'Paluzzi', '1937-06-10', NULL),
(28, 'Rosamund', 'Pike', '1979-01-27', NULL),
(29, 'Jonathan', 'Pryce', '1947-06-01', NULL),
(30, 'Izabella', 'Scorupco', '1970-06-04', NULL),
(31, 'Andrew', 'Scott', '1976-10-21', NULL),
(32, 'Léa', 'Seydoux', '1985-07-01', NULL),
(33, 'Toby', 'Stephens', '1969-04-21', NULL),
(34, 'Rik', 'Van Nutter', '1929-05-01', '2005-10-15'),
(35, 'Christoph', 'Waltz', '1956-10-04', NULL),
(36, 'Jeffrey', 'Wright', '1965-12-07', NULL),
(37, 'Michelle', 'Yeoh', '1962-08-06', NULL),
(38, 'Rick', 'Yune', '1971-08-22', NULL);


-- Création de la table participation_acteurs_this
CREATE TABLE participation_acteurs_this (
    id INT PRIMARY KEY,
    Id_acteur INT,
    prenom_rôle VARCHAR(255),
    nom_rôle VARCHAR(255),
    Id_film INT
); ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';

-- Insertion des enregistrements dans la table participation_acteurs_this
INSERT INTO participation_acteurs_this (id, Id_acteur, prenom_rôle, nom_rôle, Id_film) VALUES
(1, 1, 'Dominic', 'Greene', 7),
(2, 1, 'Dominic', 'Greene', 8),
(3, 2, 'Strawberry', 'Fields', 7),
(4, 2, 'Strawberry', 'Fields', 8),
(5, 3, 'Domino', 'Derval', 2),
(6, 4, 'Raoul', 'Silva', 9),
(7, 5, 'Alec', 'Trevelyan', 3),
(8, 6, 'Lucia', 'Sciarra', 10),
(9, 7, 'Jinx', '', 5),
(10, 8, 'Pussy', 'Galore', 1),
(11, 9, 'James', 'Bond', 3),
(12, 9, 'James', 'Bond', 4),
(13, 9, 'James', 'Bond', 5),
(14, 10, 'Emilio', 'Largo', 2),
(15, 11, 'James', 'Bond', 1),
(16, 11, 'James', 'Bond', 2),
(17, 12, 'James', 'Bond', 6),
(18, 12, 'James', 'Bond', 7),
(19, 12, 'James', 'Bond', 8),
(20, 12, 'James', 'Bond', 9),
(21, 12, 'James', 'Bond', 10),
(22, 13, 'M', '', 6),
(23, 14, 'Jack', 'Wade', 3),
(24, 14, 'Jack', 'Wade', 4),
(25, 15, 'Jill', 'Masterson', 1),
(26, 16, 'Gareth', 'Mallory / M', 9),
(27, 17, 'Auric', 'Goldfinger', 1),
(28, 18, 'René', 'Mathis', 7),
(29, 18, 'René', 'Mathis', 8),
(30, 19, 'Vesper', 'Lynd', 6),
(31, 20, 'Eve', 'Moneypenny', 9),
(32, 21, 'Paris', 'Carver', 4),
(33, 22, 'Xenia', 'Onatopp', 3),
(34, 23, 'Camille', 'Montes', 7),
(35, 23, 'Camille', 'Montes', 8),
(36, 24, 'Tilly', 'Masterson', 1),
(37, 25, 'Sévérine', '', 9),
(38, 26, 'Le', 'Chiffre', 6),
(39, 27, 'Fiona', 'Volpe', 2),
(40, 28, 'Miranda', 'Frost', 5),
(41, 29, 'Elliot', 'Carver', 4),
(42, 30, 'Natalya', 'Simonova', 3),
(43, 31, 'Lucia', 'Sciarra', 10),
(44, 32, 'Madeleine', 'Swann', 10),
(45, 33, 'Gustav', 'Graves', 5),
(46, 34, 'Felix', 'Leiter', 2),
(47, 35, 'Ernst Stavro', 'Blofeld', 10),
(48, 36, 'Felix', 'Leiter', 6),
(49, 37, 'Wai', 'Lin', 4),
(50, 38, 'Zao', '', 5);


-- Création de la table réalisateurs
CREATE TABLE réalisateurs (
    id INT PRIMARY KEY,
    prenom_realisateur VARCHAR(255),
    nom_realisateur VARCHAR(255),
    date_naissance DATE,
    date_deces DATE
);  ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';

-- Insertion des enregistrements dans la table réalisateurs
INSERT INTO réalisateurs (id, prenom_realisateur, nom_realisateur, date_naissance, date_deces) VALUES
(1, 'Guy', 'Hamilton', '1922-09-16', '2016-04-20'),
(2, 'Terence', 'Young', '1915-06-20', '1994-09-07'),
(3, 'Martin', 'Campbell', '1943-10-24', NULL),
(4, 'Roger', 'Spottiswoode', '1945-01-05', NULL),
(5, 'Lee', 'Tamahori', '1950-06-17', NULL),
(6, 'Marc', 'Forster', '1969-11-30', NULL),
(7, 'Sam', 'Mendes', '1965-08-01', NULL),
(8, 'Cary', 'Joji Fukunaga', '1977-07-10', NULL);


-- Création de la table autres_films_réalisateurs
CREATE TABLE autres_films_réalisateurs (
    id INT PRIMARY KEY,
    titre VARCHAR(255),
    date_sortie DATE,
    id_realisateur INT
);  ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';

-- Insertion des enregistrements dans la table autres_films_réalisateurs
INSERT INTO autres_films_réalisateurs (id, titre, date_sortie, id_realisateur) VALUES
(1, 'Battle of Britain', '1969', 1),
(2, 'Diamonds Are Forever', '1971', 1),
(3, 'Live and Let Die', '1973', 1),
(4, 'The Man with the Golden Gun', '1974', 1),
(5, 'Evil Under the Sun', '1982', 1),
(6, 'Dr. No', '1962', 2),
(7, 'From Russia with Love', '1963', 2),
(8, 'Wait Until Dark', '1967', 2),
(9, 'Inchon', '1981', 2),
(10, 'The Mask of Zorro', '1998', 3),
(11, 'Vertical Limit', '2000', 3),
(12, 'The Legend of Zorro', '2005', 3),
(13, 'Green Lantern', '2011', 3),
(14, 'Air America', '1990', 4),
(15, 'Turner & Hooch', '1989', 4),
(16, 'The 6th Day', '2000', 4),
(17, 'Ripley Under Ground', '2005', 4),
(18, 'Once Were Warriors', '1994', 5),
(19, 'Along Came a Spider', '2001', 5),
(20, 'XXX: State of the Union', '2005', 5),
(21, 'The Devil_s Double', '2011', 5),
(22, 'Monsters Ball', '2001', 6),
(23, 'Finding Neverland', '2004', 6),
(24, 'World War Z', '2013', 6),
(25, 'Christopher Robin', '2018', 6),
(26, 'American Beauty', '1999', 7),
(27, 'Road to Perdition', '2002', 7),
(28, 'Revolutionary Road', '2008', 7),
(29, '1917', '2019', 7),
(30, 'Sin Nombre', '2009', 8),
(31, 'Jane Eyre', '2011', 8),
(32, 'Beasts of No Nation', '2015', 8),
(33, 'Maniac', '2018', 8);


-- Création de la table participation_autres_films
CREATE TABLE participation_autres_films (
    id INT PRIMARY KEY,
    id_acteur INT,
    nom_acteur VARCHAR(255),
    titre VARCHAR(255),
    date_sortie DATE,
    id_realisateur INT
);  ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';

-- Insertion des enregistrements dans la table participation_autres_films
INSERT INTO participation_autres_films (id, id_acteur, nom_acteur, titre, date_sortie, id_realisateur) VALUES
(1, 11, 'Sean Connery', 'Battle of Britain', '1969', 1),
(2, 17, 'Gert Fröbe', 'Battle of Britain', '1969', 1),
(3, 8, 'Honor Blackman', 'Battle of Britain', '1969', 1),
(4, 24, 'Tania Mallet', 'Battle of Britain', '1969', 1),
(5, 3, 'Claudine Auger', 'Battle of Britain', '1969', 1),
(6, 10, 'Adolfo Celi', 'Battle of Britain', '1969', 1),
(7, 27, 'Luciana Paluzzi', 'Battle of Britain', '1969', 1),
(8, 34, 'Rik Van Nutter', 'Battle of Britain', '1969', 1),
(9, 11, 'Sean Connery', 'Diamonds Are Forever', '1971', 1),
(10, 15, 'Shirley Eaton', 'Diamonds Are Forever', '1971', 1),
(11, 9, 'Pierce Brosnan', 'The 6th Day', '2000', 4),
(12, 14, 'Joe Don Baker', 'The 6th Day', '2000', 4),
(13, 7, 'Halle Berry', 'Monsters Ball', '2001', 6);


-- Création de la table voitures
CREATE TABLE voitures (
    id INT PRIMARY KEY,
    modèle VARCHAR(255),
    statut VARCHAR(255),
    date_mise_circulation DATE,
    propriétaire VARCHAR(255),
    photo VARCHAR(255)
);  ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';

-- Insertion des enregistrements dans la table voitures
INSERT INTO voitures (id, modèle, statut, date_mise_circulation, propriétaire, photo) VALUES
(1, 'DB5', 'Collection privée', '1963', 'Information secrète', '1'),
(2, 'V12 Vanquish', 'Collection privée', '2013', 'Information secrète', '2'),
(3, 'DBS', 'Collection privée', '2006', 'Information secrète', '3'),
(4, 'DB10', 'Collection privée', '2015', 'Information secrète', '4'),
(5, 'V8', 'Collection privée', '1967', 'Information secrète', '5'),
(6, 'DBS', 'Collection privée', '2006', 'Information secrète', '6'),
(7, 'Valhalla', 'Collection privée', NULL, 'Information secrète', '7');


-- Création de la table client
CREATE TABLE client (
    id INT PRIMARY KEY,
    nom_proprietaire VARCHAR(255),
    mail VARCHAR(255),
    telephone VARCHAR(255),
    civilite VARCHAR(255),
    date_naissance DATE
);  ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='InnoDB free: 11264 kB';


