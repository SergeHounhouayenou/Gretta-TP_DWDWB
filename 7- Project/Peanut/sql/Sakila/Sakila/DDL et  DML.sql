-- -------------------------------------------------------------------
-- DDL (data definition language et DML (data manipulation language) 
-- -------------------------------------------------------------------

-- 1. Définition de la structure de la base de données
-- Définir l'encondage des charactères et la mmanière dont les charactères sont comparés (collate)
DROP DATABASE IF EXISTS Ecommerce ;
CREATE DATABASE IF NOT EXISTS Ecommerce 
CHARACTER SET  utf8mb4 
COLLATE utf8mb4_unicode_ci ;

-- Sélectionner notre database
USE Ecommerce ;

-- Création de table "utilisateur"
CREATE TABLE IF NOT EXISTS utilisateur 
(
id_utilisateur INT AUTO_INCREMENT PRIMARY KEY, 
nom VARCHAR(100) NOT NULL,
email VARCHAR(150) UNIQUE NOT NULL,
mot_de_passe VARCHAR(255) NOT NULL,
date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE = INNODB;

-- Création de la table catégorie
CREATE TABLE IF NOT EXISTS categorie 
(
id_categorie INT AUTO_INCREMENT PRIMARY KEY,
nom_categorie VARCHaR(100) NOT NULL,
description TEXT
)ENGINE = InnoDB;

-- Création de la table produit
CREATE TABLE IF NOT EXISTS produit 
(
id_produit INT AUTO_INCREMENT PRIMARY KEY,

nom_produit VARCHaR(100) NOT NULL,
description TEXT,
prix DECIMAL(10,2) NOT NULL,
stock INT NOT NULL,
id_categorie INT,
FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie) ON DELETE SET NULL
)ENGINE = InnoDB;
-- On DELETE SET NULL : si une catégorie est supprimée de la table catégorie
-- alors la valeur de id_categori dans la table produit sera à NULL au lieu de supprimer les produits liésavepoint
-- Les produitss liés à ses suppressions sont dit "orphelins"

CREATE TABLE IF NOT EXISTS commande 
(
id_commande INT AUTO_INCREMENT PRIMARY KEY,
id_utilisateur INT NOT NULL,
date_commande DATETIME DEFAULT CURRENT_TIMESTAMP, 
total DECIMAL(10,2) NOT NULL, 
FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE
)ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS ligne_commande 
(
id_ligne_commande INT AUTO_INCREMENT PRIMARY KEY,
id_commande INT NOT NULL,
id_produit INT NOT NULL,
quantite INT NOT NULL,
prix_unitaire DECIMAL(10,2) NOT NULL,
FOREIGN KEY (id_commande) REFERENCES commande(id_commande) ON DELETE CASCADE,
FOREIGN KEY (id_produit) REFERENCES produit(id_produit) ON DELETE CASCADE
)ENGINE = InnoDB;


-- 2. Insertion des données dans les tables
INSERT INTO categorie (nom_categorie, description) VALUES
('Electronique', 'Appareils électronique'),
('Maison', 'Produits pour la maison'),
('Vetements', 'Mode et habillement');

INSERT INTO produit (nom_produit, description, prix, stock, id_categorie) VALUES
('Smartphone', 'Dernier modèl avec écran AMOLED', 699.99, 50,1),
('Canape', 'Canapé confortable 3 places', 499.99, 10,2),
('T-shirt, T-Shirt 100% coton', 19.99, 200, 3);

ALTER TABLE utilisateur ADD COLUMN adresse VARCHAR(255) NOT NULL AFTER email;

INSERT INTO utilisateur (nom, email, mot_de_passe) VALUES
('Saman', 'sam@sam.fr', '12 rue de Paris 75009 Paris', 'pasword123'),
('Nadjet', 'nad@nad.fr', '15 rue de Lyon 69100 Lyon', 'secure123');

-- Réapprovisionner un produit - Mise à jour des données 
UPDATE produit 
SET stock = stock + 100
WHERE nom_produit = 'T-Shirt' ;

-- Supprimer un utilisateur spécifique
DELETE FROM utilisateur WHERE email = 'sam@sam.fr';

-- Supprimer un utilisateur spécifique
-- Attention : supprimer les tables uniquement si elle existent
DROP TABLE IF EXISTS produit;

-- Les contraintes : Ce sont des condtioons que l'on pose sur une table
ALTER TABLE produit ADD CONSTRAINT check_stock CHECK (stock >=0); 
-- Voir la liste des mot clés possible dans la documentation pour vérifier sa prise en charge par le SGBD choisi (ex. MariaDB) 
ALTER TABLE utilisateur MODIFY email VARCHAR(150) NOT NULL;
ALTER TABLE utilisateur ADD CONSTRAiNT unique_email UNIQUE (email);
ALTER TABLE rental ADD CONSTRAINT fk_custome FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE;
ALTER TABLE customer ALTER COLUMN active SET DEFAULT TRUE;
 








