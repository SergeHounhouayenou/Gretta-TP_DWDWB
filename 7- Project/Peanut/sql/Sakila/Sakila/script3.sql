-- LA clause Where

-- Syntaxe ; 
-- SELECT colonnes
-- FROM table
-- WHERE condition 1 [AND  | OR ] condition 2 

-- WHERE se lit après )s le FORM ordre : FROM , WHERE, SELECT , ORDER BY LIMIT

-- Exemple : trouver les adresses situées dans le distrct californien ayant un city Id > 200
SELECT address_id AS AdressID,
address AS FullAddress,
district AS DistrictName,
city_id AS CityID
FROM address 
WHERE Distric = 'California' and City_id> 200;
-- Attention à laisser les nom d'origine sans alias appliqués pour les WHERE car ils sont lus avant les alias. 

SELECT address_id AS AdressID,
address AS FullAddress,
district AS DistrictName,
city_id AS CityID
FROM address 
WHERE district = 'Alberta' OR City_id> 300;

-- partie 3 : Utilisation OR et AND ensemble
SELECT address_id AS AdressID,
address AS FullAddress,
district AS DistrictName,
city_id AS CityID
FROM address 
WHERE city_id > 500 AND (district = 'California' OR district = "QLD");

-- Partie 4 Requete bilan
SELECT title AS FilmTitle, 
	rating AS FilmRating,
    length AS FilmDuration
    FROM film
    where length > 120 AND rating = 'PG-13'
    order by FilmDuration desc
    LIMIT 5 ;

-- la clause LIKE 
-- SELECT colonne 
--  FROM table
-- WHERE colonne LIKE motif ; 
-- Motif utilisés avec LIKE :
-- --> Le symbole à zéro, un , ou plusieurs chractèreset
-- Exemple : 'a%'  --> le mot commencepar "a"
-- "_" crée une restriction stricte pour un charactère. Cumuler le symbole pour plus de charactère. 
-- "a_" peut donc correspondre à à 'ab' ; 'ac', mais pas 'adc'

SELECT address_id AS AddressID, 
address AS FullAddress
FROM address
WHERE address LIKE '%Boulevard%' 
ORDER BY AddressID
LIMIT 10 ;
 
-- On cherche des adresses commençant par 47
SELECT address_id AS AddressID,
address AS FullAddress
FROM address
WHERE address LIKE '47%';

-- Combinaison AND,  OR
SELECT address_id, address 
FROM address
WHERE address LIKE '%Drive' OR address LIKE'%Way%' ;

-- Partie3 : Utilisation de _ pour les recherches précises
-- Trouver les adresses ou le deuxième caractère est '7'
SELECT address_id, address 
FROM address
Where address LIKE'_7%';

-- clause BETWEN et IN 
-- Syntaxe  :
-- SELECT colonnes
-- FROM table
-- WHERE colonne BETWEEN valeur 1 AND valeur 2 ;
-- OU
-- WHERE colonne IN (valeur1, valeur2, valeur3 ...):


-- BETWEEN
SELECT address_id AS AddressID, 
address AS FullAddress
FROM address
WHERE address_id BETWEEN 10 AND 20 
ORDER BY addressID;

-- IN --> Je cherche parmis une liste de valeurs bien précise
SELECT address_id AS AddressID, 
address AS FullAddress
FROM address
WHERE address_id IN (5,10,15,20);


-- BETWEEN et IN mélangés
SELECT adress_id AS AdressID,
address AS FullAddress
FROM address
WHERE address_id BETWEEN 10 AND 50 AND city_id IN (1,2,3) ;


select title AS firstTitles
FROM film
WHERE title LIKE "%Love%" OR "R%"
ORDER BY title ASC
Limit 10 ;


SELECT first_name AS NOM, last_name AS prenom
FROM actor
WHERE first_name LIKE "%son"
ORDER BY last_name
LIMIT 9 ;



