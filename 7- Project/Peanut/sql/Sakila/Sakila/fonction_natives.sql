-- les fonctions natives

-- catégories : 
-- 1. maths
-- 2. date et heure
-- 3. manipulation de chaines
-- 4. transtypage et chiffremment
-- 5. Fonctions avancées 

-- ---------------------------------------------------
-- Première partie : Maths 
-- ---------------------------------------------------

-- Ex. 1 : calculer le nombre total de film
SELECT COUNT(*) AS total_films
FROM film ;
-- count(*) compte toutes les lignes dans la table
-- count(colonne) compte par défaut les lignes ou la colonne contient une valeur non nulle
-- count(DISTINCT colonne) : compte les valeurs uniques

-- Exemple 2 : Calculer la duréee totale des films
  SELECT SUM(length) AS total_duration
  FROM film;
  -- SUM : fonction d'agrégation pour calculer une somme. Elle ignire les "null"
  
  -- Exemple 3 : calculer la durrée moyenne
  SELECT AVG(length) AS durée_moyenne_films
  FROM film WHERE length > 100;
  -- fonction d'agrégation pour moyenne numérique
  
  -- exemple 4 : Arrondir les tarifs de location des films
  SELECT title, ROUND(rental_rate, 2) AS rounded_rate
  FROM film ;
    -- ROUND : arrondir la valeur à un nombre de décimal précisé
  
  -- Exemple 5 : Arondir sup/inf
  SELECT rental_rate, FLOOR(rental_rate) AS floor_rate,
  CEIL(rental_rate) AS ceil_rate
  FROM film; 
  
 -- ------------------------------------------------
  -- Deuxième partie : les fonctions date et heure
 -- ---------------------------------------------
 
 -- exemple 1 : obtenir la date et l'heure actuelle
 -- SELECT NOW() as current_datetime ;
 -- cette fonction ne prend pas de paramètre et retourne une valeur de type DATETIME
 -- Elle fonctionne avec INSERT INTO. Ex : INSERT INTO table (...) (NOW())  
 
 -- Exemple 2 : Extraire uniquement la date
 SELECT CUREDATE();
 -- Retourne la date actuelle sans l'heure
 -- Type : DATE 
 
 -- Exemple 3 : Calculer l'age des films en années 
 SELECT title, YEAR(CURDATE()) - release_year AS film_age
 FROM film; 
 -- !! release_year doit nécessairement être une fonction de type YEAR. Sinon la fonction échoue !!
  
 -- se renseigner sur les informations d'une table
 DESCRIBE film;
 
 -- Exemple 4 : Autres
 SELECT staff_id,
		last_update,
        DATE_FORMAT(last_update, "%d-%m-%Y") AS formatted_date,
        DATEDIFF(CURDATE(), last_update) AS days_since_last_update,
        ADDDATE(last_update, INTERVAL 7 DAY) AS next_update,
        WEEK(last_update) AS week_number,
        MONTHNAME(last_update) AS month_name
FROM staff; 
-- DATE_FORMAT : %d (jour numérique), %m (mois en numérique), Y (année complète), 
-- "m" et "d" en majuscule donneront les nom littéraires des mois et des joiurs au lieu du format numérique
-- DATEDIFF (x, y) : différence en jours entre les deux dates x et y
-- ADDDATE() : ajoute des jours, mois ... à une date. (on peut utiliser DATE_ADD)
-- WEEK() : retourne le numéro de la semaine (configurable)
-- WEEK : sert à configurer les format de contage des semaines (à l'anglaise, à la française, etc.)

-- ------------------------------------------------
  -- Troisième partie : les fonctions de manipulation de chaine
 -- ---------------------------------------------
 
 -- Exemple 1 : Convertir les titres de films en majuscules
 SELECT UPPER(title) AS title_uppercase
 FROM film;
 
 -- Exemple 2 : Trouver une longueur des titres
 SELECT title, CHAR_LENGTH(title) AS title_length
 FROM film; 
 
 -- Exemple 3 : Extraire une partiie des titres 
 SELECT title, SUBSTRING(title, 1,5) AS title_start
 FROM film;
 -- SUBSTRING (chaine, position de départ, longuer)
 
 -- Exemple 4 : Supprimer les espaces au début et à la fin
 SELECT TRIM(' Sakila ') AS trimmed_value;
 
 -- Exemple 5 : Combiner plusieurs chaines
 SELECT CONCAT (first_name,' ', last_name) AS fuul_name
 FROM actor;
 
 -- Exemple 6 : Remplacer une sous chaine par une autre
 SELECT title, REPLACE(title, 'ACADEMY', 'Le') AS translated_title
 FROM film;
 
 -- -----------------------------------------------
 -- Partie 4 : Les fonctions de chiffrement et transtypage
 -- -----------------------------------------------
 
 -- Exemple 1 : les conversions de type
 SELECT title, CAST(length AS CHAR) AS length_as_text
 FROM film;
 -- syntaxe : CAST (expression AS target_type)
 -- conversion de type INT --> CHAR
 -- !! la fonction CHAR() retourne le charactère ASCII
 
 -- Exemple 2 : Générer un hash MD5 (Message Migest algorithme 5)
 SELECT title, MD5(title) AS title_hash
 FROM film;
 -- hachage crypto qui calcule une emprunte (hash) en utilisant l'algorithme MD5.
 -- !! Ne pas utiliser pour les mots de pass car cet algo à été compris par les attaquants !! 
 -- Les mots de pass seront hashés via password_hash() de php qui utilise des algo de hash : bcrypt et argon2
 -- La requête front elle devra être chiffrée au niveau du Java Script. 
 -- Penser au stade d'opacité de la déclaration du mot de pass
 
 -- Exemple 3 : Générer des hash sécurisés
 SELECT title, SHA2(title, 256) AS secure_hash
 FROM film;
 -- utile pour le mot de pass (avec le sel - salage)
 -- Exemple : LEFT (UUID(); 8) +SHA2(password) --> SALAGE
 -- LEFT (UUID(), 8) représente le sel du hashage
 

 
 
 
 
  
