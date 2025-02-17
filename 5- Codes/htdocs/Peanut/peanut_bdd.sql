drop database if exists peanut_bdd;

create database if not exists peanut_bdd;

use peanut_bdd;

-- Script pour créer la table dictionnaire_entité et automatiser sa mise à jour
CREATE TABLE dictionnaire_entité (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom_entité VARCHAR(255) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    type_données TEXT NOT NULL,
    relations TEXT,
    colonnes TEXT NOT NULL,
    contraintes TEXT,
    mise_a_jour_automatique BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- Trigger pour maintenir l'intégrité du dictionnaire_entité lors de l'ajout/modification des tables
-- DELIMITER $$
-- CREATE TRIGGER update_dictionnaire_apres_insertion
-- AFTER CREATE ON SCHEMA
-- FOR EACH ROW
-- BEGIN
-- Exemple : Ajout d'une nouvelle entité (table) dans le dictionnaire
--    INSERT INTO dictionnaire_entité (nom_entité, description, type_données, colonnes, contraintes)
--    VALUES (
--    NEW.table_name,
--   'Description par défaut de l'entité.',
--   'Type de données défini dynamiquement.',
--   (SELECT GROUP_CONCAT(COLUMN_NAME SEPARATOR ', ') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = NEW.table_name),
--   'Contraintes à définir selon le projet.'
--   );
-- END$$
-- DELIMITER ;


-- Script pour créer la table modèle_fonctionnel
CREATE TABLE modele_fonctionnel (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom_fonction VARCHAR(255) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    entites_associees TEXT NOT NULL,
    reference_implementation TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- Trigger pour garder le modèle fonctionnel synchronisé avec les changements de code
DELIMITER $$
CREATE TRIGGER update_modele_fonctionnel_apres_modification
AFTER UPDATE ON modele_fonctionnel
FOR EACH ROW
BEGIN
    -- Exemple : Log ou synchronisation d'une fonction modifiée
    INSERT INTO dictionnaire_entité (nom_entité, description)
    VALUES (
        NEW.nom_fonction,
        CONCAT('Mise à jour liée à ', NEW.nom_fonction, ' dans le modèle fonctionnel.')
    )
    ON DUPLICATE KEY UPDATE
        description = CONCAT(description, ' Mise à jour supplémentaire détectée.');
END$$
DELIMITER ;



CREATE TABLE Controle (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    id_acteur INT NOT NULL, 
    id_cible INT NOT NULL, 
    description TEXT,
    profil_niveau VARCHAR(255),
    notification TEXT,
    qualite_action VARCHAR(50),
    date_action DATETIME DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20),
    historique_action ENUM('validé', 'rejeté', 'ajourné') NOT NULL,
    id_validation INT,
    valide_par INT, 
    date_validation DATETIME,
    historique TEXT,
    validation_etat VARCHAR(50),
    regles_appliquees TEXT,
    permission_verifiee BOOLEAN NOT NULL,
    autorisation_verifiee BOOLEAN NOT NULL,
    authentification_verifiee BOOLEAN NOT NULL,
    conditions_validation TEXT,
    duree_validite INT,
    id_enregistrement INT,
    id_suivi INT,
    conditions_retrait TEXT,
    date_retrait DATETIME,
    responsables TEXT,
    alertes TEXT,
    rapports_audit TEXT,
    tentacules_internes TEXT,  -- Pour suivre les actions internes liées aux tentacules
    tentacules_externes TEXT,  -- Pour suivre les actions externes liées aux tentacules
    FOREIGN KEY (id_validation) REFERENCES Validation(id),
    FOREIGN KEY (id_enregistrement) REFERENCES Enregistrement(id),
    FOREIGN KEY (id_suivi) REFERENCES Suivi(id),
    FOREIGN KEY (id_acteur) REFERENCES Acteurs(id),
    FOREIGN KEY (id_cible) REFERENCES Cibles(id),
    FOREIGN KEY (valide_par) REFERENCES Acteurs(id)
) ENGINE=InnoDB;
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;


-- Index pour les colonnes fréquemment recherchées
CREATE INDEX idx_date_action ON Controle(date_action);
CREATE INDEX idx_statut ON Controle(statut);
CREATE INDEX idx_valide_par ON Controle(valide_par);


-- Trigger pour vérifier les modifications illégitimes de time t
DELIMITER $$
CREATE TRIGGER trg_check_time_t
BEFORE UPDATE ON Controle
FOR EACH ROW
BEGIN
    IF OLD.date_action != NEW.date_action THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Modification illégale de time t, arrêt du processus';
    END IF;
END;
DELIMITER ;


DELIMITER $$
CREATE TRIGGER trg_mise_a_jour_tentacules
AFTER INSERT OR UPDATE ON Controle
FOR EACH ROW
BEGIN
    -- Mise à jour de la table FonctionsRelais pour activer des actions externes
    UPDATE FonctionsRelais 
    SET statut = 'actif', date_activation = CURRENT_TIMESTAMP
    WHERE controle_id = NEW.id AND cible = 'external_action'; -- Cibler des actions spécifiques

    -- Enregistrement d'une nouvelle réaction vive (réaction par défaut)
    INSERT INTO ReactionsVives (controle_id, type_reaction, contenu, priorite, id_acteur)
    VALUES (NEW.id, 'defaut', 'Réaction par défaut suite à la mise à jour du contrôle', 1, NEW.id_acteur);
END;
DELIMITER ;


-- Partitionnement mensuel automatique
CREATE EVENT IF NOT EXISTS partition_control_monthly
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    DECLARE partition_name VARCHAR(64);
    SET partition_name = CONCAT('Controle_', DATE_FORMAT(CURRENT_DATE(), '%Y_%m'));
    SET @sql = CONCAT('CREATE TABLE ', partition_name, ' LIKE Controle');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('INSERT INTO ', partition_name, ' SELECT * FROM Controle WHERE date_action >= ', DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01'), ' AND date_action < ', DATE_ADD(DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01'), INTERVAL 1 MONTH));
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;


CREATE TABLE ReactionsVives (
    id INT AUTO_INCREMENT PRIMARY KEY,
    controle_id INT NOT NULL,                        -- Référence à la table Controle
    type_reaction ENUM('defaut', 'elargissement') NOT NULL,
    contenu TEXT NOT NULL,                           -- Détail de la requête ou de l'élargissement
    priorite INT DEFAULT 0,                          -- Priorité de la réaction (0 = basse, 1 = haute, etc.)
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_mise_a_jour DATETIME ON UPDATE CURRENT_TIMESTAMP,
    id_acteur INT NOT NULL,                          -- Acteur ayant déclenché la réaction
    FOREIGN KEY (controle_id) REFERENCES Controle(id),
    FOREIGN KEY (id_acteur) REFERENCES Acteurs(id)
) ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;


CREATE TABLE FonctionsRelais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    controle_id INT NOT NULL,                        -- Référence à la table Controle
    fonction VARCHAR(255) NOT NULL,                  -- Nom ou type de fonction relais
    cible VARCHAR(255) NOT NULL,                     -- Entité ou espace affecté par la fonction
    parametres JSON,                                 -- Paramètres de la fonction (sous forme de JSON pour flexibilité)
    statut ENUM('actif', 'inactif') DEFAULT 'actif', -- Statut de la fonction relais
    date_activation DATETIME,                        -- Date d'activation
    date_desactivation DATETIME,                     -- Date de désactivation (si applicable)
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    historique_statut TEXT,                          -- Historique des changements de statut
    FOREIGN KEY (controle_id) REFERENCES Controle(id)
) ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;


-- Bilan des volontés de controle positionnés (reste à les intanciers) 
-- - gestion des permissions
-- - traçabilité
-- - gestion de la mémoire interne 
-- - optimisation des requêtes. 
-- Mise à jour de la table Contrôle :  
-- Nous allons maintenant ajouter les colonnes 
-- permettant de lier Controle aux tables   ReactionsVives et FonctionsRelais. 
-- Ces colonnes permettront de gérer les "tentacules" internes et externes.

ALTER TABLE Controle
ADD COLUMN tentacules_internes TEXT,  -- Pour suivre les actions internes liées aux tentacules
ADD COLUMN tentacules_externes TEXT;  -- Pour suivre les actions externes liées aux tentacules


-- Test de l'insertion d'un contrôle
-- Après la création d'un trigger je vérifie que tout fonctionne comme prévu. 
-- Insérer un nouveau contrôle dans la table Controle pour vérifier si cela déclenche correctement les mises à jour dans FonctionsRelais et ReactionsVives.
-- On peut modifier un contrôle existant pour voir si le trigger met à jour les actions des tentacules.
-- On peut consulter les tables ReactionsVives et FonctionsRelais pour vérifier que les mises à jour sont bien effectuées.
-- Exemple d'insertion :

INSERT INTO Controle (id_acteur, id_cible, description, statut, historique_action)
VALUES (1, 1, 'Test de contrôle initial', 'actif', 'valide');

-- Je Vérifie dans ReactionsVives et FonctionsRelais que des actions sont générées comme prévu.


CREATE TABLE Experience_Utilisateur (
    id INT PRIMARY KEY AUTO_INCREMENT,
    controle_id INT NOT NULL,  -- Référence à la table Controle pour lier l'expérience à une action spécifique
    nom VARCHAR(255),  -- Nom de l'expérience (ex: interface, fluidité)
    qualite ENUM('navigation', 'ergonomie') NOT NULL,  -- Qualité de l'expérience
    note INT,  -- Note attribuée à l'expérience (ex: 5 ou 10)
    commentaires_utilisateur TEXT,  -- Commentaires de l'utilisateur
    date_experience DATETIME,  -- Date de l'expérience
    FOREIGN KEY (controle_id) REFERENCES Controle(id)  -- Lien avec la table Controle
) ENGINE=InnoDB;

INSERT INTO Experience_Utilisateur (nom, qualite, note, commentaires_utilisateur, date_experience) 
VALUES ('Interface A', 'ergonomie', 8, 'Bonne fluidité générale, quelques lenteurs sur certaines pages.', '2025-01-25 10:30:00');
INSERT INTO Experience_Utilisateur (nom, qualite, note, commentaires_utilisateur, date_experience) 
VALUES ('Interface B', 'navigation', 6, 'Navigation intuitive mais manque de certaines options.', '2025-01-25 11:00:00');
INSERT INTO Experience_Utilisateur (nom, qualite, note, commentaires_utilisateur, date_experience) 
VALUES ('Interface C', 'ergonomie', 9, 'Interface claire et réactive, très bonne expérience.', '2025-01-25 12:00:00');
-- Je Vérifie dans experience_utilisateur que tout fonctionne comme prévu.


CREATE TABLE Vérification_Performance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom_verification VARCHAR(255),  -- Nom de la vérification
    qualite ENUM('charge', 'réactivité') NOT NULL,  -- Qualité de la vérification
    etat ENUM('en cours', 'complété') NOT NULL,  -- État de la vérification
    date_verification DATETIME,  -- Date de la vérification
    resultat TEXT,  -- Résultat de la vérification
    commentaires TEXT  -- Commentaires sur la vérification
) ENGINE=InnoDB;

INSERT INTO Vérification_Performance (nom_verification, qualite, etat, date_verification, resultat, commentaires) 
VALUES 
('Test Charge', 'charge', 'en cours', '2025-01-25 12:00:00', 'Test en cours', 'Aucune anomalie détectée.'),
('Test Réactivité', 'réactivité', 'complété', '2025-01-24 10:30:00', 'Succès', 'Réactivité optimale sous charge.'),
('Test Charge', 'charge', 'en cours', '2025-01-23 09:00:00', 'En attente', 'Analyse en cours.');


CREATE TABLE Compte_utilisateur (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_utilisateur INT,  -- Lien avec l'entité Utilisateur
    qualite ENUM('gratuit', 'premium') NOT NULL,  -- Qualité du compte
    nom VARCHAR(255),  -- Nom du compte
    email VARCHAR(255),  -- Email du compte
    authentification ENUM('email', 'biometrique') NOT NULL,  -- Méthode d'authentification
    date_creation DATETIME,  -- Date de création du compte
    date_expiration DATETIME,  -- Date d'expiration du compte
    qualite_compte ENUM('administrateur', 'standard') NOT NULL,  -- Qualité du compte
    etat_profil ENUM('actif', 'inactif', 'nonétant') NOT NULL,  -- État du profil
    date_derniere_connexion DATETIME,  -- Date de la dernière connexion
    commentaire TEXT,  -- Commentaire
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id)  -- Lien avec l'entité Utilisateur
) ENGINE=InnoDB;


-- Insertion des données de test
INSERT INTO Compte_utilisateur (id_utilisateur, qualite, nom, email, authentification, date_creation, date_expiration, qualite_compte, etat_profil, date_derniere_connexion, commentaire) 
VALUES 
(1, 'premium', 'Compte Premium Utilisateur 1', 'utilisateur1@example.com', 'email', '2025-01-01 08:00:00', '2026-01-01 08:00:00', 'administrateur', 'actif', '2025-01-25 10:00:00', 'Compte actif, aucune anomalie.'),
(2, 'gratuit', 'Compte Gratuit Utilisateur 2', 'utilisateur2@example.com', 'biometrique', '2024-12-01 08:00:00', '2025-12-01 08:00:00', 'standard', 'inactif', '2025-01-15 08:00:00', 'Compte inactif depuis 15 jours.');



CREATE TABLE Profil_Utilisateur (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_utilisateur_associe INT,  -- Lien avec l'entité Utilisateur
    nom_profil VARCHAR(255),  -- Nom du profil
    description_profil TEXT,  -- Description du profil
    image_profil VARCHAR(255),  -- URL de l'image de profil
    preferences_profil TEXT,  -- Préférences du profil
    date_creation DATETIME,  -- Date de création du profil
    etat_profil ENUM('actif', 'inactif', 'nonétant') NOT NULL,  -- État du profil
    commentaires_profil TEXT,  -- Commentaires sur le profil
    FOREIGN KEY (id_utilisateur_associe) REFERENCES Utilisateur(id)  -- Lien avec l'entité Utilisateur
) ENGINE=InnoDB;

-- Insertion des données de test
INSERT INTO Profil_Utilisateur (id_utilisateur_associe, nom_profil, description_profil, image_profil, preferences_profil, date_creation, etat_profil, commentaires_profil) 
VALUES 
(1, 'Profil Admin Utilisateur 1', 'Profil dédié à l\'administrateur du système.', 'https://example.com/profile1.jpg', 'Préférence 1: Notifications activées.', '2025-01-01 08:00:00', 'actif', 'Profil actif et fonctionnel.'),
(2, 'Profil Standard Utilisateur 2', 'Profil standard de l\'utilisateur, avec des paramètres par défaut.', 'https://example.com/profile2.jpg', 'Préférence 2: Notifications désactivées.', '2024-12-01 08:00:00', 'inactif', 'Profil inactif, aucune activité récente.');



CREATE TABLE Utilisateur (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),  -- Nom de l'utilisateur
    email VARCHAR(255),  -- Email de l'utilisateur
    mot_de_passe_utilisateur VARCHAR(255),  -- Mot de passe
    role_utilisateur ENUM('administrateur', 'membre') NOT NULL,  -- Rôle de l'utilisateur
    etat ENUM('actif', 'inactif', 'nonétant') NOT NULL,  -- État de l'utilisateur
    date_creation DATETIME,  -- Date de création de l'utilisateur
    date_derniere_connexion DATETIME,  -- Date de la dernière connexion
    heure_derniere_connexion TIME,  -- Heure de la dernière connexion
    commentaires TEXT  -- Commentaires
) ENGINE=InnoDB;

-- Insertion des données de test
INSERT INTO Utilisateur (nom, email, mot_de_passe_utilisateur, role_utilisateur, etat, date_creation, date_derniere_connexion, heure_derniere_connexion, commentaires) 
VALUES 
('Utilisateur Admin 1', 'admin1@example.com', 'password123', 'administrateur', 'actif', '2025-01-01 08:00:00', '2025-01-25 10:00:00', '10:30:00', 'Compte administrateur avec accès complet.'),
('Utilisateur Membre 2', 'membre2@example.com', 'password456', 'membre', 'inactif', '2024-12-01 08:00:00', '2025-01-24 09:30:00', '09:45:00', 'Utilisateur inactif, aucun accès récent.');



CREATE TABLE Statistiques_Utilisation_Contenu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_contenu INT,  -- Lien avec l'entité Contenu
    methode_mesure VARCHAR(255),  -- Méthode de mesure (ex: taux d'engagement)
    regle_mesure TEXT,  -- Règles appliquées pour la mesure
    nombre_interactions INT,  -- Nombre total d'interactions
    duree_utilisation_moyenne DECIMAL(10, 2),  -- Durée moyenne d'utilisation
    total_acces INT,  -- Nombre total d'accès
    commentaires_statistiques TEXT,  -- Commentaires supplémentaires
    FOREIGN KEY (id_contenu) REFERENCES Contenu(id)  -- Lien avec la table Contenu
) ENGINE=InnoDB;

-- Insertion des données de test
INSERT INTO Statistiques_Utilisation_Contenu (id_contenu, methode_mesure, regle_mesure, nombre_interactions, duree_utilisation_moyenne, total_acces, commentaires_statistiques) 
VALUES 
(1, 'Taux d_engagement', 'Mesure basée sur le temps passé sur le contenu et les interactions', 500, 15.5, 1000, 'Statistiques pour le contenu avec un bon engagement'),
(2, 'Nombre d\'accès', 'Mesure basée sur le nombre d\'accès directs', 200, 5.0, 800, 'Contenu avec un grand nombre d\'accès mais peu d\'interactions');



CREATE TABLE Interaction_Acteur_Cible (
    id INT PRIMARY KEY AUTO_INCREMENT,                        -- Clé primaire
    id_acteur INT,                                           -- Clé étrangère vers Acteur
    id_cible INT,                                            -- Clé étrangère vers Cible
    type_interaction VARCHAR(50),                             -- Type d'interaction
    date_interaction TIMESTAMP,                               -- Date de l'interaction
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),            -- Clé étrangère vers Acteur
    FOREIGN KEY (id_cible) REFERENCES Cible(id)               -- Clé étrangère vers Cible
) ENGINE=InnoDB;


-- Insertion des données de test
INSERT INTO Interaction_Acteur_Cible (id_acteur, id_cible, type_interaction, date_interaction) 
VALUES 
(1, 1, 'Consultation', '2025-01-25 14:00:00'),
(2, 3, 'Modification', '2025-01-25 15:30:00'),
(3, 2, 'Consultation', '2025-01-25 16:45:00');



CREATE TABLE Interaction_Acteur_Actant (
    id INT PRIMARY KEY AUTO_INCREMENT,                        -- Clé primaire
    id_acteur INT,                                           -- Clé étrangère vers Acteur
    id_actant INT,                                           -- Clé étrangère vers Actant
    type_interaction VARCHAR(50),                             -- Type d'interaction
    date_interaction TIMESTAMP,                               -- Date de l'interaction
    heure_interaction TIME,                                   -- Heure de l'interaction
    commentaires_interaction TEXT,                            -- Commentaires sur l'interaction
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),            -- Clé étrangère vers Acteur
    FOREIGN KEY (id_actant) REFERENCES Actant(id)             -- Clé étrangère vers Actant
) ENGINE=InnoDB;

-- Insertion des données de test
INSERT INTO Interaction_Acteur_Actant (id_acteur, id_actant, type_interaction, date_interaction, heure_interaction, commentaires_interaction) 
VALUES 
(1, 1, 'Collaboration', '2025-01-25 14:00:00', '14:00:00', 'Interaction sur un projet collaboratif'),
(2, 3, 'Analyse', '2025-01-25 15:30:00', '15:30:00', 'Analyse de performance'),
(3, 2, 'Révision', '2025-01-25 16:45:00', '16:45:00', 'Révision d_une tâche effectuée');


CREATE TABLE Suivi_Interaction_Acteur (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),  -- Nom de l'interaction
    id_contact INT,  -- Lien avec l'entité Contact
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_utilisateur INT,  -- Lien avec l'entité Utilisateur
    id_actant INT,  -- Lien avec l'entité Actant
    id_cible INT,  -- Lien avec l'entité Cible
    id_contenu INT,  -- Lien avec l'entité Contenu
    id_enregistrement INT,  -- Lien avec l'entité Enregistrement
    id_validation INT,  -- Lien avec l'entité Validation
    qualite ENUM('écoute', 'lecture', 'évaluation', 'commentaire') NOT NULL,  -- Qualité de l'interaction
    date_interaction DATETIME,  -- Date de l'interaction
    heure_interaction TIME,  -- Heure de l'interaction
    commentaires_interaction TEXT,  -- Commentaires sur l'interaction
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id), -- Clé étrangère vers Utilisateur
    FOREIGN KEY (id_contact) REFERENCES Contact(id), -- Clé étrangère vers Contact
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id), -- Clé étrangère vers Acteur
    FOREIGN KEY (id_actant) REFERENCES Actant(id), -- Clé étrangère vers Actant
    FOREIGN KEY (id_cible) REFERENCES Cible(id), -- Clé étrangère vers Cible
    FOREIGN KEY (id_contenu) REFERENCES Contenu(id), -- Clé étrangère vers Contenu
    FOREIGN KEY (id_enregistrement) REFERENCES Enregistrement(id), -- Clé étrangère vers Enregistrement
    FOREIGN KEY (id_validation) REFERENCES Validation(id) -- Clé étrangère vers Validation
) ENGINE=InnoDB;

-- Insertion des données de test
INSERT INTO Suivi_Interaction_Acteur (
    nom, id_contact, id_acteur, id_utilisateur, id_actant, id_cible, id_contenu, id_enregistrement, id_validation, qualite, date_interaction, heure_interaction, commentaires_interaction
) 
VALUES 
('Interaction 1', 1, 1, 2, 3, 1, 1, 1, 1, 'écoute', '2025-01-25 14:00:00', '14:00:00', 'Interaction centrée sur l_écoute du contenu'),
('Interaction 2', 2, 3, 1, 2, 2, 3, 2, 2, 'évaluation', '2025-01-25 15:00:00', '15:00:00', 'Évaluation du contenu par l_acteur et la cible');



CREATE TABLE Suivi_Interaction_Actant (
    id INT PRIMARY KEY AUTO_INCREMENT,
    appellation VARCHAR(255),  -- Appellation de l'interaction
    id_contact INT,  -- Lien avec l'entité Contact
    id_actant INT,  -- Lien avec l'entité Actant
    id_utilisateur INT,  -- Lien avec l'entité Utilisateur
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_cible INT,  -- Lien avec l'entité Cible
    id_contenu INT,  -- Lien avec l'entité Contenu
    id_enregistrement INT,  -- Lien avec l'entité Enregistrement
    id_validation INT,  -- Lien avec l'entité Validation
    qualite ENUM('écoute', 'lecture', 'évaluation', 'commentaire') NOT NULL,  -- Qualité de l'interaction
    date_interaction DATETIME,  -- Date de l'interaction
    heure_interaction TIME,  -- Heure de l'interaction
    commentaires_interaction TEXT,  -- Commentaires sur l'interaction
    statut_licence ENUM('public_domain', 'proprietary', 'restricted') NOT NULL,  -- Statut de la licence du contenu
    date_licence DATETIME,  -- Date de la licence
    free_access BOOLEAN,  -- Indicateur d'accès gratuit
    licence VARCHAR(255),  -- Licence associée au contenu
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id), -- Clé étrangère vers Utilisateur
    FOREIGN KEY (id_contact) REFERENCES Contact(id), -- Clé étrangère vers Contact
    FOREIGN KEY (id_actant) REFERENCES Actant(id), -- Clé étrangère vers Actant
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id), -- Clé étrangère vers Acteur
    FOREIGN KEY (id_cible) REFERENCES Cible(id), -- Clé étrangère vers Cible
    FOREIGN KEY (id_contenu) REFERENCES Contenu(id), -- Clé étrangère vers Contenu
    FOREIGN KEY (id_enregistrement) REFERENCES Enregistrement(id), -- Clé étrangère vers Enregistrement
    FOREIGN KEY (id_validation) REFERENCES Validation(id) -- Clé étrangère vers Validation
) ENGINE=InnoDB;

-- Insertion des données de test
INSERT INTO Suivi_Interaction_Actant (
    appellation, id_contact, id_actant, id_utilisateur, id_acteur, id_cible, id_contenu, id_enregistrement, id_validation, qualite, date_interaction, heure_interaction, commentaires_interaction, statut_licence, date_licence, free_access, licence
) 
VALUES 
('Interaction 1', 1, 1, 2, 1, 3, 1, 1, 1, 'écoute', '2025-01-25 14:00:00', '14:00:00', 'Interaction avec contenu libre', 'public_domain', '2025-01-25 14:00:00', TRUE, 'Licence Publique'),
('Interaction 2', 2, 3, 1, 2, 2, 3, 2, 2, 'évaluation', '2025-01-25 15:00:00', '15:00:00', 'Évaluation avec contenu sous licence restreinte', 'restricted', '2025-01-25 15:00:00', FALSE, 'Licence Restreinte');



CREATE TABLE Suivi_Interaction_Utilisateur (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),  -- Nom de l'interaction
    id_contact INT,  -- Lien avec l'entité Contact
    id_utilisateur INT,  -- Lien avec l'entité Utilisateur
    id_actant INT,  -- Lien avec l'entité Actant
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_cible INT,  -- Lien avec l'entité Cible
    id_contenu INT,  -- Lien avec le contenu (musique, livre, etc.)
    id_enregistrement INT,  -- Lien avec l'entité Enregistrement
    id_validation INT,  -- Lien avec l'entité Validation
    qualite ENUM('écoute', 'lecture', 'évaluation', 'commentaire') NOT NULL,  -- Qualité de l'interaction
    date_interaction DATETIME,  -- Date de l'interaction
    heure_interaction TIME,  -- Heure de l'interaction
    commentaires_interaction TEXT,  -- Commentaires sur l'interaction
    statut_licence ENUM('public_domain', 'proprietary', 'restricted') NOT NULL,  -- Statut de la licence du contenu
    date_licence DATETIME,  -- Date de la licence
    free_access BOOLEAN,  -- Indicateur d'accès gratuit
    licence VARCHAR(255),  -- Licence associée au contenu
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id), -- Clé étrangère vers Utilisateur
    FOREIGN KEY (id_contact) REFERENCES Contact(id), -- Clé étrangère vers Contact
    FOREIGN KEY (id_actant) REFERENCES Actant(id), -- Clé étrangère vers Actant
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id), -- Clé étrangère vers Acteur
    FOREIGN KEY (id_cible) REFERENCES Cible(id), -- Clé étrangère vers Cible
    FOREIGN KEY (id_contenu) REFERENCES Contenu(id), -- Clé étrangère vers Contenu
    FOREIGN KEY (id_enregistrement) REFERENCES Enregistrement(id), -- Clé étrangère vers Enregistrement
    FOREIGN KEY (id_validation) REFERENCES Validation(id) -- Clé étrangère vers Validation
) ENGINE=InnoDB;

-- Insertion des données de test
INSERT INTO Suivi_Interaction_Utilisateur (
    nom, id_contact, id_utilisateur, id_actant, id_acteur, id_cible, id_contenu, id_enregistrement, id_validation, qualite, date_interaction, heure_interaction, commentaires_interaction, statut_licence, date_licence, free_access, licence
) 
VALUES 
('Interaction 1', 1, 1, 1, 1, 1, 1, 1, 1, 'écoute', '2025-01-25 14:00:00', '14:00:00', 'Interaction utilisateur avec contenu libre', 'public_domain', '2025-01-25 14:00:00', TRUE, 'Licence Publique'),
('Interaction 2', 2, 2, 2, 2, 2, 2, 2, 2, 'évaluation', '2025-01-25 15:00:00', '15:00:00', 'Évaluation avec contenu sous licence', 'restricted', '2025-01-25 15:00:00', FALSE, 'Licence Restreinte');



CREATE TABLE Accès_Utilisateur_Contenu (
    id SERIAL PRIMARY KEY,                        -- Clé primaire
    id_utilisateur INT,                           -- Clé étrangère vers l'entité Utilisateur
    id_contenu INT,                               -- Clé étrangère vers l'entité Contenu
    qualite_acces VARCHAR(50),                    -- Qualité de l'accès (ex: écoute, lecture, téléchargement)
    date_acces TIMESTAMP,                         -- Date d'accès
    heure_acces TIME,                             -- Heure d'accès
    commentaires_acces TEXT,                      -- Commentaires associés
    free_access BOOLEAN,                          -- Accès gratuit autorisé
    statut_licence ENUM('public_domain', 'proprietary', 'restricted') NOT NULL,  -- Statut de la licence du contenu
    date_licence DATETIME,                        -- Date de la licence
    licence VARCHAR(255),                         -- Licence associée au contenu
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id), -- Clé étrangère vers Utilisateur
    FOREIGN KEY (id_contenu) REFERENCES Contenu(id) -- Clé étrangère vers Contenu
) ENGINE=InnoDB;

-- Insertion des données de test
INSERT INTO Accès_Utilisateur_Contenu (
    id_utilisateur, id_contenu, qualite_acces, date_acces, heure_acces, commentaires_acces, free_access, statut_licence, date_licence, licence
) 
VALUES 
(1, 1, 'écoute', '2025-01-25 16:00:00', '16:00:00', 'Accès au contenu libre', TRUE, 'public_domain', '2025-01-25 16:00:00', 'Licence Publique'),
(2, 2, 'lecture', '2025-01-25 17:00:00', '17:00:00', 'Accès au contenu sous licence', FALSE, 'restricted', '2025-01-25 17:00:00', 'Licence Restreinte');



CREATE TABLE Livres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255),  -- Titre du livre
    auteur VARCHAR(255),  -- Auteur du livre
    genre VARCHAR(255),  -- Genre du livre (ex: fiction, non-fiction, fantasy)
    date_publication DATETIME,  -- Date de publication du livre
    editeur VARCHAR(255),  -- Éditeur du livre
    edition VARCHAR(255),  -- Édition du livre
    isbn_livre VARCHAR(255),  -- ISBN du livre
    url VARCHAR(255),  -- URL du livre
    qualite ENUM('papier', 'ebook', 'audio') NOT NULL,  -- Qualité du livre
    etat ENUM('disponible', 'en_précommande', 'épuisé') NOT NULL,  -- État du livre
    feedback_utilisateur TEXT,  -- Feedback des utilisateurs
    feedback_interne TEXT,  -- Feedback interne
    resume TEXT,  -- Résumé du livre
    accessibilite TEXT,  -- Accessibilité du livre
    licence VARCHAR(255),  -- Licence du livre
    free_diffusion BOOLEAN,  -- Diffusion gratuite autorisée
    free_acquirement BOOLEAN,  -- Acquisition gratuite autorisée
    statut_licence ENUM('public_domain', 'proprietary', 'restricted') NOT NULL,  -- Statut de la licence
    date_licence DATETIME  -- Date de la licence
) ENGINE=InnoDB;

-- Insertion de données de test
INSERT INTO Livres (
    titre, auteur, genre, date_publication, editeur, edition, isbn_livre, url, qualite, etat, feedback_utilisateur, feedback_interne, resume, accessibilite, licence, free_diffusion, free_acquirement, statut_licence, date_licence
)
VALUES 
('Le Comte de Monte-Cristo', 'Alexandre Dumas', 'Roman historique', '1844-01-01', 'Ed. A. L. A', '1ère', '978-3-16-148410-0', 'http://exemple.com/montecristo', 'papier', 'disponible', 'Un chef-d_œuvre de la littérature', 'Très bon accueil interne', 'L_histoire de vengeance et de rédemption de Edmond Dantès', 'Accessible aux personnes malvoyantes', 'Licence Publique', TRUE, TRUE, 'public_domain', '1844-01-01'),
('1984', 'George Orwell', 'Science-fiction', '1949-06-08', 'Secker & Warburg', '1ère', '978-0-452-28423-4', 'http://exemple.com/1984', 'ebook', 'disponible', 'Livre captivant et perturbant', 'Analyse très critique', 'Une dystopie sur la surveillance de l_individu', 'Pas encore accessible aux malentendants', 'Licence Restreinte', FALSE, FALSE, 'restricted', '1949-06-08');


-- Create the Musiques table if it doesn't exist
CREATE TABLE IF NOT EXISTS Musiques (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),  -- Nom de la musique
    artiste_id INT,  -- Lien avec l'artiste
    album_id INT,  -- Lien avec l'album
    duree INT,  -- Durée de la musique (en secondes)
    genre VARCHAR(255),  -- Genre de la musique
    description TEXT,  -- Description de la musique
    date_production DATETIME,  -- Date de production
    date_commercialisation DATETIME,  -- Date de commercialisation
    licence VARCHAR(255),  -- Licence de la musique
    free_diffusion BOOLEAN,  -- Diffusion gratuite autorisée
    free_acquirement BOOLEAN,  -- Acquisition gratuite autorisée
    statut_licence ENUM('public_domain', 'proprietary', 'restricted') NOT NULL,  -- Statut de la licence
    date_licence DATETIME,  -- Date de la licence
    accessibilite TEXT,  -- Accessibilité
    feedback_utilisateur TEXT,  -- Feedback des utilisateurs
    auteur VARCHAR(255),  -- Auteur de la musique
    compositeur VARCHAR(255),  -- Compositeur de la musique
    interprete VARCHAR(255),  -- Interprète de la musique
    producteur VARCHAR(255),  -- Producteur de la musique
    url VARCHAR(255),  -- URL de la musique
    commentaires TEXT,  -- Commentaires supplémentaires
    FOREIGN KEY (artiste_id) REFERENCES Artiste(id),
    FOREIGN KEY (album_id) REFERENCES Album(id)
) ENGINE=InnoDB;

-- Test the existence of the table
SELECT COUNT(*) 
FROM information_schema.tables -- vue interne des métadonnées indépendante de la table système des métadonnées SQL Server.
WHERE table_name = 'Musiques';

-- Test the primary key auto-increment
DESCRIBE Musiques;

-- Test the foreign key constraints (Check if the referenced tables exist)
SHOW CREATE TABLE Musiques;

-- Test ENUM values in statut_licence
-- Insert sample data to verify ENUM behavior
INSERT INTO Musiques (nom, artiste_id, album_id, duree, genre, statut_licence) 
VALUES ('Sample Music', 1, 1, 300, 'Pop', 'public_domain');

-- Insert valid data for further testing
INSERT INTO Musiques (nom, artiste_id, album_id, duree, genre, statut_licence, date_production, date_commercialisation, licence, free_diffusion, free_acquirement, date_licence)
VALUES ('Classic Melody', 2, 2, 250, 'Jazz', 'proprietary', NOW(), NOW(), 'Proprietary License', TRUE, TRUE, NOW());

-- Select the inserted data for verification
SELECT * FROM Musiques;


-- Créer la table Album si elle n'existe pas
CREATE TABLE IF NOT EXISTS Album (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255),  -- Titre de l'album
    artiste_id INT,  -- Lien avec l'artiste
    date_production DATETIME,  -- Date de production
    licence VARCHAR(255),  -- Licence de l'album
    free_diffusion BOOLEAN,  -- Diffusion gratuite autorisée
    free_acquirement BOOLEAN,  -- Acquisition gratuite autorisée
    statut_licence ENUM('public_domain', 'proprietary', 'restricted') NOT NULL,  -- Statut de la licence
    date_licence DATETIME,  -- Date de la licence
    url VARCHAR(255),  -- URL de l'album
    commentaires TEXT,  -- Commentaires sur l'album
    FOREIGN KEY (artiste_id) REFERENCES Artiste(id)
) ENGINE=InnoDB;

-- Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Album';

-- Tester la clé primaire auto-incrémentée
DESCRIBE Album;

-- Tester les contraintes de clé étrangère (Vérifier que la table Artiste existe)
SHOW CREATE TABLE Album;

-- Tester les valeurs de l'ENUM pour statut_licence
-- Insérer des données d'exemple pour vérifier le comportement de l'ENUM
INSERT INTO Album (titre, artiste_id, statut_licence) 
VALUES ('Album Test', 1, 'public_domain');

-- Insérer des données valides pour un test plus complet
INSERT INTO Album (titre, artiste_id, date_production, licence, free_diffusion, free_acquirement, statut_licence, date_licence, url)
VALUES ('Classic Jazz', 2, NOW(), 'Public Domain', TRUE, TRUE, 'public_domain', NOW(), 'http://url.com');


-- Créer la table Artiste si elle n'existe pas
CREATE TABLE IF NOT EXISTS Artiste (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),  -- Nom de l'artiste
    date_creation DATETIME,  -- Date de création
    licence VARCHAR(255),  -- Licence de l'artiste
    free_diffusion BOOLEAN,  -- Diffusion gratuite autorisée
    free_acquirement BOOLEAN,  -- Acquisition gratuite autorisée
    statut_licence ENUM('public_domain', 'proprietary', 'restricted') NOT NULL,  -- Statut de la licence
    date_licence DATETIME,  -- Date de la licence
    url VARCHAR(255),  -- URL de l'artiste
    commentaires TEXT  -- Commentaires supplémentaires
) ENGINE=InnoDB;

-- Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Artiste';

-- Tester la clé primaire auto-incrémentée
DESCRIBE Artiste;

-- Tester les contraintes de clé étrangère
SHOW CREATE TABLE Artiste;

-- Tester les valeurs de l'ENUM pour statut_licence
-- Insérer des données d'exemple pour vérifier le comportement de l'ENUM
INSERT INTO Artiste (nom, statut_licence) 
VALUES ('Artiste Test', 'public_domain');

-- Insérer des données valides pour un test plus complet
INSERT INTO Artiste (nom, date_creation, licence, free_diffusion, free_acquirement, statut_licence, date_licence, url)
VALUES ('Test Artist', NOW(), 'Public Domain', TRUE, TRUE, 'public_domain', NOW(), 'http://urlartist.com');



-- Créer la table Logs_utilisateur si elle n'existe pas
CREATE TABLE IF NOT EXISTS Logs_utilisateur (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_utilisateur INT,  -- Lien avec l'entité Utilisateur
    action_sujette ENUM('connexion', 'modification') NOT NULL,  -- Action réalisée par l'utilisateur
    date_action DATETIME,  -- Date de l'action
    details_action TEXT,  -- Détails de l'action
    commentaires TEXT,  -- Commentaires sur l'action
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id)  -- Relation avec la table Utilisateur
) ENGINE=InnoDB;

-- Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Logs_utilisateur';

-- Tester la clé primaire auto-incrémentée
DESCRIBE Logs_utilisateur;

-- Tester la clé étrangère (id_utilisateur)
SHOW CREATE TABLE Logs_utilisateur;

-- Tester l'insertion de données valides
-- Exemple d'insertion d'une action de connexion
INSERT INTO Logs_utilisateur (id_utilisateur, action_sujette, date_action, details_action, commentaires)
VALUES (1, 'connexion', NOW(), 'Connexion réussie', 'Connexion normale');

-- Vérifier la récupération des données insérées
SELECT * FROM Logs_utilisateur;

-- Tester la validation de l'ENUM (action_sujette)
-- Tentative d'insertion d'une action non valide pour vérifier la contrainte
-- INSERT INTO Logs_utilisateur (id_utilisateur, action_sujette, date_action, details_action, commentaires)
-- VALUES (1, 'invalid_action', NOW(), 'Tentative d\'action invalide', 'Erreur de type d\'action');



-- Créer la table Alertes_système si elle n'existe pas
CREATE TABLE IF NOT EXISTS Alertes_système (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_enregistrement INT,  -- Lien avec l'entité Enregistrement
    qualite ENUM('performance', 'sécurité', 'erreur') NOT NULL,  -- Qualité de l'alerte système
    severite ENUM('sans_danger', 'faible', 'moyenne', 'élevée', 'critique') NOT NULL,  -- Sévérité de l'alerte
    date DATETIME,  -- Date de l'alerte
    is_actant BOOLEAN,  -- Si l'alerte est liée à un actant
    id_acteur INT,  -- Lien avec l'entité Acteur
    commentaires TEXT,  -- Commentaires sur l'alerte système
    FOREIGN KEY (id_enregistrement) REFERENCES Enregistrement(id),  -- Relation avec la table Enregistrement
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id)  -- Relation avec la table Acteur
) ENGINE=InnoDB;

-- Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Alertes_système';

-- Tester la clé primaire auto-incrémentée
DESCRIBE Alertes_système;

-- Tester les clés étrangères (id_enregistrement, id_acteur)
SHOW CREATE TABLE Alertes_système;

-- Tester l'insertion de données valides
-- Exemple d'insertion d'une alerte de performance faible
INSERT INTO Alertes_système (id_enregistrement, qualite, severite, date, is_actant, id_acteur, commentaires)
VALUES (1, 'performance', 'faible', NOW(), FALSE, 1, 'Problème de performance détecté');

-- Vérifier la récupération des données insérées
SELECT * FROM Alertes_système;

-- Tester la validation des ENUM
-- Tentative d'insertion d'une qualité non valide pour vérifier la contrainte
-- INSERT INTO Alertes_système (id_enregistrement, qualite, severite, date, is_actant, id_acteur, commentaires)
-- VALUES (1, 'invalid_quality', 'faible', NOW(), FALSE, 1, 'Test d\'alerte invalide');



-- Créer la table Sécurisation_Accès si elle n'existe pas
CREATE TABLE IF NOT EXISTS Sécurisation_Accès (
    id INT PRIMARY KEY AUTO_INCREMENT,
    qualite ENUM('authentification', 'cryptage') NOT NULL,  -- Qualité de la sécurisation d'accès
    niveau ENUM('faible', 'moyen', 'élevé') NOT NULL,       -- Niveau de sécurisation
    date_securisation DATETIME,                             -- Date de sécurisation de l'accès
    acteur_securisation VARCHAR(255),                       -- Acteur responsable de la sécurisation
    actant_securisant VARCHAR(255),                          -- Actant responsable de la sécurisation
    commentaires TEXT,                                      -- Commentaires sur la sécurisation de l'accès
    FOREIGN KEY (acteur_securisation) REFERENCES Acteur(id), -- Relation avec la table Acteur
    FOREIGN KEY (actant_securisant) REFERENCES Actant(id)    -- Relation avec la table Actant
) ENGINE=InnoDB;

-- Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Sécurisation_Accès';

-- Tester la clé primaire auto-incrémentée
DESCRIBE Sécurisation_Accès;

-- Tester les clés étrangères (acteur_securisation, actant_securisant)
SHOW CREATE TABLE Sécurisation_Accès;

-- Tester l'insertion de données valides
-- Exemple d'insertion d'une sécurisation d'accès avec authentification et niveau élevé
INSERT INTO Sécurisation_Accès (qualite, niveau, date_securisation, acteur_securisation, actant_securisant, commentaires)
VALUES ('authentification', 'élevé', NOW(), 'Acteur Test', 'Actant Test', 'Sécurisation par authentification avec niveau élevé');

-- Vérifier la récupération des données insérées
SELECT * FROM Sécurisation_Accès;

-- Tester la validation des ENUM
-- Tentative d'insertion d'une qualité non valide pour vérifier la contrainte
-- INSERT INTO Sécurisation_Accès (qualite, niveau, date_securisation, acteur_securisation, actant_securisant, commentaires)
-- VALUES ('invalid_quality', 'faible', NOW(), 'Acteur Test', 'Actant Test', 'Test de sécurisation invalide');


-- Créer la table Ressource si elle n'existe pas
CREATE TABLE IF NOT EXISTS Ressource (
    id INT PRIMARY KEY AUTO_INCREMENT,            -- Clé primaire
    qualite ENUM('mémoire', 'processeur', 'stockage') NOT NULL,  -- Qualité de la ressource
    quantite INT,                                 -- Quantité disponible
    disponibilite BOOLEAN,                        -- Disponibilité
    date_allocation TIMESTAMP,                    -- Date d'allocation
    quantite_utilisee DECIMAL(10, 2),             -- Quantité utilisée de la ressource
    date_utilisation DATETIME,                    -- Date d'utilisation de la ressource
    usager VARCHAR(255),                          -- Usager de la ressource
    etat VARCHAR(50),                             -- Etat de la ressource
    FOREIGN KEY (id) REFERENCES Controle(id)      -- Il faut que j'ajuste ultérieurement la relation avec la table Contrôle
) ENGINE=InnoDB;

-- Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Ressource';

-- Tester la clé primaire auto-incrémentée
DESCRIBE Ressource;

-- Tester les contraintes ENUM
SHOW CREATE TABLE Ressource;

-- Tester l'insertion de données valides
-- Exemple d'insertion d'une ressource avec qualité "mémoire"
INSERT INTO Ressource (qualite, quantite, disponibilite, date_allocation, quantite_utilisee, date_utilisation, usager, etat)
VALUES ('mémoire', 100, TRUE, NOW(), 50.0, NOW(), 'Usager Test', 'fonctionnel');

-- Vérifier la récupération des données insérées
SELECT * FROM Ressource;

-- Tester la validation des ENUM
-- Tentative d'insertion d'une qualité non valide pour vérifier la contrainte
-- INSERT INTO Ressource (qualite, quantite, disponibilite, date_allocation, quantite_utilisee, date_utilisation, usager, etat)
-- VALUES ('invalid_quality', 100, TRUE, NOW(), 50.0, NOW(), 'Usager Test', 'fonctionnel');


-- Créer la table Accessibilité si elle n'existe pas
CREATE TABLE IF NOT EXISTS Accessibilité (
    id INT PRIMARY KEY AUTO_INCREMENT,
    norme VARCHAR(255),  -- Norme d'accessibilité (ex: WCAG 2.1)
    score DECIMAL(5, 2),  -- Score d'accessibilité (ex: 80%)
    element_non_accessible TEXT,  -- Éléments non accessibles
    date_evaluation DATETIME,  -- Date de l'évaluation d'accessibilité
    acteur_evaluation VARCHAR(255),  -- Acteur ayant évalué l'accessibilité
    actant_evaluation VARCHAR(255),  -- Actant ayant évalué l'accessibilité
    commentaires TEXT,  -- Commentaires sur l'accessibilité
    CHECK (date_evaluation <= CURRENT_TIMESTAMP)  -- Vérification que la date n'est pas dans le futur
) ENGINE=InnoDB;

-- Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Accessibilité';

-- Tester la clé primaire auto-incrémentée
DESCRIBE Accessibilité;

-- Tester la contrainte CHECK sur date_evaluation
SHOW CREATE TABLE Accessibilité;

-- Tester l'insertion de données valides
-- Exemple d'insertion d'une évaluation d'accessibilité
INSERT INTO Accessibilité (norme, score, element_non_accessible, date_evaluation, acteur_evaluation, actant_evaluation, commentaires)
VALUES ('WCAG 2.1', 85.5, 'Contraste insuffisant sur certaines pages', NOW(), 'Évaluateur Test', 'Actant Test', 'Accès satisfaisant dans l_ensemble');

-- 6. Vérifier la récupération des données insérées
SELECT * FROM Accessibilité;

-- 7. Tester la contrainte CHECK (date_evaluation <= CURRENT_TIMESTAMP)
-- Tentative d'insertion avec une date future pour tester la contrainte
-- INSERT INTO Accessibilité (norme, score, element_non_accessible, date_evaluation, acteur_evaluation, actant_evaluation, commentaires)
-- VALUES ('WCAG 2.1', 75.0, 'Problème de navigation au clavier', '9999-12-31 00:00:00', 'Évaluateur Test', 'Actant Test', 'Problème non résolu');


-- 1. Créer la table Taux_conversion si elle n'existe pas
CREATE TABLE IF NOT EXISTS Taux_conversion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),  -- Nom de la conversion (ex: abonnement)
    valeur DECIMAL(5, 2),  -- Valeur du taux de conversion (ex: 15%)
    qualite_conversion ENUM('excellente', 'moyenne', 'faible') NOT NULL,  -- Qualité de la conversion
    date_conversion DATETIME,  -- Date de la conversion
    source_accroche TEXT,  -- Source de l'accroche
    commentaires TEXT,  -- CREER UNE CLONNE RESPONSABE EN REQUIRED OU PENSER A RENDRE CETTE COLONNE OBLIGATOIRE ! CONFIRMATION DE L4ACTION ADMINISTRATIVE SUJETTE ! Commentaires sur la conversion 
    strategie TEXT,  -- Stratégie utilisée
    time_t DATETIME NOT NULL,  -- Temps immuable pour la conversion
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que le temps t de la conversion n'est pas dans le futur
) ENGINE=InnoDB;

-- 2. Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Taux_conversion';

-- 3. Tester la clé primaire auto-incrémentée
DESCRIBE Taux_conversion;

-- 4. Tester la contrainte CHECK sur time_t
SHOW CREATE TABLE Taux_conversion;

-- 5. Tester l'insertion de données valides
-- Exemple d'insertion d'un taux de conversion
INSERT INTO Taux_conversion (nom, valeur, qualite_conversion, date_conversion, source_accroche, commentaires, strategie, time_t)
VALUES ('Abonnement annuel', 15.00, 'excellente', NOW(), 'Campagne email', 'Conversion réussie', 'Stratégie d_emailing', NOW());

-- 6. Vérifier la récupération des données insérées
SELECT * FROM Taux_conversion;

-- 7. Tester la contrainte CHECK (time_t <= now)
-- Tentative d'insertion avec un time_t futur pour tester la contrainte
-- INSERT INTO Taux_conversion (nom, valeur, qualite_conversion, date_conversion, source_accroche, commentaires, strategie, time_t)
-- VALUES ('Abonnement mensuel', 10.00, 'moyenne', NOW(), 'Publicité en ligne', 'Conversion en cours', 'Publicité ciblée', '9999-12-31 00:00:00');


-- 1. Créer la table Performance_système si elle n'existe pas
CREATE TABLE IF NOT EXISTS Performance_système (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_actant INT,  -- Lien avec l'entité Actant
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_indicacteur INT,  -- Lien avec l'entité Indicacteur
    id_interface INT,  -- Lien avec l'entité Interface
    valeur DECIMAL(10, 2),  -- Valeur de la performance mesurée
    seuil_alerte DECIMAL(10, 2),  -- Seuil d'alerte pour la performance
    date_performance DATETIME,  -- Date de la mesure de performance
    commentaires TEXT,  -- Commentaires sur la performance du système
    time_t DATETIME NOT NULL,  -- Temps immuable pour la performance
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que le temps t de la performance n'est pas dans le futur
) ENGINE=InnoDB;

-- 2. Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Performance_système';

-- 3. Tester la clé primaire auto-incrémentée
DESCRIBE Performance_système;

-- 4. Tester la contrainte CHECK sur time_t
SHOW CREATE TABLE Performance_système;

-- 5. Tester l'insertion de données valides
-- Exemple d'insertion d'une performance système
INSERT INTO Performance_système (id_actant, id_acteur, id_indicacteur, id_interface, valeur, seuil_alerte, date_performance, commentaires, time_t)
VALUES (1, 1, 1, 1, 85.5, 90.0, NOW(), 'Performance mesurée pour l_interface', NOW());

-- 6. Vérifier la récupération des données insérées
SELECT * FROM Performance_système;

-- 7. Tester la contrainte CHECK (time_t <= now)
-- Tentative d'insertion avec un time_t futur pour tester la contrainte
-- INSERT INTO Performance_système (id_actant, id_acteur, id_indicacteur, id_interface, valeur, seuil_alerte, date_performance, commentaires, time_t)
-- VALUES (1, 1, 1, 1, 95.0, 90.0, NOW(), 'Performance future testée', '9999-12-31 00:00:00');


-- 1. Créer la table Expérience_utilisateur si elle n'existe pas
CREATE TABLE IF NOT EXISTS Expérience_utilisateur (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_utilisateur INT,  -- Lien avec l'entité Utilisateur
    score_satisfaction INT,  -- Score de satisfaction de l'utilisateur
    feedback_utilisateur TEXT,  -- Feedback de l'utilisateur
    temps_interaction INT,  -- Temps d'interaction
    difficulté ENUM('faible', 'modérée', 'moyenne', 'élevée', 'très_élevée') NOT NULL,  -- Difficulté de l'interaction
    feedback_amelioration TEXT,  -- Feedback pour l'amélioration
    date_feedback DATETIME,  -- Date du feedback
    time_t DATETIME NOT NULL,  -- Temps immuable pour le feedback
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que le temps t du feedback n'est pas dans le futur
) ENGINE=InnoDB;

-- 2. Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Expérience_utilisateur';

-- 3. Tester la clé primaire auto-incrémentée
DESCRIBE Expérience_utilisateur;

-- 4. Tester la contrainte CHECK sur time_t
SHOW CREATE TABLE Expérience_utilisateur;

-- 5. Tester l'insertion de données valides
-- Exemple d'insertion d'une expérience utilisateur
INSERT INTO Expérience_utilisateur (id_acteur, id_utilisateur, score_satisfaction, feedback_utilisateur, temps_interaction, difficulté, feedback_amelioration, date_feedback, time_t)
VALUES (1, 1, 8, 'Très satisfait de l_interaction', 30, 'faible', 'Améliorer la vitesse de la page', NOW(), NOW());

-- 6. Vérifier la récupération des données insérées
SELECT * FROM Expérience_utilisateur;

-- 7. Tester la contrainte CHECK (time_t <= now)
-- Tentative d'insertion avec un time_t futur pour tester la contrainte
-- INSERT INTO Expérience_utilisateur (id_acteur, id_utilisateur, score_satisfaction, feedback_utilisateur, temps_interaction, difficulté, feedback_amelioration, date_feedback, time_t)
-- VALUES (1, 1, 9, 'Très satisfait, mais besoin d\'améliorations', 45, 'modérée', 'Optimiser les temps de réponse', NOW(), '9999-12-31 00:00:00');



-- 1. Créer la table Optimisation si elle n'existe pas
CREATE TABLE IF NOT EXISTS Optimisation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_actant INT,  -- Lien avec l'entité Actant
    id_acteur INT,  -- Lien avec l'entité Acteur
    qualite ENUM('base_de_données', 'traitement_des_requêtes') NOT NULL,  -- Qualité de l'optimisation
    objectif ENUM('vitesse', 'consommation_mémoire') NOT NULL,  -- Objectif de l'optimisation
    date DATETIME,  -- Date de l'optimisation
    résultat ENUM('succès', 'échec') NOT NULL,  -- Résultat de l'optimisation
    commentaires TEXT,  -- Commentaires sur l'optimisation
    time_t DATETIME NOT NULL,  -- Temps immuable pour l'optimisation
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que le temps t de l'optimisation n'est pas dans le futur
) ENGINE=InnoDB;

-- 2. Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Optimisation';

-- 3. Tester la clé primaire auto-incrémentée
DESCRIBE Optimisation;

-- 4. Tester la contrainte CHECK sur time_t
SHOW CREATE TABLE Optimisation;

-- 5. Tester l'insertion de données valides
-- Exemple d'insertion d'une optimisation
INSERT INTO Optimisation (id_actant, id_acteur, qualite, objectif, date, résultat, commentaires, time_t)
VALUES (1, 1, 'base_de_données', 'vitesse', NOW(), 'succès', 'Optimisation réussie pour améliorer la vitesse de la base de données', NOW());

-- 6. Vérifier la récupération des données insérées
SELECT * FROM Optimisation;

-- 7. Tester la contrainte CHECK (time_t <= now)
-- Tentative d'insertion avec un time_t futur pour tester la contrainte
-- INSERT INTO Optimisation (id_actant, id_acteur, qualite, objectif, date, résultat, commentaires, time_t)
-- VALUES (1, 1, 'traitement_des_requêtes', 'consommation_mémoire', NOW(), 'échec', 'Optimisation échouée', '9999-12-31 00:00:00');


-- 1. Créer la table Feedback si elle n'existe pas
CREATE TABLE IF NOT EXISTS Feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    qualite ENUM('positif', 'négatif', 'neutre') NOT NULL,  -- Qualité du feedback
    source ENUM('utilisateur', 'acteur') NOT NULL,  -- Source du feedback
    commentaires TEXT,  -- Commentaires du feedback
    date DATETIME,  -- Date du feedback
    statut ENUM('en_attente', 'terminé') NOT NULL,  -- Statut du feedback
    time_t DATETIME NOT NULL,  -- Temps immuable pour le feedback
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que le temps t du feedback n'est pas dans le futur
) ENGINE=InnoDB;

-- 2. Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Feedback';

-- 3. Tester la clé primaire auto-incrémentée
DESCRIBE Feedback;

-- 4. Tester la contrainte CHECK sur time_t
SHOW CREATE TABLE Feedback;

-- 5. Tester l'insertion de données valides
-- Exemple d'insertion d'un feedback positif
INSERT INTO Feedback (qualite, source, commentaires, date, statut, time_t)
VALUES ('positif', 'utilisateur', 'Très satisfait de la performance.', NOW(), 'terminé', NOW());

-- 6. Vérifier la récupération des données insérées
SELECT * FROM Feedback;

-- 7. Tester la contrainte CHECK (time_t <= now)
-- Tentative d'insertion avec un time_t futur pour tester la contrainte
-- INSERT INTO Feedback (qualite, source, commentaires, date, statut, time_t)
-- VALUES ('négatif', 'acteur', 'Performance insatisfaisante.', NOW(), 'en_attente', '9999-12-31 00:00:00');



-- 1. Créer la table Synchronisation si elle n'existe pas
CREATE TABLE IF NOT EXISTS Synchronisation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    qualite ENUM('temps_réel', 'batch') NOT NULL,  -- Qualité de la synchronisation
    source VARCHAR(255),  -- Source de la synchronisation
    cible VARCHAR(255),  -- Cible de la synchronisation
    statut ENUM('en_attente', 'en_cours', 'réussie', 'échouée') NOT NULL,  -- Statut de la synchronisation
    date DATETIME,  -- Date de la synchronisation
    time_t DATETIME NOT NULL,  -- Temps immuable pour la synchronisation
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date de synchronisation n'est pas dans le futur
) ENGINE=InnoDB;

-- 2. Tester l'existence de la table
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_name = 'Synchronisation';

-- 3. Tester la clé primaire auto-incrémentée
DESCRIBE Synchronisation;

-- 4. Tester la contrainte CHECK sur time_t
SHOW CREATE TABLE Synchronisation;

-- 5. Tester l'insertion de données valides
-- Exemple d'insertion d'une synchronisation réussie
INSERT INTO Synchronisation (qualite, source, cible, statut, date, time_t)
VALUES ('batch', 'Source A', 'Cible A', 'réussie', NOW(), NOW());

-- 6. Vérifier la récupération des données insérées
SELECT * FROM Synchronisation;

-- 7. Tester la contrainte CHECK (time_t <= now)
-- Tentative d'insertion avec un time_t futur pour tester la contrainte
-- INSERT INTO Synchronisation (qualite, source, cible, statut, date, time_t)
-- VALUES ('temps_réel', 'Source B', 'Cible B', 'en_attente', NOW(), '9999-12-31 00:00:00');


-- Création de la table Droit_Accès avec les contraintes et attributs
CREATE TABLE Droit_Accès (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    utilisateur INT,  -- Lien avec l'entité Utilisateur
    qualite ENUM('lecture', 'écriture') NOT NULL,  -- Qualité de l'accès (lecture, écriture)
    ressource_concernees TEXT,  -- Ressources concernées par le droit d'accès
    date_affectation DATETIME,  -- Date d'affectation du droit
    date_activation DATETIME,  -- Date d'activation du droit
    duree INT,  -- Durée de validité du droit
    date_desactivation DATETIME,  -- Date de désactivation du droit
    date_desaffectation DATETIME,  -- Date de désaffectation du droit
    time_t DATETIME NOT NULL,  -- Temps immuable pour l'affectation du droit
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now),  -- Vérification que la date d'affectation n'est pas dans le futur
    FOREIGN KEY (utilisateur) REFERENCES Utilisateur(id)  -- Relation avec la table Utilisateur
) ENGINE=InnoDB;

-- Tests pour la table Droit_Accès

-- Test de l'ajout d'un droit d'accès
INSERT INTO Droit_Accès (utilisateur, qualite, ressource_concernees, date_affectation, date_activation, duree, time_t)
VALUES (1, 'lecture', 'Document1', '2025-01-25 12:00:00', '2025-01-25 12:05:00', 30, '2025-01-25 12:00:00');

-- Test d'ajout d'un droit d'accès avec date désactivation
INSERT INTO Droit_Accès (utilisateur, qualite, ressource_concernees, date_affectation, date_activation, duree, date_desactivation, time_t)
VALUES (2, 'écriture', 'Document2', '2025-01-25 14:00:00', '2025-01-25 14:10:00', 60, '2025-01-25 14:30:00', '2025-01-25 14:00:00');

-- Test d'ajout d'un droit d'accès avec une date d'affectation dans le futur (devrait échouer)
INSERT INTO Droit_Accès (utilisateur, qualite, ressource_concernees, date_affectation, date_activation, duree, time_t)
VALUES (3, 'lecture', 'Document3', '2025-01-25 15:00:00', '2025-01-25 15:05:00', 120, '2025-01-25 15:30:00');

-- Test de la suppression d'un droit d'accès
DELETE FROM Droit_Accès WHERE id = 1;

-- Test de modification de la durée d'un droit d'accès
UPDATE Droit_Accès SET duree = 45 WHERE id = 2;


-- Création de la table Mesure
CREATE TABLE Mesure (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    actant VARCHAR(255),  -- Actant de la mesure
    acteur VARCHAR(255),  -- Acteur responsable de la mesure
    qualite ENUM('performance', 'conformité') NOT NULL,  -- Qualité de la mesure
    valeur DECIMAL(10, 2),  -- Valeur mesurée
    date DATETIME,  -- Date de la mesure
    validite_mesure BOOLEAN,  -- Validité de la mesure
    validite_resultat BOOLEAN,  -- Validité du résultat
    time_t DATETIME NOT NULL,  -- Temps immuable de la mesure
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date de la mesure n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Mesure

-- Test d'ajout d'une mesure de performance
INSERT INTO Mesure (actant, acteur, qualite, valeur, date, validite_mesure, validite_resultat, time_t)
VALUES ('Actant1', 'Acteur1', 'performance', 85.5, '2025-01-25 10:00:00', TRUE, TRUE, '2025-01-25 10:00:00');

-- Test d'ajout d'une mesure de conformité
INSERT INTO Mesure (actant, acteur, qualite, valeur, date, validite_mesure, validite_resultat, time_t)
VALUES ('Actant2', 'Acteur2', 'conformité', 92.3, '2025-01-25 12:00:00', TRUE, FALSE, '2025-01-25 12:00:00');

-- Test d'ajout avec une date de mesure dans le futur (devrait échouer)
INSERT INTO Mesure (actant, acteur, qualite, valeur, date, validite_mesure, validite_resultat, time_t)
VALUES ('Actant3', 'Acteur3', 'performance', 75.2, '2025-01-26 09:00:00', TRUE, TRUE, '2025-01-26 09:00:00');

-- Test de la suppression d'une mesure
DELETE FROM Mesure WHERE id = 1;

-- Test de modification d'une mesure (mettre à jour la validité du résultat)
UPDATE Mesure SET validite_resultat = TRUE WHERE id = 2;



-- Création de la table Alertes
CREATE TABLE Alertes (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    qualite ENUM('sécurité', 'performance') NOT NULL,  -- Qualité de l'alerte
    date DATETIME,  -- Date de l'alerte
    criteres_declenchement TEXT,  -- Critères déclencheurs de l'alerte
    action_requise TEXT,  -- Action requise en réponse à l'alerte
    statut ENUM('critique', 'résolue', 'en_cours', 'peu_attendre', 'ignorée') NOT NULL,  -- Statut de l'alerte
    time_t DATETIME NOT NULL,  -- Temps immuable de l'alerte
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date de l'alerte n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Alertes

-- Test d'ajout d'une alerte de sécurité
INSERT INTO Alertes (qualite, date, criteres_declenchement, action_requise, statut, time_t)
VALUES ('sécurité', '2025-01-25 14:00:00', 'Tentative d_accès non autorisée', 'Analyser les logs', 'en_cours', '2025-01-25 14:00:00');

-- Test d'ajout d'une alerte de performance
INSERT INTO Alertes (qualite, date, criteres_declenchement, action_requise, statut, time_t)
VALUES ('performance', '2025-01-25 15:00:00', 'Utilisation élevée du processeur', 'Optimiser le code', 'peu_attendre', '2025-01-25 15:00:00');

-- Test d'ajout avec une date d'alerte dans le futur (devrait échouer)
INSERT INTO Alertes (qualite, date, criteres_declenchement, action_requise, statut, time_t)
VALUES ('sécurité', '2025-01-26 16:00:00', 'Accès refusé multiple', 'Évaluer la configuration', 'critique', '2025-01-26 16:00:00');

-- Test de la suppression d'une alerte
DELETE FROM Alertes WHERE id = 1;

-- Test de modification d'une alerte (changer le statut à "résolue")
UPDATE Alertes SET statut = 'résolue' WHERE id = 2;



-- Création de la table Audit_Externe
CREATE TABLE Audit_Externe (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    acteur VARCHAR(255),  -- Acteur de l'audit externe
    actant VARCHAR(255),  -- Actant de l'audit externe
    organisation_realisation VARCHAR(255),  -- Organisation ayant réalisé l'audit
    date_audit DATETIME,  -- Date de l'audit
    rapport TEXT,  -- Rapport de l'audit
    commentaires TEXT,  -- Commentaires supplémentaires
    time_t DATETIME NOT NULL,  -- Temps immuable de l'audit
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date de l'audit n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Audit_Externe

-- Test d'ajout d'un audit externe
INSERT INTO Audit_Externe (acteur, actant, organisation_realisation, date_audit, rapport, commentaires, time_t)
VALUES ('Jean Dupont', 'Actant1', 'Organisation A', '2025-01-25 10:00:00', 'Audit conforme', 'Audit sans anomalies', '2025-01-25 10:00:00');

-- Test d'ajout d'un audit externe avec une date dans le futur (devrait échouer)
INSERT INTO Audit_Externe (acteur, actant, organisation_realisation, date_audit, rapport, commentaires, time_t)
VALUES ('Marie Dubois', 'Actant2', 'Organisation B', '2025-02-01 12:00:00', 'Audit en cours', 'Audit planifié', '2025-02-01 12:00:00');

-- Test de suppression d'un audit externe
DELETE FROM Audit_Externe WHERE id = 1;

-- Test de mise à jour d'un audit externe (changer le rapport)
UPDATE Audit_Externe SET rapport = 'Audit avec améliorations recommandées' WHERE id = 2;



-- Création de la table Sécurité
CREATE TABLE Sécurité (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    qualite ENUM('mot_de_passe', 'authentification_biometrique') NOT NULL,  -- Qualité de la sécurité
    criteres_associe TEXT,  -- Critères associés à la sécurité
    date_modification DATETIME,  -- Date de modification
    responsable VARCHAR(255),  -- Responsable de la sécurité
    historique TEXT,  -- Historique des changements de sécurité
    time_t DATETIME NOT NULL,  -- Temps immuable de la modification
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date de modification n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Sécurité

-- Test d'ajout d'une entrée de sécurité valide
INSERT INTO Sécurité (qualite, criteres_associe, date_modification, responsable, historique, time_t)
VALUES ('mot_de_passe', 'Critères de longueur et complexité', '2025-01-25 10:00:00', 'Jean Dupont', 'Modification pour renforcer la sécurité des mots de passe', '2025-01-25 10:00:00');

-- Test d'ajout d'une entrée avec une date dans le futur (devrait échouer)
INSERT INTO Sécurité (qualite, criteres_associe, date_modification, responsable, historique, time_t)
VALUES ('authentification_biometrique', 'Critères de reconnaissance faciale', '2025-02-01 12:00:00', 'Marie Dubois', 'Changement vers une authentification biométrique', '2025-02-01 12:00:00');

-- Test de suppression d'une entrée de sécurité
DELETE FROM Sécurité WHERE id = 1;

-- Test de mise à jour d'une entrée de sécurité (modifier l'historique)
UPDATE Sécurité SET historique = 'Modification du critère d_authentification' WHERE id = 2;


-- Création de la table Performance
CREATE TABLE Performance (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    qualite ENUM('individu', 'équipe') NOT NULL,  -- Qualité de la performance
    periode VARCHAR(255),  -- Période de performance
    criteres_evaluation TEXT,  -- Critères utilisés pour l'évaluation de la performance
    score INT,  -- Score de performance
    objectifs_performance TEXT,  -- Objectifs de performance
    time_t DATETIME NOT NULL,  -- Temps immuable de l'évaluation
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date d'évaluation n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Performance

-- Test d'ajout d'une performance valide
INSERT INTO Performance (qualite, periode, criteres_evaluation, score, objectifs_performance, time_t)
VALUES ('individu', 'Q1 2025', 'Évaluation basée sur la productivité et l_engagement', 85, 'Objectifs de productivité atteints', '2025-01-25 09:00:00');

-- Test d'ajout d'une performance avec une date dans le futur (devrait échouer)
INSERT INTO Performance (qualite, periode, criteres_evaluation, score, objectifs_performance, time_t)
VALUES ('équipe', 'Q2 2025', 'Évaluation basée sur la collaboration et les résultats collectifs', 90, 'Objectifs d_équipe atteints', '2025-02-01 10:00:00');

-- Test de suppression d'une performance
DELETE FROM Performance WHERE id = 1;

-- Test de mise à jour d'une performance (modifier le score)
UPDATE Performance SET score = 95 WHERE id = 2;



-- Création de la table Rapport
CREATE TABLE Rapport (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    qualite ENUM('interne', 'externe', 'financier') NOT NULL,  -- Qualité du rapport
    date_redaction DATETIME,  -- Date de rédaction du rapport
    auteur VARCHAR(255),  -- Auteur du rapport
    contenu TEXT,  -- Contenu du rapport
    destinataires TEXT,  -- Destinataires du rapport
    time_t DATETIME NOT NULL,  -- Temps immuable de la rédaction
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps actuel pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date de rédaction n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Rapport
-- Test d'ajout d'un rapport valide
INSERT INTO Rapport (qualite, date_redaction, auteur, contenu, destinataires, time_t)
VALUES ('interne', '2025-01-25 14:00:00', 'John Doe', 'Contenu du rapport interne.', 'Responsables, Directeur', '2025-01-25 14:00:00');

-- Test d'ajout d'un rapport avec une date dans le futur (devrait échouer)
INSERT INTO Rapport (qualite, date_redaction, auteur, contenu, destinataires, time_t)
VALUES ('externe', '2025-02-01 10:00:00', 'Jane Smith', 'Contenu du rapport externe.', 'Partenaires, Auditeurs', '2025-02-01 10:00:00');

-- Test de mise à jour d'un rapport (modifier le contenu)
UPDATE Rapport SET contenu = 'Contenu mis à jour du rapport interne.' WHERE id = 1;

-- Test de suppression d'un rapport
DELETE FROM Rapport WHERE id = 1;


-- Création de la table Conformité
CREATE TABLE Conformité (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    titre VARCHAR(255),  -- Titre de la conformité
    norme TEXT,  -- Norme de conformité
    date_evaluation DATETIME,  -- Date de l'évaluation
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_actant INT,  -- Lien avec l'entité Actant
    id_cible INT,  -- Lien avec l'entité Cible
    statut ENUM('non_appliqué', 'non_conforme', 'conforme', 'non_applicable') NOT NULL,  -- Statut de la conformité
    action_remédiation_nonconformité TEXT,  -- Actions à entreprendre pour la non-conformité
    archive TEXT,  -- Archivage de la conformité
    time_t DATETIME NOT NULL,  -- Temps immuable de la conformité
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps courant pour comparaison
    CHECK (time_t <= now),  -- Vérification que le temps de conformité n'est pas dans le futur
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),  -- Relation avec Acteur
    FOREIGN KEY (id_actant) REFERENCES Actant(id),  -- Relation avec Actant
    FOREIGN KEY (id_cible) REFERENCES Cible(id)  -- Relation avec Cible
) ENGINE=InnoDB;

-- Tests pour la table Conformité

-- Test d'ajout d'une conformité valide
INSERT INTO Conformité (titre, norme, date_evaluation, id_acteur, id_actant, id_cible, statut, action_remédiation_nonconformité, archive, time_t)
VALUES ('Conformité ISO 9001', 'Norme ISO 9001', '2025-01-25 12:00:00', 1, 1, 1, 'conforme', 'Aucune action requise', 'Archivage effectué', '2025-01-25 12:00:00');

-- Test d'ajout d'une conformité avec une date dans le futur (devrait échouer)
INSERT INTO Conformité (titre, norme, date_evaluation, id_acteur, id_actant, id_cible, statut, action_remédiation_nonconformité, archive, time_t)
VALUES ('Conformité ISO 27001', 'Norme ISO 27001', '2025-02-01 10:00:00', 2, 2, 2, 'non_conforme', 'Mise en conformité nécessaire', 'Archivage en cours', '2025-02-01 10:00:00');

-- Test de mise à jour d'une conformité (modifier le statut)
UPDATE Conformité SET statut = 'conforme', action_remédiation_nonconformité = 'Conformité obtenue' WHERE id = 1;

-- Test de suppression d'une conformité
DELETE FROM Conformité WHERE id = 1;



-- Création de la table Processus_de_risques
CREATE TABLE Processus_de_risques (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    qualite ENUM('financier', 'opérationnel') NOT NULL,  -- Qualité du processus de risques
    mesures TEXT,  -- Mesures pour la gestion des risques
    etat ENUM('latent', 'imminent', 'domageant', 'élevé', 'mitigé', 'en_propagation', 'maîtrisé', 'dissipé') NOT NULL,  -- État du risque
    date_debut DATETIME,  -- Date de début du processus de risque
    date_fin DATETIME,  -- Date de fin du processus de risque
    historique TEXT,  -- Historique du processus de risque
    responsable VARCHAR(255),  -- Responsable du processus de risque
    time_t DATETIME NOT NULL,  -- Temps immuable du processus
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps courant pour comparaison
    CHECK (time_t <= now),  -- Vérification que le temps de début du risque n'est pas dans le futur
    CHECK (date_debut <= date_fin)  -- Vérification que la date de début est avant la date de fin
) ENGINE=InnoDB;

-- Tests pour la table Processus_de_risques

-- Test d'ajout d'un processus de risque valide
INSERT INTO Processus_de_risques (qualite, mesures, etat, date_debut, date_fin, historique, responsable, time_t)
VALUES ('financier', 'Mesures de réduction des pertes', 'élevé', '2025-01-25 12:00:00', '2025-01-30 12:00:00', 'Risque détecté, en cours d’atténuation', 'Jean Dupont', '2025-01-25 12:00:00');

-- Test d'ajout d'un processus de risque avec une date de fin avant la date de début (devrait échouer)
INSERT INTO Processus_de_risques (qualite, mesures, etat, date_debut, date_fin, historique, responsable, time_t)
VALUES ('opérationnel', 'Mesures de prévention', 'imminent', '2025-01-30 12:00:00', '2025-01-25 12:00:00', 'Risque imminent', 'Marie Lemoine', '2025-01-25 12:00:00');

-- Test de mise à jour d'un processus de risque
UPDATE Processus_de_risques SET etat = 'maîtrisé', historique = 'Risque maîtrisé avec succès' WHERE id = 1;

-- Test de suppression d'un processus de risque
DELETE FROM Processus_de_risques WHERE id = 1;



-- Création de la table Communication
CREATE TABLE Communication (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    id_contact INT,  -- Lien avec l'entité Contact
    id_actant INT,  -- Lien avec l'entité Actant
    id_acteur INT,  -- Lien avec l'entité Acteur
    initiateur VARCHAR(255),  -- Initiateur de la communication
    destinataire VARCHAR(255),  -- Destinataire de la communication
    etapes_circulation TEXT,  -- Étapes de circulation de l'information
    qualite ENUM('interne', 'externe') NOT NULL,  -- Qualité de la communication
    canal ENUM('email', 'réunion', 'autre') NOT NULL,  -- Canal de communication
    date DATETIME,  -- Date de la communication
    message TEXT,  -- Message de la communication
    time_t DATETIME NOT NULL,  -- Temps immuable de la communication
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps courant pour comparaison
    CHECK (time_t <= now),  -- Vérification que la date de la communication n'est pas dans le futur
    FOREIGN KEY (id_contact) REFERENCES Contact(id),  -- Clé étrangère vers Contact
    FOREIGN KEY (id_actant) REFERENCES Actant(id),  -- Clé étrangère vers Actant
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id)  -- Clé étrangère vers Acteur
) ENGINE=InnoDB;

-- Tests pour la table Communication

-- Test d'ajout d'une communication valide
INSERT INTO Communication (id_contact, id_actant, id_acteur, initiateur, destinataire, etapes_circulation, qualite, canal, date, message, time_t)
VALUES (1, 1, 1, 'Jean Dupont', 'Marie Lemoine', 'Initialisation -> Validation -> Confirmation', 'interne', 'email', '2025-01-25 12:00:00', 'Message important sur la mise à jour du projet', '2025-01-25 12:00:00');

-- Test d'ajout d'une communication avec une date de communication dans le futur (devrait échouer)
INSERT INTO Communication (id_contact, id_actant, id_acteur, initiateur, destinataire, etapes_circulation, qualite, canal, date, message, time_t)
VALUES (1, 1, 1, 'Jean Dupont', 'Marie Lemoine', 'Initialisation -> Validation', 'externe', 'réunion', '2025-02-01 12:00:00', 'Communication planifiée', '2025-02-01 12:00:00');

-- Test de mise à jour d'une communication
UPDATE Communication SET message = 'Mise à jour du projet', etapes_circulation = 'Validation -> Finalisation' WHERE id = 1;

-- Test de suppression d'une communication
DELETE FROM Communication WHERE id = 1;



-- Création de la table Formation
CREATE TABLE Formation (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    titre VARCHAR(255),  -- Titre de la formation
    date DATETIME,  -- Date de la formation
    formateur VARCHAR(255),  -- Formateur
    participants TEXT,  -- Liste des participants
    contenu TEXT,  -- Contenu de la formation
    bilan TEXT,  -- Bilan de la formation
    archive TEXT,  -- Archivage de la formation
    time_t DATETIME NOT NULL,  -- Temps immuable de la formation
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps courant pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date de la formation n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Formation

-- Test d'ajout d'une formation valide
INSERT INTO Formation (titre, date, formateur, participants, contenu, bilan, archive, time_t)
VALUES ('Formation SQL', '2025-01-30 10:00:00', 'Jean Dupont', 'Alice, Bob, Charlie', 'Introduction à SQL, Requêtes simples, Requêtes avancées', 'Très bonne formation', 'Archive de la formation', '2025-01-30 10:00:00');

-- Test d'ajout d'une formation avec une date dans le futur (devrait échouer)
INSERT INTO Formation (titre, date, formateur, participants, contenu, bilan, archive, time_t)
VALUES ('Formation PHP', '2025-02-10 10:00:00', 'Marie Lemoine', 'David, Eva', 'Introduction à PHP, Structures de données, Programmation orientée objet', 'Bilan en attente', 'Archivage prévu', '2025-02-10 10:00:00');

-- Test de mise à jour de la formation
UPDATE Formation SET bilan = 'Bilan très positif', participants = 'Alice, Bob, Charlie, David' WHERE id = 1;

-- Test de suppression d'une formation
DELETE FROM Formation WHERE id = 1;



-- Création de la table Historique
CREATE TABLE Historique (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    titre VARCHAR(255),  -- Titre de l'événement
    evenement TEXT,  -- Description de l'événement
    qualite_evenement ENUM('modification', 'création') NOT NULL,  -- Qualité de l'événement
    date DATETIME,  -- Date de l'événement
    acteur VARCHAR(255),  -- Acteur impliqué dans l'événement
    actant VARCHAR(255),  -- Actant impliqué dans l'événement
    entité_affectée TEXT,  -- Entité affectée par l'événement
    actant_affecté TEXT,  -- Actant affecté par l'événement
    acteur_affecté TEXT,  -- Acteur affecté par l'événement
    processus_affecté TEXT,  -- Processus affecté par l'événement
    time_t DATETIME NOT NULL,  -- Temps immuable de l'événement
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps courant pour comparaison
    CHECK (time_t <= now)  -- Vérification que la date de l'événement n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Historique

-- Test d'ajout d'un événement de création
INSERT INTO Historique (titre, evenement, qualite_evenement, date, acteur, actant, entité_affectée, actant_affecté, acteur_affecté, processus_affecté, time_t)
VALUES ('Création d\'un utilisateur', 'Création d\'un nouvel utilisateur dans le système', 'création', '2025-01-30 09:00:00', 'Admin', 'Utilisateur', 'Utilisateur', 'Nouveau Utilisateur', 'Admin', 'Création Processus', '2025-01-30 09:00:00');

-- Test d'ajout d'un événement de modification
INSERT INTO Historique (titre, evenement, qualite_evenement, date, acteur, actant, entité_affectée, actant_affecté, acteur_affecté, processus_affecté, time_t)
VALUES ('Modification d\'un utilisateur', 'Modification des informations de l\'utilisateur existant', 'modification', '2025-01-30 10:00:00', 'Admin', 'Utilisateur', 'Utilisateur', 'Utilisateur Modifié', 'Admin', 'Modification Processus', '2025-01-30 10:00:00');

-- Test de mise à jour de l'événement
UPDATE Historique SET evenement = 'Mise à jour des informations utilisateur' WHERE id = 1;

-- Test de suppression d'un événement
DELETE FROM Historique WHERE id = 1;



-- Création de la table Audit
CREATE TABLE Audit (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    qualite ENUM('interne', 'externe') NOT NULL,  -- Qualité de l'audit
    periode VARCHAR(255),  -- Période de l'audit
    objectif TEXT,  -- Objectif de l'audit
    methode TEXT,  -- Méthode de l'audit
    criteres_conduite TEXT,  -- Critères de conduite de l'audit
    validite ENUM('valide', 'non_valide') NOT NULL,  -- Validité de l'audit
    rapport TEXT,  -- Rapport de l'audit
    validation ENUM('validé', 'rejeté') NOT NULL,  -- Validation de l'audit
    time_t DATETIME NOT NULL,  -- Temps immuable de l'audit
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps courant pour comparaison
    CHECK (time_t <= now)  -- Vérification que le temps de l'audit n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Audit

-- Test d'ajout d'un audit interne valide
INSERT INTO Audit (qualite, periode, objectif, methode, criteres_conduite, validite, rapport, validation, time_t)
VALUES ('interne', '2025-Q1', 'Audit de conformité interne', 'Méthode d\'audit standard', 'Critères A, B, C', 'valide', 'Rapport détaillé', 'validé', '2025-01-25 10:00:00');

-- Test d'ajout d'un audit externe non valide
INSERT INTO Audit (qualite, periode, objectif, methode, criteres_conduite, validite, rapport, validation, time_t)
VALUES ('externe', '2025-Q1', 'Audit externe de sécurité', 'Méthode d\'audit sécurisé', 'Critères X, Y, Z', 'non_valide', 'Rapport externe non validé', 'rejeté', '2025-01-25 11:00:00');

-- Test de mise à jour d'un audit
UPDATE Audit SET validation = 'validé', rapport = 'Rapport mis à jour' WHERE id = 1;

-- Test de suppression d'un audit
DELETE FROM Audit WHERE id = 2;



-- Création de la table Évaluation
CREATE TABLE Évaluation (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    qualite ENUM('performance', 'compétence', 'conformité') NOT NULL,  -- Qualité de l'évaluation
    description TEXT,  -- Description de l'évaluation
    evaluateur VARCHAR(255),  -- Evaluateur
    id_cible INT,  -- Lien avec l'entité Cible
    id_actant INT,  -- Lien avec l'entité Actant
    id_acteur INT,  -- Lien avec l'entité Acteur
    date DATETIME,  -- Date de l'évaluation
    responsable VARCHAR(255),  -- Responsable de l'évaluation
    score INT,  -- Score de l'évaluation
    commentaire TEXT,  -- Commentaire sur l'évaluation
    time_t DATETIME NOT NULL,  -- Temps immuable de l'évaluation
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps courant pour comparaison
    FOREIGN KEY (id_cible) REFERENCES Cible(id),  -- Relation avec l'entité Cible
    FOREIGN KEY (id_actant) REFERENCES Actant(id),  -- Relation avec l'entité Actant
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),  -- Relation avec l'entité Acteur
    CHECK (time_t <= now)  -- Vérification que le temps de l'évaluation n'est pas dans le futur
) ENGINE=InnoDB;

-- Tests pour la table Évaluation

-- Test d'ajout d'une évaluation de performance
INSERT INTO Évaluation (qualite, description, evaluateur, id_cible, id_actant, id_acteur, date, responsable, score, commentaire, time_t)
VALUES ('performance', 'Évaluation de la performance annuelle', 'John Doe', 1, 2, 3, '2025-01-25 10:00:00', 'Jane Smith', 85, 'Bon travail', '2025-01-25 10:00:00');

-- Test d'ajout d'une évaluation de compétence
INSERT INTO Évaluation (qualite, description, evaluateur, id_cible, id_actant, id_acteur, date, responsable, score, commentaire, time_t)
VALUES ('compétence', 'Évaluation des compétences techniques', 'Alice Brown', 4, 5, 6, '2025-01-25 11:00:00', 'Bob White', 90, 'Excellente maîtrise des outils', '2025-01-25 11:00:00');

-- Test d'ajout d'une évaluation de conformité
INSERT INTO Évaluation (qualite, description, evaluateur, id_cible, id_actant, id_acteur, date, responsable, score, commentaire, time_t)
VALUES ('conformité', 'Vérification de la conformité réglementaire', 'Chris Green', 7, 8, 9, '2025-01-25 12:00:00', 'Diana Black', 100, 'Conforme à toutes les normes', '2025-01-25 12:00:00');

-- Test de mise à jour d'une évaluation
UPDATE Évaluation SET score = 95, commentaire = 'Amélioration remarquable' WHERE id = 1;

-- Test de suppression d'une évaluation
DELETE FROM Évaluation WHERE id = 2;



CREATE TABLE Préparation (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Clé primaire auto-incrémentée
    qualite ENUM('opérationnelle', 'stratégique') NOT NULL,  -- Qualité de la préparation
    objectifs TEXT,  -- Objectifs de la préparation
    ressources_utilisees TEXT,  -- Ressources utilisées pour la préparation
    date_debut DATETIME,  -- Date de début de la préparation
    date_fin DATETIME,  -- Date de fin de la préparation
    time_t DATETIME NOT NULL,  -- Temps immuable de l'action
    now TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Temps courant pour comparaison
    CHECK (date_debut <= date_fin),  -- Vérification que la date de début est avant ou égale à la date de fin
    CHECK (time_t <= now)  -- Vérification que le temps de l'action n'est pas dans le futur
) ENGINE=InnoDB;

-- Exemple 1 : Insertion d'une préparation opérationnelle
INSERT INTO Préparation (qualite, objectifs, ressources_utilisees, date_debut, date_fin, time_t)
VALUES ('opérationnelle', 
        'Optimiser le flux de travail en réduisant les temps d’attente.', 
        'Personnel, équipements informatiques, formation', 
        '2025-02-01 08:00:00', 
        '2025-02-01 12:00:00', 
        '2025-01-25 00:00:00');

-- Exemple 2 : Insertion d'une préparation stratégique
INSERT INTO Préparation (qualite, objectifs, ressources_utilisees, date_debut, date_fin, time_t)
VALUES ('stratégique', 
        'Développer un plan quinquennal pour la croissance de l’entreprise.', 
        'Conseil externe, analyse de marché, ateliers de réflexion', 
        '2025-03-01 09:00:00', 
        '2025-03-15 17:00:00', 
        '2025-01-25 00:00:00');

-- Ce test échouera car la date de début est après la date de fin
INSERT INTO Préparation (qualite, objectifs, ressources_utilisees, date_debut, date_fin, time_t)
VALUES ('stratégique', 
        'Créer une nouvelle ligne de produits.', 
        'Équipe R&D, matériaux de production', 
        '2025-04-01 10:00:00', 
        '2025-03-01 17:00:00', 
        '2025-01-25 00:00:00');

-- Ce test échouera car la date de time_t est dans le futur
INSERT INTO Préparation (qualite, objectifs, ressources_utilisees, date_debut, date_fin, time_t)
VALUES ('opérationnelle', 
        'Améliorer l_efficacité de la chaîne de production.', 
        'Personnel, machines', 
        '2025-02-10 08:00:00', 
        '2025-02-10 16:00:00', 
        '2025-02-01 00:00:00');

-- Ce test échouera car time_t est dans le futur
INSERT INTO Préparation (qualite, objectifs, ressources_utilisees, date_debut, date_fin, time_t)
VALUES ('opérationnelle', 
        'Améliorer le processus de recrutement.', 
        'Équipe RH, logiciels de gestion des candidatures', 
        '2025-02-20 09:00:00', 
        '2025-02-20 17:00:00', 
        '2025-02-01 00:00:00');



CREATE TABLE Récupération (
    id INT PRIMARY KEY AUTO_INCREMENT,                       -- Clé primaire auto-incrémentée
    qualite VARCHAR(50),                                      -- Qualité des données
    ressources_recuperees TEXT,                               -- Détails des ressources récupérées
    source_donnees_recuperees TEXT,                           -- Source des données récupérées
    date_recuperation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Date de récupération (avec valeur par défaut)
    methode_recuperation VARCHAR(50),                         -- Méthode de récupération
    etat VARCHAR(50),                                         -- Etat de la récupération
    etat_detaille TEXT,                                       -- Etat détaillé de la récupération
    id_controle INT,                                          -- Lien avec la table Controle
    FOREIGN KEY (id_controle) REFERENCES Controle(id)         -- Relation avec la table Contrôle
) ENGINE=InnoDB;

-- Exemple d'insertion dans la table Récupération
INSERT INTO Récupération (qualite, ressources_recuperees, source_donnees_recuperees, 
                          date_recuperation, methode_recuperation, etat, etat_detaille, id_controle)
VALUES ('Haute', 
        'Fichiers de sauvegarde du serveur', 
        'Serveur principal de l\'entreprise', 
        '2025-01-25 10:30:00', 
        'Automatisée', 
        'Complète', 
        'Les données ont été entièrement récupérées et validées.', 
        1);  -- Assurez-vous que l'id_controle fait référence à un enregistrement existant dans la table Contrôle


-- Exemple d'insertion de contrôle dans la table Controle
INSERT INTO Controle (id, qualite, statut)
VALUES (1, 'Interne', 'Validé');  -- Cette ligne assure que l'id 1 existe dans Controle

-- Réessayer l'insertion dans Récupération
INSERT INTO Récupération (qualite, ressources_recuperees, source_donnees_recuperees, 
                          date_recuperation, methode_recuperation, etat, etat_detaille, id_controle)
VALUES ('Haute', 
        'Fichiers de sauvegarde du serveur', 
        'Serveur principal de l_entreprise', 
        '2025-01-25 10:30:00', 
        'Automatisée', 
        'Complète', 
        'Les données ont été entièrement récupérées et validées.', 
        1);



CREATE TABLE Collaboration (
    id INT PRIMARY KEY AUTO_INCREMENT,                         -- Clé primaire auto-incrémentée
    id_acteurs INT,                                             -- Clé étrangère vers l'entité Acteurs
    id_actant INT,                                              -- Clé étrangère vers l'entité Actants
    objectif TEXT,                                              -- Objectif de la collaboration
    date_debut TIMESTAMP,                                       -- Date de début de la collaboration
    date_fin TIMESTAMP,                                         -- Date de fin de la collaboration
    resultats_attendus TEXT,                                    -- Résultats attendus
    resultats_obtenus TEXT,                                     -- Résultats obtenus (après fin de collaboration)
    etat ENUM('active', 'terminee', 'en_pause') NOT NULL,       -- Statut de la collaboration
    INDEX (id_acteurs),                                         -- Index sur id_acteurs pour optimiser les recherches
    INDEX (id_actant),                                          -- Index sur id_actant pour optimiser les recherches
    FOREIGN KEY (id_acteurs) REFERENCES Acteur(id),             -- Clé étrangère vers Acteurs
    FOREIGN KEY (id_actant) REFERENCES Actant(id)               -- Clé étrangère vers Actant
) ENGINE=InnoDB;

-- Exemple d'insertion dans la table Collaboration
INSERT INTO Collaboration (id_acteurs, id_actant, objectif, date_debut, date_fin, resultats_attendus, resultats_obtenus, etat)
VALUES (1, 2, 'Améliorer les processus internes', '2025-01-01 09:00:00', '2025-12-31 18:00:00', 
        'Optimisation de la gestion des ressources', 'Optimisation partielle des processus', 'active');



CREATE TABLE Reporting (
    id INT PRIMARY KEY AUTO_INCREMENT,                          -- Clé primaire auto-incrémentée
    qualite VARCHAR(50),                                          -- Qualité du reporting
    destinataire INT,                                             -- Destinataire (peut être une clé étrangère)
    periode TIMESTAMP,                                            -- Période de reporting
    donnees TEXT,                                                 -- Données du reporting
    frequence VARCHAR(50),                                        -- Fréquence de génération du reporting
    responsable INT,                                              -- Responsable de l'action
    date_creation DATETIME,                                       -- Date de création du reporting
    etat ENUM('complet', 'en_cours', 'en_attente', 'annule') NOT NULL, -- Statut du reporting
    INDEX (destinataire),                                         -- Index sur destinataire pour optimisation
    INDEX (responsable),                                          -- Index sur responsable pour optimisation
    INDEX (periode),                                              -- Index sur période pour optimisation
    FOREIGN KEY (destinataire) REFERENCES Utilisateur(id),        -- Clé étrangère vers Utilisateur
    FOREIGN KEY (responsable) REFERENCES Acteur(id)               -- Clé étrangère vers Acteur
) ENGINE=InnoDB;

-- Exemple d'insertion dans la table Reporting
INSERT INTO Reporting (qualite, destinataire, periode, donnees, frequence, responsable, date_creation, etat)
VALUES ('financier', 1, '2025-01-01 00:00:00', 'Données financières du mois', 'mensuelle', 2, '2025-01-01 10:00:00', 'en_cours');



CREATE TABLE Ressource (
    id INT PRIMARY KEY AUTO_INCREMENT,                                -- Clé primaire auto-incrémentée
    qualite ENUM('humaine', 'matérielle', 'numérique') NOT NULL,       -- Qualité de la ressource (humaine, matérielle, numérique)
    quantite INT,                                                     -- Quantité de la ressource
    disponibilite ENUM('disponible', 'utilisée', 'en_reparation', 'épuisée', 'retirée') NOT NULL,  -- Disponibilité de la ressource
    etat ENUM('disponible', 'utilisée', 'en_reparation', 'épuisée', 'retirée') NOT NULL,  -- État de la ressource
    date_allocation DATETIME,                                          -- Date d'allocation de la ressource
    description TEXT,                                                  -- Description de la ressource
    id_projet INT,                                                     -- Lien avec l'entité Projet (facultatif)
    INDEX (disponibilite),                                             -- Index sur la disponibilité pour améliorer les recherches
    INDEX (etat),                                                      -- Index sur l'état pour améliorer les recherches
    FOREIGN KEY (id_projet) REFERENCES Projet(id)                      -- Lien avec un projet, si applicable
) ENGINE=InnoDB;

-- Exemple d'insertion dans la table Ressource
INSERT INTO Ressource (qualite, quantite, disponibilite, etat, date_allocation, description, id_projet)
VALUES ('matérielle', 10, 'disponible', 'disponible', '2025-01-01 09:00:00', 'Ordinateurs portables pour les projets', 1);



CREATE TABLE Stratégie (
    id INT PRIMARY KEY AUTO_INCREMENT,                                -- Clé primaire auto-incrémentée
    titre VARCHAR(255) NOT NULL,                                       -- Titre de la stratégie
    objectif TEXT,                                                     -- Objectif de la stratégie
    moyens TEXT,                                                       -- Moyens nécessaires pour atteindre l'objectif
    periode VARCHAR(255),                                              -- Période de la stratégie
    id_suivi INT,                                                      -- Lien avec l'entité Suivi
    etat ENUM('en_attente', 'en_cours', 'suspendue', 'terminee', 'abandonnée') NOT NULL,  -- État de la stratégie
    date_debut DATETIME,                                               -- Date de début de la stratégie
    date_fin DATETIME,                                                 -- Date de fin de la stratégie
    historique TEXT,                                                   -- Historique des changements de stratégie
    INDEX (etat),                                                      -- Index sur l'état pour améliorer les recherches
    FOREIGN KEY (id_suivi) REFERENCES Suivi(id)                        -- Lien avec l'entité Suivi
) ENGINE=InnoDB;

-- Exemple d'insertion dans la table Stratégie
INSERT INTO Stratégie (titre, objectif, moyens, periode, id_suivi, etat, date_debut, date_fin, historique)
VALUES ('Stratégie de croissance', 'Développer notre présence sur le marché européen', 'Marketing, Développement de produits', '2025-2027', 1, 'en_cours', '2025-01-01', '2027-12-31', 'Lancement en phase de développement, révisions trimestrielles');

-- Points importants à vérifier :
-- Relation avec la table Suivi : Assurez-vous que la table Suivi existe et que les données sont bien insérées dans cette table pour que la clé étrangère fonctionne correctement.
-- Date de début et de fin : Vérifiez que la date de fin soit toujours supérieure à la date de début pour maintenir l'intégrité des données.



CREATE TABLE Sécurisation ( 
    id INT PRIMARY KEY AUTO_INCREMENT,                              -- Clé primaire auto-incrémentée
    qualite ENUM('cryptage', 'authentification', 'autre') NOT NULL,  -- Qualité de la sécurisation
    methode ENUM('HTTPS', 'VPN', 'autre') NOT NULL,                 -- Méthode utilisée
    ressource_associée TEXT,                                        -- Ressources associées
    date_implémentation DATETIME,                                   -- Date d'implémentation
    etat ENUM('actif', 'en_maintenance', 'desactive') NOT NULL,      -- État de la sécurisation
    date_expiration DATETIME,                                       -- Durée d'expiration de la sécurisation
    historique TEXT,                                                -- Historique des actions de sécurisation
    logs_securite TEXT,                                             -- Logs ou événements de sécurité associés
    INDEX (methode),                                                -- Index sur la méthode de sécurisation
    INDEX (etat)                                                    -- Index sur l'état pour la gestion de la sécurité
) ENGINE=InnoDB;

-- Exemple d'insertion dans la table Sécurisation
INSERT INTO Sécurisation (qualite, methode, ressource_associée, date_implémentation, etat, date_expiration, historique, logs_securite)
VALUES ('cryptage', 'HTTPS', 'Serveurs Web', '2025-01-01 12:00:00', 'actif', '2025-12-31 23:59:59', 'Mise en place de la sécurisation des connexions', 'Aucune anomalie détectée');



CREATE TABLE Processus (
    id_processus INT PRIMARY KEY AUTO_INCREMENT,                     -- Clé primaire auto-incrémentée
    nom_processus VARCHAR(255) NOT NULL,                               -- Nom du processus
    description TEXT,                                                 -- Description détaillée du processus
    entrees TEXT,                                                     -- Données ou ressources nécessaires au début du processus
    sorties TEXT,                                                     -- Résultats ou produits générés par le processus
    indicateurs_performance TEXT,                                     -- Indicateurs utilisés pour mesurer la performance du processus
    version INT DEFAULT 1,                                             -- Version du processus
    date_creation DATETIME,                                           -- Date de création du processus
    date_modification DATETIME,                                       -- Date de dernière modification
    historique TEXT,                                                  -- Historique des modifications
    INDEX (nom_processus),                                            -- Index sur le nom du processus pour les recherches
    INDEX (entrees),                                                  -- Indexation optionnelle sur les entrées
    INDEX (sorties)                                                   -- Indexation optionnelle sur les sorties
) ENGINE=InnoDB;

-- Exemple d'insertion dans la table Processus
INSERT INTO Processus (nom_processus, description, entrees, sorties, indicateurs_performance, date_creation, date_modification, historique)
VALUES ('Processus d_intégration', 'Processus d_intégration des nouveaux employés', 'Documents RH, accès aux systèmes', 'Intégration réussie, employés actifs', 'Taux de réussite de l_intégration', '2025-01-25 08:00:00', '2025-01-25 08:00:00', 'Création initiale du processus');


-- Points importants à vérifier :
-- Types de données : Assurez-vous que les types de données comme TEXT sont suffisants pour vos besoins en termes de taille. Vous pouvez ajuster les tailles de champs comme VARCHAR si nécessaire.
-- Date et historique : Vérifiez que les dates sont bien formatées et que l'historique reste concis et précis pour faciliter la gestion.



CREATE TABLE Planification (
    id INT PRIMARY KEY AUTO_INCREMENT,                          -- Clé primaire auto-incrémentée
    id_projet INT,                                               -- Lien avec l'entité Projet
    id_charge INT,                                               -- Lien avec l'entité Charge
    id_tache INT,                                                -- Lien avec l'entité Tache
    id_action INT,                                               -- Lien avec l'entité Action
    id_profil INT,                                               -- Lien avec l'entité Profil
    id_statut INT,                                               -- Lien avec l'entité Statut
    id_role INT,                                                 -- Lien avec l'entité Rôle
    id_tag INT,                                                  -- Lien avec l'entité Tag
    date_debut DATETIME,                                         -- Date de début de la planification
    date_fin DATETIME,                                           -- Date de fin de la planification
    etat ENUM('en_attente', 'active', 'en_retard', 'terminee') NOT NULL, -- État de la planification
    description TEXT,                                            -- Description de la planification
    avancement INT,                                              -- Avancement de la planification (en pourcentage)
    date_achèvement_estimee DATETIME,                            -- Date d'achèvement estimée
    INDEX (date_debut),                                          -- Indexation pour les recherches par date de début
    INDEX (date_fin),                                            -- Indexation pour les recherches par date de fin
    INDEX (etat),                                                -- Indexation pour les recherches par état
    INDEX (id_projet, id_tache, id_role),                        -- Index composite pour les recherches spécifiques
    FOREIGN KEY (id_projet) REFERENCES Projet(id),               -- Lien avec l'entité Projet
    FOREIGN KEY (id_charge) REFERENCES Charge(id),               -- Lien avec l'entité Charge
    FOREIGN KEY (id_tache) REFERENCES Tache(id),                 -- Lien avec l'entité Tache
    FOREIGN KEY (id_action) REFERENCES Action(id),               -- Lien avec l'entité Action
    FOREIGN KEY (id_profil) REFERENCES Profil(id),               -- Lien avec l'entité Profil
    FOREIGN KEY (id_statut) REFERENCES Statut(id),               -- Lien avec l'entité Statut
    FOREIGN KEY (id_role) REFERENCES Role(id),                   -- Lien avec l'entité Role
    FOREIGN KEY (id_tag) REFERENCES Tag(id)                      -- Lien avec l'entité Tag
) ENGINE=InnoDB;

-- Exemple d'insertion dans la table Planification
INSERT INTO Planification (id_projet, id_charge, id_tache, id_action, id_profil, id_statut, id_role, id_tag, date_debut, date_fin, etat, description, avancement, date_achèvement_estimee)
VALUES 
(1, 2, 3, 4, 5, 6, 7, 8, '2025-02-01 09:00:00', '2025-02-15 18:00:00', 'active', 'Planification du projet X', 50, '2025-02-14 18:00:00');

-- Vérification de l'existence de la table Planification
SHOW TABLES LIKE 'Planification';

-- Vérification des colonnes de la table
DESCRIBE Planification;

-- Test d'insertion de plusieurs lignes avec des dates spécifiques
INSERT INTO Planification (id_projet, id_charge, id_tache, id_action, id_profil, id_statut, id_role, id_tag, date_debut, date_fin, etat, description, avancement, date_achèvement_estimee)
VALUES 
(1, 2, 3, 4, 5, 6, 7, 8, '2025-03-01 08:00:00', '2025-03-15 18:00:00', 'en_retard', 'Planification du projet Y', 20, '2025-03-14 18:00:00');



CREATE TABLE Memoire (
    id INT PRIMARY KEY AUTO_INCREMENT,                          -- Clé primaire auto-incrémentée
    qualite ENUM('cache', 'historique', 'autre') NOT NULL,       -- Qualité de la mémoire (ex: cache, historique, etc.)
    donnees_associées TEXT,                                      -- Données associées à la mémoire
    date_enregistrement DATETIME,                                 -- Date d'enregistrement des données
    duree_de_vie INT,                                            -- Durée de vie de la mémoire (en jours, mois, etc.)
    date_expiration DATETIME,                                    -- Date d'expiration calculée
    reglementation_regle TEXT,                                   -- Règles de régulation de la mémoire
    INDEX (date_enregistrement),                                 -- Indexation pour les recherches par date d'enregistrement
    INDEX (qualite)                                              -- Indexation pour les recherches par qualité de la mémoire
) ENGINE=InnoDB;

-- Exemple d'insertion d'une entrée de mémoire
INSERT INTO Memoire (qualite, donnees_associées, date_enregistrement, duree_de_vie, date_expiration, reglementation_regle)
VALUES 
('cache', 'Données temporaires stockées pour accélérer les requêtes', '2025-01-25 10:00:00', 30, DATE_ADD('2025-01-25', INTERVAL 30 DAY), 'Conformité avec la politique de gestion des données temporaires');

-- Vérifier l'existence de la table Memoire
SHOW TABLES LIKE 'Memoire';
-- Vérification des colonnes dans la table Memoire
DESCRIBE Memoire;
-- Exemple de requêtes de recherche sur la table Memoire
SELECT * FROM Memoire WHERE qualite = 'historique';
SELECT * FROM Memoire WHERE date_enregistrement > '2025-01-01';



CREATE TABLE Cluster (
    id INT PRIMARY KEY AUTO_INCREMENT,                            -- Clé primaire auto-incrémentée
    nom VARCHAR(255) NOT NULL,                                     -- Nom du cluster
    qualite ENUM('haute_disponibilite', 'mise_en_charge', 'autre') NOT NULL,  -- Qualité du cluster (ex: haute disponibilité, mise en charge)
    description TEXT,                                              -- Description du cluster
    capacite_ressources TEXT,                                      -- Capacité des ressources du cluster
    noeuds TEXT,                                                   -- Liste des noeuds du cluster
    redondance ENUM('actif-actif', 'actif-passif') NOT NULL,        -- Type de redondance du cluster
    id_reseau INT,                                                 -- Lien avec l'entité Réseau
    proprietaire TEXT,                                             -- Propriétaire du cluster
    gestionnaire TEXT,                                             -- Gestionnaire du cluster
    parametres_securite TEXT,                                      -- Paramètres de sécurité du cluster
    controle_acces TEXT,                                           -- Contrôle d'accès du cluster
    permissions TEXT,                                              -- Permissions associées au cluster
    etat ENUM('actif', 'ferme', 'suspendu', 'depossede') NOT NULL, -- État du cluster
    historique_pannes TEXT,                                        -- Historique des pannes du cluster
    historique_interruptions TEXT,                                 -- Historique des interruptions du cluster
    utilisation_bande_passante TEXT,                               -- Utilisation de la bande passante du cluster
    performance_globale TEXT,                                      -- Performance globale du cluster
    historique_maintenances_mises_a_jour TEXT,                     -- Historique des maintenances et mises à jour
    performances_disponibilite_globale TEXT,                       -- Performances et disponibilité globale du cluster
    date_mise_en_service DATETIME,                                 -- Date de mise en service du cluster
    historique TEXT,                                               -- Historique des actions ou changements
    FOREIGN KEY (id_reseau) REFERENCES Reseau(id),                 -- Relation avec l'entité Réseau
    INDEX (etat),                                                 -- Indexation pour les recherches par état
    INDEX (id_reseau),                                             -- Indexation pour les recherches par réseau
    INDEX (performance_globale)                                    -- Indexation pour les recherches par performance
) ENGINE=InnoDB;

-- Exemple d'insertion d'un cluster
INSERT INTO Cluster (nom, qualite, description, capacite_ressources, noeuds, redondance, id_reseau, proprietaire, gestionnaire, parametres_securite, controle_acces, permissions, etat, historique_pannes, historique_interruptions, utilisation_bande_passante, performance_globale, historique_maintenances_mises_a_jour, performances_disponibilite_globale, date_mise_en_service, historique)
VALUES 
('Cluster Principal', 'haute_disponibilite', 'Cluster principal avec haute disponibilité pour les services critiques', '10 To', 'Node1, Node2, Node3', 'actif-actif', 1, 'Entreprise X', 'Equipe IT', 'Chiffrement AES-256', 'Accès restreint', 'Lecture/Écriture', 'actif', 'Aucune panne enregistrée', 'Aucune interruption récente', '50%', 'Optimale', 'Maintenance régulière chaque mois', '100%', '2025-01-25 08:00:00', 'Changements de configuration mineurs');

-- Vérifier l'existence de la table Cluster
SHOW TABLES LIKE 'Cluster';

-- Vérification des colonnes dans la table Cluster
DESCRIBE Cluster;
Exemples de requêtes
SELECT * FROM Cluster WHERE etat = 'actif';
SELECT * FROM Cluster WHERE redondance = 'actif-actif';
SELECT * FROM Cluster WHERE id_reseau = 1;



CREATE TABLE Reseau (
    id INT PRIMARY KEY AUTO_INCREMENT,                             -- Clé primaire auto-incrémentée
    nom VARCHAR(255) NOT NULL,                                      -- Nom du réseau
    architecture_description TEXT,                                  -- Description de l'architecture du réseau
    id_cluster INT,                                                 -- Lien avec l'entité Cluster
    localisation_physique TEXT,                                     -- Localisation physique du réseau
    localisation_virtuelle TEXT,                                    -- Localisation virtuelle du réseau
    proprietaire TEXT,                                              -- Propriétaire du réseau
    gestionnaire TEXT,                                              -- Gestionnaire du réseau
    parametres_securite TEXT,                                       -- Paramètres de sécurité du réseau
    controle_acces TEXT,                                            -- Contrôle d'accès du réseau
    permissions TEXT,                                               -- Permissions associées au réseau
    etat ENUM('actif', 'deconnecte', 'suspendu', 'ferme', 'depossede') NOT NULL,  -- État du réseau
    historique_pannes TEXT,                                         -- Historique des pannes du réseau
    historique_interruptions TEXT,                                  -- Historique des interruptions du réseau
    utilisation_bande_passante TEXT,                                -- Utilisation de la bande passante
    performance_globale TEXT,                                       -- Performance globale du réseau
    date_mise_en_service DATETIME,                                  -- Date de mise en service du réseau
    historique TEXT,                                                -- Historique des actions ou changements
    FOREIGN KEY (id_cluster) REFERENCES Cluster(id),                -- Lien avec l'entité Cluster
    INDEX (etat),                                                  -- Indexation pour les recherches par état
    INDEX (id_cluster),                                             -- Indexation pour les recherches par cluster
    INDEX (performance_globale)                                     -- Indexation pour les recherches par performance globale
) ENGINE=InnoDB;

-- Exemple d'insertion d'un réseau
INSERT INTO Reseau (nom, architecture_description, id_cluster, localisation_physique, localisation_virtuelle, proprietaire, gestionnaire, parametres_securite, controle_acces, permissions, etat, historique_pannes, historique_interruptions, utilisation_bande_passante, performance_globale, date_mise_en_service, historique)
VALUES 
('Réseau Principal', 'Architecture réseau pour les services internes avec des sous-réseaux distincts', 1, 'Salle Serveur Paris', '192.168.1.0/24', 'Entreprise X', 'Equipe Réseau', 'Pare-feu Cisco, Cryptage SSL', 'Accès restreint par VLAN', 'Lecture/Écriture', 'actif', 'Aucune panne enregistrée', 'Interruption planifiée le 2025-01-20', '60%', 'Performance stable, latence <10ms', '2025-01-25 08:00:00', 'Mise à jour des équipements le 2025-01-10');

-- Vérifier l'existence de la table Reseau
SHOW TABLES LIKE 'Reseau';

-- Vérification des colonnes dans la table Reseau
DESCRIBE Reseau;

SELECT * FROM Reseau WHERE etat = 'actif';

SELECT * FROM Reseau WHERE id_cluster = 1;

SELECT * FROM Reseau WHERE performance_globale = 'Performance stable, latence <10ms';



CREATE TABLE Domaine (
    id INT PRIMARY KEY AUTO_INCREMENT,                             -- Clé primaire auto-incrémentée
    nom ENUM('public', 'prive') NOT NULL,                          -- Nom du domaine (ex: public, privé)
    qualite TEXT,                                                  -- Qualité du domaine
    description TEXT,                                              -- Description du domaine (application, fonction, réseau)
    id_reseau INT,                                                 -- Lien avec l'entité Reseau
    id_cluster INT,                                                -- Lien avec l'entité Cluster
    proprietaire TEXT,                                             -- Propriétaire du domaine
    gestionnaire TEXT,                                             -- Gestionnaire du domaine
    parametres_securite TEXT,                                      -- Paramètres de sécurité associés au domaine
    controle_acces TEXT,                                           -- Contrôle d'accès du domaine
    permissions TEXT,                                              -- Permissions associées au domaine
    etat ENUM('actif', 'ferme', 'suspendu', 'depossede') NOT NULL, -- État du domaine
    date_activation DATETIME,                                      -- Date d'activation du domaine
    date_fermeture DATETIME,                                       -- Date de fermeture du domaine
    historique TEXT,                                               -- Historique des actions ou changements
    FOREIGN KEY (id_reseau) REFERENCES Reseau(id),                 -- Lien avec l'entité Reseau
    FOREIGN KEY (id_cluster) REFERENCES Cluster(id),               -- Lien avec l'entité Cluster
    INDEX (id_reseau),                                             -- Indexation pour les recherches par réseau
    INDEX (id_cluster),                                            -- Indexation pour les recherches par cluster
    INDEX (etat),                                                  -- Indexation pour les recherches par état
    INDEX (date_activation),                                       -- Indexation pour les recherches par date d'activation
    INDEX (date_fermeture)                                         -- Indexation pour les recherches par date de fermeture
) ENGINE=InnoDB;

-- Exemple d'insertion d'un domaine
INSERT INTO Domaine (nom, qualite, description, id_reseau, id_cluster, proprietaire, gestionnaire, parametres_securite, controle_acces, permissions, etat, date_activation, date_fermeture, historique)
VALUES 
('public', 'Haute sécurité, domaine public', 'Domaine pour la gestion des services publics', 1, 1, 'Gouvernement', 'Equipe Réseau', 'SSL, VPN', 'Accès ouvert au public', 'Lecture seule', 'actif', '2025-01-01 00:00:00', '2025-12-31 23:59:59', 'Mise en service initiale le 2025-01-01');

-- Vérifier l'existence de la table Domaine
SHOW TABLES LIKE 'Domaine';

-- Vérification des colonnes dans la table Domaine
DESCRIBE Domaine;

SELECT * FROM Domaine WHERE etat = 'actif';

SELECT * FROM Domaine WHERE id_cluster = 1;

SELECT * FROM Domaine WHERE date_activation = '2025-01-01 00:00:00';



CREATE TABLE Intermediate_Device (
    id INT PRIMARY KEY AUTO_INCREMENT,
    qualite ENUM('router', 'switch', 'firewall', 'load_balancer', 'access_point', 'gateway', 'hub', 'bridge', 'modem', 'repeater', 'proxy') NOT NULL, -- Qualité du dispositif intermédiaire
    capacite TEXT,                                                         -- Capacités du dispositif (CPU, RAM, ports, etc.)
    etat ENUM('actif', 'hors_ligne', 'en_maintenance', 'decommissionne') NOT NULL, -- État du dispositif
    date_mise_en_service DATETIME NOT NULL,                                -- Date de mise en service
    date_fin_service DATETIME,                                             -- Date de fin de service (si applicable)
    date_decommission DATETIME,                                            -- Date de décommissionnement
    configuration TEXT,                                                    -- Configuration spécifique de l'appareil
    usage TEXT,                                                            -- Usage de l'appareil (par exemple, production, test, etc.)
    redondance ENUM('oui', 'non') NOT NULL,                                -- Indique si l'appareil est redondant
    localisation_redondance TEXT,                                          -- Localisation de la redondance
    id_domaine INT,                                                        -- Lien avec l'entité Domaine
    id_reseau INT,                                                         -- Lien avec l'entité Réseau
    historique_pannes TEXT,                                                -- Historique des pannes
    historique_maintenances TEXT,                                          -- Historique des maintenances
    gestion_utilisateurs TEXT,                                             -- Gestion des utilisateurs sur le dispositif
    gestion_acces_device TEXT,                                             -- Gestion des accès au dispositif
    FOREIGN KEY (id_domaine) REFERENCES Domaine(id),
    FOREIGN KEY (id_reseau) REFERENCES Reseau(id),
    INDEX (id_domaine),
    INDEX (id_reseau),
    INDEX (qualite),                                                       -- Indexation pour les recherches par qualité
    INDEX (etat),                                                          -- Indexation pour les recherches par état
    INDEX (date_mise_en_service)                                           -- Indexation pour les recherches par date de mise en service
) ENGINE=InnoDB;

-- Insertion d'exemples pour Intermediate_Device
INSERT INTO Intermediate_Device (
    qualite, capacite, etat, date_mise_en_service, configuration, usage, redondance, localisation_redondance, id_domaine, id_reseau, historique_pannes, historique_maintenances, gestion_utilisateurs, gestion_acces_device
) VALUES
('router', '8 CPU, 16GB RAM, 16 ports', 'actif', '2023-01-15 08:00:00', 'Configuration par défaut', 'Routage principal', 'oui', 'Cluster A', 1, 1, 'Aucune panne signalée', 'Maintenance mensuelle', 'Admins uniquement', 'Accès limité au VPN'),
('switch', '4 CPU, 8GB RAM, 48 ports', 'en_maintenance', '2022-11-10 09:00:00', 'Configuration VLAN avancée', 'Segmentation réseau', 'non', NULL, 1, 2, 'Panne majeure le 2023-05-12', 'Maintenance semi-annuelle', 'Opérateurs réseau', 'Accès local uniquement'),
('firewall', '16 CPU, 32GB RAM, double alimentation', 'actif', '2021-07-25 14:00:00', 'Règles de sécurité personnalisées', 'Filtrage de trafic', 'oui', 'Site secondaire', 2, 3, 'Aucune panne signalée', 'Inspection trimestrielle', 'Responsables sécurité', 'Accès sécurisé par clé SSH');

-- Test des enregistrements dans Intermediate_Device SELECT * FROM Intermediate_Device;

-- Rechercher tous les dispositifs intermédiaires actifs SELECT * FROM Intermediate_Device WHERE etat = 'actif';
-- Vérifier les appareils liés à un domaine ou réseau spécifique SELECT * FROM Intermediate_Device WHERE id_domaine = 1; SELECT * FROM End_Device WHERE id_reseau = 2;

-- Rechercher les dispositifs intermédiaires appartenant à un domaine donné SELECT id, qualite, usage FROM Intermediate_Device WHERE id_domaine = (SELECT id FROM Domaine WHERE nom = 'prive');



CREATE TABLE End_Device (
    id INT PRIMARY KEY AUTO_INCREMENT,
    qualite ENUM('laptop', 'PC', 'smartphone', 'tablet', 'smart_tv', 'printer', 'scanner', 'gaming_console', 'iot_device', 'wearable', 'voip_phone', 'camera', 'home_automation_device', 'storage_device') NOT NULL, -- Qualité de l'appareil final
    capacite TEXT,                                                         -- Capacités de l'appareil (CPU, RAM, etc.)
    etat ENUM('actif', 'hors_ligne', 'en_maintenance', 'decommissionne') NOT NULL, -- État de l'appareil
    date_mise_en_service DATETIME NOT NULL,                                -- Date de mise en service
    date_fin_service DATETIME,                                             -- Date de fin de service (si applicable)
    date_decommission DATETIME,                                            -- Date de décommissionnement
    configuration TEXT,                                                    -- Configuration spécifique de l'appareil
    usage TEXT,                                                            -- Usage de l'appareil (par exemple, personnel, production, test, etc.)
    localisation TEXT,                                                     -- Localisation physique ou virtuelle de l'appareil
    id_domaine INT,                                                        -- Lien avec l'entité Domaine
    id_reseau INT,                                                         -- Lien avec l'entité Réseau
    historique_pannes TEXT,                                                -- Historique des pannes
    historique_utilisation TEXT,                                           -- Historique des utilisations
    gestion_utilisateurs TEXT,                                             -- Gestion des utilisateurs sur l'appareil
    gestion_acces_device TEXT,                                             -- Gestion des accès à l'appareil
    FOREIGN KEY (id_domaine) REFERENCES Domaine(id),
    FOREIGN KEY (id_reseau) REFERENCES Reseau(id),
    INDEX (id_domaine),
    INDEX (id_reseau),
    INDEX (qualite),                                                       -- Indexation pour les recherches par qualité
    INDEX (etat),                                                          -- Indexation pour les recherches par état
    INDEX (date_mise_en_service)                                           -- Indexation pour les recherches par date de mise en service
) ENGINE=InnoDB;
-- Insertion d'exemples pour End_Device
INSERT INTO End_Device (
    qualite, capacite, etat, date_mise_en_service, configuration, usage, localisation, id_domaine, id_reseau, historique_pannes, historique_utilisation, gestion_utilisateurs, gestion_acces_device
) VALUES
('laptop', 'Intel i7, 16GB RAM, 512GB SSD', 'actif', '2023-06-01 10:30:00', 'Windows 11, logiciels de bureau installés', 'Travail administratif', 'Bureau 4', 1, 1, 'Batterie remplacée en 2024', 'Utilisé quotidiennement', 'Utilisateur individuel', 'Accès protégé par mot de passe'),
('smartphone', 'Snapdragon 888, 8GB RAM, 128GB stockage', 'actif', '2023-09-15 08:00:00', 'Android 13, applications sécurisées', 'Communication et mobilité', 'Utilisateur externe', 2, 2, 'Écran fissuré en 2024', 'Utilisation modérée', 'Utilisateur individuel', 'Gestion via MDM (Mobile Device Management)'),
('printer', 'Impression A3 couleur, 25 ppm', 'en_maintenance', '2022-01-10 09:15:00', 'Mode réseau activé', 'Impression partagée', 'Salle des imprimantes', 1, 3, 'Problème de toner signalé', 'Utilisation fréquente en heures de bureau', 'Tous les employés', 'Accès réseau restreint par IP');

-- Test des enregistrements dans End_Device SELECT * FROM End_Device;
-- Rechercher tous les dispositifs finaux avec une qualité spécifique (par ex., laptop) SELECT * FROM End_Device WHERE qualite = 'laptop';

-- Vérifier les appareils liés à un domaine ou réseau spécifique SELECT * FROM Intermediate_Device WHERE id_domaine = 1; SELECT * FROM End_Device WHERE id_reseau = 2;

-- Rechercher les appareils finaux connectés à un réseau donné SELECT id, qualite, localisation FROM End_Device WHERE id_reseau = (SELECT id FROM Reseau WHERE etat = 'actif');


CREATE TABLE Acces (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description_qualites_acces TEXT NOT NULL,  -- Description des qualités d'accès possibles (réseau, application, ressource)
    conditions_attribution_acces TEXT,  -- Conditions d’attribution de l’accès
    statut_acces ENUM('autorise', 'refuse', 'en_attente') NOT NULL,  -- Statut de l’accès
    date_acces DATETIME NOT NULL,  -- Date de l'accès
    date_permission DATETIME,  -- Date de permission d’accès
    date_attribution DATETIME,  -- Date d'attribution de l'accès
    duree_attribution INT,  -- Durée d'attribution de l'accès en jours
    duree_acces INT,  -- Durée d'accès en jours
    date_expiration DATETIME,  -- Date d'expiration de l'accès
    historique TEXT,  -- Historique des actions sur l'accès
    reglementation TEXT,  -- Règlementation associée à l'accès
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_cible INT,  -- Lien avec l'entité Cible
    id_tag INT,  -- Lien avec l'entité Tag
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),
    FOREIGN KEY (id_cible) REFERENCES Cible(id),
    FOREIGN KEY (id_tag) REFERENCES Tag(id),
    INDEX (id_acteur),  -- Index pour optimiser les recherches sur acteur
    INDEX (id_cible),  -- Index pour optimiser les recherches sur cible
    INDEX (id_tag),  -- Index pour optimiser les recherches sur tag
    INDEX (date_expiration)  -- Index pour optimiser les recherches sur les dates d'expiration
) ENGINE=InnoDB;

INSERT INTO Acces (
    description_qualites_acces, conditions_attribution_acces, statut_acces, date_acces, date_permission, date_attribution, duree_attribution, duree_acces, date_expiration, historique, reglementation, id_acteur, id_cible, id_tag
) VALUES
('Accès au réseau principal', 'Autorisé uniquement pour les administrateurs', 'autorise', '2025-01-20 10:00:00', '2025-01-19 15:00:00', '2025-01-20 09:00:00', 30, 30, '2025-02-19 10:00:00', 'Créé par l_administrateur système', 'Conforme RGPD', 1, 2, 1),
('Accès à la base de données', 'Réservé au service finance', 'en_attente', '2025-01-22 11:00:00', NULL, '2025-01-22 10:30:00', 14, 14, '2025-02-05 11:00:00', 'Demande en attente d_approbation', 'ISO 27001', 3, 4, 2),
('Accès temporaire à une application', 'Usage temporaire pour consultant externe', 'refuse', '2025-01-18 09:30:00', '2025-01-17 18:00:00', '2025-01-18 09:00:00', 7, 7, '2025-01-25 09:30:00', 'Refusé en raison d_une politique de sécurité stricte', 'Interne uniquement', 5, 6, 3);

-- Vérifier toutes les entrées dans Acces
SELECT * FROM Acces;

-- Vérifier les accès autorisés
SELECT * FROM Acces WHERE statut_acces = 'autorise';

-- Vérifier les accès ayant une date d'expiration spécifique
SELECT * FROM Acces WHERE date_expiration > '2025-01-30';

-- Vérifier les accès liés à un acteur spécifique
SELECT * FROM Acces WHERE id_acteur = 1;

-- Rechercher les accès avec des tags spécifiques
SELECT * FROM Acces WHERE id_tag = 2;

-- Rechercher les accès liés à une cible
SELECT description_qualites_acces, statut_acces FROM Acces
WHERE id_cible = (SELECT id FROM Cible WHERE nom = 'Serveur de production');

-- Rechercher les accès expirés
SELECT * FROM Acces WHERE date_expiration < NOW();



CREATE TABLE Tag (
    id INT PRIMARY KEY AUTO_INCREMENT,
    qualite ENUM('temporaire', 'situationnel', 'liee_a_un_role_specifique') NOT NULL, -- Type de tag
    description TEXT,  -- Description du tag
    id_cible INT,  -- Lien vers l'entité Cible
    id_acteur INT,  -- Lien vers l'entité Acteur
    id_projet INT,  -- Lien vers l'entité Projet
    id_attribution INT,  -- Lien vers l'entité Attribution
    id_statut INT,  -- Lien vers l'entité Statut
    id_role INT,  -- Lien vers l'entité Role
    id_acces INT,  -- Lien vers l'entité Acces
    duree_application INT,  -- Durée d'application en jours ou autres unités
    duree_validation INT,  -- Durée de validation en jours ou autres unités
    duree_attente INT,  -- Durée d'attente en jours ou autres unités
    historique TEXT,  -- Historique des changements ou actions liés au tag
    effet_permissions TEXT,  -- Effet des permissions sur les entités liées
    effet_interactions TEXT,  -- Effet des interactions sur les entités liées
    debut DATETIME,  -- Date et heure du début d'application
    fin DATETIME,  -- Date et heure de fin d'application
    FOREIGN KEY (id_cible) REFERENCES Cible(id),
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),
    FOREIGN KEY (id_projet) REFERENCES Projet(id),
    FOREIGN KEY (id_attribution) REFERENCES Attribution(id),
    FOREIGN KEY (id_statut) REFERENCES Statut(id),
    FOREIGN KEY (id_role) REFERENCES Role(id),
    FOREIGN KEY (id_acces) REFERENCES Acces(id),
    INDEX (id_cible),  -- Optimisation pour les recherches par cible
    INDEX (id_acteur),  -- Optimisation pour les recherches par acteur
    INDEX (id_projet),  -- Optimisation pour les recherches par projet
    INDEX (id_attribution)
    ) ENGINE=InnoDB;

-- Insérer des tags de test dans la table Tag
INSERT INTO Tag (
    qualite, description, id_cible, id_acteur, id_projet, id_attribution, id_statut, id_role, id_acces,
    duree_application, duree_validation, duree_attente, historique, effet_permissions, effet_interactions, debut, fin
) VALUES
('temporaire', 'Tag temporaire pour une ressource', 1, 1, 1, 1, 1, 1, 1, 7, 3, 1, 'Créé pour un test temporaire', 'Aucun effet notable', 'Aucune interaction impactée', '2025-01-20 10:00:00', '2025-01-27 10:00:00'),
('situationnel', 'Tag appliqué en situation exceptionnelle', 2, 2, 2, 2, 2, 2, 2, 14, 7, 2, 'Créé pour une situation exceptionnelle', 'Permissions étendues pour la durée', 'Interactions restreintes', '2025-01-15 09:00:00', '2025-01-29 09:00:00'),
('liee_a_un_role_specifique', 'Tag lié à un rôle administratif', 3, 3, 3, 3, 3, 3, 3, 30, 15, 5, 'Créé pour le rôle Administrateur', 'Accès complet accordé', 'Impact mineur sur interactions', '2025-01-01 00:00:00', '2025-02-01 00:00:00');

-- Afficher tous les enregistrements
SELECT * FROM Tag;

-- Rechercher les tags temporaires
SELECT * FROM Tag WHERE qualite = 'temporaire';

-- Rechercher les tags actifs à une date donnée
SELECT * FROM Tag
WHERE debut <= '2025-01-22' AND (fin IS NULL OR fin >= '2025-01-22');

-- Vérifier les tags liés à un acteur spécifique
SELECT * FROM Tag WHERE id_acteur = 1;

-- Vérifier les tags liés à une cible spécifique
SELECT * FROM Tag WHERE id_cible = 2;

-- Vérifier les tags liés à un projet spécifique
SELECT * FROM Tag WHERE id_projet = 3;

-- Rechercher rapidement des tags avec une date de début spécifique
SELECT * FROM Tag WHERE debut = '2025-01-20 10:00:00';

-- Rechercher des tags expirant avant une certaine date
SELECT * FROM Tag WHERE fin < '2025-01-30 00:00:00';



CREATE TABLE Devoir (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT NOT NULL,  -- Description détaillée du devoir
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_cible INT,  -- Lien avec l'entité Cible
    id_contact INT,  -- Lien avec l'entité Contact
    qualite ENUM('lecture', 'écriture', 'exécution', 'suppression') NOT NULL,  -- Nature du devoir
    condition_attribution TEXT,  -- Conditions d’attribution du devoir
    condition_retrait TEXT,  -- Conditions de retrait du devoir
    historique_attribution TEXT,  -- Historique des attributions du devoir
    historique_revoquation TEXT,  -- Historique des révocations du devoir
    id_validation INT,  -- Lien avec l'entité Validation
    id_controle INT,  -- Lien avec l'entité Contrôle
    duree_validite ENUM('permanent', 'limité') NOT NULL,  -- Durée de validité
    duree_validite_limitee INT,  -- Durée en jours si la validité est limitée
    debut DATETIME,  -- Date et heure de début d’application
    fin DATETIME,  -- Date et heure de fin d’application
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),
    FOREIGN KEY (id_cible) REFERENCES Cible(id),
    FOREIGN KEY (id_contact) REFERENCES Contact(id),
    FOREIGN KEY (id_validation) REFERENCES Validation(id),
    FOREIGN KEY (id_controle) REFERENCES Controle(id),
    INDEX (id_acteur),  -- Optimisation pour les recherches par acteur
    INDEX (id_cible),  -- Optimisation pour les recherches par cible
    INDEX (id_contact),  -- Optimisation pour les recherches par contact
    INDEX (id_validation),  -- Optimisation pour les recherches par validation
    INDEX (id_controle),  -- Optimisation pour les recherches par contrôle
    INDEX (debut),  -- Optimisation pour les recherches par date de début
    INDEX (fin)  -- Optimisation pour les recherches par date de fin
) ENGINE=InnoDB;


-- Insérer des devoirs de test
INSERT INTO Devoir (
    description, id_acteur, id_cible, id_contact, qualite, condition_attribution, 
    condition_retrait, historique_attribution, historique_revoquation, 
    id_validation, id_controle, duree_validite, duree_validite_limitee, debut, fin
) VALUES
('Autorisation d_écrire dans le projet X', 1, 2, 3, 'écriture', 
 'Attribué par le responsable', 'Révocable en cas de non-respect des règles', 
 'Attribué le 2025-01-01', NULL, 
 1, 1, 'limité', 30, '2025-01-01 09:00:00', '2025-01-31 23:59:59'),

('Accès permanent à la lecture des données', 2, 3, 4, 'lecture', 
 'Accès requis pour audit', 'Révocable après audit', 
 'Attribué le 2025-01-15', 'Révoqué le 2025-02-01', 
 2, 2, 'permanent', NULL, '2025-01-15 09:00:00', NULL);

-- Afficher tous les devoirs
SELECT * FROM Devoir;
-- Rechercher les devoirs limités dans le temps
SELECT * FROM Devoir WHERE duree_validite = 'limité';
-- Rechercher les devoirs actifs à une date donnée
SELECT * FROM Devoir
WHERE debut <= '2025-01-20' AND (fin IS NULL OR fin >= '2025-01-20');

-- Vérifier les devoirs liés à un acteur spécifique
SELECT * FROM Devoir WHERE id_acteur = 1;
-- Vérifier les devoirs liés à une cible spécifique
SELECT * FROM Devoir WHERE id_cible = 2;

-- Vérifier les devoirs contrôlés par une entité spécifique
SELECT * FROM Devoir WHERE id_controle = 1;
-- Vérifier que les devoirs limités ont une durée définie
SELECT * FROM Devoir 
WHERE duree_validite = 'limité' AND duree_validite_limitee IS NULL;

-- Vérifier que les devoirs permanents n'ont pas de durée limitée
SELECT * FROM Devoir 
WHERE duree_validite = 'permanent' AND duree_validite_limitee IS NOT NULL;



CREATE TABLE Droit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT NOT NULL,  -- Description détaillée du droit
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_cible INT,  -- Lien avec l'entité Cible
    id_contact INT,  -- Lien avec l'entité Contact
    qualite ENUM('lecture', 'écriture', 'exécution', 'suppression') NOT NULL,  -- Nature du droit
    condition_attribution TEXT,  -- Conditions d’attribution du droit
    condition_retrait TEXT,  -- Conditions de retrait du droit
    historique_attribution TEXT,  -- Historique des attributions
    historique_revoquation TEXT,  -- Historique des révocations
    id_validation INT,  -- Lien avec l'entité Validation
    id_controle INT,  -- Lien avec l'entité Contrôle
    duree_validite ENUM('permanent', 'limité') NOT NULL,  -- Durée de validité
    duree_validite_limitee INT,  -- Durée en jours si la validité est limitée
    debut DATETIME,  -- Date et heure de début de validité
    fin DATETIME,  -- Date et heure de fin de validité
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),
    FOREIGN KEY (id_cible) REFERENCES Cible(id),
    FOREIGN KEY (id_contact) REFERENCES Contact(id),
    FOREIGN KEY (id_validation) REFERENCES Validation(id),
    FOREIGN KEY (id_controle) REFERENCES Controle(id),
    INDEX (id_acteur),  -- Optimisation pour les recherches par acteur
    INDEX (id_cible),  -- Optimisation pour les recherches par cible
    INDEX (id_contact),  -- Optimisation pour les recherches par contact
    INDEX (id_validation),  -- Optimisation pour les recherches par validation
    INDEX (id_controle),  -- Optimisation pour les recherches par contrôle
    INDEX (debut),  -- Optimisation pour les recherches par date de début
    INDEX (fin)  -- Optimisation pour les recherches par date de fin
) ENGINE=InnoDB;

-- Insérer des exemples de droits
INSERT INTO Droit (
    description, id_acteur, id_cible, id_contact, qualite, 
    condition_attribution, condition_retrait, historique_attribution, 
    historique_revoquation, id_validation, id_controle, duree_validite_effective, 
    duree_validite_limitee, debut, fin
) VALUES
('Droit de lecture des fichiers projet', 1, 2, 3, 'lecture',
 'Droit attribué par le chef de projet', 'Révocable en cas de départ', 
 'Attribué le 2025-01-10', 'Révoqué le 2025-01-20', 
 1, 1, 'limité', 15, '2025-01-10 08:00:00', '2025-01-25 20:00:00'),

('Droit permanent d\'écriture sur la base de données', 2, 4, 5, 'écriture',
 'Attribué avec validation', 'Révocable en cas d\'infraction', 
 'Attribué le 2025-01-01', NULL, 
 2, 2, 'permanent', NULL, '2025-01-01 00:00:00', NULL);

-- Afficher tous les droits
SELECT * FROM Droit;

-- Rechercher les droits limités dans le temps
SELECT * FROM Droit WHERE duree_validite = 'limité';

-- Rechercher les droits actifs à une date donnée
SELECT * FROM Droit
WHERE debut <= '2025-01-15' AND (fin IS NULL OR fin >= '2025-01-15');


-- Rechercher les droits attribués à un acteur spécifique
SELECT * FROM Droit WHERE id_acteur = 1;

-- Vérifier les droits associés à une cible spécifique
SELECT * FROM Droit WHERE id_cible = 2;

-- Rechercher les droits validés par une validation spécifique
SELECT * FROM Droit WHERE id_validation = 1;


-- Vérifier que les droits limités ont une durée définie
SELECT * FROM Droit 
WHERE duree_validite = 'limité' AND duree_validite_limitee IS NULL;

-- Vérifier que les droits permanents n'ont pas de durée limitée
SELECT * FROM Droit 
WHERE duree_validite = 'permanent' AND duree_validite_limitee IS NOT NULL;



CREATE TABLE Interaction (
    id INT PRIMARY KEY AUTO_INCREMENT,
    qualite ENUM('communication', 'activation', 'animation', 'validation', 'autre') NOT NULL,  -- Type d'interaction
    id_acteur INT,  -- Lien avec l'entité Acteur
    id_actant INT,  -- Lien avec l'entité Actant
    id_cible INT,  -- Lien avec l'entité Cible
    historique TEXT,  -- Historique des actions ou changements liés à l'interaction
    norme_configuration TEXT,  -- Configurations ou normes associées à l'interaction
    impact_echelles TEXT,  -- Description des impacts à différentes échelles (local/global)
    duree INT,  -- Durée de l'interaction en minutes
    frequence INT,  -- Fréquence de l'interaction (par exemple, par semaine)
    etat ENUM('ouverte', 'en cours', 'terminee') NOT NULL,  -- Statut actuel de l'interaction
    resultats_attendus TEXT,  -- Objectifs ou résultats attendus de l'interaction
    resultats_effectif TEXT,  -- Résultats effectifs obtenus
    importance_biai TEXT,  -- Importance ou biais associé à l'interaction
    feedback TEXT,  -- Retour d’expérience ou remarques
    debut DATETIME,  -- Date et heure de début de l'interaction
    fin DATETIME,  -- Date et heure de fin de l'interaction
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),
    FOREIGN KEY (id_actant) REFERENCES Actant(id),
    FOREIGN KEY (id_cible) REFERENCES Cible(id),
    INDEX (id_acteur),  -- Optimisation pour les recherches par acteur
    INDEX (id_actant),  -- Optimisation pour les recherches par actant
    INDEX (id_cible),  -- Optimisation pour les recherches par cible
    INDEX (debut),  -- Optimisation pour les recherches par date de début
    INDEX (fin)  -- Optimisation pour les recherches par date de fin
) ENGINE=InnoDB;


-- Insérer des exemples d'interactions
INSERT INTO Interaction (
    qualite, id_acteur, id_actant, id_cible, historique, norme_configuration, 
    impact_echelles, duree, frequence, etat, resultats_attendus, 
    resultats_effectif, importance_biai, feedback, debut, fin
) VALUES
('communication', 1, 2, 3, 'Création d_un canal de communication', 
 'Norme ISO123', 'Impact local', 30, 5, 'ouverte', 
 'Améliorer la collaboration', NULL, 'Aucun', NULL, '2025-01-25 08:00:00', NULL),

('activation', 2, 3, 4, 'Activation d_un service', 'Configuration standard', 
 'Impact global', 120, 1, 'terminee', 'Activation réussie', 'Service actif', 
 'Priorité élevée', 'Très positif', '2025-01-20 10:00:00', '2025-01-20 12:00:00');

-- Afficher toutes les interactions
SELECT * FROM Interaction;

-- Rechercher les interactions ouvertes
SELECT * FROM Interaction WHERE etat = 'ouverte';

-- Rechercher les interactions actives sur une période
SELECT * FROM Interaction 
WHERE debut <= '2025-01-25 12:00:00' AND (fin IS NULL OR fin >= '2025-01-25 12:00:00');

-- Rechercher les interactions d'un acteur spécifique
SELECT * FROM Interaction WHERE id_acteur = 1;

-- Vérifier les interactions liées à un actant donné
SELECT * FROM Interaction WHERE id_actant = 2;

-- Rechercher les interactions impliquant une cible spécifique
SELECT * FROM Interaction WHERE id_cible = 3;

-- Vérifier les interactions sans fin alors qu'elles sont terminées
SELECT * FROM Interaction WHERE etat = 'terminee' AND fin IS NULL;

-- Rechercher les interactions sans résultat effectif alors qu'elles sont terminées
SELECT * FROM Interaction WHERE etat = 'terminee' AND resultats_effectif IS NULL;



CREATE TABLE Enregistrement (
    id INT PRIMARY KEY AUTO_INCREMENT,
    qualite ENUM('action', 'transaction', 'communication') NOT NULL,  -- Type d'enregistrement
    description TEXT,  -- Description générale de l'enregistrement
    actant INT,  -- Lien avec la table Actant
    acteur INT,  -- Lien avec la table Acteur
    cible INT,  -- Lien avec la table Cible
    date DATETIME NOT NULL,  -- Date et heure de l'enregistrement
    heure TIME NOT NULL,  -- Heure spécifique de l'enregistrement
    contexte TEXT,  -- Informations sur le contexte : ressources, interface, objectifs
    donnees_associees TEXT,  -- Données associées ou pertinentes
    etat ENUM('réussi', 'échoué') NOT NULL,  -- Statut de l'enregistrement
    reglementation TEXT,  -- Règles ou lois applicables
    obligation_legale TEXT,  -- Obligations légales spécifiques
    historique TEXT,  -- Historique général de l'enregistrement
    archivage TEXT,  -- Informations sur l'archivage
    note_contentieux TEXT,  -- Notes liées aux problèmes légaux ou contentieux
    traçabilite_et_archivage_contentieux TEXT,  -- Traçabilité et archivage pour le contentieux
    methode TEXT,  -- Méthodes utilisées pour l'action ou l'enregistrement
    verification_action TEXT,  -- Résultat des vérifications d'action
    verification_sources TEXT,  -- Résultat des vérifications des sources
    authenticite_reference TEXT,  -- Authentification de référence
    authenticite_archive TEXT,  -- Authentification de l'archive
    id_validation INT,  -- Référence à la table Validation
    id_suivi INT,  -- Référence à la table Suivi
    historique_actions TEXT,  -- Historique des actions spécifiques liées
    FOREIGN KEY (actant) REFERENCES Actant(id),
    FOREIGN KEY (acteur) REFERENCES Acteur(id),
    FOREIGN KEY (cible) REFERENCES Cible(id),
    FOREIGN KEY (id_validation) REFERENCES Validation(id),
    FOREIGN KEY (id_suivi) REFERENCES Suivi(id),
    INDEX (actant),  -- Optimisation pour les requêtes utilisant Actant
    INDEX (acteur),  -- Optimisation pour les requêtes utilisant Acteur
    INDEX (cible),  -- Optimisation pour les requêtes utilisant Cible
    INDEX (id_validation),  -- Optimisation pour les requêtes utilisant Validation
    INDEX (id_suivi),  -- Optimisation pour les requêtes utilisant Suivi
    INDEX (date),  -- Optimisation pour les requêtes temporelles
    INDEX (etat)  -- Optimisation pour les recherches sur l'état
) ENGINE=InnoDB;

-- Exemples d'enregistrements
INSERT INTO Enregistrement (
    qualite, description, actant, acteur, cible, date, heure, contexte, donnees_associees, 
    etat, reglementation, obligation_legale, historique, archivage, note_contentieux, 
    traçabilite_et_archivage_contentieux, methode, verification_action, verification_sources, 
    authenticite_reference, authenticite_archive, id_validation, id_suivi, historique_actions
) VALUES
('action', 'Création d_un nouveau projet', 1, 2, 3, '2025-01-25 10:00:00', '10:00:00', 
 'Utilisation des ressources locales', 'Données relatives au projet X', 'réussi', 
 'Conforme à la réglementation', 'Obligation de conformité', 
 'Historique initial', 'Archivage automatique', 'Aucun contentieux', 
 'Traçabilité complète', 'Méthode A', 'Vérification OK', 'Sources validées', 
 'Référence authentifiée', 'Archive authentifiée', 4, 5, 'Aucune action supplémentaire');

-- Afficher tous les enregistrements
SELECT * FROM Enregistrement;

-- Rechercher les enregistrements liés à un acteur spécifique
SELECT * FROM Enregistrement WHERE acteur = 2;

-- Rechercher les enregistrements par date
SELECT * FROM Enregistrement WHERE date BETWEEN '2025-01-01' AND '2025-01-31';

-- Rechercher les enregistrements réussis
SELECT * FROM Enregistrement WHERE etat = 'réussi';

-- Vérifier les enregistrements sans contexte
SELECT * FROM Enregistrement WHERE contexte IS NULL;

-- Rechercher les enregistrements sans données associées
SELECT * FROM Enregistrement WHERE donnees_associees IS NULL;



CREATE TABLE Contact (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL UNIQUE,                        -- Nom unique pour identifier le contact
    qualite VARCHAR(255) NOT NULL,                           -- Qualité ou titre du contact
    permissions_interaction TEXT,                            -- Liste ou description des permissions d'interaction
    autorisations_interaction TEXT,                          -- Liste ou description des autorisations d'interaction
    role_relation ENUM('client', 'partenaire', 'utilisateur interne') NOT NULL,  -- Rôle dans la relation
    id_coordonnees INT,                                      -- Lien avec les coordonnées
    historique_communications TEXT,                          -- Historique des communications
    acces_documents TEXT,                                    -- Liste des documents accessibles
    authentification TEXT,                                   -- Détails d'authentification du contact
    id_acteur INT,                                           -- Référence à la table Acteur
    id_actant INT,                                           -- Référence à la table Actant
    id_cible INT,                                            -- Référence à la table Cible
    id_validation INT,                                       -- Référence à la table Validation
    id_enregistrement INT,                                   -- Référence à la table Enregistrement
    id_suivi INT,                                            -- Référence à la table Suivi
    id_feedback INT,                                         -- Référence à la table Feedback
    preference_communication TEXT,                           -- Description des préférences de communication
    historique_interaction TEXT,                             -- Historique des interactions
    FOREIGN KEY (id_coordonnees) REFERENCES Coordonnees(id),
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id),
    FOREIGN KEY (id_actant) REFERENCES Actant(id),
    FOREIGN KEY (id_cible) REFERENCES Cible(id),
    FOREIGN KEY (id_validation) REFERENCES Validation(id),
    FOREIGN KEY (id_enregistrement) REFERENCES Enregistrement(id),
    FOREIGN KEY (id_suivi) REFERENCES Suivi(id),
    FOREIGN KEY (id_feedback) REFERENCES Feedback(id),
    -- Index pour améliorer les performances des requêtes
    INDEX (nom),
    INDEX (id_coordonnees),
    INDEX (id_acteur),
    INDEX (id_actant),
    INDEX (id_cible),
    INDEX (id_validation),
    INDEX (id_enregistrement),
    INDEX (id_suivi),
    INDEX (id_feedback)
) ENGINE=InnoDB;


-- Exemple de données pour un contact
INSERT INTO Contact (
    nom, qualite, permissions_interaction, autorisations_interaction, role_relation, 
    id_coordonnees, historique_communications, acces_documents, authentification, 
    id_acteur, id_actant, id_cible, id_validation, id_enregistrement, id_suivi, 
    id_feedback, preference_communication, historique_interaction
) VALUES (
    'Jean Dupont', 'Responsable commercial', 
    'lecture, écriture', 'validation, activation', 'partenaire', 
    1, 'Appels fréquents en 2024', 'Accès à tous les contrats', 'Mot de passe sécurisé', 
    2, 3, 4, 5, 6, 7, 8, 'Email uniquement', 'Aucune interaction critique à ce jour'
);



-- Lister tous les contacts
SELECT * FROM Contact;

-- Rechercher un contact spécifique par nom
SELECT * FROM Contact WHERE nom = 'Jean Dupont';

-- Lister les contacts liés à un acteur spécifique
SELECT * FROM Contact WHERE id_acteur = 2;

-- Vérifier les coordonnées associées
SELECT c.nom, co.adresse
FROM Contact c
JOIN Coordonnees co ON c.id_coordonnees = co.id;

-- Vérifier les validations associées
SELECT c.nom, v.resultat
FROM Contact c
JOIN Validation v ON c.id_validation = v.id;

-- Contacts sans coordonnées associées
SELECT * FROM Contact WHERE id_coordonnees IS NULL;

-- Contacts sans historique de communication
SELECT * FROM Contact WHERE historique_communications IS NULL;



CREATE TABLE Actant (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL UNIQUE,                      -- Nom unique de l'actant
    qualite VARCHAR(255) NOT NULL,                          -- Qualité de l'actant
    categorie_actant ENUM('équipement', 'logiciel', 'agent') NOT NULL,  -- Catégorie de l'actant
    description TEXT,                                       -- Description de l'actant
    id_projet INT,                                          -- Référence au projet
    id_charge INT,                                          -- Référence à la charge
    id_tache INT,                                           -- Référence à la tâche
    id_role INT,                                            -- Référence au rôle
    id_cible INT,                                           -- Référence à la cible
    id_attribution INT,                                     -- Référence à l'attribution
    profil TEXT,                                            -- Profil de l'actant
    statut TEXT,                                            -- Statut de l'automatisation
    fonctionnalites TEXT,                                   -- Fonctionnalités de l'actant
    id_statut INT,                                          -- Référence au statut
    id_contact INT,                                         -- Référence au contact
    id_validation INT,                                      -- Référence à la validation
    etat ENUM('etant', 'actif', 'inactif', 'fonctionne', 'non-fonctionnel', 'nonetant_anticipé') NOT NULL,  -- État de l'actant
    historique_actions TEXT,                                -- Historique des actions
    permissions_et_droits_acces TEXT,                       -- Permissions et droits d'accès
    historique_interactions TEXT,                           -- Historique des interactions
    histoire_evenements TEXT,                               -- Historique des événements
    permissions_acces TEXT,                                 -- Permissions d'accès
    droits_permission_acces TEXT,                           -- Droits relatifs aux permissions d'accès
    permissions_action TEXT,                                -- Permissions d'action
    droits_permission_action TEXT,                          -- Droits relatifs aux actions
    paramétrage_experience_utilisateur TEXT,                -- Paramétrage de l'expérience utilisateur
    experience_acteur TEXT,                                 -- Expérience de l'acteur
    categorie_humaine VARCHAR(255),                         -- Catégorie humaine
    activite VARCHAR(255),                                  -- Activité de l'actant
    notifications TEXT,                                     -- Notifications pour l'actant
    alertes TEXT,                                           -- Alertes pour l'actant
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,       -- Date de création
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Dernière modification

    -- Clés étrangères
    FOREIGN KEY (id_projet) REFERENCES Projet(id),
    FOREIGN KEY (id_charge) REFERENCES Charge(id),
    FOREIGN KEY (id_tache) REFERENCES Tache(id),
    FOREIGN KEY (id_role) REFERENCES Role(id),
    FOREIGN KEY (id_cible) REFERENCES Cible(id),
    FOREIGN KEY (id_attribution) REFERENCES Attribution(id),
    FOREIGN KEY (id_statut) REFERENCES Statut(id),
    FOREIGN KEY (id_contact) REFERENCES Contact(id),
    FOREIGN KEY (id_validation) REFERENCES Validation(id),

    -- Index pour les colonnes fréquemment recherchées
    INDEX (nom),
    INDEX (id_projet),
    INDEX (id_charge),
    INDEX (id_tache),
    INDEX (id_role),
    INDEX (id_attribution),
    INDEX (id_statut),
    INDEX (id_contact),
    INDEX (id_validation),
    INDEX (id_cible),
    INDEX (etat)  -- Indexation de l'état pour optimiser les requêtes sur ce champ
) ENGINE=InnoDB;

INSERT INTO Actant (
    nom, qualite, categorie_actant, description, id_projet, id_charge, id_tache, 
    id_role, id_cible, id_attribution, profil, statut, fonctionnalites, id_statut, 
    id_contact, id_validation, etat, historique_actions, permissions_et_droits_acces
) 
VALUES (
    'Actant 1', 'Acteur', 'logiciel', 'Logiciel de gestion', 1, 1, 1, 1, 1, 1, 
    'Profil de l\'actant', 'Actif', 'Gestion des projets', 1, 1, 1, 'actif', 
    'Action 1', 'Droits d\'accès'
);

SELECT * FROM Actant WHERE etat = 'actif';



CREATE TABLE Acteur (
    id INT PRIMARY KEY AUTO_INCREMENT,                  -- Identifiant unique
    nom VARCHAR(255) NOT NULL UNIQUE,                   -- Nom unique de l'acteur
    qualite VARCHAR(255) NOT NULL,                      -- Qualité de l'acteur
    id_projet INT,                                      -- Référence au projet
    id_charge INT,                                      -- Référence à la charge
    id_tache INT,                                       -- Référence à la tâche
    id_role INT,                                        -- Référence au rôle
    id_attribution INT,                                 -- Référence à une attribution
    id_profil INT,                                      -- Référence au profil (admin, utilisateur, etc.)
    id_contact INT,                                     -- Référence au contact
    id_validation INT,                                  -- Référence à la validation
    id_cible INT,                                       -- Référence à la cible associée
    etat ENUM('etant', 'actif', 'inactif', 'nonetant') NOT NULL DEFAULT 'actif', -- État de l'acteur
    id_statut INT,                                      -- Référence au statut
    competences TEXT,                                   -- Compétences de l'acteur
    disponibilites TEXT,                                -- Disponibilités de l'acteur
    historique_actions TEXT,                            -- Historique des actions réalisées
    permissions_et_droits_acces TEXT,                   -- Permissions et droits d'accès
    historique_interactions TEXT,                       -- Historique des interactions
    histoire_evenements TEXT,                           -- Histoire des événements
    permissions_acces TEXT,                             -- Permissions d'accès
    droits_permission_acces TEXT,                       -- Droits associés aux permissions d'accès
    permissions_action TEXT,                            -- Permissions pour les actions
    droits_permission_action TEXT,                      -- Droits associés aux actions
    paramétrage_experience_utilisateur TEXT,            -- Paramétrage de l'expérience utilisateur
    experience_acteur TEXT,                             -- Expérience spécifique de l'acteur
    categorie_humaine VARCHAR(255),                     -- Catégorie humaine (si applicable)
    activite VARCHAR(255),                              -- Activité de l'acteur
    notifications TEXT,                                 -- Notifications pour l'acteur
    alertes TEXT,                                       -- Alertes pour l'acteur
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,   -- Date de création
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Dernière modification

    -- Clés étrangères
    FOREIGN KEY (id_projet) REFERENCES Projet(id),
    FOREIGN KEY (id_charge) REFERENCES Charge(id),
    FOREIGN KEY (id_tache) REFERENCES Tache(id),
    FOREIGN KEY (id_role) REFERENCES Role(id),
    FOREIGN KEY (id_attribution) REFERENCES Attribution(id),
    FOREIGN KEY (id_profil) REFERENCES Profil(id),
    FOREIGN KEY (id_contact) REFERENCES Contact(id),
    FOREIGN KEY (id_validation) REFERENCES Validation(id),
    FOREIGN KEY (id_cible) REFERENCES Cible(id),
    FOREIGN KEY (id_statut) REFERENCES Statut(id),

    -- Index pour les colonnes fréquemment recherchées
    INDEX (nom),
    INDEX (id_projet),
    INDEX (id_charge),
    INDEX (id_tache),
    INDEX (id_role),
    INDEX (id_attribution),
    INDEX (id_profil),
    INDEX (id_contact),
    INDEX (id_validation),
    INDEX (id_cible),
    INDEX (etat),
    INDEX (id_statut)
) ENGINE=InnoDB;

INSERT INTO Acteur (
    nom, qualite, id_projet, id_charge, id_tache, id_role, id_attribution, id_profil, id_contact, 
    id_validation, id_cible, etat, id_statut, competences, disponibilites
) 
VALUES (
    'Actor 1', 'Manager', 1, 1, 1, 1, 1, 1, 1, 1, 1, 'actif', 1, 'Leadership, Communication', 'Full-time'
);

SELECT * FROM Acteur WHERE etat = 'actif';

SELECT A.nom, P.nom AS projet_nom, C.nom AS charge_nom 
FROM Acteur A 
JOIN Projet P ON A.id_projet = P.id 
JOIN Charge C ON A.id_charge = C.id;



CREATE TABLE cible (
    id INT AUTO_INCREMENT PRIMARY KEY,                       -- Identifiant unique de la cible
    nom VARCHAR(255) NOT NULL UNIQUE,                         -- Nom de la cible (doit être unique)
    qualite VARCHAR(255) NOT NULL,                            -- Qualité ou caractéristique principale de la cible
    id_projet INT,                                            -- Référence au projet associé
    id_charge INT,                                            -- Référence à une charge associée
    id_tache INT,                                             -- Référence à une tâche associée
    id_role INT,                                              -- Référence à un rôle associé
    id_attribution INT,                                       -- Référence à une attribution
    id_profil INT,                                            -- Référence au profil
    classe_cible VARCHAR(255) NOT NULL,                        -- Catégorie de la cible (client, utilisateur, etc.)
    activite VARCHAR(255),                                    -- Activité ou occupation de la cible
    historique_interactions TEXT,                             -- Historique des interactions avec la cible
    historique_actions TEXT,                                  -- Historique des actions réalisées par ou pour la cible
    histoire_evenements TEXT,                                 -- Historique des événements liés à la cible
    permissions_acces TEXT,                                   -- Détails des permissions d'accès de la cible
    droits_permission_acces TEXT,                             -- Droits relatifs aux permissions d'accès
    permissions_action TEXT,                                  -- Détails des permissions d'action de la cible
    droits_permission_action TEXT,                            -- Droits relatifs aux permissions d'action
    parametres_experience_utilisateur TEXT,                   -- Paramétrage de l'expérience utilisateur
    notifications TEXT,                                       -- Notifications spécifiques à la cible
    alertes TEXT,                                             -- Alertes spécifiques à la cible
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,         -- Date de création de l'enregistrement
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Date de dernière modification
    
    -- Clés étrangères
    FOREIGN KEY (id_projet) REFERENCES projet(id) ON DELETE SET NULL,  -- Lien avec la table Projet
    FOREIGN KEY (id_charge) REFERENCES charge(id) ON DELETE SET NULL,  -- Lien avec la table Charge
    FOREIGN KEY (id_tache) REFERENCES tache(id) ON DELETE SET NULL,    -- Lien avec la table Tache
    FOREIGN KEY (id_role) REFERENCES role(id) ON DELETE SET NULL,      -- Lien avec la table Role
    FOREIGN KEY (id_attribution) REFERENCES attribution(id) ON DELETE SET NULL, -- Lien avec la table Attribution
    FOREIGN KEY (id_profil) REFERENCES profil(id) ON DELETE SET NULL,   -- Lien avec la table Profil

    -- Index pour les colonnes fréquemment recherchées
    INDEX (id_projet),                                           -- Index pour accélérer les recherches sur id_projet
    INDEX (id_tache),                                            -- Index pour accélérer les recherches sur id_tache
    INDEX (id_role),                                             -- Index pour accélérer les recherches sur id_role
    INDEX (id_profil),                                            -- Index pour accélérer les recherches sur id_profil
    INDEX (classe_cible)                                          -- Index pour accélérer les recherches sur classe_cible
) ENGINE=InnoDB;

CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

INSERT INTO cible (
    nom, qualite, id_projet, id_charge, id_tache, id_role, id_attribution, id_profil, 
    classe_cible, activite, historique_interactions, historique_actions, histoire_evenements
) 
VALUES (
    'Target 1', 'Client', 1, 1, 1, 1, 1, 1, 'client', 'Sales', 'Interaction 1', 'Action 1', 'Event 1'
);

SELECT * FROM cible WHERE classe_cible = 'client';

SELECT C.nom, P.nom AS projet_nom, T.nom AS tache_nom 
FROM cible C
JOIN projet P ON C.id_projet = P.id
JOIN tache T ON C.id_tache = T.id;



CREATE TABLE cahier_bilans (
    id INT AUTO_INCREMENT PRIMARY KEY,                         -- Identifiant unique du bilan
    nom VARCHAR(255) NOT NULL,                                 -- Nom du bilan
    version VARCHAR(50),                                       -- Version du bilan
    date_bilan DATE NOT NULL,                                  -- Date du bilan
    frequence VARCHAR(50),                                     -- Fréquence des bilans
    id_projet INT NOT NULL,                                     -- Référence au projet associé
    id_charge INT,                                             -- Référence à une charge associée
    id_tache INT,                                              -- Référence à une tâche associée
    id_role INT,                                               -- Référence à un rôle associé
    id_actant INT,                                             -- Référence à un actant associé
    id_acteur INT,                                             -- Référence à un acteur associé
    redacteur VARCHAR(255),                                    -- Rédacteur du bilan
    statut_du_bilan VARCHAR(50),                               -- Statut du bilan
    synthese_initial TEXT,                                     -- Synthèse initiale
    synthese_final TEXT,                                       -- Synthèse finale
    bilan_d_activite TEXT,                                     -- Bilan d'activité
    resultats_globaux_bruts_projet TEXT,                       -- Résultats bruts globaux du projet
    resultats_globaux_bruts_charge TEXT,                       -- Résultats bruts globaux des charges
    resultats_globaux_bruts_tache TEXT,                        -- Résultats bruts globaux des tâches
    resultats_globaux_bruts_role TEXT,                         -- Résultats bruts globaux des rôles
    indicateurs_performance_projet TEXT,                       -- Indicateurs de performance du projet
    indicateurs_performance_charge TEXT,                       -- Indicateurs de performance des charges
    indicateurs_performance_tache TEXT,                        -- Indicateurs de performance des tâches
    indicateurs_performance_role TEXT,                         -- Indicateurs de performance des rôles
    evaluation_projet TEXT,                                    -- Évaluation du projet
    evaluation_charge TEXT,                                    -- Évaluation des charges
    evaluation_tache TEXT,                                     -- Évaluation des tâches
    evaluation_role TEXT,                                      -- Évaluation des rôles
    historique_bilans TEXT,                                    -- Historique des bilans
    lecons_apprises TEXT,                                      -- Leçons apprises
    ameliorations_recommandees TEXT,                           -- Améliorations recommandées
    perspective_futur TEXT,                                    -- Perspectives futures
    retours_experience_acteurs TEXT,                           -- Retours d'expérience des acteurs
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,          -- Date de création du bilan
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Date de dernière modification
    
    -- Clés étrangères
    FOREIGN KEY (id_projet) REFERENCES projet(id) ON DELETE SET NULL,        -- Lien avec la table Projet
    FOREIGN KEY (id_charge) REFERENCES cahier_charges(id) ON DELETE SET NULL, -- Lien avec Cahier_charges
    FOREIGN KEY (id_tache) REFERENCES cahier_taches(id) ON DELETE SET NULL,   -- Lien avec Cahier_taches
    FOREIGN KEY (id_role) REFERENCES cahier_roles(id) ON DELETE SET NULL,     -- Lien avec Cahier_roles
    FOREIGN KEY (id_actant) REFERENCES actants(id) ON DELETE SET NULL,        -- Lien avec la table Actants
    FOREIGN KEY (id_acteur) REFERENCES acteurs(id) ON DELETE SET NULL,        -- Lien avec la table Acteurs

    -- Index pour accélérer les recherches sur les colonnes fréquemment utilisées
    INDEX (id_projet),                                               -- Index pour projet
    INDEX (id_charge),                                               -- Index pour charge
    INDEX (id_tache),                                                -- Index pour tâche
    INDEX (id_role),                                                 -- Index pour rôle
    INDEX (id_actant),                                               -- Index pour actant
    INDEX (id_acteur)                                                -- Index pour acteur
) ENGINE=InnoDB;

CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

INSERT INTO cahier_bilans (
    nom, version, date_bilan, frequence, id_projet, id_charge, id_tache, id_role, 
    id_actant, id_acteur, redacteur, statut_du_bilan, synthese_initial
) 
VALUES (
    'Bilan 1', '1.0', '2025-01-26', 'Mensuel', 1, 1, 1, 1, 1, 1, 'John Doe', 'Validé', 'Bilan initial'
);

SELECT CB.nom, P.nom AS projet_nom, C.nom AS charge_nom
FROM cahier_bilans CB
JOIN projet P ON CB.id_projet = P.id
JOIN cahier_charges C ON CB.id_charge = C.id;



CREATE TABLE cahier_roles (
    id INT AUTO_INCREMENT PRIMARY KEY,                     -- Identifiant unique du rôle
    nom VARCHAR(255) NOT NULL,                             -- Nom du rôle
    version VARCHAR(50),                                   -- Version du rôle
    assignation TEXT,                                      -- Assignation spécifique
    competences_requises TEXT,                             -- Compétences requises pour le rôle
    formation TEXT,                                        -- Formation nécessaire
    id_projet INT NOT NULL,                                -- Référence au projet associé
    id_charge INT NOT NULL,                                -- Référence à une charge associée
    id_tache INT,                                          -- Référence à une tâche associée
    id_actant INT,                                         -- Référence à l'actant impliqué
    id_acteur INT,                                         -- Référence à l'acteur impliqué
    id_validation INT,                                     -- Référence à la validation
    id_enregistrement INT,                                 -- Référence à un enregistrement
    personnes_ou_equipes_affectees TEXT,                   -- Liste des personnes ou équipes affectées
    description TEXT,                                      -- Description du rôle
    responsabilites TEXT,                                  -- Responsabilités du rôle
    historique_actions TEXT,                               -- Historique des actions réalisées
    historique_reattributions TEXT,                        -- Historique des réattributions de rôle
    critere_notation TEXT,                                 -- Critères de notation associés au rôle
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,      -- Date de création du rôle
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Date de dernière modification

    -- Clés étrangères
    FOREIGN KEY (id_projet) REFERENCES projet(id) ON DELETE SET NULL,   -- Lien avec la table Projet
    FOREIGN KEY (id_charge) REFERENCES cahier_charges(id) ON DELETE SET NULL, -- Lien avec Cahier_charges
    FOREIGN KEY (id_tache) REFERENCES cahier_taches(id) ON DELETE SET NULL,   -- Lien avec Cahier_taches
    FOREIGN KEY (id_actant) REFERENCES actants(id) ON DELETE SET NULL, -- Lien avec la table Actants
    FOREIGN KEY (id_acteur) REFERENCES acteurs(id) ON DELETE SET NULL, -- Lien avec la table Acteurs
    FOREIGN KEY (id_validation) REFERENCES validation(id) ON DELETE SET NULL, -- Lien avec Validation
    FOREIGN KEY (id_enregistrement) REFERENCES enregistrement(id) ON DELETE SET NULL, -- Lien avec Enregistrement

    -- Index pour améliorer les performances des recherches
    INDEX (id_projet),                                           -- Index pour projet
    INDEX (id_charge),                                           -- Index pour charge
    INDEX (id_tache),                                            -- Index pour tâche
    INDEX (id_actant),                                           -- Index pour actant
    INDEX (id_acteur),                                           -- Index pour acteur
    INDEX (id_validation),                                       -- Index pour validation
    INDEX (id_enregistrement),                                   -- Index pour enregistrement
    INDEX (nom)                                                  -- Index pour nom (recherche plus rapide)
) ENGINE=InnoDB;

CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

INSERT INTO cahier_roles (
    nom, version, assignation, competences_requises, formation, 
    id_projet, id_charge, id_tache, id_actant, id_acteur, id_validation, 
    id_enregistrement, personnes_ou_equipes_affectees, description, 
    responsabilites, historique_actions
) 
VALUES (
    'Chef de projet', '1.0', 'Responsable de la coordination', 
    'Gestion de projet, communication', 'Formation interne', 
    1, 1, 1, 1, 1, 1, 1, 'Équipe A, Équipe B', 'Gestion de projet et communication', 
    'Responsabilité principale dans la gestion du projet', 'Actions réalisées: Planification, suivi.'
);



CREATE TABLE cahier_taches (
    id INT AUTO_INCREMENT PRIMARY KEY,                     -- Identifiant unique de la tâche
    nom VARCHAR(255) NOT NULL,                             -- Nom de la tâche
    version VARCHAR(50),                                   -- Version de la tâche
    id_projet INT NOT NULL,                                -- Référence au projet associé
    id_charge INT NOT NULL,                                -- Référence à une charge associée
    id_role INT,                                           -- Référence au rôle assigné
    id_actant INT,                                         -- Référence à l'actant impliqué
    id_acteur INT,                                         -- Référence à l'acteur impliqué
    id_suivi INT,                                          -- Référence au suivi
    id_validation INT,                                     -- Référence à la validation
    id_enregistrement INT,                                 -- Référence à un enregistrement
    liste_taches TEXT,                                     -- Liste des sous-tâches ou tâches associées
    priorite ENUM('basse', 'moyenne', 'haute') DEFAULT 'moyenne',  -- Priorité de la tâche
    etat ENUM('en cours', 'complétée', 'à venir') NOT NULL, -- État de la tâche
    duree INT,                                             -- Durée estimée de la tâche (en heures ou jours)
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,      -- Date de création de la tâche
    dates_debut_fin JSON,                                  -- Dates de début et de fin (ou deux champs si nécessaire)
    deadline_rendu_specifique DATETIME,                    -- Deadline spécifique
    ressources_necessaires TEXT,                           -- Ressources nécessaires
    risques_associes TEXT,                                 -- Risques associés
    affectation_tache TEXT,                                -- Affectation des tâches
    affectation_rendu_specifique TEXT,                     -- Affectation des rendus spécifiques
    description TEXT,                                      -- Description de la tâche
    affectation_roles TEXT,                                -- Rôles affectés à la tâche
    historique_actions TEXT,                               -- Historique des actions réalisées
    ressources_assignees TEXT,                             -- Ressources assignées à la tâche
    id_critere_notation INT,                               -- Référence aux critères de notation
    notes_performance TEXT,                                -- Notes de performance de la tâche
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Date de dernière modification

    -- Clés étrangères
    FOREIGN KEY (id_projet) REFERENCES projet(id) ON DELETE SET NULL, -- Lien avec la table Projet
    FOREIGN KEY (id_charge) REFERENCES cahier_charges(id) ON DELETE SET NULL, -- Lien avec la table Cahier_charges
    FOREIGN KEY (id_role) REFERENCES roles(id) ON DELETE SET NULL,    -- Lien avec la table Roles
    FOREIGN KEY (id_actant) REFERENCES actants(id) ON DELETE SET NULL, -- Lien avec la table Actants
    FOREIGN KEY (id_acteur) REFERENCES acteurs(id) ON DELETE SET NULL, -- Lien avec la table Acteurs
    FOREIGN KEY (id_suivi) REFERENCES suivi(id) ON DELETE SET NULL,   -- Lien avec la table Suivi
    FOREIGN KEY (id_validation) REFERENCES validation(id) ON DELETE SET NULL, -- Lien avec la table Validation
    FOREIGN KEY (id_enregistrement) REFERENCES enregistrement(id) ON DELETE SET NULL, -- Lien avec la table Enregistrement
    FOREIGN KEY (id_critere_notation) REFERENCES criteres_notation(id) ON DELETE SET NULL, -- Lien avec les Critères de notation

    -- Index pour améliorer les performances des recherches
    INDEX (id_projet),                                           -- Index pour projet
    INDEX (id_charge),                                           -- Index pour charge
    INDEX (id_role),                                             -- Index pour rôle
    INDEX (id_actant),                                           -- Index pour actant
    INDEX (id_acteur),                                           -- Index pour acteur
    INDEX (id_suivi),                                            -- Index pour suivi
    INDEX (id_validation),                                       -- Index pour validation
    INDEX (id_enregistrement),                                   -- Index pour enregistrement
    INDEX (id_critere_notation),                                 -- Index pour critère de notation
    INDEX (nom),                                                 -- Index pour nom (recherche plus rapide)
    INDEX (etat)                                                 -- Index pour état (optimiser les recherches par état)
) ENGINE=InnoDB;

CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

INSERT INTO cahier_taches (
    nom, version, id_projet, id_charge, id_role, id_actant, id_acteur, 
    id_suivi, id_validation, id_enregistrement, liste_taches, 
    priorite, etat, duree, dates_debut_fin, deadline_rendu_specifique, 
    ressources_necessaires, risques_associes, affectation_tache, 
    affectation_rendu_specifique, description, affectation_roles, 
    historique_actions, ressources_assignees, id_critere_notation, notes_performance
) 
VALUES (
    'Développement de la fonctionnalité X', '1.0', 1, 1, 1, 1, 1, 
    1, 1, 1, 'Sous-tâche 1, Sous-tâche 2', 'haute', 'en cours', 5, 
    '{"debut": "2025-01-27", "fin": "2025-01-30"}', '2025-01-28', 
    'Serveur, Équipe de développement', 'Retard possible', 'Affecter les développeurs', 
    'Rendu spécifique: Rapport de développement', 'Développement d_une nouvelle fonctionnalité', 
    'Développeur', 'Actions réalisées: Développement, tests', 'Ressources assignées: Équipe de développement', 
    1, 'Performance: Bonne'
);



CREATE TABLE cahier_charges (
    id INT AUTO_INCREMENT PRIMARY KEY,                -- Identifiant unique pour chaque cahier des charges
    nom VARCHAR(255) NOT NULL,                        -- Nom du cahier des charges
    version VARCHAR(50),                              -- Version du cahier des charges
    unite VARCHAR(100),                               -- Unité associée au cahier des charges
    id_projet INT NOT NULL,                           -- Référence au projet
    id_tache INT NOT NULL,                            -- Référence à une tâche
    id_role INT NOT NULL,                             -- Référence à un rôle
    id_actant INT NOT NULL,                           -- Référence à un actant
    id_acteur INT NOT NULL,                           -- Référence à un acteur
    description TEXT,                                 -- Description détaillée du cahier des charges
    contraintes TEXT,                                 -- Contraintes spécifiques
    dependances TEXT,                                 -- Dépendances avec d'autres projets ou tâches
    objectifs TEXT,                                   -- Objectifs à atteindre
    livrables TEXT,                                   -- Liste des livrables
    criteres_acceptation TEXT,                        -- Critères d'acceptation des livrables
    indicateurs_validation TEXT,                      -- Indicateurs de validation
    regles_de_gestion_associees TEXT,                 -- Règles de gestion associées au cahier
    historique_des_modifications TEXT,                -- Historique des modifications effectuées
    resultats_attendus TEXT,                          -- Résultats attendus du cahier des charges
    etat ENUM('en cours', 'complété', 'à venir') NOT NULL, -- Etat du cahier des charges
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP, -- Date de création du cahier
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Date de dernière modification

    -- Clés étrangères
    FOREIGN KEY (id_projet) REFERENCES projet(id) ON DELETE SET NULL, -- Lien avec la table projet
    FOREIGN KEY (id_tache) REFERENCES tache(id) ON DELETE SET NULL,   -- Lien avec la table tache
    FOREIGN KEY (id_role) REFERENCES roles(id) ON DELETE SET NULL,    -- Lien avec la table roles
    FOREIGN KEY (id_actant) REFERENCES actants(id) ON DELETE SET NULL, -- Lien avec la table actants
    FOREIGN KEY (id_acteur) REFERENCES acteurs(id) ON DELETE SET NULL, -- Lien avec la table acteurs
    FOREIGN KEY (id_suivi) REFERENCES suivi(id) ON DELETE SET NULL,   -- Lien avec la table suivi
    FOREIGN KEY (id_validation) REFERENCES validation(id) ON DELETE SET NULL, -- Lien avec la table validation
    FOREIGN KEY (id_enregistrement) REFERENCES enregistrement(id) ON DELETE SET NULL, -- Lien avec la table enregistrement
    FOREIGN KEY (id_critere_notation) REFERENCES criteres_notation(id) ON DELETE SET NULL, -- Lien avec les critères de notation

    -- Index pour améliorer les performances des recherches
    INDEX (id_projet),                                           -- Index pour projet
    INDEX (id_tache),                                            -- Index pour tâche
    INDEX (id_role),                                             -- Index pour rôle
    INDEX (id_actant),                                           -- Index pour actant
    INDEX (id_acteur),                                           -- Index pour acteur
    INDEX (etat)                                                 -- Index pour état
) ENGINE=InnoDB;


CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

INSERT INTO cahier_charges (
    nom, version, unite, id_projet, id_tache, id_role, id_actant, id_acteur,
    description, contraintes, dependances, objectifs, livrables, 
    criteres_acceptation, indicateurs_validation, regles_de_gestion_associees, 
    historique_des_modifications, resultats_attendus, etat
) 
VALUES (
    'Cahier des charges pour le projet X', '1.0', 'Unité A', 1, 1, 1, 1, 1,
    'Description détaillée', 'Contraintes techniques', 'Dépendances avec d_autres projets', 
    'Objectifs à atteindre', 'Livrables attendus', 'Critères d_acceptation définis', 
    'Indicateurs de validation prédéfinis', 'Règles de gestion associées', 
    'Historique des modifications', 'Résultats attendus', 'en cours'
);



CREATE TABLE Projet (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Identifiant unique pour chaque projet
    nom VARCHAR(255) NOT NULL,                       -- Nom du projet
    version VARCHAR(50),                             -- Version du projet
    unite VARCHAR(100),                              -- Unité associée au projet
    description TEXT,                                -- Description détaillée du projet
    date_de_debut DATE,                              -- Date de début du projet
    date_de_fin DATE,                                -- Date de fin du projet
    budget_alloue DECIMAL(15, 2),                    -- Budget alloué au projet
    etat_du_projet ENUM('en cours', 'complété', 'à venir') NOT NULL, -- État actuel du projet
    risques TEXT,                                    -- Liste des risques associés au projet
    plan_mitigation TEXT,                            -- Plan de mitigation des risques
    responsables VARCHAR(255),                      -- Personnes responsables du projet
    liens_vers_cahiers_des_charges TEXT,             -- Liens vers les cahiers des charges
    liens_vers_taches TEXT,                          -- Liens vers les tâches associées
    liens_vers_roles TEXT,                           -- Liens vers les rôles associés
    liens_vers_bilans TEXT,                          -- Liens vers les bilans
    historique_des_actions TEXT,                     -- Historique des actions entreprises
    indicateurs_de_performance TEXT,                 -- Indicateurs de performance du projet
    priorite ENUM('basse', 'moyenne', 'haute') DEFAULT 'moyenne', -- Niveau de priorité du projet
    categorie_du_projet VARCHAR(100),                -- Catégorie du projet
    qualite_de_gestion_du_projet VARCHAR(100),       -- Évaluation de la qualité de gestion
    etat_d_avancement VARCHAR(100),                  -- État d'avancement du projet
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Date de dernière modification

    -- Liens avec d'autres tables (à définir selon votre structure)
    FOREIGN KEY (liens_vers_cahiers_des_charges) REFERENCES cahier_charges(id) ON DELETE SET NULL,
    FOREIGN KEY (liens_vers_taches) REFERENCES tache(id) ON DELETE SET NULL,
    FOREIGN KEY (liens_vers_roles) REFERENCES roles(id) ON DELETE SET NULL,
    FOREIGN KEY (liens_vers_bilans) REFERENCES bilans(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- Inserting a sample project
INSERT INTO Projet (
    nom, version, unite, description, date_de_debut, date_de_fin, budget_alloue, etat_du_projet,
    risques, plan_mitigation, responsables, liens_vers_cahiers_des_charges, liens_vers_taches,
    liens_vers_roles, liens_vers_bilans, historique_des_actions, indicateurs_de_performance, priorite,
    categorie_du_projet, qualite_de_gestion_du_projet, etat_d_avancement
) VALUES (
    'Développement du logiciel', '1.0', 'Heures', 'Développement d\'un nouveau système', '2025-02-01', '2025-12-31', 500000.00, 
    'en cours', 'Risques techniques, Risques financiers', 'Plan d\'atténuation pour risques techniques et financiers', 
    'Alice, Bob', 'Lien vers cahier1', 'Tâche1, Tâche2', 'Rôle1', 'Bilan1', 
    'Historique des actions', 'Indicateurs de performance définis', 'haute', 'Technologie', 'Bonne', '75%'
);

-- Selecting the inserted project to verify the insertion
SELECT * FROM Projet WHERE nom = 'Développement du logiciel';


-- Update the project state to 'complété'
UPDATE Projet
SET etat_du_projet = 'complété'
WHERE id = 1;
-- After running the update, the date_modification field should automatically reflect the --- current timestamp.

-- Verifying the updated data
SELECT id, etat_du_projet, date_modification FROM Projet WHERE id = 1;

-- Trying to delete a project that is referenced in foreign key
DELETE FROM Projet WHERE id = 1;
-- If the foreign keys are set with ON DELETE SET NULL, the related records 
-- in cahier_charges, tache, etc., should have their Projet references set to NULL 
-- without deleting those records.

-- Insert a new project with NULL foreign key references
INSERT INTO Projet (
    nom, version, unite, description, date_de_debut, date_de_fin, budget_alloue, etat_du_projet,
    risques, plan_mitigation, responsables, liens_vers_cahiers_des_charges, liens_vers_taches,
    liens_vers_roles, liens_vers_bilans, historique_des_actions, indicateurs_de_performance, priorite,
    categorie_du_projet, qualite_de_gestion_du_projet, etat_d_avancement
) VALUES (
    'Projet sans références externes', '1.0', 'Heures', 'Description du projet sans références', '2025-03-01', '2025-06-30', 100000.00, 
    'à venir', 'Aucun risque majeur', 'Pas de plan de mitigation', 
    'John, Jane', NULL, NULL, NULL, NULL, 
    'Pas d\'historique', 'Pas d\'indicateur', 'basse', 'Informatique', 'Moyenne', '10%'
);








