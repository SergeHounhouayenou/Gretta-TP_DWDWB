-- -----------------
-- Cours SQL : SELECT classique (DQL)
--  -------------------------------

-- -----------------------------
-- Partie 1 : Structure de base
-- ----------------------------

-- La commande SELECT est utilisée pour intérroger des données dans une base
-- Sa syntaxe de base est : 
-- SELECT colonne 1, colonne2, ...
-- FROM table ; 

-- Exemple  : obtenir les titres et les durées des films
SELECT title, length
FROM film;

-- Partie  2 : Sélectionner toutes les collonnes d'une table :
-- *  --> considéré comme une mauvaise pratique car en sélectionnant tout on ralentit et on surcharge le temps de lecture. 
select * 
FROM film ;

-- Partie 3 : ajouter des alias pou renommer temporairement et améliorer la lisibilitéalter
-- syntaxe : nomDecolonne AS alis
Select title as film_title, length AS film_duration
FROM film;


 