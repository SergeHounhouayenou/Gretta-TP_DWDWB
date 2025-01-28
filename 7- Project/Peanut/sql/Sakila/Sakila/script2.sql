-- ORDER BY et LIMIT pour ordonner et limiter les données. Limit sert à sélectionnner une valeur par défaut
-- Par défaut le trie est ascendant
-- Syntaxe :
-- SELECT colonne
-- FROM table
-- ORDER bY colonne [asc| DESC
-- LIMIT nbr_lignes_à_couper [offset départ]

SELECT title 
FROM film 
ORDER BY title ASC  ;

-- Trier les films par leur durée dans l'ordre déroissant. 
SELECT title, length
FROM film 
ORDER BY length DESC ;

-- Trier sur plusieurs collonnes
SELECT title AS Film_Title, length AS Duration
FROM film
ORDER BY Duration ASC, Film_Title ASC;

-- ordre de lecture et exécution par SQL : 
-- FROM --> SELECT --> ORDER BY --> 
-- Les alias présent dans le SELECT sont disponibles dans le ORDER BY

-- partie 2  : utilisation du limit et du ofset
-- limit : limiter le nombre de ligne
-- ofset ; spécifier un point de départ
-- Exemple ; retourner les 5 premiers films
SELECT title AS Film_title
FROM film
order by Film_title
Limit 5 ; 

-- Exemple 5 : ignirer les 10 premiers films et retourner les 5 suivants
--  Attention à la syntaxe OFFSET vient toujours après Limite.
SELECT title AS Film_title
FROM film
order by Film_title
Limit 5 OFFSET 10;

-- Variante ORACLE
-- SELECT title FROM film ORDER BY title OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY ;

-- Exemple 6 : Le film le plus long
SELECT title, length AS Film_length
FROM film
ORDER BY Film_length
Limit 3
